# -*- encoding: utf-8 -*-

require 'fileutils'
require 'open-uri'

module TechnoGate
  module Vimius
    module Command
      class Install < TgCli::Base

        register "install", "Install Janus"

        def execute
          sanity_check
          Shell.exec("git clone -b #{REPO_BRANCH} #{REPO_URL}")
        end

        protected
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
      end
    end
  end
end


if false
  require 'fileutils'

  module TechnoGate
    module Vimius
      module CLI
        module Install

          def self.included(base)
            base.send :require, 'open-uri'
            base.class_eval <<-END, __FILE__, __LINE__ + 1
              desc "install", "Install vimius"
              def install
                # Sanity check
                sanity_check

                # Clone the repository
                Shell.exec("git clone git://github.com/TechnoGate/vimius.git ~/.vim")

                # Create symlinks
                FileUtils.ln_s(File.join(USER_VIM_PATH, 'vimius', 'vimrc'), USER_VIMRC_PATH)
                FileUtils.ln_s(File.join(USER_VIM_PATH, 'vimius', 'gvimrc'), USER_GVIMRC_PATH)
              end

              desc "setup", "Move away any non-vimius installation and install vimius"
              def setup
                # Make way for Vimius
                make_way_for_vimius
                # Call the install task
                install
              end

              protected
              def sanity_check
                if File.exists?(USER_VIM_PATH)
                  abort "\#{USER_VIM_PATH} exists, cannot continue, please run 'vimius setup' instead."
                end

                if File.exists?(USER_VIMRC_PATH)
                  abort "\#{USER_VIMRC_PATH} exists, cannot continue, please run 'vimius setup' instead."
                end

                if File.exists?(USER_GVIMRC_PATH)
                  abort "\#{USER_GVIMRC_PATH} exists, cannot continue, please run 'vimius setup' instead."
                end
              end

              def make_way_for_vimius
                if File.exists?(USER_VIM_PATH)
                  FileUtils.mv USER_VIM_PATH, "\#{USER_VIM_PATH}.old"
                end

                if File.exists?(USER_VIMRC_PATH)
                  FileUtils.mv USER_VIMRC_PATH, "\#{USER_VIMRC_PATH}.old"
                end

                if File.exists?(USER_GVIMRC_PATH)
                  FileUtils.mv USER_GVIMRC_PATH, "\#{USER_GVIMRC_PATH}.old"
                end
              end
            END
          end
        end
      end
    end
  end
end
