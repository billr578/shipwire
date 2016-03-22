module Shipwire
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path('../templates', __FILE__)

      def copy_initializer_file
        file = 'config/initializers/shipwire.rb'

        copy_file(file, file)
      end
    end
  end
end
