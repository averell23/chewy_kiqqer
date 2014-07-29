require 'spec_helper'

describe ChewyKiqqer::Worker do

  let(:worker) { ChewyKiqqer::Worker.new }
  let(:lock) { double(acquire!: true, release!: true) }

  before(:each) { allow(worker).to receive(:lock).and_return(lock) }

  it 'calls the indexing with chewy' do
    index = double
    expect(Chewy).to receive(:derive_type).with('foo#bar').and_return(index)
    expect(index).to receive(:import).with([17])

    worker.perform('foo#bar', [17])
  end

  it 'raises a lock error if the lock cannot be acquired' do
    allow(lock).to receive(:acquire!).and_return(false)
    expect {
      worker.perform('foo#bar', [17])
    }.to raise_error(ChewyKiqqer::Worker::LockError)
  end

end
