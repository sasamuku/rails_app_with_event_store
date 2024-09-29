class Order < ApplicationRecord
  include AggregateRoot
  class HasBeenAlreadySubmitted < StandardError; end
  class HasExpired < StandardError; end

  def initialize
    self.status = :new
    # any other code here
  end

  def submit
    raise HasBeenAlreadySubmitted if status == :submitted
    raise HasExpired if status == :expired
    apply OrderSubmitted.new(data: { delivery_date: Time.now + 24.hours })
  end

  def expire
    apply OrderExpired.new
  end

  on OrderSubmitted do |event|
    self.status = :submitted
    @delivery_date = event.data.fetch(:delivery_date)
  end

  on OrderExpired do |event|
    self.status = :expired
  end
end
