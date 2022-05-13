module Sneakers
  module ActiveRecord
    module ConnectionManagement
      # https://github.com/jondot/sneakers/issues/302
      # https://github.com/rails/rails/commit/c7b7c6ad1c773102753f1a11b857d0e37ceb6a21
      def process_work(delivery_info, metadata, msg, handler)
        super
      ensure
        ::ActiveRecord::Base.clear_active_connections! unless ENV['RAILS_ENV'] == 'test'
      end
    end
  end
end

module Sneakers
  module Worker
    Rails.logger.send(:warn, { message: 'Patch Sneakers::Worker to clear ActiveRecord connections' }.to_json)
    prepend Sneakers::ActiveRecord::ConnectionManagement
  end
end

Sneakers.configure connection: Bunny.new(addresses: 'rabbitmq:5672',
                                         username: 'guest',
                                         password: 'guest',
                                         vhost: '/',
                                         logger: Rails.logger,
                                         connection_attempts: 5),
                   workers: 1,
                   ack: true

Sneakers.logger.level = :info
