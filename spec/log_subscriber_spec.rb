require 'spec_helper'

describe ChewyKiqqer::LogSubscriber do

  let(:subscriber) { ChewyKiqqer::LogSubscriber.new }
  let(:logger) { Logger.new(nil) }

  it 'logs a perform with the default logger' do
    expect {
      subscriber.perform(double(payload: { index_name: 'foo', ids: [1,2] }, duration: 0.2))
    }.to_not raise_error
  end

  it 'logs a perform event' do
    allow(subscriber).to receive(:logger).and_return(logger)
    expect(logger).to receive(:info)
    expect {
      subscriber.perform(double(payload: { index_name: 'foo', ids: [1,2] }, duration: 0.2))
    }.to_not raise_error
  end

  it 'log a queue_jobs event' do
    allow(subscriber).to receive(:logger).and_return(logger)
    expect(logger).to receive(:debug)
    expect {
      subscriber.queue_jobs(double(payload: { class: 'Huha', id: 123 }))
    }.to_not raise_error
  end

end
