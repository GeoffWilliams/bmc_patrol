require 'spec_helper'
describe 'bmc_patrol' do
  let :pre_condition do
    'include download_and_do'
  end
  let :facts do
    {
      :os => {
        "family"      => "RedHat",
      }
    }
  end
  let :params do
    {
      :media_source => "http://www.bmc-patrol.com/silentinstaller.tar",
    }
  end
  context 'compiles ok' do
    it { should compile }
  end

  context 'with default values for all parameters' do
    it { should contain_class('bmc_patrol') }
  end
end
