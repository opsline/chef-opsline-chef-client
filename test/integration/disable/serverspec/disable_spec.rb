require 'serverspec'

set :backend, :exec

describe "disable" do

  describe file('/var/log/chef/disabled') do
    it { should be_file }
  end

end
