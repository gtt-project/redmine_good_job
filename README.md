# Redmine GoodJob plugin

This plugin adds a job queue to Redmine using [GoodJob](https://github.com/bensheldon/good_job).

## Compatibility

- GoodJob version: 4.0.2
- Redmine version: 5.1.0
- Ruby version: > 3.0
- PostgreSQL version: > 12.0

## Installation

1. Clone this repository to your Redmine plugins directory
2. Run `bundle install`
3. Run `bundle exec rake redmine:plugins:migrate`
4. Configure good_job in your additional environment configuration file (e.g. `config/additional_environment.rb`):
```ruby
# config/additional_environment.rb
# Set the queue adapter to GoodJob
config.active_job.queue_adapter = :good_job

# GoodJob configuration
config.good_job.execution_mode = ENV.fetch("GOOD_JOB_EXECUTION_MODE", 'async').to_sym
config.good_job.max_threads = ENV.fetch("GOOD_JOB_MAX_THREADS", 2).to_i
config.good_job.poll_interval = ENV.fetch("GOOD_JOB_POLL_INTERVAL", 10).to_i
```
5. Restart your Redmine instance
