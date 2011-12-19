# -*- coding: utf-8 -*-
require 'rack/session/abstract/id'
require 'roma-client'

module Rack
  module Session
    # Rack::Session::Roma provides simple cookie based session management.
    # Session data is stored in ROMA. The corresponding session key is
    # maintained in the cookie.
    # You may treat Session::Roma as you would Session::Pool with the
    # following caveats.
    #
    # * Setting :expire_after to 0 would note to the ROMA server to hang
    #   onto the session data until it would drop it according to it's own
    #   specifications. However, the cookie sent to the client would expire
    #   immediately.
    class Roma < Abstract::ID
      attr_reader :mutex

      # RomaStore constractor .
      #
      # If :roma_client_pool_name option is set, this library use
      # Roma::Client::ClientPool.instance(options[:roma_client_pool_name].
      # If :roma_client_pool_name option is not set, this library use
      # :default name.
      def initialize(app, options = {})
        options[:expire_after] ||= options[:expires]
        super

        @mutex = Mutex.new
        instance_name = options[:roma_client_pool_name] || :default

        @pool = ::Roma::Client::ClientPool.instance(instance_name)
      end

      def generate_sid
        loop do
          sid = super
          val = nil
          @pool.client do |client|
            val = client.get(sid)
          end
          break sid unless val
        end
      end

      def get_session(env, sid)
        session = {}
        with_lock(env, [nil, {}]) do
          @pool.client do |client|

            unless sid and session = client.get(sid)
              sid, session = generate_sid, {}
              unless /^STORED/ =~ client.add(sid, session)
                raise "Session collision on '#{sid.inspect}'"
              end
            end
          end
        end

        [sid, session]
      end

      def set_session(env, session_id, new_session, options)
        expiry = options[:expire_after]
        expiry = expiry.nil? ? 0 : expiry + 1

        with_lock(env, false) do
          @pool.client do |client|
            client.set session_id, new_session, expiry
          end
          session_id
        end
      end

      def destroy_session(env, session_id, options)
        with_lock(env) do
          @pool.client do |client|
            client.delete(session_id)
          end
          generate_sid unless options[:drop]
        end
      end

      # get current session id
      #
      # Overwrite AbstractStore for security reason.
      # Check session id is correct value.
      def current_session_id(env)
        if env[Abstract::ENV_SESSION_OPTIONS_KEY][:id]
          if env[Abstract::ENV_SESSION_OPTIONS_KEY][:id] =~ /^[0-9a-zA-Z]{#{@sid_length*2}}$/
            return env[Abstract::ENV_SESSION_OPTIONS_KEY][:id]
          else
            env[Abstract::ENV_SESSION_OPTIONS_KEY][:id] = nil
            return nil
          end
        end
      end

      def with_lock(env, default=nil)
        @mutex.lock if env['rack.multithread']
        yield
      rescue Exception
        default
      ensure
        @mutex.unlock if @mutex.locked?
      end
    end
  end
end
