class ApplicationController < ActionController::Base
  protect_from_forgery

  def initialize
    self.roma_servers = ["localhost:12000", "localhost:12001"]
  end
end
