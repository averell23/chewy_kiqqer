require 'chewy_kiqqer'

class Gummi
  include ChewyKiqqer::Mixin

  def self.after_save(*args) ; end
  def self.after_destroy(*args) ; end
  def id ; 17 ; end

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

  context '#queue_job' do

    let(:record) { Gummi.new }

    it 'queues the job' do
      Gummi.async_update_index index: 'foo#bar'
      ChewyKiqqer::Worker.should_receive(:perform_async).with('foo#bar', 17)
      record.queue_chewy_job
    end

  end

end
