require 'chewy_kiqqer'

class Gummi
  include ChewyKiqqer::Mixin

  def self.after_save(*args) ; end
  def self.after_destroy(*args) ; end

end

describe ChewyKiqqer::Mixin do

  before(:each) { Gummi.reset_async_chewy }

  context '#update_index' do

    it 'installs the hooks if nothing was installed yet' do
      Gummi.should_receive(:install_chewy_hooks)
      Gummi.async_update_index(index: 'xxx')
    end

    it 'does not install the hooks twice' do
      Gummi.should_receive(:install_chewy_hooks).once
      Gummi.async_update_index(index: 'xxx')
      Gummi.async_update_index(index: 'xxx')
    end

    it 'installs the indexer' do
      ChewyKiqqer::Index.should_receive(:new)
                        .with(index: 'some#thing', queue: :medium, backref: :foobar)
                        .and_return(:idx)
      Gummi.async_update_index(index: 'some#thing', queue: :medium, backref: :foobar)
      Gummi.indexers.should eq [:idx]
    end

  end

  context '#install hooks' do

    it 'installs the hooks' do
      Gummi.should_receive(:after_save).with(:queue_chewy_jobs)
      Gummi.should_receive(:after_destroy).with(:queue_chewy_jobs)
      Gummi.install_chewy_hooks
    end

  end

  context '#queue_chewy_jobs' do

    let(:record) { Gummi.new }

    it 'queues the job' do
      idx = double
      idx.should_receive(:enqueue).with(record)
      Gummi.stub(indexers: [idx])
      record.queue_chewy_jobs
    end

  end

end
