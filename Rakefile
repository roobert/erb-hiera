require "bundler/gem_tasks"
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:spec)

task :default => :spec

task :guard do
  Kernel.system("bundle exec guard --clear")
end
