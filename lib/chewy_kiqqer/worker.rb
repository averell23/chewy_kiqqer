require 'sidekiq'
require 'redis-namespace'
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

    def sidekiq_redis
      # Sidekiq.redis may both be a Redis client directly, or a
      # redis namespace. Since namespaces don't allow for passing through
      # the lock behaviour any more, we want the "real" connection in
      # any case
      Sidekiq.redis do |redis|
        real_redis = redis.is_a?(Redis::Namespace) ? redis.redis : redis
        yield real_redis
      end
    end

    def with_lock(index_name, ids)
      sidekiq_redis do |redis|
        lock_name = "chewy-kiqqer:#{ChewyKiqqer.locking_scope}:#{index_name}-#{ids.join('-')}"
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
