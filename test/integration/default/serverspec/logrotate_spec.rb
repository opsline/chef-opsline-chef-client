require 'serverspec'

set :backend, :exec

describe "logrotate" do

  describe file('/etc/logrotate.d/chef-client') do
    it { should be_file }
  end

end
