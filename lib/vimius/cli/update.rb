# -*- encoding: utf-8 -*-

module TechnoGate
  module Vimius
    module CLI
      module Update

        def self.included(base)
          base.class_eval <<-END, __FILE__, __LINE__ + 1
            desc "update", "Update vimius"
            def update
              # Sanity check
              sanity_check
            end

            protected
            def sanity_check
              unless File.exists?(USER_VIM_PATH) && File.exists?(MODULES_FILE)
                abort "Vimius is not installed, please run 'vimius install'"
              end
            end
          END
        end
      end
    end
  end
end
