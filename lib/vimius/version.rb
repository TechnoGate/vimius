module TechnoGate
  module Vimius
    MAJOR = 0
    MINOR = 0
    TINY = 1
    PRE = 'beta1'

    def self.version
      # Init the version
      version = [MAJOR, MINOR, TINY]
      # Add the pre if available
      version << PRE unless PRE.nil? || PRE !~ /\S/
      # Return the version joined by a dot
      version.join('.')
    end
  end
end
