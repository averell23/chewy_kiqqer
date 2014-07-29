require 'active_support/concern'
require 'active_support/core_ext/array/wrap'

module ChewyKiqqer

  def self.default_queue=(queue)
    @default_queue = queue
  end

  def self.default_queue
    @default_queue || 'default'
  end

  module Mixin

    extend ActiveSupport::Concern

    module ClassMethods

      attr_reader :indexers

      def async_update_index(index: nil, queue: ChewyKiqqer::default_queue, backref: :self)
        @indexers ||= []
        install_chewy_hooks if @indexers.empty?
        @indexers << ChewyKiqqer::Index.new(index: index, queue: queue, backref: backref)
      end

      def reset_async_chewy
        @indexers and @indexers.clear
      end

      def install_chewy_hooks
        after_commit :queue_chewy_jobs
      end
    end

    def queue_chewy_jobs
      ActiveSupport::Notifications.instrument('queue_jobs.chewy_kiqqer', class: self.class.name) do
        self.class.indexers or return
        self.class.indexers.each { |idx| idx.enqueue(self) }
      end
    end
  end
end
