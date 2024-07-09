# for dashboard
require 'good_job/engine'

Redmine::Plugin.register :redmine_good_job do
  name 'Redmine Good Job plugin'
  author 'Georepublic'
  author_url 'https://github.com/georepublic'
  url 'https://github.com/gtt-project/redmine_good_job'
  description 'Add support for Good Job background job processing to Redmine.'
  version '1.0.0'

  requires_redmine version_or_higher: '5.1.0'
end
