require 'rake/testtask'

task :default => :test

desc "Run all tests"
Rake::TestTask.new do |task|
  task.pattern = "test/*_test.rb"
end

desc "Run all specs"
Rake::TestTask.new(:spec) do |task|
  task.pattern = "spec/*_spec.rb"
end
