require 'spec_helper'

describe UI do

  subject { UI.instance }

  context 'singleton' do
    it "should respond to instance" do
      UI.should respond_to :instance
    end

    it "should not allow calling new" do
      lambda { UI.new }.should raise_error NoMethodError
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
