require 'spec_helper'

describe Submodules do
  let(:submodules) do
    {
      "submodules" => {
        "pathogen" => {
          "path"  => "vimius/vim/core/pathogen",
          "group" => "core",
        },
        "tlib" => {
          "path"  => "vimius/vim/tools/tlib",
          "group" => "tools",
          "dependencies" => ["pathogen"],
        },
        "github" => {
          "path"  => "vimius/vim/tools/github",
          "group" => "tools",
          "dependencies" => ["tlib", "pathogen"],
        },
        "command-t" => {
          "path"  => "vimius/vim/tools/command-t",
          "group" => "tools",
          "dependencies" => ["tlib"],
        },
      },
    }
  end

  let(:expected_submodules) do
    [
      {
        "path"  => "vimius/vim/core/pathogen",
        "group" => "core",
        "name"  => "pathogen",
      },
      {
        "path"  => "vimius/vim/tools/tlib",
        "group" => "tools",
        "dependencies" => ["pathogen"],
        "name"  => "tlib",
      },
      {
        "path"  => "vimius/vim/tools/github",
        "group" => "tools",
        "dependencies" => ["tlib", "pathogen"],
        "name"  => "github",
      },
      {
        "path"  => "vimius/vim/tools/command-t",
        "group" => "tools",
        "dependencies" => ["tlib"],
        "name"  => "command-t",
      },
    ]
  end

  let(:expected_active_submodules) do
    [
      {
        "path"  => "vimius/vim/core/pathogen",
        "group" => "core",
        "name"  => "pathogen",
      },
      {
        "path"  => "vimius/vim/tools/tlib",
        "group" => "tools",
        "dependencies" => ["pathogen"],
        "name"  => "tlib",
      },
      {
        "path"  => "vimius/vim/tools/github",
        "group" => "tools",
        "dependencies" => ["tlib", "pathogen"],
        "name"  => "github",
      },
    ]
  end

  let(:expected_inactive_submodules) do
    [
      {
        "path"  => "vimius/vim/tools/command-t",
        "group" => "tools",
        "dependencies" => ["tlib"],
        "name"  => "command-t",
      },
    ]
  end

  let(:submodules_by_group) do
    {
      "core" =>
      [
        {
          "path"  => "vimius/vim/core/pathogen",
          "group" => "core",
          "name"  => "pathogen",
        },
      ],
      "tools" =>
      [
        {
          "path"  => "vimius/vim/tools/tlib",
          "group" => "tools",
          "dependencies" => ["pathogen"],
          "name" => "tlib",
        },
        {
          "path"  => "vimius/vim/tools/github",
          "group" => "tools",
          "dependencies" => ["tlib", "pathogen"],
          "name" => "github",
        },
        {
          "path"  => "vimius/vim/tools/command-t",
          "group" => "tools",
          "dependencies" => ["tlib"],
          "name" => "command-t",
        },
      ],
    }
  end

  let (:submodules_by_name) do
    {
      "pathogen" => {
        "path"  => "vimius/vim/core/pathogen",
        "group" => "core",
        "name"  => "pathogen",
      },
      "tlib" => {
        "path"  => "vimius/vim/tools/tlib",
        "group" => "tools",
        "dependencies" => ["pathogen"],
        "name"  => "tlib",
      },
      "github" => {
        "path"  => "vimius/vim/tools/github",
        "group" => "tools",
        "dependencies" => ["tlib", "pathogen"],
        "name"  => "github",
      },
      "command-t" => {
        "path"  => "vimius/vim/tools/command-t",
        "group" => "tools",
        "dependencies" => ["tlib"],
        "name"  => "command-t",
      },
    }
  end

  let(:active_by_group) do
    {
      "core" =>
      [
        {
          "path"  => "vimius/vim/core/pathogen",
          "group" => "core",
          "name"  => "pathogen",
        },
      ],
      "tools" =>
      [
        {
          "path"  => "vimius/vim/tools/tlib",
          "group" => "tools",
          "dependencies" => ["pathogen"],
          "name" => "tlib",
        },
        {
          "path"  => "vimius/vim/tools/github",
          "group" => "tools",
          "dependencies" => ["tlib", "pathogen"],
          "name" => "github",
        },
      ],
    }
  end

  let (:active_by_name) do
    {
      "pathogen" => {
        "path"  => "vimius/vim/core/pathogen",
        "group" => "core",
        "name"  => "pathogen",
      },
      "tlib" => {
        "path"  => "vimius/vim/tools/tlib",
        "group" => "tools",
        "dependencies" => ["pathogen"],
        "name"  => "tlib",
      },
      "github" => {
        "path"  => "vimius/vim/tools/github",
        "group" => "tools",
        "dependencies" => ["tlib", "pathogen"],
        "name"  => "github",
      },
    }
  end

  let(:inactive_by_group) do
    {
      "tools" =>
      [
        {
          "path"  => "vimius/vim/tools/command-t",
          "group" => "tools",
          "dependencies" => ["tlib"],
          "name" => "command-t",
        },
      ],
    }
  end

  let (:inactive_by_name) do
    {
      "command-t" => {
        "path"  => "vimius/vim/tools/command-t",
        "group" => "tools",
        "dependencies" => ["tlib"],
        "name"  => "command-t",
      },
    }
  end

  before(:each) do
    @file_handler = mock "file handler"
    @file_handler.stubs(:write)
    ::File.stubs(:open).with(MODULES_FILE, 'w').yields(@file_handler)
    ::File.stubs(:open).with(CONFIG_FILE, 'w').yields(@file_handler)

    ::File.stubs(:readable?).with(MODULES_FILE).returns(true)
    ::File.stubs(:writable?).with(MODULES_FILE).returns(true)

    ::File.stubs(:readable?).with(CONFIG_FILE).returns(true)
    ::File.stubs(:writable?).with(CONFIG_FILE).returns(true)

    # XXX: Fix for Ruby 1.8 (code working but not tests.)
    ::File.stubs(:open).with(MODULES_FILE).returns(submodules.to_yaml)
    ::File.stubs(:open).with(MODULES_FILE, 'r').returns(submodules.to_yaml)

    # XXX: Fix for Ruby 1.8 (code working but not tests.)
    ::File.stubs(:open).with(CONFIG_FILE).
      returns({"submodules" => ["pathogen", "tlib", "github"]}.to_yaml)
    ::File.stubs(:open).with(CONFIG_FILE, 'r').
      returns({"submodules" => ["pathogen", "tlib", "github"]}.to_yaml)
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
    before(:each) do
    end

    it { should respond_to :active }

    its(:active) { should == expected_active_submodules }
  end

  context "#inactive" do
    before(:each) do
      
    end
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
      ::File.stubs(:open).with(CONFIG_FILE).returns({}.to_yaml)

      Vimius.config[:submodules].should be_nil

      lambda { subject.activate("command-t") }.should_not raise_error NoMethodError
    end

    pending "should not activate an existing active submodule" do
      subject.activate("tlib")

      subject.active.should == expected_active_submodules
    end
  end
end
