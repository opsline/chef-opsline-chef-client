require 'serverspec'

include Serverspec::Helper::Exec
include Serverspec::Helper::DetectOS

RSpec.configure do |c|
  c.before :all do
    c.path = '/sbin:/usr/sbin'
  end
end

describe file('/opt/chef/bin/run_chef_client') do
  it { should be_file}
end

describe file('/opt/chef/bin/disable_chef') do
  it { should be_file}
end

describe file('/usr/local/bin/disable_chef') do
  it { should be_linked_to '/opt/chef/bin/disable_chef' }
end

describe file('/opt/chef/bin/enable_chef') do
  it { should be_file}
end

describe file('/usr/local/bin/enable_chef') do
  it { should be_linked_to '/opt/chef/bin/enable_chef' }
end

describe service('chef-client') do
  it { should_not be_running }
end

describe file('/var/log/chef') do
  it { should be_directory }
end

describe cron do
  it { should have_entry '/opt/chef/bin/run_chef_client >/dev/null 2>&1'}
end