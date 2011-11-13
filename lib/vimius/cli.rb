# -*- encoding: utf-8 -*-

require 'thor'

# Load all modules
Dir["#{VIMIUS_RUBY_PATH}/lib/vimius/cli/**/*.rb"].each { |f| require f }

module TechnoGate
  module Vimius
    module CLI
      class Runner < ::Thor
        # Include cli modules
        include CLI::Version
        include CLI::Install
        include CLI::Submodules
      end
    end
  end
end
