# -*- encoding: utf-8 -*-

module TechnoGate
  module Vimius
    module CLI
      module Version

        def self.included(base)
          base.class_eval <<-END, __FILE__, __LINE__ + 1
            desc "version", "Print Vimius version and exit."
            def version
              puts "Vimius version \#{Vimius.version}"
            end
          END
        end
      end
    end
  end
end

