# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require_relative 'config/application'

Rails.application.load_tasks

Rake::Task["default"].clear if Rake::Task.task_defined?("default")

task :default do
  puts "Starting specs"
  system('bundle exec rspec')

  puts "Starting tests"
  system('bundle exec rake test')
end

