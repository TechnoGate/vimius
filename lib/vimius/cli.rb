# -*- encoding: utf-8 -*-

require 'thor'

# Load all modules
Dir["#{VIMIUS_LIB_PATH}/vimius/cli/**/*.rb"].each { |f| require f }

module TechnoGate
  module Vimius
    module CLI

      ASCII_ART = File.read(File.join(File.dirname(__FILE__), 'vimius_ascii.txt'))

      class Runner < ::Thor
        # Include cli modules
        include CLI::Version
        include CLI::Install
        include CLI::Submodules
        include CLI::Update
      end
    end
  end
end
