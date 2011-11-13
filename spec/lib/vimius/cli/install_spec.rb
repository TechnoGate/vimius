require 'spec_helper'

class CliInstallTestClass < ::Thor
  include CLI::Install
end

module CLI
  describe Install do
    subject { CliInstallTestClass.new }

    context "#install" do
      it { should respond_to :install }
    end
  end
end
