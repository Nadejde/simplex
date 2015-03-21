require 'matrix'

class Simplex
  attr_accessor :tableau
    
  def initialize( initial_tableau )
    @tableau = Matrix.rows( initial_tableau )
  end
    
  def basic_solution 
    @basic_solution = []
    
    #last columns is Ans. not interested in that
    @tableau.column_vectors[0..-2].each do |column| 
      if column.count { |value| value != 0 } > 1 
        @basic_solution << 0 
      else
        variable_row_index = column.find_index { |value| value != 0 } 
        @basic_solution << 
            @tableau[variable_row_index, -1] / column[variable_row_index] 
      end 
    end
    
    @basic_solution 
  end
  
  def star_row?
    #looks for negative surpluss values and returns first row
    return nil unless column = @basic_solution.find_index { |value| value < 0 }
    found_index = @tableau.column( column ).find_index { |value| value != 0}
  end
  
  def variable_count
    @tableau.column_count - @tableau.row_count - 1
  end 
  
  def feasible_solution?
    return false if @basic_solution.find_index { |value| value < 0 }
    return true
  end
  
  def pivot_column
    if star_row = star_row?
      #ignore last column (ans)
      column = @tableau.row( star_row ).
            find_index( @tableau.row( star_row )[0..-2].max )
    end
    
    return column
  end
end