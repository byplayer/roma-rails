module RomaRails
  # Hook class to update rttable after send data
  class RTTableUpdateHook < ActiveSupport::LogSubscriber
    def process_action(event)
      logger.debug("start ROMA rttable update")
      Roma::Client::ClientPool.client_pools.each do |k,pool|
        clients = pool.clients
        if clients
          clients.each_index do |i|
            if (Time.now - clients[i].rttable_last_update) >=
                RTTableUpdateHook.rttable_update_interval
              logger.info("update ROMA rttable(#{k},#{i}) start")
              begin
                clients[i].update_rttable
              rescue Exception => e
                logger.error("update ROMA rttable error: #{e.to_log_msg}")
              end
              logger.info("update ROMA rttable(#{k},#{i}) end")
            end
          end
        end
      end
      logger.debug("end   ROMA rttable update")
    end

    # set routing table update intarval
    #
    # default is 60 sec
    def self.rttable_update_interval=(v)
      @@rttable_update_interval = v
    end

    # get routing table update intarval
    def self.rttable_update_interval
      @@rttable_update_interval
    end

    @@rttable_update_interval = 10

    def logger
      ActionController::Base.logger
    end
  end
end

RomaRails::RTTableUpdateHook.attach_to :action_controller
