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
      [1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0, 40.0],
      [2.0, 1.0, -1.0, 0.0, -1.0, 0.0, 0.0, 10.0],
      [0.0, -1.0, 1.0, 0.0, 0.0, -1.0, 0.0, 10.0],
      [-2.0, -3.0, -1.0, 0.0, 0.0, 0.0, 1.0, 0.0] 
      ]
  end
  
  it 'should exist' do
    class_type = Simplex
    
    expect(Simplex.class).to eq(Class)
  end
  
  it 'should hold initial tableau in Matrix object' do
    simplex = Simplex.new(@initial_tableau)
    
    expect(simplex.tableau).to eq(Matrix.rows(@initial_tableau))
  end
  
  it 'should calculate basic solution for tableau' do
    # A basic solution is calculated by looking for columns 
    # with only one value != 0. 
    # Get row index for that one value.
    # Variable attached to that colum is Ans[rowindex] / column[rowindex]
    simplex = Simplex.new(@initial_tableau)
    
    expect(simplex.basic_solution).to eq([0.0, 0.0 ,0.0, 40.0, -10.0, -10.0, 0.0])
  end
  
  it 'should detect negative surplus variables and return row indexes' do
    #negative surplus values are not permited for a feasible solution
    simplex = Simplex.new(@initial_tableau)
    
    expect(simplex.star_rows?).to eq([1, 2])
  end
  
  it 'should not return row index if no negateive surplus variables' do
    tableau = 
    [
      [1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0, 40.0],
      [2.0, 1.0, -1.0, 0.0, 1.0, 0.0, 0.0, 10.0],
      [0.0, -1.0, 1.0, 0.0, 0.0, 1.0, 0.0, 10.0],
      [-2.0, -3.0, -1.0, 0.0, 0.0, 0.0, 1.0, 0.0]
      ]
    simplex = Simplex.new(tableau)
    
    expect(simplex.star_rows?).to  be_falsey
  end
  
  it 'ignores the block for star_rows? if no star rows exist' do
    tableau = 
    [
      [1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0, 40.0],
      [2.0, 1.0, -1.0, 0.0, 1.0, 0.0, 0.0, 10.0],
      [0.0, -1.0, 1.0, 0.0, 0.0, 1.0, 0.0, 10.0],
      [-2.0, -3.0, -1.0, 0.0, 0.0, 0.0, 1.0, 0.0]
      ]
    simplex = Simplex.new(tableau)
    
    expect(simplex.star_rows? { |rows| rows.count }).to be_falsey
  end
  
  it 'takes a block with star_rows?' do
    simplex = Simplex.new(@initial_tableau)
    
    expect(simplex.star_rows? { |rows| rows.count }).to eq(2)
  end
  
  it 'should count number of variables' do
    simplex = Simplex.new(@initial_tableau)
    
    expect(simplex.variable_count).to eq(3)
  end
  
  it 'should know solution is not feasible while slack variables are negative' do
    simplex = Simplex.new(@initial_tableau)
    
    expect(simplex.feasible_solution?).to be_falsey
  end
  
  it 'should find correct pivot column while slack variables are negative' do
    simplex = Simplex.new(@initial_tableau)
    
    expect(simplex.pivot_column_index).to eq(0)
  end
  
  it 'should find correct pivot row in column' do
    simplex = Simplex.new(@initial_tableau)
    
    expect(simplex.pivot_row_index).to eq(1)
  end
  
  it 'should pivot' do
    pivoted_tableau = 
    Matrix[
        [0.0, 0.5, 1.5, 1.0, 0.5, 0.0, 0.0, 35.0], 
        [1.0, 0.5, -0.5, 0.0, -0.5, 0.0, 0.0, 5.0], 
        [0.0, -1.0, 1.0, 0.0, 0.0, -1.0, 0.0, 10.0], 
        [0.0, -2.0, -2.0, 0.0, -1.0, 0.0, 1.0, 10.0]]
    simplex = Simplex.new(@initial_tableau)
    
    expect(simplex.pivot).to eq(pivoted_tableau)

    pivoted_tableau = 
    Matrix[
        [0, 2, 0, 1, 0.5, 1.5, 0, 20],   
        [1, 0, 0, 0, -0.5, -0.5, 0, 10],   
        [0, -1, 1, 0, 0, -1, 0, 10],
        [0, -4, 0, 0, -1, -2, 1, 30]]
    
    expect(simplex.pivot).to eq(pivoted_tableau)
    
    pivoted_tableau = 
    Matrix[
        [0, 1, 0, 0.5, 0.25, 0.75, 0, 10],     
        [1, 0, 0, 0, -0.5, -0.5, 0, 10],
        [0, 0, 1, 0.5, 0.25, -0.25, 0, 20],    
        [0, 0, 0, 2, 0, 1, 1, 70]] 
        
    expect(simplex.pivot).to eq(pivoted_tableau)
  end
  
  it 'should find correct pivot column if no negative slack variables' do
    pivoted_tableau = 
        [
        [0, 2, 0, 1, 0.5, 1.5, 0, 20],   
        [1, 0, 0, 0, -0.5, -0.5, 0, 10],   
        [0, -1, 1, 0, 0, -1, 0, 10],
        [0, -4, 0, 0, -1, -2, 1, 30]]
        
    simplex = Simplex.new(pivoted_tableau)
    
    expect(simplex.pivot_column_index).to eq(1)
  end
  
  it 'should find correct pivot row if no negative slack variables' do
    pivoted_tableau = 
        [
        [0, 2, 0, 1, 0.5, 1.5, 0, 20],   
        [1, 0, 0, 0, -0.5, -0.5, 0, 10],   
        [0, -1, 1, 0, 0, -1, 0, 10],
        [0, -4, 0, 0, -1, -2, 1, 30]]
        
    simplex = Simplex.new(pivoted_tableau)
    
    expect(simplex.pivot_row_index).to eq(0)
  end
  
  it 'knows solutions is not feasible while negative values on last row' do
    pivoted_tableau = 
        [
        [0, 2, 0, 1, 0.5, 1.5, 0, 20],   
        [1, 0, 0, 0, -0.5, -0.5, 0, 10],   
        [0, -1, 1, 0, 0, -1, 0, 10],
        [0, -4, 0, 0, -1, -2, 1, 30]]
    simplex = Simplex.new(pivoted_tableau)
    
    expect(simplex.feasible_solution?).to be_falsey
  end
  
   it 'knows feasible solution' do
    pivoted_tableau = 
        [
        [0, 1, 0, 0.5, 0.25, 0.75, 0, 10],     
        [1, 0, 0, 0, -0.5, -0.5, 0, 10],
        [0, 0, 1, 0.5, 0.25, -0.25, 0, 20],    
        [0, 0, 0, 2, 0, 1, 1, 70]] 
    simplex = Simplex.new(pivoted_tableau)
    
    expect(simplex.feasible_solution?).to be_truthy 
  end
  
  it 'knows solution in final tableau' do
    pivoted_tableau = 
        [
        [0, 1, 0, 0.5, 0.25, 0.75, 0, 10],     
        [1, 0, 0, 0, -0.5, -0.5, 0, 10],
        [0, 0, 1, 0.5, 0.25, -0.25, 0, 20],    
        [0, 0, 0, 2, 0, 1, 1, 70]] 
    simplex = Simplex.new(pivoted_tableau)
    
    expect(simplex.solution).to eq([70, 10, 10, 20])
  end
  
  it 'finds solution' do
    simplex = Simplex.new(@initial_tableau)
    
    #p = 70, x= 10, 7= 10, z= 20
    expect(simplex.solution).to eq([70, 10, 10, 20])
  end
  
  it 'finds solution for standard problem' do
     pivoted_tableau = 
        [
          [4, -3, 1, 1,  0,  0,  0, 3],     
          [1, 1, 1, 0, 1, 0, 0, 10],     
          [2, 1, -1, 0, 0, 1, 0, 10],     
          [-2, 3, -4, 0, 0, 0, 1, 0]]
          
    converted_tableau = 
        [
          [4.0, -3.0, 1.0, 1.0,  0.0,  0.0,  0.0, 3.0],     
          [1.0, 1.0, 1.0, 0.0, 1.0, 0.0, 0.0, 10.0],     
          [2.0, 1.0, -1.0, 0.0, 0.0, 1.0, 0.0, 10.0],     
          [-2.0, 3.0, -4.0, 0.0, 0.0, 0.0, 1.0, 0.0]]
          
    simplex = Simplex.new(converted_tableau) 
    
    expect(simplex.solution).to eq([27.75, 0, 1.75, 8.25])
  end
  
  it 'returns nil solution for unbound problems' do
    tableau = [
      [2, -2, 1, 0, 6],
      [4, 0, 0, 1, 16],
      [-4, -6, 0, 0, 0]
      ]
    simplex = Simplex.new(tableau)
    
    expect(simplex.solution).to be_nil
  end
  
  it 'solves Sefans complex food problem' do
    tableau = [
      [ 4.1,  7.7,  12.6,    5.4,   7.7,  3.7, -1.0,  0.0,  0.0,  0.0,  0.0,  0.0,  0.0,  0.0,  0.0,  0.0,  0.0,  0.0, 27.1],
      [ 1.8,  7.7,   2.1,    2.2,   0.5,  9.3,  0.0, -1.0,  0.0,  0.0,  0.0,  0.0,  0.0,  0.0,  0.0,  0.0,  0.0,  0.0, 48.2],
      [16.5,  0.0,   7.5,   14.0,  15.7,  0.6,  0.0,  0.0, -1.0,  0.0,  0.0,  0.0,  0.0,  0.0,  0.0,  0.0,  0.0,  0.0, 43.5],
      [94.0, 39.1, 418.5, 1075.3, 101.5, 14.5,  0.0,  0.0,  0.0, -1.0,  0.0,  0.0,  0.0,  0.0,  0.0,  0.0,  0.0,  0.0,  0.0],
      [ 1.0,  0.0,   0.0,    0.0,   0.0,  0.0,  0.0,  0.0,  0.0,  0.0, -1.0,  0.0,  0.0,  0.0,  0.0,  0.0,  0.0,  0.0,  0.5],
      [ 0.0,  1.0,   0.0,    0.0,   0.0,  0.0,  0.0,  0.0,  0.0,  0.0,  0.0, -1.0,  0.0,  0.0,  0.0,  0.0,  0.0,  0.0,  0.5],
      [ 0.0,  0.0,   1.0,    0.0,   0.0,  0.0,  0.0,  0.0,  0.0,  0.0,  0.0,  0.0, -1.0,  0.0,  0.0,  0.0,  0.0,  0.0,  0.5],
      [ 0.0,  0.0,   0.0,    1.0,   0.0,  0.0,  0.0,  0.0,  0.0,  0.0,  0.0,  0.0,  0.0, -1.0,  0.0,  0.0,  0.0,  0.0,  0.1],
      [ 0.0,  0.0,   0.0,    0.0,   1.0,  0.0,  0.0,  0.0,  0.0,  0.0,  0.0,  0.0,  0.0,  0.0, -1.0,  0.0,  0.0,  0.0,  0.5],
      [ 0.0,  0.0,   0.0,    0.0,   0.0,  1.0,  0.0,  0.0,  0.0,  0.0,  0.0,  0.0,  0.0,  0.0,  0.0, -1.0,  0.0,  0.0,  0.5],
      [ 0.0,  0.0,   0.0,    0.0,   0.0,  1.0,  0.0,  0.0,  0.0,  0.0,  0.0,  0.0,  0.0,  0.0,  0.0,  0.0,  1.0,  0.0,  1.0],
      [-1.0, -1.0,  -1.0,   -1.0,  -1.0, -1.0,  0.0,  0.0,  0.0,  0.0,  0.0,  0.0,  0.0,  0.0,  0.0,  0.0,  0.0, -1.0,  0.0],
      ]
    simplex = Simplex.new(tableau, precision:0.01)
    
    expect(simplex.solution).to eq([-8.34, 1.81, 4.43, 0.5, 0.1, 0.5, 1.0] )
  end
  
  it 'should take block for settings' do
    simplex = Simplex.new(@initial_tableau, precision: 0.01, max_cycles: 10)
    
    expect(simplex.max_cycles).to eq 10
    expect(simplex.precision).to eq 0.01
  end

  it 'should save old basic solution before pivot' do
    simplex = Simplex.new(@initial_tableau, precision: 0.01, max_cycles: 10)
    basic_solution = simplex.basic_solution
    simplex.pivot
    
    expect(simplex.old_basic_solution).to eq [0, 0, 0, 40.0, -10.0, -10.0, 0.0]
  end
  
  it 'should calculate gap between old and new solution' do
    simplex = Simplex.new(@initial_tableau, precision: 0.01, max_cycles: 10)
    simplex.pivot
    
    expect(simplex.basic_solution_gap).to eq 10
  end
  
  it 'should return :max_cycles when hitting cycles exit condition' do
    simplex = Simplex.new(@initial_tableau, precision: 0.01, max_cycles: 3)
    simplex.solution
    
    expect(simplex.exit_condition?).to eq :max_cycles
  end
  
  it 'should return :precision when hitting precision exit condition' do
    tableau = [
      [ 4.1,  7.7,  12.6,    5.4,   7.7,  3.7, -1.0,  0.0,  0.0,  0.0,  0.0,  0.0,  0.0,  0.0,  0.0,  0.0,  0.0,  0.0, 27.1],
      [ 1.8,  7.7,   2.1,    2.2,   0.5,  9.3,  0.0, -1.0,  0.0,  0.0,  0.0,  0.0,  0.0,  0.0,  0.0,  0.0,  0.0,  0.0, 48.2],
      [16.5,  0.0,   7.5,   14.0,  15.7,  0.6,  0.0,  0.0, -1.0,  0.0,  0.0,  0.0,  0.0,  0.0,  0.0,  0.0,  0.0,  0.0, 43.5],
      [94.0, 39.1, 418.5, 1075.3, 101.5, 14.5,  0.0,  0.0,  0.0, -1.0,  0.0,  0.0,  0.0,  0.0,  0.0,  0.0,  0.0,  0.0,  0.0],
      [ 1.0,  0.0,   0.0,    0.0,   0.0,  0.0,  0.0,  0.0,  0.0,  0.0, -1.0,  0.0,  0.0,  0.0,  0.0,  0.0,  0.0,  0.0,  0.5],
      [ 0.0,  1.0,   0.0,    0.0,   0.0,  0.0,  0.0,  0.0,  0.0,  0.0,  0.0, -1.0,  0.0,  0.0,  0.0,  0.0,  0.0,  0.0,  0.5],
      [ 0.0,  0.0,   1.0,    0.0,   0.0,  0.0,  0.0,  0.0,  0.0,  0.0,  0.0,  0.0, -1.0,  0.0,  0.0,  0.0,  0.0,  0.0,  0.5],
      [ 0.0,  0.0,   0.0,    1.0,   0.0,  0.0,  0.0,  0.0,  0.0,  0.0,  0.0,  0.0,  0.0, -1.0,  0.0,  0.0,  0.0,  0.0,  0.1],
      [ 0.0,  0.0,   0.0,    0.0,   1.0,  0.0,  0.0,  0.0,  0.0,  0.0,  0.0,  0.0,  0.0,  0.0, -1.0,  0.0,  0.0,  0.0,  0.5],
      [ 0.0,  0.0,   0.0,    0.0,   0.0,  1.0,  0.0,  0.0,  0.0,  0.0,  0.0,  0.0,  0.0,  0.0,  0.0, -1.0,  0.0,  0.0,  0.5],
      [ 0.0,  0.0,   0.0,    0.0,   0.0,  1.0,  0.0,  0.0,  0.0,  0.0,  0.0,  0.0,  0.0,  0.0,  0.0,  0.0,  1.0,  0.0,  1.0],
      [-1.0, -1.0,  -1.0,   -1.0,  -1.0, -1.0,  0.0,  0.0,  0.0,  0.0,  0.0,  0.0,  0.0,  0.0,  0.0,  0.0,  0.0, -1.0,  0.0],
      ]
      
    simplex = Simplex.new(tableau, precision: 0.0001, max_cycles: 1000)
    simplex.solution
    
    expect(simplex.exit_condition?).to eq :precision
  end
  
  it 'should have exit_condition? return fasey if solution found' do
    simplex = Simplex.new(@initial_tableau, precision: 0.01, max_cycles: 10)
    simplex.solution
    
    expect(simplex.exit_condition?).to be_falsey
  end
end
