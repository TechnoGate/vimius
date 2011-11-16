require 'spec_helper'

class CliInstallTestClass < ::Thor
  include CLI::Install
end

module CLI
  describe Install do
    subject { CliInstallTestClass.new }

    context "#install" do
      it { should respond_to :install }

      it "should call sanity_check" do
        subject.expects(:sanity_check).once

        subject.install
      end

      it "should call Shell.exec" do
        Shell.expects(:exec).with("git clone git://github.com/TechnoGate/vimius.git ~/.vim")

        subject.install
      end
    end

    context "#setup" do
      it { should respond_to :setup }

      it "should call :make_way_for_vimius" do
        subject.expects(:make_way_for_vimius).once

        subject.setup
      end

      it "should call install" do
        subject.expects(:install).once

        subject.setup
      end
    end

    context "#make_way_for_vimius" do
      it { should respond_to :make_way_for_vimius }

      it "should move any vim file before running" do
        ::FileUtils.expects(:mv).with(USER_VIM_PATH, "#{USER_VIM_PATH}.old").once
        ::FileUtils.expects(:mv).with(USER_VIMRC_PATH, "#{USER_VIMRC_PATH}.old").once
        ::FileUtils.expects(:mv).with(USER_GVIMRC_PATH, "#{USER_GVIMRC_PATH}.old").once

        subject.send :make_way_for_vimius
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
          "#{USER_VIM_PATH} exists, cannot continue, please run 'vimius setup' instead.".should be_in_output
        end

        it "should abort if USER_VIMRC_PATH exists." do
          ::File.expects(:exists?).with(USER_VIMRC_PATH).returns(false).once

          subject.send(:sanity_check).should be_false
          "#{USER_VIMRC_PATH} exists, cannot continue, please run 'vimius setup' instead.".should be_in_output
        end

        it "should abort if USER_GVIMRC_PATH exists." do
          ::File.expects(:exists?).with(USER_GVIMRC_PATH).returns(false).once

          subject.send(:sanity_check).should be_false
          "#{USER_GVIMRC_PATH} exists, cannot continue, please run 'vimius setup' instead.".should be_in_output
        end
      end
    end
  end
end
