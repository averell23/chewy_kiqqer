require 'chewy_kiqqer'
require 'chewy'

describe ChewyKiqqer::Worker do

  let(:worker) { ChewyKiqqer::Worker.new }

  it 'calls the indexing with chewy' do
    index = double
    Chewy.should_receive(:derive_type).with('foo#bar').and_return(index)
    index.should_receive(:import).with([17])

    worker.perform('foo#bar', [17])
  end

end
