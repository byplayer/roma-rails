require 'spec_helper'
describe Rack::Session::Roma do
  session_key = Rack::Session::Abstract::ID::DEFAULT_OPTIONS[:key]
  dummy_app = lambda do |env|
    env["rack.session"]["counter"] ||= 0
    env["rack.session"]["counter"] += 1
    Rack::Response.new(env["rack.session"].inspect).to_a
  end

  servers = ['localhost:12000', 'localhost:12001']

  before(:each) do
    Roma::Client::ClientPool.instance.servers = servers
  end

  it "faults on no connection" do
    lambda{
      Roma::Client::ClientPool.instance.servers = []
      pool = Rack::Session::Roma.new(dummy_app)
      res = Rack::MockRequest.new(pool).get("/")
    }.should raise_error
  end

  it "creates a new cookie" do
    pool = Rack::Session::Roma.new(dummy_app)
    res = Rack::MockRequest.new(pool).get("/")
    res["Set-Cookie"].should include("#{session_key}=")
    res.body.should == '{"counter"=>1}'
  end

  it "determines session from a cookie" do
    pool = Rack::Session::Roma.new(dummy_app)
    req = Rack::MockRequest.new(pool)
    res = req.get("/")
    res.body.should == '{"counter"=>1}'
    cookie = res["Set-Cookie"]
    res["Set-Cookie"] =~ /#{session_key}=([a-zA-Z0-9]+)/
    sid = $1
    sid.should_not be_nil

    res = req.get("/", "HTTP_COOKIE" => cookie)
    res.body.should == '{"counter"=>2}'
    res["Set-Cookie"] =~ /#{session_key}=([a-zA-Z0-9]+)/
    sid2 = $1
    sid2.should_not be_nil
    sid.should == sid2
  end
end
