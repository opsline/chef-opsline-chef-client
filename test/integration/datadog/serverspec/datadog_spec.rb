require 'serverspec'

set :backend, :exec

describe "datadog" do

  describe file('/etc/dd-agent/checks.d/chef_status.py') do
    it { should be_file }
  end

  describe file('/etc/dd-agent/conf.d/chef_status.yaml') do
    it { should be_file }
  end

end
