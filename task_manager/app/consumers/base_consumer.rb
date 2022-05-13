require 'sneakers/handlers/maxretry'

class BaseConsumer
  attr_accessor :params

  def work(msg)
    @params = JSON.parse(msg)

    execute

    ack!
  end

  def execute
    raise NotImplementedError
  end
end
