require 'rspec/core/rake_task'

# Define the "spec" task, at task load time rather than inside another task
RSpec::Core::RakeTask.new(:spec)

desc 'Run tests with Sneakers'
task :run_tests do
  print "################\n"
  print "Starting Sneakers...\n"
  print "################\n"
  sh 'rake sneakers:run WORKERS=CreateNetPromoterScoreWorker RAILS_ENV=test'
  print "################\n"
  print "Running tests...\n"
  print "################\n"

  Rake::Task["spec"].invoke

  sh 'rm sneakers.pid'
  print 'Stopping Sneakers and lefover rubies... (this will give rake error and it is expected, see Known Issues in the README file)'
  sh "kill -SIGTERM `pidof ruby`"
end