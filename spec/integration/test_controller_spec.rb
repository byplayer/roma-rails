require 'spec_helper'

describe TestController, "update rttable", :type => :controller do
  it "call" do
    get "test/test"
    response.should be_success
    response.body.should == "test"
  end
end
