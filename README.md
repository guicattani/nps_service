# NetPromoterScore Service

## Pre Requisites
- Docker
- docker-compose
- Ruby 3.1.1

## How to run
1. Install dependencies with `bundle install`
2. Setup RabbitMQ using `docker-compose up`
3. (Optional) Add `rabbitmq_management` plugin to RabbitMQ using `docker exec YOUR-CONTAINER-ID rabbitmq-plugins enable rabbitmq_management` (this will enable RabbitMQ admin panel on `http://0.0.0.0:15672`)
4. Start a Sneakers server with `rake sneakers:run WORKERS=CreateNetPromoterScoreWorker`
5. Start the server with `rails server`

## Running tests
Simply run `rake run_tests`

This will create a Sneakers server and run the tests.

## Known issues
Rake tests leave ruby instances running in the background running unless all rubies instances are terminated together, so all ruby pids are terminated, **this may lead to a server stopping**, because all running rubies all will receive SIGTERM.