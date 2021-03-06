# -*- encoding: utf-8 -*-

module TechnoGate
  module Vimius
    module Command
      class Version < TgCli::Base

        register "version", "Prints the Vimius version information", :alias => %w(-v --version)

        def execute
          puts "Vimius version #{Vimius.version}"
        end
      end
    end
  end
end

