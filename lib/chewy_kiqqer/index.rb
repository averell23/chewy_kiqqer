module ChewyKiqqer

  class Index

    def initialize(backref: :self, index: nil, queue: ChewyKiqqer.default_queue)
      @index_name = index
      @backref_method = backref
      @queue = queue
    end

    def enqueue(object)
      Sidekiq::Client.push(queue: @queue, class: ChewyKiqqer::Worker, args: [@index_name, backref_ids(object)])
    end

    def backref(object)
      return @backref_method.call(object) if @backref_method.respond_to?(:call)
      return object if @backref_method.to_s == 'self'
      object.send(@backref_method)
    end

    def backref_ids(object)
      Array.wrap(backref(object)).map { |object| object.respond_to?(:id) ? object.id : object.to_i }
    end

  end

end
