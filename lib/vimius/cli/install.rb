# -*- encoding: utf-8 -*-

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

              # Download the bootstrap file
              File.open('/tmp/vimius_bootstrap.sh', 'w') do |f|
                f.write(open('https://raw.github.com/TechnoGate/vimius/master/bootstrap.sh').read)
              end

              # Run the bootstrap file
              Shell.exec("cat /tmp/vimius_bootstrap.sh | sh", true)
            end

            protected
            def sanity_check
              if File.exists?(USER_VIM_PATH)
                abort "\#{USER_VIM_PATH} exists, cannot continue."
              end

              if File.exists?(USER_VIMRC_PATH)
                abort "\#{USER_VIMRC_PATH} exists, cannot continue."
              end

              if File.exists?(USER_GVIMRC_PATH)
                abort "\#{USER_GVIMRC_PATH} exists, cannot continue."
              end
            end
          END
        end
      end
    end
  end
end
