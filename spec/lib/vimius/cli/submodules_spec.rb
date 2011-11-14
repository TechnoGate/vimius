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

    context "list" do
      it { should respond_to :list }

      it "should print the list of submodules organised by group" do
        subject.list
      end
    end
  end
end
