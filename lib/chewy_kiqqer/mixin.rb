require 'active_support/concern'
require 'active_support/core_ext/array/wrap'

module ChewyKiqqer

  mattr_accessor(:default_queue) { 'default' }

  module Mixin

    extend ActiveSupport::Concern

    included do
      class_attribute :indexers
      self.indexers = []
    end

    module ClassMethods

      def async_update_index(index: nil, queue: ChewyKiqqer.default_queue, backref: :self)
        install_chewy_hooks if indexers.empty? # Only install them once
        indexers << ChewyKiqqer::Index.new(index: index, queue: queue, backref: backref)
      end

      def install_chewy_hooks
        after_commit :queue_chewy_jobs
        respond_to?(:after_touch) and after_touch(:queue_chewy_jobs)
      end
    end

    def queue_chewy_jobs
      ActiveSupport::Notifications.instrument('queue_jobs.chewy_kiqqer', class: self.class.name, id: self.id) do
        self.class.indexers or return
        self.class.indexers.each { |idx| idx.enqueue(self) }
      end
    end
  end
end
