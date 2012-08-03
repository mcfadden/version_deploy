module VersionDeploy
  #require "lib/version_deploy/railtie" if defined?(Rails)
  require 'rake'
  load 'rake/version_deploy_task.rb'
end