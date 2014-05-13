require 'sidekiq'

module ChewyKiqqer
  class Worker
    include Sidekiq::Worker
  end
end
