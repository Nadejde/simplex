require 'matrix'

class Simplex
  attr_accessor :tableau
  attr_accessor :max_cycles
  attr_accessor :count
  attr_accessor :precision
  attr_accessor :old_basic_solution
  
  MAX_PRECISION_COUNT = 100
  
  def initialize(initial_tableau, max_cycles: 10000, precision: 0.01)
    @tableau = Matrix.rows(initial_tableau).map { |v| Float( v ) }
    @max_cycles = max_cycles
    @precision = precision
    @count = 0
    @precision_count = 0
    
    basic_solution #figure out first basic solution
    
  end
    
  def basic_solution_gap
      return basic_solution.map(&:abs).max if @old_basic_solution.nil?
      gap = 0
      basic_solution.each_with_index do |value, index|
         gap = (value - @old_basic_solution[index]).abs > gap ?
               (value - @old_basic_solution[index]).abs : gap 
      end
      gap
  end
  
  def exit_condition?
    return :max_cycles if @count == @max_cycles
    if basic_solution_gap < @precision
      @precision_count += 1
      return :precision if @precision_count > MAX_PRECISION_COUNT
    else
      @precision_count = 0
    end
    return nil
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
    return false if @basic_solution.find_index { |v| v < 0 }
    return false if @tableau.row(-1)[0..-2].find_index { |v| v < 0 }
    return true
  end
  
  def pivot_column_index
    column_index = nil
    
    star_rows? do |rows|
      #ignore last column (ans)
      column_index = @tableau.row(rows.first).
            find_index(@tableau.row(rows.first)[0..-2].max)
    end
    
    #if no star rows pick pivot column the standard way
    column_index = @tableau.row(-1).find_index( 
                @tableau.row(-1)[0..-2].
                select { |v| v < 0 } .min()) unless column_index
  
    column_index
  end
  
  def pivot_row_index
    column_index = pivot_column_index
    min_ratio = nil
    row_index = nil
    
    @tableau.row_vectors.each_with_index do |row, i|
      next if row[column_index] <= 0
      ratio = row[-1] / row[column_index]
      min_ratio ||= ratio
      row_index ||= i
      if min_ratio > ratio
        min_ratio = ratio
        row_index = i
      end
    end
    
    #if one of the star rows has min ratio return that
    star_rows? do |rows|
       @tableau.row_vectors.each_with_index do |row, i|  
        return i if row[column_index] > 0 && 
                  (min_ratio ==  row[-1]  / row[column_index]) && 
                  rows.include?(i)
      end
    end
    
    #if no star rows has min ratio just return first row
   row_index
  end
  
  def pivot
    @old_basic_solution = basic_solution
    new_tableau = []
    row_index = pivot_row_index
    
    return nil if row_index.nil? #if no row index return now with no solution
    
    @count += 1 #update steps count
    column_index = pivot_column_index
    
    @tableau.row_vectors.each_with_index do |row,i|
      if row[column_index] == 0
        new_tableau << row.to_a 
      elsif i == row_index
        new_tableau << (row / @tableau[row_index, column_index]).to_a
      else
        new_tableau << (row  - @tableau.row(row_index) / 
                        @tableau[row_index, column_index] * 
                        @tableau[i, column_index]).to_a
      end
    end
    
    @tableau = Matrix.rows(new_tableau)
    basic_solution # after pivot compute new basic solution
    
    @tableau
  end
  
  def solution
    until feasible_solution? || exit_condition?
      return nil if pivot.nil?
    end
    
    @basic_solution.rotate(-1)[0..variable_count].map { |v| v.round(2) }
  end
end