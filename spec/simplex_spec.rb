require 'simplex'

describe Simplex do
  before :each do
    #most test will use the initial tableau for this problem
    # p = 2x + 3y + z
    #  x + y + z <= 40 
    # 2x + y - z => 10 
    # - y + z => 10 
    # x => 0, y => 0, z => 0 
    @initial_tableau = 
    [
      [1, 1, 1, 1, 0, 0, 0, 40],
      [2, 1, -1, 0, -1, 0, 0, 10],
      [0, -1, 1, 0, 0, -1, 0, 10],
      [-2, -3, -1, 0, 0, 0, 1, 0]
      ]
  end
  
  it 'should exist' do
    class_type = Simplex
    
    Simplex.class.should == Class
  end
  
  it 'should hold initial tableau in Matrix object' do
    simplex = Simplex.new( @initial_tableau )
    
    simplex.tableau.should == Matrix.rows( @initial_tableau )
  end
  
  it 'should calculate basic solution for tableau' do
    # A basic solution is calculated by looking for columns 
    # with only one value != 0. 
    # Get row index for that one value.
    # Variable attached to that colum is Ans[rowindex] / column[rowindex]
    simplex = Simplex.new( @initial_tableau )
    
    simplex.basic_solution.should == [0, 0 ,0, 40, -10, -10, 0]
  end
  
  it 'should detect negative surplus variables and return firs found row index' do
    #negative surplus values are not permited for a feasible solution
    simplex = Simplex.new( @initial_tableau )
    simplex.basic_solution
    
    simplex.star_rows?.should == [1, 2]
  end
  
  it 'should not return row index if no negateive surplus variables' do
    tableau = 
    [
      [1, 1, 1, 1, 0, 0, 0, 40],
      [2, 1, -1, 0, 1, 0, 0, 10],
      [0, -1, 1, 0, 0, 1, 0, 10],
      [-2, -3, -1, 0, 0, 0, 1, 0]
      ]
    simplex = Simplex.new( tableau )
    simplex.basic_solution
    
    simplex.star_rows?.should be_nil
  end
  
  it 'takes a block with star_rows?' do
    simplex = Simplex.new( @initial_tableau )
    simplex.basic_solution
    
    simplex.star_rows? { |rows| rows.count }.should == 2
  end
  
  it 'should count number of variables' do
    simplex = Simplex.new( @initial_tableau)
    
    simplex.variable_count.should == 3
  end
  
  it 'should know solution is not feasible while slack variables are negative' do
    simplex = Simplex.new( @initial_tableau )
    simplex.basic_solution #calculate basic solution
    
    simplex.feasible_solution?.should == false
  end
  
  it 'should find correct pivot column while slack variables are negative' do
    simplex = Simplex.new( @initial_tableau )
    simplex.basic_solution
    
    simplex.pivot_column.should == 0
  end
  
  it 'should find correct pivot row in column' do
    simplex = Simplex.new( @initial_tableau )
    simplex.basic_solution
    
    simplex.pivot_row.should == 1
  end
end
