require 'spec_helper'

describe 'config' do
  context '#logger' do

    after(:each) { ChewyKiqqer.logger = nil }

    it 'can be set from the outside' do
      ChewyKiqqer.logger = :nolog
      expect(ChewyKiqqer.logger).to eq(:nolog)
    end

  end

  context '#locking_scope' do

    after(:each) { ChewyKiqqer.locking_scope = 'default' }

    it 'can be set from the outside' do
      ChewyKiqqer.locking_scope = '42'
      expect(ChewyKiqqer.locking_scope).to eq('42')
    end

    it 'has a default' do
      expect(ChewyKiqqer.locking_scope).to eq('default')
    end

  end
end
