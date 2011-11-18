#require 'spec_helper'

#class CliUpdateTestClass < ::Thor
  #include CLI::Update
#end

#module CLI
  #describe Update do
    #subject { CliUpdateTestClass.new }

    #context "#update" do
      #pending { should respond_to :update }

      #pending "should call sanity check" do
        #subject.expects(:sanity_check).once

        #subject.update
      #end

      #pending "should get the list of active submodules" do
        #Vimius.submodules.expects(:active_by_group).once

        #subject.update
      #end
    #end

    #context "#sanity_check" do
      #pending { should respond_to :sanity_check}

      #pending "should check if USER_VIM_PATH exists" do
        #::File.expects(:exists?).with(USER_VIM_PATH).returns(true).once

        #subject.send :sanity_check
      #end

      #pending "should check if MODULES_FILE exists" do
        #::File.expects(:exists?).with(MODULES_FILE).returns(true).once

        #subject.send :sanity_check
      #end

      #pending "should abort if vimius is not installed" do
        #::File.stubs(:exists?).with(USER_VIM_PATH).returns(false)

        #subject.send :sanity_check

        #"Vimius is not installed, please run 'vimius install'".should be_in_output
      #end

      #pending "should abort if vimius is not installed" do
        #::File.stubs(:exists?).with(MODULES_FILE).returns(false)

        #subject.send :sanity_check

        #"Vimius is not installed, please run 'vimius install'".should be_in_output
      #end
    #end
  #end
#end
