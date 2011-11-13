# -*- encoding: utf-8 -*-

module TechnoGate
  module Vimius
    module CLI
      module Install

        def self.included(base)
          base.class_eval <<-END, __FILE__, __LINE__ + 1
            desc "Install vimius", "install"
            def install
              if File.exists?(USER_VIM_PATH)
                puts "\#{USER_VIM_PATH} exists, cannot continue."
              end
            end
          END
        end
      end
    end
  end
end
