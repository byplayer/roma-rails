# -*- coding: utf-8 -*-
module RomaRails
  # This module provide Roma::Client::ClientPool access interface.
  #
  # You can use ClientPool if you don't use this module.
  # But you can use this module and roma_client method to access RomaClient,
  # Your client doesn't start routing table sync proc.
  module RomaClientAccess

    # get instance
    def roma_client_pool(type = :default)
      Roma::Client::ClientPool.instance(type)
    end

    # use roma client
    def roma_client(type = :default)
      unless block_given?
        raise 'client_pool method should be called with block'
      end

      pool = roma_client_pool(type)
      if pool.pool_count == 0
        pool.start_sync_routing_proc = false
      end

      pool.client do |c|
        yield c
      end
    end
  end
end
