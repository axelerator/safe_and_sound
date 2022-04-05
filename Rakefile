# frozen_string_literal: true

require 'rake'
require 'rubocop/rake_task'
require 'rake/testtask'

RuboCop::RakeTask.new

Rake::TestTask.new do |t|
  t.libs << 'test'
  t.test_files = FileList['test/**/*_test.rb']
  t.verbose = true
end

task default: :test
