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
      # @param [HashWithIndifferentAccess] submodules
      # @return [Hash]
      def submodules_by_group(submodules = nil)
        submodules ||= self.submodules

        submodules.group_by { |submodule| submodule[:group] }
      end

      # Return the submodules bu name
      #
      # @param [HashWithIndifferentAccess] submodules
      # @return [Hash]
      def submodules_by_name(submodules = nil)
        submodules ||= self.submodules

        res = {}
        submodules.each do |submodule|
          res[submodule[:name]] = submodule
        end
        res
      end

      # Return the active submodules by group
      #
      # @return [Hash]
      def active_by_group
        submodules_by_group(active)
      end

      # Return the active submodules by name
      #
      # @return [Hash]
      def active_by_name
        submodules_by_name(active)
      end

      # Return the inactive submodules by group
      #
      # @return [Hash]
      def inactive_by_group
        submodules_by_group(inactive)
      end

      # Return the inactive submodules by name
      #
      # @return [Hash]
      def inactive_by_name
        submodules_by_name(inactive)
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
        Vimius.config[:submodules].map do |submodule|
          submodule(submodule)
        end
      end

      # Return an array of inactive submodiles
      #
      # @return [Array]
      def inactive
        submodules - active
      end

      # Return all available groups
      #
      # @return [Array]
      def groups
        submodules.map { |submodule| submodule[:group] }.uniq.sort
      end

      # Activate a submodule
      #
      # @param [String] Submodule's name
      def activate(submodule_name)
        Vimius.config[:submodules] ||= []
        Vimius.config[:submodules] += [submodule_name] unless active?(submodule_name)
      end

      # Deactive a submodule
      #
      # @param [String] Submodule's name
      def deactivate(submodule_name)
        return unless Vimius.config[:submodules]
        return unless active?(submodule_name)

        Vimius.config[:submodules] -= [submodule_name]
      end

      # Check if a submodule is active
      #
      # @param [String] Submodule's name
      # @return [Boolean] true if submodule is active
      def active?(submodule_name)
        active_by_name.map {|k, v| k.to_s}.include?(submodule_name.to_s)
      end

      # Check if a submodule is inactive
      #
      # @param [String] Submodule's name
      # @return [Boolean] true if submodule is inactive
      def inactive?(submodule_name)
        !!!active?(submodule_name) && submodule(submodule_name).present?
      end

      # Toggle a submodule
      #
      # @param [String] Submodule's name
      # @raise [SubmoduleNotFoundError]
      def toggle(submodule_name)
        if active?(submodule_name)
          deactivate(submodule_name)
        elsif inactive?(submodule_name)
          activate(submodule_name)
        else
          raise SubmoduleNotFoundError
        end
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
