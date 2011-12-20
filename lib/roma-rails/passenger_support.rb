# -*- coding: utf-8 -*-

if defined?(PhusionPassenger)
  PhusionPassenger.on_event(:starting_worker_process) do |forked|
    if forked
      Rails.logger.info("All ROMA client pool release due to passenger was forked")
      Roma::Client::ClientPool.release_all
    end
  end
end
