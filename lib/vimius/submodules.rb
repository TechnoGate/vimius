module TechnoGate
  module Vimius
    class Submodules < TgConfig

      # Return the submodules
      #
      # @return [Hash]
      def submodules
        @submodules ||= self[:submodules].map { |k, v| v.merge(:name => k) }
      end

      # Return the submodules bu group
      #
      # @return [Hash]
      def submodules_by_group
        submodules.group_by { |submodule| submodule[:group] }
      end

      # Return the submodules bu name
      #
      # @return [Hash]
      def submodules_by_name
        res = {}
        submodules.each do |submodule|
          res[submodule[:name]] = submodule
        end
        res
      end

      # Return a submodule along with all its dependencies
      #
      # @return [Array]
      def submodule_with_dependencies(name)
        res = [submodule(name)]
        dependencies(name).each do |dependency|
          res << submodule(dependency)
        end

        res.flatten.uniq
      end

      # Find the submodule given bu the name
      #
      # @param [String] name
      # @return [Hash]
      def submodule(name)
        submodules.select { |s| s[:name].to_s == name.to_s }.
          first
      end

      # Return an array of active submodules
      #
      # @return [Array]
      def active
        TgConfig[:submodules].map do |submodule|
          submodule(submodule)
        end
      end

      # Return all available groups
      #
      # @return [Array]
      def groups
        submodules.map { |submodule| submodule[:group] }.uniq.sort
      end

      protected
      # Return a list of all dependencies of a submodule (recursive)
      #
      # @param [String] name
      # @return [Array]
      def dependencies(name)
        dependencies = []
        submodule = submodule(name)
        if submodule.has_key?(:dependencies)
          submodule[:dependencies].each do |dependency|
            dependencies << dependency
            dependencies << dependencies(dependency)
          end
        end

        dependencies.flatten.uniq.sort
      end
    end
  end
end
