# -*- coding: utf-8 -*-
require File.expand_path('roma_client_access',
                         File.dirname(__FILE__))

module RomaRails
  class Railtie < Rails::Railtie
    initializer :roma_rails_init_controller do
      ::ActionController::Base.send(:include, RomaRails::RomaClientAccess)
    end
  end
end
