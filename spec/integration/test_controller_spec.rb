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

  it "check rttable update" do
    get "test/test2"
    response.should be_success
    response.body.should == "test:value"

    pool = Roma::Client::ClientPool.instance
    old_update_time = nil
    pool.client do |c|
      old_update_time = c.rttable_last_update
    end

    get "test/test2"
    response.should be_success
    response.body.should == "test:value"

    pool.client do |c|
      c.rttable_last_update.should == old_update_time
    end

    old_interval = RomaRails::RTTableUpdateHook.rttable_update_interval
    RomaRails::RTTableUpdateHook.rttable_update_interval = 0

    get "test/test2"
    response.should be_success
    response.body.should == "test:value"

    pool.client do |c|
      c.rttable_last_update.should > old_update_time
    end

    RomaRails::RTTableUpdateHook.rttable_update_interval = old_interval
  end
end
