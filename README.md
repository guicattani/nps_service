# NetPromoterScore Service

## Pre Requisites
- Docker
- docker-compose
- Ruby 3.1.1

## How to run
1. Install dependencies with `bundle install`
2. Setup RabbitMQ using `docker-compose up`
3. (Optional) Add `rabbitmq_management` plugin to RabbitMQ using `docker exec YOUR-CONTAINER-ID rabbitmq-plugins enable rabbitmq_management`
4. Start a Sneakers server with `rake sneakers:run WORKERS=CreateNetPromoterScoreWorker`
5. Start the server with `rails server`

## Running tests
Simply run `rake run_tests`

This will create a Sneakers server and run the tests.