module ChewyKiqqer

  class LogSubscriber < ActiveSupport::LogSubscriber

    def perform(event)
      info "ChewyKiqqer performed on #{event.payload[:index_name]} with ids #{event.payload[:ids]} - duration #{event.duration}"
    end

    def queue_jobs(event)
      debug "ChewyKiqqer queued jobs from #{event.payload[:class]} #{event.payload[:id]}"
    end

    def logger
      ChewyKiqqer.logger
    end

  end

end
