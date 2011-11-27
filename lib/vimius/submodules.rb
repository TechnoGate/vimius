module TechnoGate
  module Vimius
    class Submodules < TgConfig

      # Return the submodules
      #
      # @return [Hash]
      def submodules
        return @submodules if @submodules && @submodules.any?

        @submodules = []

        raise SubmoduleNotFoundError unless self[:submodules]

        self[:submodules].each do |group, submodules|
          submodules.each do |name, submodule|
            submodule ||= {}

            submodule.reverse_merge! "name" => name,
              "description" => "",
              "group" => group,
              "path" => submodule_path(name, group),
              "dependencies" => []

            @submodules << submodule.with_indifferent_access
          end
        end

        @submodules
      rescue Errno::ENOENT => e
        raise SubmoduleNotFoundError, e
      end

      # Return the submodules bu group
      #
      # @param [HashWithIndifferentAccess] submodules
      # @return [Hash]
      def submodules_by_group(submodules = nil)
        submodules ||= self.submodules

        submodules.group_by { |submodule| submodule[:group] }
      end

      # Return the active submodules by group
      #
      # @return [Hash]
      def active_by_group
        submodules_by_group(active)
      end

      # Return the inactive submodules by group
      #
      # @return [Hash]
      def inactive_by_group
        submodules_by_group(inactive)
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
          self.submodule(submodule)
        end
      rescue NoMethodError
        []
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
        raise SubmoduleAlreadyActiveError if active?(submodule_name)

        Vimius.config[:submodules] ||= []
        Vimius.config[:submodules] += [submodule_name]
        dependencies(submodule_name).each do |submodule|
          Vimius.config[:submodules] += [submodule] unless active?(submodule)
        end
      end

      # Deactive a submodule
      # The *options+ hash has the following valid keys
      #   - [Boolean] remove_dependent: Remove also dependent modules
      #
      # @param [String] Submodule's name
      # @param [Hash] options
      # @return [Array] deactivated submodules
      def deactivate(submodule_name, options = {})
        return unless Vimius.config[:submodules]
        raise SubmoduleNotActiveError unless active?(submodule_name)
        # Fetch the reverse dependencies
        rd = reverse_dependencies(submodule_name)
        raise SubmoduleIsDependedOnError, rd.join(' ') if rd.any? && !options[:remove_dependent]

        Vimius.config[:submodules] -= [submodule_name] + rd

        [submodule_name] + rd
      end

      # Check if a submodule is active
      #
      # @param [String] Submodule's name
      # @return [Boolean] true if submodule is active
      def active?(submodule_name)
        active.select { |s| s[:name].to_s == submodule_name.to_s }.any?
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

      # Return a list of all submodules that dependens on this submodule
      #
      # @param [String] name
      # @return [Array]
      def reverse_dependencies(name)
        reverse_dependencies = []
        submodules.each do |submodule|
          next if submodule[:name] == name

          reverse_dependencies << submodule[:name] if dependencies(submodule[:name]).include?(name)
        end

        reverse_dependencies.flatten.uniq.sort
      end

      def submodule_path(name, group)
        "vimius/vim/#{group}/#{name}"
      end
    end
  end
end
