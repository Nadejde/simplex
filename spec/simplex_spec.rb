require 'simplex'

describe Simplex do
  it 'should exist' do
    class_type = Simplex
    Simplex.class.should == Class
  end
  
  it 'should hold initial tableau in Matrix object' do
    matrix = [ [ 2, 2 ], [ 1, 2 ] ] 
    simplex = Simplex.new( matrix )
    simplex.initial_tableau.should == Matrix.rows( matrix )
  end
end
