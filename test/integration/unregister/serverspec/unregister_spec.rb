require 'serverspec'

include Serverspec::Helper::Exec
include Serverspec::Helper::DetectOS

RSpec.configure do |c|
  c.before :all do
    c.path = '/sbin:/usr/sbin'
  end
end

describe file('/opt/chef/bin/unregister_chef') do
  it { should be_file}
end

describe file('/etc/init/chef-unregister') do
  it { should be_file}
end
