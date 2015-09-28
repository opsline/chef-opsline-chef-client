require 'serverspec'

set :backend, :exec

describe "disable_enable" do

  describe file('/opt/chef/bin/disable_chef') do
    it { should be_file }
  end

  describe file('/usr/local/bin/disable_chef') do
    it { should be_linked_to '/opt/chef/bin/disable_chef' }
  end

  describe file('/opt/chef/bin/enable_chef') do
    it { should be_file }
  end

  describe file('/usr/local/bin/enable_chef') do
    it { should be_linked_to '/opt/chef/bin/enable_chef' }
  end

  describe file('/opt/chef/bin/check_chef') do
    it { should be_file }
  end

  describe file('/usr/local/bin/check_chef') do
    it { should be_linked_to '/opt/chef/bin/check_chef' }
  end

  describe command('/usr/local/bin/disable_chef') do
    its(:stdout) { should match /disabled/ }
  end

  describe command('/usr/local/bin/check_chef') do
    its(:stdout) { should match /disabled/ }
  end

  describe file('/var/log/chef/disabled') do
    it { should be_file }
  end

  describe command('/usr/local/bin/enable_chef') do
    its(:stdout) { should match /enabled/ }
  end

  describe command('/usr/local/bin/check_chef') do
    its(:stdout) { should match /enabled/ }
  end

  describe file('/var/log/chef/disabled') do
    it { should_not be_file }
  end

end
