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
        "path"  => "vimius/vim/tools/command-t",
        "group" => "tools",
        "dependencies" => ["tlib"],
        "name"  => "command-t",
      },
      {
        "path"  => "vimius/vim/tools/github",
        "group" => "tools",
        "dependencies" => ["tlib", "pathogen"],
        "name"  => "github",
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
    }
  end

  before(:each) do
    @yaml = mock "YAML"
    @yaml.stubs(:to_ruby).returns(submodules)
    Psych.stubs(:parse_file).returns(@yaml)
  end

  describe '#parse_submodules_yaml_file' do
    it { should respond_to :parse_submodules_yaml_file }

    it "should parse the submodules file and returns a Array" do
      subject.send(:parse_submodules_yaml_file).should be_instance_of Array
    end

    it "should have the elements as a HashWithIndifferentAccess" do
      subject.send(:parse_submodules_yaml_file).first.should be_instance_of HashWithIndifferentAccess
    end

    it "should handle the case where submodules is not a valid YAML file." do
      Psych.stubs(:parse_file).raises(Psych::SyntaxError)

      -> { subject.send :parse_submodules_yaml_file }.should raise_error SubmodulesNotValidError
    end

    it "should handle the case where Psych returns nil." do
      Psych.stubs(:parse_file).returns(nil)

      -> { subject.send :parse_submodules_yaml_file }.should raise_error SubmodulesNotValidError
    end

    it "should handle the case where :submodules key does not exist" do
      config = {}
      yaml = mock
      yaml.stubs(:to_ruby).returns(config)
      Psych.stubs(:parse_file).returns(yaml)

      -> { subject.send :parse_submodules_yaml_file }.should raise_error SubmodulesNotValidError
    end
  end

  describe "#dependencies" do
    it {should respond_to :dependencies}

    it "should return tlib and pathogen as dependencies of command-t" do
      subject.send(:dependencies, 'command-t').should == ["pathogen", "tlib"]
    end
  end

  describe "#submodules" do
    it { should respond_to :submodules }

    it "should return submodules" do
      subject.submodules.should == expected_submodules
    end

    it "should be cached" do
      subject.submodules.should == expected_submodules
      Psych.stubs(:parse_file).returns(nil)
      subject.submodules.should == expected_submodules
    end

    it "should add the name for each submodule" do
      subject.submodules.first["name"].should == "pathogen"
    end
  end

  describe "#find_submodule" do
    it { should respond_to :find_submodule }

    it "should return the submodule we're looking for" do
      subject.send(:find_submodule, :pathogen).should == expected_submodules.first
    end
  end

  describe "#submodule" do
    it { should respond_to :submodule }

    it "should return the correct module from the submodules hash" do
      subject.submodule("pathogen").first.should == expected_submodules.first
    end

    it "should return the name with the submodule" do
      subject.submodule("pathogen").first["name"].should == "pathogen"
    end

    it "should return all dependencies when getting the module command-t" do
      subject.submodule("command-t").should include expected_submodules[1]
      subject.submodule("command-t").should include expected_submodules.first
    end

    it "should not include the same dependency twice" do
      subject.submodule("github").select { |c| c["name"] == "pathogen"}.size.should == 1
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
  end

  describe "#submodules_by_group" do
    it { should respond_to :submodules_by_group }

    it "should return submodules_by_group" do
      subject.submodules_by_group.should == submodules_by_group
    end
  end
end
