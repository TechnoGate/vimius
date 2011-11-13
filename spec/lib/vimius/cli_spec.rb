require 'spec_helper'

module CLI
  describe Runner do
    subject { Runner }

    context 'Thor' do
      it { should respond_to :start }
    end
  end
end
