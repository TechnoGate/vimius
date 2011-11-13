require 'spec_helper'

class Output
  attr_accessor :messages

  def puts(message)
    @messages ||= []
    @messages << message
  end
end

describe UI do

  subject { UI.instance }

  before(:each) do
    @output = Output.new
    subject.send(:instance_variable_set, :@output, @output)
  end


  context 'singleton' do
    it "should respond to instance" do
      UI.should respond_to :instance
    end

    it "should not allow calling new" do
      lambda { UI.new }.should raise_error NoMethodError
    end

    it "should set @output STDOUT" do
      UI.send(:instance_variable_set, :@__instance__, nil) # Ruby 1.8
      UI.send(:instance_variable_set, :@singleton__instance__, nil) # Ruby 1.9
      UI.instance.send(:instance_variable_get, :@output).should == STDOUT
    end
  end

  context '#run' do
    it { should respond_to :run }

    it "should load the config" do
      Vimius.expects(:config).once

      subject.run
    end
  end
end
