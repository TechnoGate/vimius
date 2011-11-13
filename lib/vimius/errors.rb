module TechnoGate
  module Vimius
    # Errors
    VimiusError = Class.new Exception
    BlockNotGivenError = Class.new VimiusError
    RubyGemsNotFoundError = Class.new VimiusError

    SubmoduleError = Class.new VimiusError
    SubmodulesNotValidError = Class.new SubmoduleError
    SubmoduleNotFoundError = Class.new SubmoduleError
  end
end
