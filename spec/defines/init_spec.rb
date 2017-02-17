require 'spec_helper'
describe 'easy_install', :type => :define do
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
  let :title do "coolapp" end
  let :params do
    {
      :media_source => "http://www.coolapp.com/silentinstaller.tar",
    }
  end
  context 'compiles ok' do
    it { should compile }
  end

  context 'two instances' do
    let :pre_condition do
      'include download_and_do
      easy_install { "otherapp":
        media_source => "http://www.coolapp.com/otherinstaller.tar",
      }'
    end
    let :title do "coolapp" end
    let :params do
      {
        :media_source => "http://www.coolapp.com/silentinstaller.tar",
      }
    end
    context 'compiles ok' do
      it { should compile }
    end


  end

end
