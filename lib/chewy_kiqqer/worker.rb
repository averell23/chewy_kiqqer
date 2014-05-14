require 'sidekiq'

module ChewyKiqqer
  class Worker
    include Sidekiq::Worker

    def perform(index_name, ids)
      Chewy.derive_type(index_name).import ids
    end
  end
end
