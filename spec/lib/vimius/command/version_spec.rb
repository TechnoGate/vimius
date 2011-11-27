require 'spec_helper'

module Command
  describe Version do

    subject { TechnoGate::TgCli::Main }

    context "#version" do
      it "should have a task called version" do
        subject.tasks.should include "version"
      end

      it "should prints Vimius version" do
        capture(:stdout) { subject.start(["version"]) }.
          should puts("Vimius version #{Vimius.version}")
      end

      it "should be aliased to -v" do
        capture(:stdout) { subject.start(["-v"]) }.
          should puts("Vimius version #{Vimius.version}")
      end

      it "should be aliased to --version" do
        capture(:stdout) { subject.start(["--version"]) }.
          should puts("Vimius version #{Vimius.version}")
      end
    end
  end
end
