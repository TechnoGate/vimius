require 'singleton'

module TechnoGate
  module Vimius
    class UI
      include Singleton

      # Run the UI
      def run
        # Load the config
        config = Vimius.config

      end
    end
  end
end
