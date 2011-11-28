# -*- encoding: utf-8 -*-

module TechnoGate
  module Vimius
    module Command
      class Default < TgCli::Base
        register "default", "Default vimius task", :default => true

        def execute
          puts File.read(VIMIUS_ASCII_PATH)
          help
        end
      end
    end
  end
end
