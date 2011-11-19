module CommandMatchers
  RSpec::Matchers.define :puts do |expected|
    match do
      if $last_puts == expected
        $last_puts = nil
        true
      else
        false
      end
    end

    failure_message_for_should do
      last_puts = $last_puts
      $last_puts = nil
      "expected #{expected} to be in output, Got: #{last_puts}"
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
        $last_puts = arg
        true
      end

      def abort(arg)
        $last_puts = arg
        false
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
  end
end
