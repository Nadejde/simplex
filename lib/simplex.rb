require 'matrix'

class Simplex
  attr_accessor :tableau
    
  def initialize( initial_tableau )
    @tableau = Matrix.rows( initial_tableau )
  end
    
  def basic_solution 
    @basic_solution = []
    
    @tableau.column_vectors[0..-2].each do |column| #last columns is Ans. not interested in that
      if column.count { |value| value != 0 } > 1 
        @basic_solution << 0 
      else
        variable_row_index = column.find_index { |value| value != 0 } 
        @basic_solution << @tableau[variable_row_index, -1] / column[variable_row_index] 
      end 
    end
    
    @basic_solution 
  end
  
  def negative_surplus_variables?
    true if @tableau.minor( 0..-2, ( variable_count...-1))
            .find_index { |value| value < 0 }
  end
  
  def variable_count
    @tableau.column_count - @tableau.row_count - 1
  end  
end