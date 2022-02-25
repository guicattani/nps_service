# frozen_string_literal: true

# config/initializers/sneakers.rb
require 'sneakers'
require 'sneakers/handlers/maxretry'

module Connection
  def self.sneakers
    @sneakers ||= Bunny.new(
      addresses: ENV['BUNNY_AMQP_ADDRESSES']&.split(','),
      username: ENV['BUNNY_AMQP_USER'],
      password: ENV['BUNNY_AMQP_PASSWORD'],
      vhost: ENV['BUNNY_AMQP_VHOST'],
      automatically_recover: true,
      connection_timeout: 2,
      continuation_timeout: (ENV['BUNNY_CONTINUATION_TIMEOUT'] || 10_000).to_i
    )
  end
end

EXCHANGE_NAME = Rails.env.test? ? "#{ENV['BUNNY_AMQP_EXCHANGE']}_test" : ENV['BUNNY_AMQP_EXCHANGE']

Sneakers.configure  connection: Connection.sneakers,
                    exchange: EXCHANGE_NAME,
                    exchange_options: { durable: true },
                    runner_config_file: nil,                             # A configuration file (see below)
                    metric: nil,                                         # A metrics provider implementation
                    daemonize: true,                                     # Send to background
                    workers: ENV['SNEAKERS_WORKER'].to_i,                # Number of per-cpu processes to run
                    log: $stdout, # Log file
                    pid_path: 'sneakers.pid',                            # Pid file
                    timeout_job_after: 5 * 3600,                         # Maximal seconds to wait for job
                    prefetch: ENV['SNEAKERS_PREFETCH'].to_i,             # Grab 10 jobs together. Better speed.
                    threads: ENV['SNEAKERS_THREADS'].to_i,               # Threadpool size (good to match prefetch)
                    env: ENV['RAILS_ENV'],                               # Environment
                    durable: true,                                       # Is queue durable?
                    ack: true,                                           # Must we acknowledge?
                    heartbeat: 5,                                        # Keep a good connection with broker
                    handler: Sneakers::Handlers::Maxretry,
                    retry_max_times: 10,                             # how many times to retry the failed worker process
                    retry_timeout: 3 * 60 * 1000                     # how long between each worker retry duration

# create queues
QUEUE_NAME = Rails.env.test? ? "#{ENV['CREATE_NPS_QUEUE_NAME']}_test" : ENV['CREATE_NPS_QUEUE_NAME']

conn = Bunny.new
conn.start
channel = conn.create_channel
exchange = Bunny::Exchange.new(channel, :direct, EXCHANGE_NAME, { durable: true })
queue = Bunny::Queue.new(channel, QUEUE_NAME, { durable: true })
queue.bind(exchange, routing_key: QUEUE_NAME)
conn.close

Sneakers.logger.level = Logger::INFO
Rails.logger = Logger.new $stdout
Rails.logger.level = 0
# adapted from https://medium.com/kudos-to-you/background-job-in-rails-using-rabbitmq-and-sneaker-449c07284abf
