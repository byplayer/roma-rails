require 'spec_helper'

describe TestController, "update rttable", :type => :controller do
  before(:all) do
    servers = ["localhost:12000", "localhost:12001"]
    Roma::Client::ClientPool.instance(:spec_instance).servers = servers
  end

  it "call" do
    get "test/test"
    response.should be_success
    response.body.should == "test"
  end

  it "not start routing table thread" do
    pool = Roma::Client::ClientPool.instance(:spec_instance)
    pool.client do |c|
      c.set "test", "value"
    end

    old_thread_count = Thread.list.length

    get "test/test2"
    response.should be_success
    response.body.should == "test:value"

    Thread.list.length.should == old_thread_count
  end
end
