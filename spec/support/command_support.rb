require 'stringio'

module CommandSupport
  # Capture a stream
  def capture(stream)
    begin
      stream = stream.to_s
      eval "$#{stream} = StringIO.new"
      yield
      result = eval("$#{stream}").string
    ensure
      eval("$#{stream} = #{stream.upcase}")
    end

    result
  end

  RSpec::Matchers.define :puts do |expected|
    match do |actual|
      case
      when expected.nil? || expected.empty?
        actual.empty?
      else
        ( expected.split("\n") - actual.split("\n") ).empty?
      end
    end

    failure_message_for_should do |actual|
      "expected '#{format expected}' to be in output, Got: '#{format actual}'"
    end

    failure_message_for_should_not do
      "expected '#{format expected}' not to be in output, Got: '#{format actual}'"
    end
  end

  protected
  def format(obj)
    case
    when obj.respond_to?(:join)
      obj.join('\n')
    else
      obj.split("\n").join('\n')
    end
  end
end

RSpec.configure do |config|
  command_specs = { :file_path => config.escaped_path(%w[spec lib vimius command]) }
  config.include CommandSupport

  config.before :all, :example_group => command_specs do
    Kernel.module_eval do
      alias :orig_abort :abort

      def abort(message)
        $stderr.puts(message)
        false
      end
    end
  end

  config.after :all, :example_group => command_specs do
    Kernel.module_eval do
      alias :abort :orig_abort
      undef :orig_abort
    end
  end
end
