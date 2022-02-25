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

  print 'Stopping Sneakers...'
  sh "kill -SIGTERM `pidof ruby`"
  sh 'rm sneakers.pid'
  print "Done!\n"
end