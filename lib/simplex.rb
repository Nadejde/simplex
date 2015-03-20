require 'matrix'

class Simplex
    attr_accessor :initial_tableau
    def initialize( initial_tableau )
        @initial_tableau = Matrix.rows( initial_tableau )
    end
end