require 'chewy_kiqqer'

class Gummi
  include ChewyKiqqer::Mixin

  def self.after_save(*args) ; end
  def self.after_destroy(*args) ; end

end

describe ChewyKiqqer::Mixin do

  context 'class methods' do
    it 'installs the hooks' do
      Gummi.should_receive(:after_save).with(:queue_chewy_job)
      Gummi.should_receive(:after_destroy).with(:queue_chewy_job)
      Gummi.async_update_index(index: 'xxx')
    end

    it 'knows the index_name' do
      Gummi.async_update_index(index: 'bar#foo')
      Gummi.index_name.should eq 'bar#foo'
    end

    it 'sets the queue name' do
      ChewyKiqqer::Worker.should_receive(:sidekiq_options).with(queue: :some_queue)
      Gummi.async_update_index(index: 'xxx', queue: :some_queue)
    end

    it 'uses the default queue if none was specified' do
      ChewyKiqqer::Worker.should_receive(:sidekiq_options).with(queue: :default3)
      ChewyKiqqer.default_queue = :default3
      Gummi.async_update_index(index: 'xxx')
    end
  end

  context 'setting the backref' do

    it 'sets the defautl to self' do
      Gummi.async_update_index index: 'xxx'
      Gummi.chewy_backref.should eq :self
    end

    it 'can be configured' do
      Gummi.async_update_index index: 'xxx', backref: :foo
      Gummi.chewy_backref.should eq :foo
    end

  end

  context 'computing the backref' do
    let(:record) { Gummi.new }

    it 'returns the object if the backref is self' do
      record.compute_backref(:self).should eq record
    end

    it 'can use a random method' do
      record.stub(foobar: :bong)
      record.compute_backref(:foobar).should eq :bong
    end

    it 'is possible to use a proc' do
      record.stub(foobar: :dingdong)
      a_proc = -> (r) { r.foobar }
      record.compute_backref(a_proc).should eq :dingdong
    end

  end

  context 'turning backrefs into ids' do
    let(:record) { Gummi.new }

    it 'uses the ids of the objects' do
      record.get_ids(double(id: 3), double(id: 6)).should eq [3, 6]
    end

    it 'turns everything else into ints' do
      record.get_ids(3, '6').should eq [3, 6]
    end

    it 'computes the ids from a backref' do
      Gummi.async_update_index index: 'xxx', backref: :something
      record.should_receive(:compute_backref).with(:something).and_return([1, 2, 3])
      record.should_receive(:get_ids).with([1, 2, 3]).and_call_original
      record.backref_ids
    end
  end

  context '#queue_job' do

    let(:record) { Gummi.new }

    it 'queues the job' do
      Gummi.async_update_index index: 'foo#bar'
      record.should_receive(:backref_ids).and_return([17])
      ChewyKiqqer::Worker.should_receive(:perform_async).with('foo#bar', [17])
      record.queue_chewy_job
    end

  end

end
