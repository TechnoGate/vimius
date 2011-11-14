require 'spec_helper'

class CliSubmodulesTestClass < ::Thor
  include CLI::Submodules
end

module CLI
  describe Submodules do
    subject { CliSubmodulesTestClass.new }

    before(:each) do
      ::File.stubs(:exists?).with(MODULES_FILE).returns(true)
      ::File.stubs(:readable?).with(MODULES_FILE).returns(true)
      ::File.stubs(:writable?).with(MODULES_FILE).returns(true)

      ::File.stubs(:exists?).with(CONFIG_FILE).returns(true)
      ::File.stubs(:readable?).with(CONFIG_FILE).returns(true)
      ::File.stubs(:writable?).with(CONFIG_FILE).returns(true)

      Vimius::Submodules.any_instance.stubs(:parse_config_file).
        returns(submodules.with_indifferent_access)
      TgConfig.any_instance.stubs(:parse_config_file).
        returns({"submodules" => ["pathogen", "tlib", "github"]}.with_indifferent_access)
    end

    context "List" do
      context "by group" do
        it "should be able to list submodules by group"
        it "should mark activated submodules with an asterisk"
        it "should add 2 spaces before inactive submodules"
      end

      context "by name" do
        it "should be able to list submodules sorted by name"
        it "should mark activated submodules with an asterisk"
        it "should add 2 spaces before inactive submodules"
      end
    end

    context "Activate" do
      it "should be able to activate a submodule"
      it "should print an error if the submodule is already activated"
      it "should print an error if the submodule does not exit"
      it "should update the config file"
      it "should be listed as active"
    end

    context "Deactivate" do
      it "should be able to deactivate a submodule"
      it "should print an error if the submodule is already deactivated"
      it "should print an error if the submodule does not exit"
      it "should update the config file"
      it "should be listed as inactive"
    end
  end
end
