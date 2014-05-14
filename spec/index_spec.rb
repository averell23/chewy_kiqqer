require 'chewy_kiqqer'

describe ChewyKiqqer::Index do

  context 'compute the backref' do

    it 'defaults to the corresponding object' do
      object = Object.new
      idx = ChewyKiqqer::Index.new
      idx.backref(object).should eq object
    end

    it 'can run a random method' do
      object = double(foobar: :backref)
      idx = ChewyKiqqer::Index.new(backref: :foobar)
      idx.backref(object).should eq :backref
    end

    it 'can use a proc' do
      object = double(foobar: :my_backref)
      idx = ChewyKiqqer::Index.new(backref: -> (r) { r.foobar })
      idx.backref(object).should eq :my_backref
    end

    context 'turning backrefs into ids' do
      let(:idx) { ChewyKiqqer::Index.new }

      it 'uses the ids of the objects' do
        idx.backref_ids([double(id: 3), double(id: 6)]).should eq [3, 6]
      end

      it 'turns everything else into ints' do
        idx.backref_ids([3, '6']).should eq [3, 6]
      end

    end

    context 'queue the job' do
      it 'queues the job with the settings from the index' do
        object = double(id: 24)
        idx = ChewyKiqqer::Index.new index: 'foo#bar',
                                     queue: 'hello'

        Sidekiq::Client.should_receive(:push)
                       .with('queue' => 'hello',
                             'class' => ChewyKiqqer::Worker,
                             'args' => ['foo#bar', [24]])
        idx.enqueue object
      end

      it 'queues the job on the chewy default queue if not told otherwise' do
        object = double(id: 24)
        ChewyKiqqer.default_queue = :my_default
        idx = ChewyKiqqer::Index.new index: 'foo#bar'

        Sidekiq::Client.should_receive(:push)
                       .with('queue' => :my_default,
                             'class' => ChewyKiqqer::Worker,
                             'args' => ['foo#bar', [24]])
        idx.enqueue object
      end
    end

  end

end
