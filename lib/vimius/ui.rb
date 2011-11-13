require 'singleton'

module TechnoGate
  module Vimius
    class UI
      include Singleton

      def initialize
        @output = STDOUT
      end

      # Run the UI
      def run
        # Load the config
        config = Vimius.config
      end
    end
  end
end
