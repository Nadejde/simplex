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
    #return yield(rows)
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
    
    column
  end
  
  def pivot_row
    column = @tableau.row( pivot_column )
    min_ratio = column.select {|v| v > 0 }
                  .min_by { |value| column[-1] / value }
    
    #if one of the star rows has min ratio return that
    if star_rows = star_rows?
      column.each_with_index do |v, i|  
        return i if v > 0 && 
                  ( min_ratio == column[-1]  / v ) && 
                  star_rows.include?( i )
      end
    end
    
    #if no star rows has min ratio just return first row
    column.find_index { |v| v > 0 && ( min_ratio == column[-1] / v ) }
  end
end