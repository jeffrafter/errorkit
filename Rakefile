require "bundler/gem_tasks"
require 'rspec/core/rake_task'

gem_name = :errorkit

task :spec => ["generator:cleanup", "generator:prepare", "generator:#{gem_name}"] do
  system "cd spec/tmp/sample; bundle exec rspec --color"
end

namespace :generator do
  desc "Cleans up the sample app before running the generator"
  task :cleanup do
    FileUtils.rm_rf("spec/tmp/sample") if Dir.exist?("spec/tmp/sample") if ENV['SKIP_CLEANUP'].nil?
  end

  desc "Prepare the sample app before running the generator"
  task :prepare do
    next if Dir.exist?("spec/tmp/sample")

    FileUtils.mkdir_p("spec/tmp")

    system "cd spec/tmp && rails new sample --skip-spring"
    system "cp .ruby-version spec/tmp/sample" if File.exist?(".ruby-version")

    # bundle
    gem_root = File.expand_path(File.dirname(__FILE__))
    system "echo \"gem 'rspec-rails'\" >> spec/tmp/sample/Gemfile"
    system "echo \"gem '#{gem_name}', :path => '#{gem_root}'\" >> spec/tmp/sample/Gemfile"

    system "cd spec/tmp/sample; bundle install"
    system "cd spec/tmp/sample; bin/rails g rspec:install"

    # Make a thing
    system "cd spec/tmp/sample; bin/rails g scaffold thing name:string mood:string"
  end

  # This task is not used unless you need to test the generator with an alternate database
  # such as mysql or postgres. By default the sample application utilize sqlite3
  desc "Prepares the application with an alternate database"
  task :database do
    puts "==  Configuring the database =================================================="
    system "cp config/database.yml.example spec/tmp/sample/config/database.yml"
    system "cd spec/tmp/sample; bundle exec rake db:migrate:reset"
  end

  desc "Run the #{gem_name} generator"
  task gem_name do
    system "cd spec/tmp/sample; bin/rails g #{gem_name}:install --force && bundle exec rake db:migrate"
  end

end

task :default => :spec
