require 'spec_helper'
require 'singleton'

class Output
  include Singleton
  attr_accessor :messages

  def puts(message)
    @messages ||= []
    @messages << message
  end
end

RSpec::Matchers.define :be_in_output do
  match do |actual|
    Output.instance.messages.include?(actual).should be_true
  end
end

describe UI do

  subject { UI.instance }

  before(:each) do
    subject.send(:instance_variable_set, :@output, Output.instance)
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

  context '#puts' do
    it { should respond_to :puts }

    it "should puts into @output" do
      subject.send :puts, "Hi from tests"

      "Hi from tests".should be_in_output
    end
  end

  context '#run' do
    it { should respond_to :run }

    it "should load the config" do
      Vimius.expects(:config).once

      subject.run
    end

    it "should display the ASCII art" do
      subject.run

      UI::ASCII_ART.should be_in_output
    end
  end
end
