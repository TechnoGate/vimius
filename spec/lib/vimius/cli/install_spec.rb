require 'spec_helper'

class CliInstallTestClass < ::Thor
  include CLI::Install
end

module CLI
  describe Install do
    subject { CliInstallTestClass.new }

    before(:each) do
      @file_handler = mock "File Handler"
      @file_handler.stubs(:write)
      ::File.stubs(:open).with('/tmp/vimius_bootstrap.sh', 'w').yields(@file_handler)
      Shell.stubs(:exec)
    end

    context "#install" do
      it { should respond_to :install }

      it "should call sanity_check" do
        subject.expects(:sanity_check).once

        subject.install
      end

      it "should write the bootstrap" do
        ::File.expects(:open).with('/tmp/vimius_bootstrap.sh', 'w').
          yields(@file_handler).once

        subject.install
      end

      it "should call Shell.exec" do
        Shell.expects(:exec).with("cat /tmp/vimius_bootstrap.sh | sh", true).once

        subject.install
      end
    end

    context '#sanity_check' do
      before(:each) do
        ::File.stubs(:exists?).with(USER_GVIMRC_PATH).returns(true)
        ::File.stubs(:exists?).with(USER_VIMRC_PATH).returns(true)
        ::File.stubs(:exists?).with(USER_VIM_PATH).returns(true)
      end

      it "should check that USER_VIM_PATH exists" do
        ::File.expects(:exists?).with(USER_VIM_PATH).returns(true).once

        subject.send :sanity_check
      end

      it "should check that USER_VIMRC_PATH exists" do
        ::File.expects(:exists?).with(USER_VIMRC_PATH).returns(true).once

        subject.send :sanity_check
      end

      it "should check that USER_GVIMRC_PATH exists" do
        ::File.expects(:exists?).with(USER_GVIMRC_PATH).returns(true).once

        subject.send :sanity_check
      end

      context 'failure' do
        it "should abort if USER_VIM_PATH exists." do
          ::File.expects(:exists?).with(USER_VIM_PATH).returns(false).once

          subject.send(:sanity_check).should be_false
          "#{USER_VIM_PATH} exists, cannot continue.".should be_in_output
        end

        it "should abort if USER_VIMRC_PATH exists." do
          ::File.expects(:exists?).with(USER_VIMRC_PATH).returns(false).once

          subject.send(:sanity_check).should be_false
          "#{USER_VIMRC_PATH} exists, cannot continue.".should be_in_output
        end

        it "should abort if USER_GVIMRC_PATH exists." do
          ::File.expects(:exists?).with(USER_GVIMRC_PATH).returns(false).once

          subject.send(:sanity_check).should be_false
          "#{USER_GVIMRC_PATH} exists, cannot continue.".should be_in_output
        end
      end
    end
  end
end
