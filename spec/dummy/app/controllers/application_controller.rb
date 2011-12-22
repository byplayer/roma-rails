class ApplicationController < ActionController::Base
  protect_from_forgery
  include RomaRails::RomaClientAccess

  def initialize
    roma_client_pool.servers = ["localhost:12000", "localhost:12001"]
  end
end
