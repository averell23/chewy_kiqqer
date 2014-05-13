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

      attr_reader :index_name
      attr_reader :chewy_backref

      def async_update_index(index: nil, queue: ChewyKiqqer::default_queue, backref: :self)
        @index_name = index
        after_save    :queue_chewy_job
        after_destroy :queue_chewy_job
        ChewyKiqqer::Worker.sidekiq_options queue: queue
        @chewy_backref = backref
      end

    end

    def compute_backref(backref)
      return backref.call(self) if backref.respond_to?(:call)
      return self if backref.to_s == 'self'
      send(backref)
    end

    def get_ids(*objects)
      Array.wrap(objects.flatten).map { |object| object.respond_to?(:id) ? object.id : object.to_i }
    end

    def backref_ids
      get_ids(compute_backref(self.class.chewy_backref))
    end

    def queue_chewy_job
      ChewyKiqqer::Worker.perform_async(self.class.index_name, backref_ids)
    end
  end
end
