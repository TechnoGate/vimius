# -*- encoding: utf-8 -*-

module TechnoGate
  module Vimius
    module CLI
      module Submodules

        def self.included(base)
          base.send :require, 'thor/group'
          base.class_eval <<-END, __FILE__, __LINE__ + 1
            class SubmodulesList < ::Thor
              desc "submodules list by_group", "List submodules by group"
              def by_group
                Vimius.submodules.submodules_by_group.each do |group, submodules|
                  puts group
                  submodules.each do |submodule|
                    name = submodule[:name]
                    marker = Vimius.submodules.active?(name) ? ' |== ' : ' |-- '
                    puts "\#{marker}\#{name}"
                  end
                end

                puts ""
                puts "Active submodules are prefixed with the '|==' marker"
              end

              desc "submodules list by_name", "List submodules by name"
              def by_name
                Vimius.submodules.submodules_by_name.each do |name, submodule|
                  if Vimius.submodules.active?(name)
                    puts "== \#{name}, group: \#{submodule[:group]}"
                  else
                    puts "-- \#{name}, group: \#{submodule[:group]}"
                  end
                end

                puts ""
                puts "Active submodules are prefixed with the '==' marker"
              end
            end

            class Submodules < ::Thor
              desc "submodules activate <submodule>", "Activates a submodule with all it's dependencies"
              def activate(submodule_name)
                Vimius.submodules.activate(submodule_name) and
                  puts "\#{submodule_name} has been activated please run 'vimius update'"
              rescue SubmoduleAlreadyActiveError
                abort "\#{submodule_name} is already active"
              end

              desc "submodules deactivate <submodule>", "Deactivates a submodule"
              def deactivate(submodule_name)
                Vimius.submodules.deactivate(submodule_name) and
                  puts "\#{submodule_name} has been deactivated please run 'vimius update'"
              rescue SubmoduleNotActiveError
                abort "\#{submodule_name} is not active"
              rescue SubmoduleIsDependedOnError => e
                puts "\#{submodule_name} cannat be deactivated because it is depended on by:"
                e.message.split(' ').each do |submodule|
                  puts "- \#{submodule}"
                end
                abort ""
              end

              register(SubmodulesList, 'list', 'list <command>', 'List submodules.')
            end

            register(Submodules, 'submodules', 'submodules <command>', 'Operate on submodules')

          END
        end
      end
    end
  end
end
