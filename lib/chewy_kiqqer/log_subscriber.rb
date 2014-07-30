module ChewyKiqqer

  class LogSubscriber < ActiveSupport::LogSubscriber

    def perform(event)
      info "ChewyKiqqer job ran on #{event.payload[:index_name]} with ids #{event.payload[:ids]} - duration #{event.duration}"
    end

    def index(event)
      debug "ChewyKiqqer index updated on #{event.payload[:index_name]} with ids #{event.payload[:ids]} - duration #{event.duration}"
    end

    def queue_jobs(event)
      debug "ChewyKiqqer queued jobs from #{event.payload[:class]} #{event.payload[:id]}"
    end

    def logger
      ChewyKiqqer.logger
    end

  end

end
