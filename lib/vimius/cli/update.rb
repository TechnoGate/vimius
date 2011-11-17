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
              sanity_check_update
              # Fetch the active submodules
              active_submodules = Vimius.submodules.active_by_group
              # Go into the vimius folder
              Dir.chdir(USER_VIM_PATH) do
                # Update the active submodules
                active_submodules.each do |group, submodules|
                  submodules.each do |submodule|
                    Shell.exec "git submodule update --init -- \#{submodule[:path]}"
                  end
                end
              end
            end

            protected
            def sanity_check_update
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
