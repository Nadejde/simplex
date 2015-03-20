require 'simplex'

describe Simplex do
  it 'should exist' do
    class_type = Simplex
    Simplex.class.should == Class
  end
end
