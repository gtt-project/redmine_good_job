# plugins/redmine_good_job/init.rb
require 'good_job/engine'
require_relative 'lib/redmine_good_job_auth'

Redmine::Plugin.register :redmine_good_job do
  name 'Redmine Good Job plugin'
  author 'Georepublic'
  author_url 'https://github.com/georepublic'
  url 'https://github.com/gtt-project/redmine_good_job'
  description 'Add support for Good Job background job processing to Redmine.'
  version '1.0.0'

  requires_redmine version_or_higher: '5.1.0'

  settings default: {}, partial: 'settings/redmine_good_job_settings'
end

# Add the middleware during the initialization phase
Rails.application.config.to_prepare do
  Rails.application.config.middleware.use RedmineGoodJobAuth
end
