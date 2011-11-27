require 'spec_helper'

module Command
  describe Submodules do
    subject { TechnoGate::TgCli::Main }

    context "#list" do
      it "should mark active submodules with ' |== '" do
        subject.start(["submodules", "list"]).should puts " |== pathogen"
      end

      it "should mark inactive submodules with ' |-- '" do
        subject.start(["submodules", "list"]).should puts " |-- command-t"
      end

      it "should be able to list submodules by group" do
        subject.start(["submodules", "list"]).should puts <<-EOM
core
 |== pathogen
tools
 |== tlib
 |== github
 |-- command-t

Active submodules are prefixed with the '|==' marker
        EOM
      end
    end

    context "#activate" do
      it "should be able to activate a submodule"
      it "should print an error if the submodule is already activated"
      it "should print an error if the submodule does not exit"
      it "should update the config file"
      it "should be listed as active"
    end

    context "#deactivate" do
      it "should be able to deactivate a submodule"
      it "should print an error if the submodule is already deactivated"
      it "should print an error if the submodule does not exit"
      it "should update the config file"
      it "should be listed as inactive"
    end
  end
end
