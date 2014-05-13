require 'active_support/concern'

module ChewyKiqqer
  module Mixin

    extend ActiveSupport::Concern

    module ClassMethods

      attr_reader :index_name

      def async_update_index(index_name)
        @index_name = index_name
        after_save    :queue_job
        after_destroy :queue_job
      end

    end

    def queue_job
      ChewyKiqqer::Worker.perform_async(self.class.index_name, id)
    end
  end
end
