require 'spec_helper'

module Command
  describe Version do

    subject { TechnoGate::TgCli::Main }

    context "#version#" do
      it "should have a task called version" do
        subject.tasks.should include "version"
      end

      it "should prints Vimius version" do
        subject.start(["version"])

        "Vimius version #{Vimius.version}".
          should be_in_output
      end
    end
  end
end
