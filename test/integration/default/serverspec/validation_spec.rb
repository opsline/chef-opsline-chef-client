require 'serverspec'

set :backend, :exec

describe "validation" do

  describe file('/tmp/kitchen/validation.pem') do
    it { should_not be_file }
  end

end
