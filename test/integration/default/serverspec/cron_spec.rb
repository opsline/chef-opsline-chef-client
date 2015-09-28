require 'serverspec'

set :backend, :exec

describe "cron" do

  describe file('/opt/chef/bin/run_chef_client') do
    it { should be_file }
  end

  describe service('chef-client') do
    it { should_not be_running }
  end

  describe file('/var/log/chef') do
    it { should be_directory }
  end

  describe cron do
    it { should have_entry('27,57 * * * * /opt/chef/bin/run_chef_client >/dev/null 2>&1').with_user('root') }
  end

end
