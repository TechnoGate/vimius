require 'spec_helper'

class CliSubmodulesTestClass < ::Thor
  include CLI::Submodules
end

module CLI
  describe Submodules do
    subject { CliSubmodulesTestClass.new }

    context "List" do
      context "by group" do
        it "should be able to list submodules by group"
        it "should mark active submodules with ' |== '"
        it "should mark inactive submodules with ' |-- '"
      end

      context "by name" do
        it "should be able to list submodules sorted by name"
        it "should mark active submodules with ' |== '"
        it "should mark inactive submodules with ' |-- '"
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
