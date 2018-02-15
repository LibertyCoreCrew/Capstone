require_relative 'boot'

require 'rails/all'
require_relative './drivemanager/driveapi.rb'
require_relative './drivemanager/manager.rb'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Liberty
  # Starts the back-end process thread
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1

    if defined?(Rails::Server)
      config.after_initialize do
        Thread.new do
          begin
            manager = DriveManager::Manager.new
            initialize_data(manager)
          rescue StandardError => e
            puts "Error during processing: #{e}"
            puts "Backtrace:\n\t#{e.backtrace.join("\n\t")}"
            puts e.class
            raise e
          end
          # We will do back-end stuff here.
        end
      end
    end

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    def initialize_data(manager)
      
    end
  end
end
