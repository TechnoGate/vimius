require 'spec_helper'

module Command
  describe Install do

    subject { TechnoGate::TgCli::Main }

    let(:install) { TechnoGate::Vimius::Command::Install.new }

    context "#install" do
      it "should have a task called install" do
        subject.tasks.should include "install"
      end

      it "should call sanity_check" do
        install.class.any_instance.expects(:sanity_check).at_least(1)

        subject.start(["install"])
      end

      it "should clone the repositoru" do
        Shell.expects(:exec).with("git clone -b #{REPO_BRANCH} #{REPO_URL}")

        subject.start(["install"])
      end
    end
    
    context '#sanity_check' do
      before(:each) do
        ::File.stubs(:exists?).with(USER_GVIMRC_PATH).returns(false)
        ::File.stubs(:exists?).with(USER_VIMRC_PATH).returns(false)
        ::File.stubs(:exists?).with(USER_VIM_PATH).returns(false)
      end

      context 'vim already installed' do

        it "should check that USER_VIM_PATH exists" do
          ::File.expects(:exists?).with(USER_VIM_PATH).returns(true).once

          install.send(:sanity_check).should be_false
          install.send(:sanity_check).
            should puts("#{USER_VIM_PATH} exists, cannot continue, please run 'vimius setup' instead.")
        end

        it "should check that USER_VIMRC_PATH exists" do
          ::File.expects(:exists?).with(USER_VIMRC_PATH).returns(true).once

          install.send(:sanity_check).should be_false
          install.send(:sanity_check).
            should puts("#{USER_VIMRC_PATH} exists, cannot continue, please run 'vimius setup' instead.")
        end

        it "should check that USER_GVIMRC_PATH exists" do
          ::File.expects(:exists?).with(USER_GVIMRC_PATH).returns(true).once

          install.send(:sanity_check).should be_false
          install.send(:sanity_check).
            should puts("#{USER_GVIMRC_PATH} exists, cannot continue, please run 'vimius setup' instead.")
        end
      end

      context 'vim is not already installed' do

        it "should not output anything" do
          install.send(:sanity_check).should puts(nil)
        end
      end
    end
  end
end

#require 'spec_helper'

#class CliInstallTestClass < ::Thor
  #include CLI::Install
#end

#module CLI
  #describe Install do
    #subject { CliInstallTestClass.new }

    #context "#install" do
      #pending { should respond_to :install }

      #pending "should call sanity_check" do
        #subject.expects(:sanity_check).once

        #subject.install
      #end

      #pending "should call Shell.exec" do
        #Shell.expects(:exec).with("gpending clone git://github.com/TechnoGate/vimius.gpending ~/.vim")

        #subject.install
      #end
    #end

    #context "#setup" do
      #pending { should respond_to :setup }

      #pending "should call :make_way_for_vimius" do
        #subject.expects(:make_way_for_vimius).once

        #subject.setup
      #end

      #pending "should call install" do
        #subject.expects(:install).once

        #subject.setup
      #end
    #end

    #context "#make_way_for_vimius" do
      #pending { should respond_to :make_way_for_vimius }

      #pending "should move any vim file before running" do
        #::FileUtils.expects(:mv).with(USER_VIM_PATH, "#{USER_VIM_PATH}.old").once
        #::FileUtils.expects(:mv).with(USER_VIMRC_PATH, "#{USER_VIMRC_PATH}.old").once
        #::FileUtils.expects(:mv).with(USER_GVIMRC_PATH, "#{USER_GVIMRC_PATH}.old").once

        #subject.send :make_way_for_vimius
      #end
    #end

    #context '#sanity_check' do
      #before(:each) do
        #::File.stubs(:exists?).with(USER_GVIMRC_PATH).returns(true)
        #::File.stubs(:exists?).with(USER_VIMRC_PATH).returns(true)
        #::File.stubs(:exists?).with(USER_VIM_PATH).returns(true)
      #end

      #pending "should check that USER_VIM_PATH exists" do
        #::File.expects(:exists?).with(USER_VIM_PATH).returns(true).once

        #subject.send :sanity_check
      #end

      #pending "should check that USER_VIMRC_PATH exists" do
        #::File.expects(:exists?).with(USER_VIMRC_PATH).returns(true).once

        #subject.send :sanity_check
      #end

      #pending "should check that USER_GVIMRC_PATH exists" do
        #::File.expects(:exists?).with(USER_GVIMRC_PATH).returns(true).once

        #subject.send :sanity_check
      #end

      #context 'failure' do
        #pending "should abort if USER_VIM_PATH exists." do
          #::File.expects(:exists?).with(USER_VIM_PATH).returns(false).once

          #subject.send(:sanity_check).should be_false
          #"#{USER_VIM_PATH} exists, cannot continue, please run 'vimius setup' instead.".should be_in_output
        #end

        #pending "should abort if USER_VIMRC_PATH exists." do
          #::File.expects(:exists?).with(USER_VIMRC_PATH).returns(false).once

          #subject.send(:sanity_check).should be_false
          #"#{USER_VIMRC_PATH} exists, cannot continue, please run 'vimius setup' instead.".should be_in_output
        #end

        #pending "should abort if USER_GVIMRC_PATH exists." do
          #::File.expects(:exists?).with(USER_GVIMRC_PATH).returns(false).once

          #subject.send(:sanity_check).should be_false
          #"#{USER_GVIMRC_PATH} exists, cannot continue, please run 'vimius setup' instead.".should be_in_output
        #end
      #end
    #end
  #end
#end
