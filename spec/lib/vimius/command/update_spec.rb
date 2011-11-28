require 'spec_helper'

module Command
  describe Update do

    subject { TechnoGate::TgCli::Main }

    context "#sanity_check" do
      before(:each) do
        File.stubs(:exists?).with(USER_VIM_PATH).returns(false)
        File.stubs(:exists?).with(MODULES_FILE).returns(false)
      end

      it "should check that vimius is installed by checking USER_VIM_PATH" do
        File.expects(:exists?).with(USER_VIM_PATH).returns(false).once
        File.stubs(:exists?).with(MODULES_FILE).returns(true)

        capture(:stderr) { subject.start(["update"]) }
      end

      it "should check that vimius is installed by checking MODULES_FILE" do
        File.stubs(:exists?).with(USER_VIM_PATH).returns(true)
        File.expects(:exists?).with(MODULES_FILE).returns(false).once

        capture(:stderr) { subject.start(["update"]) }
      end

      it "should print an error" do
        capture(:stderr) { subject.start(["update"]) }.
          should puts("Vimius is not installed, please run 'vimius install'")
      end
    end

    context "#submodules" do
      it "should fetch the list of active submodules" do
        Vimius.submodules.expects(:active).returns(expected_active_submodules).once

        capture(:stdout) { subject.start(["update"]) }
      end

      it "should run exec 3 times" do
        Shell.expects(:exec).times(3)

        capture(:stdout) { subject.start(["update"]) }
      end

      it "should go into the folder" do
        Shell.expects(:exec).with("cd #{USER_VIM_PATH}").times(3)

        capture(:stdout) { subject.start(["update"]) }
      end

      it "should run git submodule init" do
        expected_active_submodules.each do |submodule|
          Shell.expects(:exec).with("git submodule init -- #{submodule["path"]}").once
        end

        capture(:stdout) { subject.start(["update"]) }
      end
    end

    context "#janus" do
      it "should exec" do
        Shell.expects(:exec).with(<<-EOS)
# Source RVM so janus .rvmrc takes effect
[[ -s /usr/local/rvm/scripts/rvm ]] && source /usr/local/rvm/scripts/rvm
[[ -s $HOME/.rvm/scripts/rvm ]] && source $HOME/.rvm/scripts/rvm

# Source Rbenv so janus .rbenv-version takes effect
if ! type rbenv &> /dev/null; then
  if [[ -s $HOME/.rbenv/bin/rbenv ]]; then
    eval "`$HOME/.rbenv/bin/rbenv init -`"
  fi
fi

cd #{USER_VIM_PATH}

if [ ! -x `which gem 2>/dev/null` ]; then
  echo "Rubygems is not installed please install it (using system ruby)
  exit 1
fi

if [ ! -x `which gem 2>/dev/null` ]; then
  echo "Rake is not installed please install it (using system ruby)
fi

rake install
        EOS

        capture(:stdout) { subject.start(["update"]) }
      end
    end
  end
end
