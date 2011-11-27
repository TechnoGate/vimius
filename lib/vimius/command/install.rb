# -*- encoding: utf-8 -*-

require 'fileutils'

module TechnoGate
  module Vimius
    module Command
      class Install < TgCli::Base

        register "install", "Install Janus"

        def sanity_check
          if ::File.exists?(USER_VIM_PATH)
            abort "#{USER_VIM_PATH} exists, cannot continue, please run 'vimius setup' instead."
          end

          if ::File.exists?(USER_VIMRC_PATH)
            abort "#{USER_VIMRC_PATH} exists, cannot continue, please run 'vimius setup' instead."
          end

          if ::File.exists?(USER_GVIMRC_PATH)
            abort "#{USER_GVIMRC_PATH} exists, cannot continue, please run 'vimius setup' instead."
          end
        end

        def execute
          Shell.exec("git clone -b #{REPO_BRANCH} #{REPO_URL}")
        end
      end
    end
  end
end
