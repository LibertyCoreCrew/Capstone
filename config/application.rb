require_relative 'boot'

require 'rails/all'
require_relative './drivemanager/driveapi.rb'
require_relative './drivemanager/manager.rb'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module DriveManager
  # Starts the back-end process thread
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1
    config.autoload_paths += %W(#{config.root}/config)
    config.autoload_paths += Dir["#{config.root}/config/**/"]

    if defined?(Rails::Server)
      config.after_initialize do
        Thread.new do
          begin
            # manager = Manager.new
            # DriveAPI.test_method(manager.service)
          rescue StandardError => e
            puts "Error during processing: #{e}"
            puts "Backtrace:\n\t#{e.backtrace.join("\n\t")}"
            puts e.class
            raise e
          end
        end
      end
    end
  end
end
