require 'spec_helper'

class Gummi
  include ChewyKiqqer::Mixin

  def self.after_commit(*args) ; end

end

describe ChewyKiqqer::Mixin do

  before(:each) { Gummi.reset_async_chewy }

  context '#update_index' do

    it 'installs the hooks if nothing was installed yet' do
      expect(Gummi).to receive(:install_chewy_hooks)
      Gummi.async_update_index(index: 'xxx')
    end

    it 'does not install the hooks twice' do
      expect(Gummi).to receive(:install_chewy_hooks).once
      Gummi.async_update_index(index: 'xxx')
      Gummi.async_update_index(index: 'xxx')
    end

    it 'installs the indexer' do
      expect(ChewyKiqqer::Index).to receive(:new)
                        .with(index: 'some#thing', queue: :medium, backref: :foobar)
                        .and_return(:idx)
      Gummi.async_update_index(index: 'some#thing', queue: :medium, backref: :foobar)
      expect(Gummi.indexers).to eq [:idx]
    end

  end

  context '#install hooks' do

    it 'installs the hooks' do
      expect(Gummi).to receive(:after_commit).with(:queue_chewy_jobs)
      Gummi.install_chewy_hooks
    end

  end

  context '#queue_chewy_jobs' do

    let(:record) { Gummi.new }

    it 'queues the job' do
      idx = double
      expect(idx).to receive(:enqueue).with(record)
      allow(Gummi).to receive(:indexers).and_return([idx])
      record.queue_chewy_jobs
    end

  end

end
