require 'serverspec'

set :backend, :exec

describe "validation" do

  describe file('/tmp/kitchen/validation.pem') do
    it { should be_file }
  end

end
