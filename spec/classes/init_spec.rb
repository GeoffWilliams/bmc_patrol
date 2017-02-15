require 'spec_helper'
describe 'bmc_patrol' do
  context 'with default values for all parameters' do
    it { should contain_class('bmc_patrol') }
  end
end
