require "#{File.join(File.dirname(__FILE__),'..','spec_helper.rb')}"

describe 'mogilefs' do

  let(:title) { 'mogilefs' }
  let(:node) { 'rspec.test.com' }
  let(:facts) { { :ipaddress => '10.0.0.1' } }

  describe 'Test mogilefs installation' do
    it { should contain_package('MogileFS::Server').with_ensure('present') }
    it { should contain_package('MogileFS::Utils').with_ensure('present') }
  end

  describe 'Test installation of a specific version' do
    let(:params) { {:version => '2.67' } }
    it { should contain_package('MogileFS::Server').with_ensure('2.67') }
  end

  describe 'Test decommissioning - absent' do
    let(:params) { {:absent => true} }
    it 'should remove Package[MogileFS::Server]' do should contain_package('MogileFS::Server').with_ensure('absent') end
    it 'should remove Package[MogileFS::Utils]' do should contain_package('MogileFS::Utils').with_ensure('absent') end
  end

  describe 'Test decommissioning - disable' do
    let(:params) { {:disable => true} }
    it { should contain_package('MogileFS::Server').with_ensure('present') }
    it { should contain_package('MogileFS::Utils').with_ensure('present') }
  end

  describe 'Test noops mode' do
    let(:params) { {:noops => true} }
    it { should contain_package('MogileFS::Server').with_noop('true') }
  end

end
