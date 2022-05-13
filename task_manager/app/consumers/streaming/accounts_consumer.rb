module Streaming
  class AccountsConsumer < BaseConsumer
    include Sneakers::Worker

    from_queue 'accounts-stream.task-manager', exchange: 'accounts-stream', exchange_type: 'fanout', durable: false

    def execute
      logger.info 'Event consumed!'
      logger.info params.inspect

      case params['event_name']
      when 'AccountCreated'
        created_account = Account.create!(params['data'].slice(*account_attrs))
        logger.info "created account #{created_account.inspect}"
      when 'AccountUpdated'
        account = Account.find_by(public_id: params.dig('data', 'public_id'))
        account&.update!(params['data'].slice(*account_attrs))
        logger.info "updated account #{account.inspect}"
      when 'AccountDeleted'
        public_id = params.dig('data', 'public_id')
        account = Account.find_by(public_id: public_id)
        account&.destroy!
        logger.info "destroyed account #{public_id}"
      end
    end

    private

    def account_attrs
      %w[public_id email full_name role]
    end
  end
end
