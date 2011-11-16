require 'spec_helper'

class CliUpdateTestClass < ::Thor
  include CLI::Update
end

module CLI
  describe Update do
    subject { CliUpdateTestClass.new }

    context "#update" do
      it { should respond_to :update }

      it "should call sanity check" do
        subject.expects(:sanity_check).once

        subject.update
      end
    end

    context "#sanity_check" do
      it { should respond_to :sanity_check}

      it "should check if USER_VIM_PATH exists" do
        ::File.expects(:exists?).with(USER_VIM_PATH).returns(true).once

        subject.send :sanity_check
      end

      it "should check if MODULES_FILE exists" do
        ::File.expects(:exists?).with(MODULES_FILE).returns(true).once

        subject.send :sanity_check
      end

      it "should abort if vimius is not installed" do
        ::File.stubs(:exists?).with(USER_VIM_PATH).returns(false)

        subject.send :sanity_check

        "Vimius is not installed, please run 'vimius install'".should be_in_output
      end

      it "should abort if vimius is not installed" do
        ::File.stubs(:exists?).with(MODULES_FILE).returns(false)

        subject.send :sanity_check

        "Vimius is not installed, please run 'vimius install'".should be_in_output
      end
    end
  end
end
