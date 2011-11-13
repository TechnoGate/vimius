require 'singleton'

module CliSupport
  class Output
    include Singleton
    attr_accessor :messages

    def initialize
      @messages = []
    end

    def puts(messages)
      if messages.respond_to? :each
        messages.each { |m| @messages << m }
      else
        @messages << messages
      end
    end
  end

  RSpec::Matchers.define :be_in_output do
    match do |actual|
      Output.instance.messages.include?(actual).should be_true
    end

    failure_message_for_should do |actual|
      "expected #{actual} to be in output, Got:"
      Output.instance.messages.each do |message|
        puts "\t#{message}"
      end
    end
  end
end

RSpec.configure do |config|
  cli_specs = { :file_path => config.escaped_path(%w[spec lib vimius cli]) }
  
  config.include CliSupport, :example_group => cli_specs
  config.before :each, :example_group => cli_specs do
    subject.class_eval <<-END, __FILE__, __LINE__ + 1
      include CliSupport

      no_tasks do
        define_method :puts do |*args|
          Output.instance.puts(*args)
        end
      end
    END
  end
end
