require 'spec_helper'

module Command
  describe Install do

    subject { TechnoGate::TgCli::Main }

    let(:install) { TechnoGate::Vimius::Command::Install.new }

    context '#sanity_check' do
      before(:each) do
        ::File.stubs(:exists?).with(USER_GVIMRC_PATH).returns(false)
        ::File.stubs(:exists?).with(USER_VIMRC_PATH).returns(false)
        ::File.stubs(:exists?).with(USER_VIM_PATH).returns(false)
      end

      context 'vim already installed' do

        it "should check that USER_VIM_PATH exists" do
          ::File.expects(:exists?).with(USER_VIM_PATH).returns(true).once

          capture(:stderr) { subject.start(["install"]) }.
            should puts("#{USER_VIM_PATH} exists, cannot continue, please run 'vimius setup' instead.")
        end

        it "should check that USER_VIMRC_PATH exists" do
          ::File.expects(:exists?).with(USER_VIMRC_PATH).returns(true).once

          capture(:stderr) { subject.start(["install"]) }.
            should puts("#{USER_VIMRC_PATH} exists, cannot continue, please run 'vimius setup' instead.")
        end

        it "should check that USER_GVIMRC_PATH exists" do
          ::File.expects(:exists?).with(USER_GVIMRC_PATH).returns(true).once

          capture(:stderr) { subject.start(["install"]) }.
            should puts("#{USER_GVIMRC_PATH} exists, cannot continue, please run 'vimius setup' instead.")
        end
      end

      context 'vim is not already installed' do

        it "should not output anything" do
          capture(:stdout) { subject.start(["install"]) }.should puts(nil)
        end
      end
    end

    context "#install" do
      it "should have a task called install" do
        subject.tasks.should include "install"
      end

      it "should clone the repositoru" do
        Shell.expects(:exec).with("git clone -b #{REPO_BRANCH} #{REPO_URL}")

        subject.start(["install"])
      end
    end
  end
end
