require 'sidekiq'
require 'redis-lock'

module ChewyKiqqer
  class Worker

    include Sidekiq::Worker


    def perform(index_name, ids)
      ActiveSupport::Notifications.instrument('perform.chewy_kiqqer', index_name: index_name, ids: ids) do
        with_lock(index_name, ids)
      end
    end

    private

    def with_lock(index_name, ids)
      Sidekiq.redis do |redis|
        lock_name = "#{index_name}-#{ids.join('-')}"
        redis.lock(lock_name, life: 60, acquire: 5) { index(index_name, ids) }
      end
    end

    def index(index_name, ids)
      ActiveSupport::Notifications.instrument('index.chewy_kiqqer', index_name: index_name, ids: ids) do
        Chewy.derive_type(index_name).import ids
      end
    end


  end
end
