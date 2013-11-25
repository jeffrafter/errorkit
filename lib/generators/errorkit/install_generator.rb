require 'rails/generators'
require 'rails/generators/active_record'

module Errorkit
  class InstallGenerator < Rails::Generators::Base
    include Rails::Generators::Migration

    desc "An error system for your Rails app"

    def self.source_root
      @source_root ||= File.join(File.dirname(__FILE__), 'templates')
    end

    def generate_errorkit
      generate_migration("create_errors")

      # Ensure the destination structure
      empty_directory "config"
      empty_directory "initializers"
      empty_directory "app"
      empty_directory "app/models"
      empty_directory "app/views"
      empty_directory "app/views/errors"
      empty_directory "spec"
      empty_directory "spec/models"
      empty_directory "spec/mailers"
      empty_directory "lib"

      # Fill out some templates (for now, this is just straight copy)
      template "config/initializers/errorkit.rb", "config/initializers/errorkit.rb"
      template "app/models/error.rb", "app/models/error.rb"
      template "spec/models/error_spec.rb", "spec/models/error_spec.rb"

      # Don't treat these like templates
      copy_file "app/views/errors/notify.html.erb", "app/views/errors/notify.html.erb"
      copy_file "app/views/errors/error.html.erb", "app/views/errors/error.html.erb"

      # RSpec needs to be in the development group to be used in generators
      gem_group :test, :development do
        gem "rspec-rails"
        gem "shoulda-matchers"
        gem 'factory_girl_rails'
      end
    end

    def self.next_migration_number(dirname)
      ActiveRecord::Generators::Base.next_migration_number(dirname)
    end

    protected

    def generate_migration(filename)
      if self.class.migration_exists?("db/migrate", "#{filename}")
        say_status "skipped", "Migration #{filename}.rb already exists"
      else
        migration_template "db/migrate/#{filename}.rb", "db/migrate/#{filename}.rb"
      end
    end
  end
end
