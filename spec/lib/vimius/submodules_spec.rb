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
        "command-t" => {
          "path"  => "vimius/vim/tools/command-t",
          "group" => "tools",
          "dependencies" => ["tlib"],
        },
        "github" => {
          "path"  => "vimius/vim/tools/github",
          "group" => "tools",
          "dependencies" => ["tlib", "pathogen"],
        },
      },
    }.with_indifferent_access
  end

  let(:expected_submodules) do
    [
      {
        "path"  => "vimius/vim/core/pathogen",
        "group" => "core",
        "name"  => "pathogen",
      }.with_indifferent_access,
      {
        "path"  => "vimius/vim/tools/tlib",
        "group" => "tools",
        "dependencies" => ["pathogen"],
        "name"  => "tlib",
      }.with_indifferent_access,
      {
        "path"  => "vimius/vim/tools/command-t",
        "group" => "tools",
        "dependencies" => ["tlib"],
        "name"  => "command-t",
      }.with_indifferent_access,
      {
        "path"  => "vimius/vim/tools/github",
        "group" => "tools",
        "dependencies" => ["tlib", "pathogen"],
        "name"  => "github",
      }.with_indifferent_access,
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
          "path"  => "vimius/vim/tools/command-t",
          "group" => "tools",
          "dependencies" => ["tlib"],
          "name" => "command-t",
        },
        {
          "path"  => "vimius/vim/tools/github",
          "group" => "tools",
          "dependencies" => ["tlib", "pathogen"],
          "name" => "github",
        },
      ],
    }.with_indifferent_access
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
      "command-t" => {
        "path"  => "vimius/vim/tools/command-t",
        "group" => "tools",
        "dependencies" => ["tlib"],
        "name"  => "command-t",
      },
      "github" => {
        "path"  => "vimius/vim/tools/github",
        "group" => "tools",
        "dependencies" => ["tlib", "pathogen"],
        "name"  => "github",
      },
    }.with_indifferent_access
  end

  subject { Submodules.new MODULES_FILE }

  before(:each) do
    @file_handler = mock "file handler"
    @file_handler.stubs(:write)
    ::File.stubs(:open).with(MODULES_FILE).returns(submodules.to_hash.to_yaml)
    ::File.stubs(:open).with(MODULES_FILE, 'r').returns(submodules.to_hash.to_yaml)
    ::File.stubs(:open).with(MODULES_FILE, 'w').yields(@file_handler)
    ::File.stubs(:readable?).with(MODULES_FILE).returns(true)
    ::File.stubs(:writable?).with(MODULES_FILE).returns(true)
  end

  describe "#submodules" do
    it { should respond_to :submodules }

    it "should return submodules" do
      subject.submodules.should == expected_submodules
    end

    it "should add the name for each submodule" do
      subject.submodules.first["name"].should == "pathogen"
    end
  end

  describe "#dependencies" do
    it {should respond_to :dependencies}

    it "should return tlib and pathogen as dependencies of command-t" do
      subject.send(:dependencies, 'command-t').should == ["pathogen", "tlib"]
    end
  end

  describe "#submodule" do
    it { should respond_to :submodule }

    it "should return the submodule we're looking for" do
      subject.send(:submodule, :pathogen).should == expected_submodules.first
    end
  end

  describe "#submodule_with_dependencies" do
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

  describe "#groups" do
    it { should respond_to :groups }

    it "should return core and tools " do
      subject.groups.should == ["core", "tools"]
    end
  end

  describe "#active" do
    it { should respond_to :active }

    it "should return expected_submodules" do
      TgConfig.stubs(:[]).with(:submodules).returns(["pathogen", "tlib", "command-t", "github"])

      subject.active.should == expected_submodules
    end
  end

  describe "#submodules_by_group" do
    it { should respond_to :submodules_by_group }

    it "should return submodules_by_group" do
      subject.submodules_by_group.should == submodules_by_group
    end
  end

  describe "#submodules_by_name" do
    it { should respond_to :submodules_by_name }

    it "should return submodules_by_name" do
      subject.submodules_by_name.should == submodules_by_name
    end
  end
end
