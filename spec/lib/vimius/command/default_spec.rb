require 'spec_helper'

module Command
  describe Default do

    subject { TechnoGate::TgCli::Main }

    context "#default" do
      it "should print vimius_ascii.txt" do
        capture(:stdout) { subject.start(["default"]) }.
          should puts(File.read VIMIUS_ASCII_PATH)
      end

      it "should print default help message" do
        capture(:stdout) { subject.start(["default"]) }.should puts <<-EOM
Tasks:
  vimius help [TASK]  # Describe available tasks or one specific task
        EOM
      end

      it "should be the default task" do
        capture(:stdout) { subject.start([]) }.
          should puts(File.read VIMIUS_ASCII_PATH)
      end
    end
  end
end
