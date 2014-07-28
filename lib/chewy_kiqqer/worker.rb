require 'sidekiq'
require 'sidekiq-lock'

module ChewyKiqqer
  class Worker
    include Sidekiq::Worker
    include Sidekiq::Lock::Worker

    sidekiq_options lock: {
      timeout: 3000,
      name:    ->(index_name, ids) { "lock:chewy_kiqqer:#{ids}-#{[ids].flatten.sort.join('-')}" }
    }


    def perform(index_name, ids)
      Chewy.derive_type(index_name).import ids
    end
  end
end
