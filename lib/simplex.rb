require 'matrix'

class Simplex
  attr_accessor :tableau
    
  def initialize( initial_tableau )
    @tableau = Matrix.rows( initial_tableau )
    
    basic_solution #figure out first basic solution
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
    return yield(rows) if block_given?
    return rows
  end
  
  def variable_count
    @tableau.column_count - @tableau.row_count - 1
  end 
  
  def feasible_solution?
    return false if @basic_solution.find_index { |value| value < 0 }
    return true
  end
  
  def pivot_column_index
    column = nil
    
    star_rows? do |rows|
      #ignore last column (ans)
      column = @tableau.row( rows.first ).
            find_index( @tableau.row( rows.first )[0..-2].max )
    end
    
    #if no star rows pick pivot column the standard way
      column = @tableau.row(-1).find_index( 
                  @tableau.row( -1 )[0..-2].
                  select { |v| v < 0 } .min() ) unless column
    
    column
  end
  
  def pivot_row_index
    column = @tableau.row( pivot_column_index )
    min_ratio = column.select {|v| v > 0 }
                  .min_by { |value| column[-1] / value }
    
    #if one of the star rows has min ratio return that
    star_rows? do |rows|
      column.each_with_index do |v, i|  
        return i if v > 0 && 
                  ( min_ratio == column[-1]  / v ) && 
                  rows.include?( i )
      end
    end
    
    #if no star rows has min ratio just return first row
    column.find_index { |v| v > 0 && ( min_ratio == column[-1] / v ) }
  end
  
  def pivot
    new_tableau = []
    row_index = pivot_row_index
    column_index = pivot_column_index
    
    @tableau.row_vectors.each_with_index do |row,i|
      if row[column_index] == 0
        new_tableau << row.to_a 
      elsif i == row_index
        new_tableau << ( row / @tableau[row_index, column_index] ).to_a
      else
        new_tableau << ( row  - @tableau.row( row_index ) / @tableau[row_index, column_index] * @tableau[i, column_index] ).to_a
      end
    end
    
    basic_solution # after pivot compute new basic solution
    
    @tableau = Matrix.rows( new_tableau )
  end
end