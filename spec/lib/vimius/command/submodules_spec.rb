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
      it "should be able to activate a submodule" do
        subject.start ["submodules", "activate", "command-t"]

        Vimius.submodules.active?("command-t").should be_true
      end

      it "should print a message when done" do
        subject.start(["submodules", "activate", "command-t"]).
          should puts "command-t has been activated please run 'vimius update'"
      end

      it "should print an error if the submodule is already activated" do
        subject.start(["submodules", "activate", "pathogen"]).
          should puts "pathogen is already active"
      end

      it "should print an error if the submodule does not exit" do
        subject.start(["submodules", "activate", "invalid-submodule"]).
          should puts "invalid-submodule does not exist"
      end
    end

    context "#deactivate" do
      it "should be able to deactivate a submodule" do
        subject.start ["submodules", "deactivate", "github"]

        Vimius.submodules.active?("github").should be_false
      end

      it "should print a message when done" do
        subject.start(["submodules", "deactivate", "github"]).should puts <<-EOM
The following submodules has been deactivated, please run 'vimius update'
- github
        EOM
      end

      it "should print an error if the submodule is already deactivated" do
        subject.start(["submodules", "deactivate", "command-t"]).
          should puts "command-t is not active"
      end

      it "should print an error if the submodule does not exit" do
        subject.start(["submodules", "deactivate", "invalid-submodule"]).
          should puts "invalid-submodule does not exist"
      end

      it "should print an error if the submodule is depended on" do
        subject.start(["submodules", "deactivate", "pathogen"]).should puts <<-EOM
pathogen cannot be deactivated because it is depended on by:
- command-t
- github
- tlib

Please re-run with the '-d' flag if you want to remove this submodule and all the submodules the depends on it
        EOM
      end

      it "should not raise an error if ran with the -d flag" do
        subject.start(["submodules", "deactivate", "pathogen", "-d"]).should puts <<-EOM
The following submodules has been deactivated, please run 'vimius update'
- command-t
- github
- tlib
- pathogen
        EOM
      end
    end
  end
end
