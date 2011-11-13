# -*- coding: utf-8 -*-
require 'singleton'

module TechnoGate
  module Vimius
    class UI
      include Singleton

      ASCII_ART = File.read(File.join(File.dirname(__FILE__), 'vimius_ascii.txt'))

      def initialize
        @output = STDOUT
      end


      # Run the UI
      def run
        # Load the config
        config = Vimius.config
        # Great the user
        puts ASCII_ART
      end

      protected
      # Override Kernel#puts with a method invoke puts on the @output
      def puts(message)
        @output.puts message
      end
    end
  end
end

