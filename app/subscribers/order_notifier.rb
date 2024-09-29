class OrderNotifier
  def call(event)
    case event
    when OrderCancelled
      order = Order.find_by(id: event.data[:order_id])
      order.update(status: "cancelled")
      Rails.logger.info("Order cancelled: #{event.data}")
    end
  end
end
