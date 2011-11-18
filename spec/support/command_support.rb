module CommandMatchers
  RSpec::Matchers.define :puts do |expected|
    match do
      $last_puts == expected
    end

    failure_message_for_should do |actual|
      "expected #{expected} to be in output, Got: #{actual}"
    end
  end
end

RSpec.configure do |config|
  command_specs = { :file_path => config.escaped_path(%w[spec lib vimius command]) }
  config.include CommandMatchers, :example_group => command_specs

  config.before :all, :example_group => command_specs do
    Kernel.module_eval do
      alias :orig_puts :puts
      def puts(arg)
        $last_puts = arg
      end
    end
  end

  config.after :all, :example_group => command_specs do
    Kernel.module_eval do
      alias :puts :orig_puts
      undef :orig_puts
    end
  end
end
