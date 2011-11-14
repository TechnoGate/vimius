require 'spec_helper'

describe Submodules do
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

  after(:each) do
    Vimius.config.send(:instance_variable_set, :@config, nil)
    subject.send(:instance_variable_set, :@config, nil)
  end

  subject { Submodules.new MODULES_FILE }

  context "#submodules" do
    it { should respond_to :submodules }

    it "should return submodules" do
      subject.submodules.should == expected_submodules
    end

    it "should add the name for each submodule" do
      subject.submodules.first["name"].should == "pathogen"
    end
  end

  context "#dependencies" do
    it {should respond_to :dependencies}

    it "should return tlib and pathogen as dependencies of command-t" do
      subject.send(:dependencies, 'command-t').should == ["pathogen", "tlib"]
    end
  end

  context "#submodule" do
    it { should respond_to :submodule }

    it "should return the submodule we're looking for" do
      subject.send(:submodule, :pathogen).should == expected_submodules.first
    end
  end

  context "#submodule_with_dependencies" do
    it { should respond_to :submodule_with_dependencies}

    it "should return the correct module from the submodules hash" do
      subject.submodule_with_dependencies("pathogen").first.should == expected_submodules.first
    end

    it "should return the name with the submodule" do
      subject.submodule_with_dependencies("pathogen").first["name"].should == "pathogen"
    end

    it "should return all dependencies when getting the module command-t" do
      subject.submodule_with_dependencies("command-t").should include expected_submodules[1]
      subject.submodule_with_dependencies("command-t").should include expected_submodules.first
    end

    it "should not include the same dependency twice" do
      subject.submodule_with_dependencies("github").select { |c| c["name"] == "pathogen"}.size.should == 1
    end
  end

  context "#groups" do
    it { should respond_to :groups }

    it "should return core and tools " do
      subject.groups.should == ["core", "tools"]
    end
  end

  context "#active" do
    it { should respond_to :active }

    its(:active) { should == expected_active_submodules }
  end

  context "#inactive" do
    it { should respond_to :inactive }

    its(:inactive) { should == expected_inactive_submodules }
  end

  context "#submodules_by_group" do
    it { should respond_to :submodules_by_group }

    it "should return submodules_by_group" do
      subject.submodules_by_group.should == submodules_by_group
    end
  end

  context "#submodules_by_name" do
    it { should respond_to :submodules_by_name }

    it "should return submodules_by_name" do
      subject.submodules_by_name.should == submodules_by_name
    end
  end

  context "#active_by_group" do
    it { should respond_to :active_by_group }

    it "should return active_by_group" do
      subject.active_by_group.should == active_by_group
    end
  end

  context "#active_by_name" do
    it { should respond_to :active_by_name }

    it "should return active_by_name" do
      subject.active_by_name.should == active_by_name
    end
  end

  context "#active_by_name" do
    it { should respond_to :active_by_name }

    it "should return active_by_name" do
      subject.active_by_name.should == active_by_name
    end
  end

  context "#active_by_name" do
    it { should respond_to :active_by_name }

    it "should return active_by_name" do
      subject.active_by_name.should == active_by_name
    end
  end

  context "#active?" do
    it { should respond_to :active? }

    it "should return true for tlib" do
      subject.active?(:tlib).should be_true
    end

    it "should return false for command-t" do
      subject.active?("command-t").should be_false
    end
  end

  context "#inactive?" do
    it { should respond_to :inactive? }

    it "should return false for tlib" do
      subject.inactive?(:tlib).should be_false
    end

    it "should return true for command-t" do
      subject.inactive?("command-t").should be_true
    end
  end

  context "#activate" do
    it { should respond_to :activate }

    it "should activate a module" do
      subject.active.should == expected_active_submodules

      subject.activate("command-t")

      subject.active.should == expected_submodules # => expected_submodules includes command-t
                                                   #    and all activated submodules
    end

    it "should not call save on the config" do
      Vimius.config.expects(:save).never

      subject.activate("command-t")
    end

    it "should not blow if there's no initially active submodules" do
      TgConfig.any_instance.stubs(:parse_config_file).  returns({}.with_indifferent_access)

      Vimius.config[:submodules].should be_nil

      lambda { subject.activate("command-t") }.should_not raise_error NoMethodError
    end

    it "should not activate an existing active submodule" do
      subject.activate("tlib")

      subject.active.should == expected_active_submodules
    end
  end

  context "#deactivate" do
    it { should respond_to :deactivate }

    it "should deactivate a module" do
      subject.activate("command-t")
      subject.active.should == expected_submodules
      subject.deactivate("command-t")
      subject.active.should == expected_active_submodules
    end

    it "should not call save on the config" do
      Vimius.config.expects(:save).never

      subject.deactivate("command-t")
    end

    it "should not blow if there's no initially active submodules" do
      TgConfig.any_instance.stubs(:parse_config_file).  returns({}.with_indifferent_access)

      Vimius.config[:submodules].should be_nil

      lambda { subject.deactivate("command-t") }.should_not raise_error NoMethodError
    end

    it "should not deactivate an inactive submodule" do
      subject.deactivate("command-t")

      subject.active.should == expected_active_submodules
    end
  end

  context "#toggle" do
    it { should respond_to :toggle }

    it "should call activate if the submodule is inactive" do
      subject.expects(:activate).with("command-t").once

      subject.toggle("command-t")
    end

    it "should call deactivate if the submodule is inactive" do
      subject.expects(:deactivate).with("tlib").once

      subject.toggle("tlib")
    end

    it "should raise SubmoduleNotFoundError if no submodule by that name exists" do
      lambda {subject.toggle("invalid-submodule") }.should raise_error SubmoduleNotFoundError
    end
  end
end
