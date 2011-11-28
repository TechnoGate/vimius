# -*- encoding: utf-8 -*-

module TechnoGate
  module Vimius
    module Command
      class Update < TgCli::Base
        register "update", "Install & Update Janus plugins"

        def sanity_check
          unless File.exists?(USER_VIM_PATH) && File.exists?(MODULES_FILE)
            abort "Vimius is not installed, please run 'vimius install'"
          end
        end

        def submodules
          Vimius.submodules.active.each do |submodule|
            Shell.exec "cd #{USER_VIM_PATH}"
            Shell.exec "git submodule init -- #{submodule[:path]}"
            Shell.exec "git submodule sync -- #{submodule[:path]}"
            Shell.exec "git submodule update -- #{submodule[:path]}"
          end
        end

        def janus
          Shell.exec <<-EOS
# Source RVM so janus .rvmrc takes effect
[[ -s /usr/local/rvm/scripts/rvm ]] && source /usr/local/rvm/scripts/rvm
[[ -s $HOME/.rvm/scripts/rvm ]] && source $HOME/.rvm/scripts/rvm

# Source Rbenv so janus .rbenv-version takes effect
if ! type rbenv &> /dev/null; then
  if [[ -s $HOME/.rbenv/bin/rbenv ]]; then
    eval "`$HOME/.rbenv/bin/rbenv init -`"
  fi
fi

cd #{USER_VIM_PATH}

if [ ! -x `which gem 2>/dev/null` ]; then
  echo "Rubygems is not installed please install it (using system ruby)
  exit 1
fi

if [ ! -x `which gem 2>/dev/null` ]; then
  echo "Rake is not installed please install it (using system ruby)
fi

rake install
          EOS
        end
      end
    end
  end
end
