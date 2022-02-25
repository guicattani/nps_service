# frozen_string_literal: true

class CreateNetPromoterScoreTestPublisher
  attr_accessor :payload

  def publish
    return false if payload.nil?

    conn = Bunny.new
    conn.start
    channel = conn.create_channel

    exchange = Bunny::Exchange.new(channel, :direct, "#{ENV['BUNNY_AMQP_EXCHANGE']}_test", { durable: true })

    queue = Bunny::Queue.new(channel, "#{ENV['CREATE_NPS_QUEUE_NAME']}_test", { durable: true })
    queue.bind(exchange, routing_key: "#{ENV['CREATE_NPS_QUEUE_NAME']}_test")

    exchange.publish(payload.to_json, routing_key: "#{ENV['CREATE_NPS_QUEUE_NAME']}_test")
    conn.close
  end
end
