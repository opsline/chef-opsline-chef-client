require 'serverspec'

set :backend, :exec

describe "unregister" do

  describe file('/opt/chef/bin/unregister_chef') do
    it { should be_file }
  end

  describe file('/etc/init.d/unregister-chef') do
    it { should be_file }
  end

end
