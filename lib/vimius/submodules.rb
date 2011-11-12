module Vimius
  class Submodules

    MODULES_FILE = File.join(VIMIUS_PATH, 'submodules.yaml')

    # Return the submodules
    #
    # @return [Hash]
    def submodules
      @submodules ||= parse_submodules_yaml_file
    end

    # Return the submodules bu group
    #
    # @return [Hash]
    def submodules_by_group
      submodules.group_by { |submodule| submodule[:group] }
    end

    # Return a submodule along with all its dependencies
    #
    # @return [Array]
    def submodule(name)
      res = [find_submodule(name)]
      dependencies(name).each do |dependency|
        res << submodule(dependency)
      end

      res.flatten.uniq
    end

    # Return an array of active submodules
    #
    # @return [Array]
    def active

    end

    # Return all available groups
    #
    # @return [Array]
    def groups
      submodules.map { |submodule| submodule[:group] }.uniq.sort
    end

    protected
    # Parse and return the submodules yaml file
    #
    # @return [Hash]
    def parse_submodules_yaml_file
      begin
        parsed_yaml = YAML.parse_file MODULES_FILE
      rescue Psych::SyntaxError => e
        raise SubmodulesNotValidError,
          "Not valid YAML file: #{e.message}."
      end
      raise SubmodulesNotValidError,
        "Not valid YAML file: The YAML does not respond_to to_ruby." unless parsed_yaml.respond_to?(:to_ruby)
      submodules = parsed_yaml.to_ruby.with_indifferent_access
      raise SubmodulesNotValidError,
        "Not valid YAML file: It doesn't contain submodules root key." unless submodules.has_key?(:submodules)

      submodules[:submodules].map { |k, v| v.merge(:name => k) }
    end

    # Return a list of all dependencies of a submodule (recursive)
    #
    # @param [String] name
    # @return [Array]
    def dependencies(name)
      dependencies = []
      submodule = find_submodule(name)
      if submodule.has_key?(:dependencies)
        submodule[:dependencies].each do |dependency|
          dependencies << dependency
          dependencies << dependencies(dependency)
        end
      end

      dependencies.flatten.uniq.sort
    end

    # Find the submodule given bu the name
    #
    # @param [String] name
    # @return [Hash]
    def find_submodule(name)
      submodules.select { |s| s[:name].to_s == name.to_s }.
        first
    end
  end
end
