# -*- encoding: utf-8 -*-

module TechnoGate
  module Vimius
    module Command
      class Default < TgCli::Base
        register "default", "Default vimius task", :default => true

        WIDTH = 72

        def vimius_ascii
          puts File.read(VIMIUS_ASCII_PATH)
          puts ""
        end

        def license
          message = <<-EOM
Copyright (c) 2011 TechnoGate <support@technogate.fr>
Released under the MIT License
          EOM

          message.split("\n").each { |l| puts l.center(WIDTH).rstrip }
          puts ""
        end

        def help
          puts File.read(VIMIUS_HELP_PATH)
          puts ""
          super
        end
      end
    end
  end
end
