# -*- coding: utf-8 -*-
module RomaRails
  module RomaClientAccess
    # set roma server configuration
    def roma_servers=(s, type = :default)
      @roma_servers = s
    end

    # get roma server configuration
    def roma_servers(type = :default)
      @roma_servers
    end

    # use roma client
    def roma_client(type = :default)
      unless block_given?
        raise 'client_pool method should be called with block'
      end

      pool = Roma::Client::ClientPool.instance(type)
      if pool.pool_count == 0
        pool.servers = roma_servers(type)
        pool.start_sync_routing_proc = false
      end

      pool.client do |c|
        yield c
      end
    end
  end
end