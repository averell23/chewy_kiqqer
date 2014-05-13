require 'active_support/concern'

module ChewyKiqqer
  module Mixin

    extend ActiveSupport::Concern

    module ClassMethods

      attr_reader :index_name

      def async_update_index(index: nil, queue: 'default')
        @index_name = index
        after_save    :queue_chewy_job
        after_destroy :queue_chewy_job
        ChewyKiqqer::Worker.sidekiq_options :queue => queue
      end

    end

    def queue_chewy_job
      ChewyKiqqer::Worker.perform_async(self.class.index_name, id)
    end
  end
end
