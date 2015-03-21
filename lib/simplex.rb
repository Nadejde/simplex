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
  
  def star_rows?
    rows = []
    #looks for negative surpluss values and returns first row
    @basic_solution.each_with_index do |value, index|
      rows << @tableau.column(index).find_index { |cv| cv != 0 } if value < 0
    end
    
    return nil unless rows.count > 0
    return rows
  end
  
  def variable_count
    @tableau.column_count - @tableau.row_count - 1
  end 
  
  def feasible_solution?
    return false if @basic_solution.find_index { |value| value < 0 }
    return true
  end
  
  def pivot_column
    if star_rows = star_rows?
      #ignore last column (ans)
      column = @tableau.row( star_rows.first ).
            find_index( @tableau.row( star_rows.first )[0..-2].max )
    end
    
    return column
  end
  
  def pivot_row
    column = @tableau.row( pivot_column )
    #get all rows with min ratio
    column.min_by(0) { |value| column[-1] / value }
    #if min ratio is both in starred row and unstarred row use starred row
    #column.count > 1 ?
  end
end