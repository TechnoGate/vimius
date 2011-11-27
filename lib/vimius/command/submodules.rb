module TechnoGate
  module Vimius
    module Command
      class Submodules < TgCli::GroupBase
        register "submodules", "Commands to manage submodules"

        desc "list", "List submodules"
        def list
          Vimius.submodules.submodules_by_group.each do |group, submodules|
            puts group
            submodules.each do |submodule|
              name = submodule[:name]
              marker = Vimius.submodules.active?(name) ? ' |== ' : ' |-- '
              puts "#{marker}#{name}"
            end
          end

          puts ""
          puts "Active submodules are prefixed with the '|==' marker"
        end

        desc "activate <submodule>", "Activates a submodule with all it's dependencies"
        def activate(submodule_name)
          Vimius.submodules.activate(submodule_name)  and
            puts "#{submodule_name} has been activated please run 'vimius update'"
        rescue SubmoduleAlreadyActiveError
          abort "#{submodule_name} is already active"
        rescue SubmoduleNotFoundError
          abort "#{submodule_name} does not exist"
        end

        desc "deactivate <submodule> [-d]", "Deactivates a submodule"
        method_option :dependency,
          :type => :boolean,
          :aliases => "-d",
          :default => false,
          :description => "Deactivate a submodule and everything that depends on it"
        def deactivate(submodule_name)
          deactivated = Vimius.submodules.deactivate(submodule_name, :remove_dependent => options[:dependency])
          if deactivated && deactivated.any?
            puts "The following submodules has been deactivated, please run 'vimius update'"
            deactivated.each do |sub|
              puts "- #{sub}"
            end
          end
        rescue SubmoduleNotActiveError
          abort "#{submodule_name} is not active"
        rescue SubmoduleNotFoundError
          abort "#{submodule_name} does not exist"
        rescue SubmoduleIsDependedOnError => e
          messages = []
          messages << "#{submodule_name} cannot be deactivated because it is depended on by:"
          e.message.split(' ').each do |submodule|
            messages << "- #{submodule}"
          end
          messages << ""
          messages << "Please re-run with the '-d' flag if you want to remove this submodule and all the submodules the depends on it"
          abort messages.join("\n")
        end
      end
    end
  end
end
