require "bundler/gem_tasks"
require 'rake/testtask'
task :default => [:build_deps, :test]

task :build_deps do
  sh 'bundle check || bundle install', chdir: 'vendor/ruby-signature'
  sh 'bundle exec rake parser', chdir: 'vendor/ruby-signature'
end

Rake::TestTask.new do |test|
  test.libs << 'test'
  test.test_files = Dir['test/**/*_test.rb']
  test.verbose = true
end
