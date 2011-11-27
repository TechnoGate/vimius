require 'singleton'

class Output
  include Singleton

  attr_reader :messages

  def initialize
    @messages = []
  end

  def puts(message)
    @messages << message
  end

  def clear
    @messages = []
  end
end


module CommandMatchers
  RSpec::Matchers.define :puts do |expected|
    match do
      if command_output.messages.include?(expected)
        true
      else
        false
      end
    end

    failure_message_for_should do
      "expected #{expected} to be in output, Got: #{command_output.messages.join("\n")}"
    end
  end
end


RSpec.configure do |config|
  command_specs = { :file_path => config.escaped_path(%w[spec lib vimius command]) }
  config.include CommandMatchers, :example_group => command_specs

  config.before :all, :example_group => command_specs do
    Kernel.module_eval do
      alias :orig_puts :puts
      alias :orig_abort :abort

      def puts(arg)
        command_output.puts(arg)
        true
      end

      def abort(arg)
        command_output.puts(arg)
        false
      end
    end

    Object.module_eval do
      def command_output
        Output.instance
      end

      def self.command_output
        Output.instance
      end
    end
  end

  config.after :all, :example_group => command_specs do
    Kernel.module_eval do
      alias :puts :orig_puts
      alias :abort :orig_abort
      undef :orig_puts
      undef :orig_abort
    end

    Object.module_eval do
      undef :command_output
      class << self
        undef :command_output
      end
    end
  end

  config.after :each, :example_group => command_specs do
    Kernel.command_output.clear
  end
end
