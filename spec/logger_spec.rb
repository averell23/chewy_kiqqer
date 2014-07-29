require 'chewy_kiqqer'

describe '#logger' do


  after(:each) { ChewyKiqqer.logger = nil }

  it 'can be set from the outside' do
    ChewyKiqqer.logger = :nolog
    expect(ChewyKiqqer.logger).to eq(:nolog)
  end


end
