require "rubygems"
require "bundler/setup"

require "active_support/core_ext"
require "tg_config"

# Setup paths
VIMIUS_PATH = File.expand_path(File.join ENV['HOME'], '.vim', 'vimius')
VIMIUS_VIM_PATH = File.join VIMIUS_PATH, 'vim'
VIMIUS_RUBY_PATH = File.expand_path(File.join File.dirname(__FILE__), '..')
CONFIG_FILE = File.expand_path(File.join ENV['HOME'], '.vimius.yaml')
MODULES_FILE = File.join(VIMIUS_PATH, 'submodules.yaml')

module TechnoGate
  module Vimius
    extend self

    def config
      @config ||= TgConfig.new(CONFIG_FILE)
    end

    # Return Vimius path
    #
    # @return [String] The absolute path to Vimius distribution
    def vimius_path
      VIMIUS_PATH
    end

    # Return the vim's path
    #
    # @return [String] The absolute path to ViM files
    def vim_path
      VIMIUS_VIM_PATH
    end

    # Return the ruby's path
    #
    # @return [String] The absolute path to Ruby files
    def ruby_path
      VIMIUS_RUBY_PATH
    end

    # Expand the path of a given file
    #
    # @param [Array] args
    # @return [String] The expanded path to the given file.
    def expand(*args)
      File.expand_path(*args)
    end

    # Execute a command under root
    #
    # @param [String]* commands to run
    def sudo(*args)
      if ENV["USER"] != "root"
        command = "sudo #{args.join(" ")}"
        puts "Please enter your password (if requested) for executing the command '#{command}'"
      else
        command = args.join(" ")
      end

      exec command
    end
  end
end

require 'vimius/errors'
require 'vimius/shell'
require 'vimius/git'
require 'vimius/vim'
require 'vimius/gems'
require 'vimius/github'
require 'vimius/plugins'
require 'vimius/submodules'
require 'vimius/cli'
