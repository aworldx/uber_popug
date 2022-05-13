class Producer
  def call(event, topic:)
    send_rabbitmq_event(event, topic)
  end

  private

  def send_rabbitmq_event(event, topic)
    require 'bunny'

    connection = Bunny.new(ENV['AMQP_URL'])
    connection.start

    channel = connection.create_channel
    exchange = channel.fanout(topic)
    exchange.publish(event.to_hash.to_json)

    connection.close
  end
end
