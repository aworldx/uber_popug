class Event
  attr_reader :data, :name

  def initialize(data, name)
    @data = data
    @name = name
  end

  def to_hash
    event_attrs.merge(data: data)
  end

  private

  def event_attrs
    {
      event_id: SecureRandom.uuid,
      event_version: 1,
      event_time: Time.now.to_s,
      producer: 'task_manager',
      event_name: name
    }
  end
end
