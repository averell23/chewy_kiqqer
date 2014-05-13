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
      Gummi.should_receive(:after_save).with(:queue_job)
      Gummi.should_receive(:after_destroy).with(:queue_job)
      Gummi.async_update_index('xxx')
    end

    it 'knows the index_name' do
      Gummi.async_update_index('bar#foo')
      Gummi.index_name.should eq 'bar#foo'
    end
  end

  context '#queue_job' do

    let(:record) { Gummi.new }

    it 'queues the job' do
      Gummi.async_update_index 'foo#bar'
      ChewyKiqqer::Worker.should_receive(:perform_async).with('foo#bar', 17)
      record.queue_job
    end

  end

end
