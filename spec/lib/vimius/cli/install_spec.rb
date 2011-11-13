require 'spec_helper'

class CliInstallTestClass < ::Thor
  include CLI::Install
end

module CLI
  describe Install do
    subject { CliInstallTestClass.new }

    context "#install" do
      it { should respond_to :install }

      it "should check that USER_VIM_PATH exists" do
        ::File.expects(:exists?).with(USER_VIM_PATH).returns(true)

        subject.install
      end
    end
  end
end
