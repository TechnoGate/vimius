require 'spec_helper'

class CliVersionTestClass < ::Thor
  include CLI::Version
end

module CLI
  describe Version do
    subject { CliVersionTestClass.new }

    context "#version#" do
      it { should respond_to :version }

      it "should prints Vimius version" do
        subject.version

        "Vimius version #{Vimius.version}".
          should be_in_output
      end
    end
  end
end
