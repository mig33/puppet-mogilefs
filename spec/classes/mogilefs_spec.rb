require "#{File.join(File.dirname(__FILE__),'..','spec_helper.rb')}"

describe 'mogilefs' do

  let(:title) { 'mogilefs' }
  let(:node) { 'rspec.test.com' }
  let(:facts) { { :ipaddress => '10.0.0.1' } }

  describe 'Test mogilefs installation' do
    it { should contain_package('MogileFS::Server').with_ensure('present') }
    it { should contain_file('/etc/mogilefs').with_ensure('directory') }
    it { should contain_service('mogilefsd').with_ensure('running') }
    it { should contain_service('mogilefsd').with_enable('true') }
    it { should contain_file('mogilefsd.conf').with_ensure('present') }
    it { should contain_file('mogilefsd.init').with_ensure('present') }
    it { should contain_service('mogstored').with_ensure('running') }
    it { should contain_service('mogstored').with_enable('true') }
    it { should contain_file('mogstored.conf').with_ensure('present') }
    it { should contain_file('mogstored.init').with_ensure('present') }
    it { should contain_package('MogileFS::Utils').with_ensure('present') }
    it { should contain_exec('mogdbsetup') }
    it { should contain_package('sysstat').with_ensure('present') }
  end

  describe 'Test installation of a specific version' do
    let(:params) { {:version => '2.67' } }
    it { should contain_package('MogileFS::Server').with_ensure('2.67') }
  end

  describe 'Test decommissioning - absent' do
    let(:params) { {:absent => true} }
    it 'should remove Package[MogileFS::Server]' do should contain_package('MogileFS::Server').with_ensure('absent') end
    it 'should stop Service[mogilefsd]' do should contain_service('mogilefsd').with_ensure('stopped') end
    it 'should remove mogilefsd init script' do should contain_file('mogilefsd.init').with_ensure('absent') end
    it 'should not enable at boot Service[mogilefsd]' do should contain_service('mogilefsd').with_enable('false') end
    it 'should remove mogilefsd configuration file' do should contain_file('mogilefsd.conf').with_ensure('absent') end

    it 'should stop Service[mogstored]' do should contain_service('mogstored').with_ensure('stopped') end
    it 'should remove mogstored init script' do should contain_file('mogstored.init').with_ensure('absent') end
    it 'should not enable at boot Service[mogstored]' do should contain_service('mogstored').with_enable('false') end
    it 'should remove mogstored configuration file' do should contain_file('mogstored.conf').with_ensure('absent') end

    it 'should remove Package[MogileFS::Utils]' do should contain_package('MogileFS::Utils').with_ensure('absent') end
    it 'should remove Package[sysstat]' do should contain_package('sysstat').with_ensure('absent') end
  end

  describe 'Test decommissioning - disable' do
    let(:params) { {:disable => true} }
    it { should contain_package('MogileFS::Server').with_ensure('present') }
    it 'should stop Service[mogilefsd]' do should contain_service('mogilefsd').with_ensure('stopped') end
    it 'should not enable at boot Service[mogilefsd]' do should contain_service('mogilefsd').with_enable('false') end
    it 'should stop Service[mogstored]' do should contain_service('mogstored').with_ensure('stopped') end
    it 'should not enable at boot Service[mogstored]' do should contain_service('mogstored').with_enable('false') end
    it { should contain_package('MogileFS::Utils').with_ensure('present') }
  end

  describe 'Test noops mode' do
    let(:params) { {:noops => true} }
    it { should contain_package('sysstat').with_noop('true') }
    it { should contain_package('MogileFS::Utils').with_noop('true') }
    it { should contain_package('MogileFS::Server').with_noop('true') }
    it { should contain_service('mogilefsd').with_noop('true') }
    it { should contain_file('mogilefsd.init').with_noop('true') }
    it { should contain_file('mogilefsd.conf').with_noop('true') }
    it { should contain_service('mogstored').with_noop('true') }
    it { should contain_file('mogstored.init').with_noop('true') }
    it { should contain_file('mogstored.conf').with_noop('true') }
  end

end
