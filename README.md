# Redmine GoodJob plugin

This plugin adds a job queue to Redmine using [GoodJob](https://github.com/bensheldon/good_job).

## Compatibility

- GoodJob version: 4.5.1
- Redmine version: >= 5.1.0
- Ruby version: >= 3.1
- PostgreSQL version: >= 13.0

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

## Other configurations

### `database.yml` example

```yaml
  pool: <%= ENV.fetch("RAILS_MAX_THREADS", 5).to_i + ENV.fetch("GOOD_JOB_MAX_THREADS", 2).to_i %>
```

### `puma.rb` example

```ruby
workers ENV.fetch("PUMA_WORKERS", 3).to_i

before_fork do
  require 'puma_worker_killer'

  PumaWorkerKiller.config do |config|
    config.ram = ENV.fetch('RAILS_MEMORY_LIMIT', 2048).to_i
    config.frequency = 10
    config.percent_usage = 0.8
    config.rolling_restart_frequency = false
    config.reaper_status_logs = false
  end

  PumaWorkerKiller.start

  # Ensure GoodJob shuts down before forking
  GoodJob.shutdown
end

on_worker_boot do
  # Ensure GoodJob restarts after the worker boots
  GoodJob.restart
end

on_worker_shutdown do
  # Ensure GoodJob shuts down cleanly when a worker shuts down
  GoodJob.shutdown
end

MAIN_PID = Process.pid
at_exit do
  # Ensure GoodJob shuts down when the main process exits
  GoodJob.shutdown if Process.pid == MAIN_PID
end
```
