require 'singleton'

module CommandSupport
  class Output
    include Singleton
    attr_reader :messages

    def initialize
      @messages = []
    end

    def add_messages(*args)
      args.each do |message|
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
  command_specs = { :file_path => config.escaped_path(%w[spec lib vimius command]) }

  config.include CommandSupport, :example_group => command_specs
  config.before :all, :example_group => command_specs do
    STDOUT.instance_eval do
      def puts(*args)
        CommandSupport::Output.instance.add_messages(*args)
        return true
      end
    end
    #TgCli::Main.extend CommandSupport
    #TgCli::Main.instance_eval do
      #no_tasks do
        #define_method :puts do |*args|
          #Output.instance.puts(*args)
          #return true
        #end

        #define_method :abort do |*args|
          #Output.instance.puts(*args)
          #return false
        #end
      #end
    #end
  end
end
