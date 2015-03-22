# simplex
Implementation of the Simplex algorithm. Solves all types of linear programming problems, including non standard.

# Using Simplex:

You can use this class to solve linear programming problems. Example of problem:

p = 2x + 3y + z

x + y + z <= 40

2x + y - z => 10

-y + z => 10

x => 0, y => 0, z => 0

You will need to do some work yourself and generate the initial tableau. Example for the problem above:
[
[1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0, 40.0],
[2.0, 1.0, -1.0, 0.0, -1.0, 0.0, 0.0, 10.0],
[0.0, -1.0, 1.0, 0.0, 0.0, -1.0, 0.0, 10.0],
[-2.0, -3.0, -1.0, 0.0, 0.0, 0.0, 1.0, 0.0] 
]

Instantiate Simplex like this:
simplex = Simplex.new( [
[1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0, 40.0],
[2.0, 1.0, -1.0, 0.0, -1.0, 0.0, 0.0, 10.0],
[0.0, -1.0, 1.0, 0.0, 0.0, -1.0, 0.0, 10.0],
[-2.0, -3.0, -1.0, 0.0, 0.0, 0.0, 1.0, 0.0] 
] )
 => #<Simplex:0x00000001c5b2e0 @tableau=Matrix[[1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0, 40.0], 
 [2.0, 1.0, -1.0, 0.0, -1.0, 0.0, 0.0, 10.0], [0.0, -1.0, 1.0, 0.0, 0.0, -1.0, 0.0, 10.0], 
 [-2.0, -3.0, -1.0, 0.0, 0.0, 0.0, 1.0, 0.0]], @max_cycles=10000, 
 @basic_solution=[0, 0, 0, 40.0, -10.0, -10.0, 0.0]> 
 
You can then call solution to get the solution:
simplex.solution
 => [70.0, 10.0, 10.0, 20.0] 
 
You can also do it step by step by calling pivot:
simplex.pivot
=> Matrix[[0.0, 0.5, 1.5, 1.0, 0.5, 0.0, 0.0, 35.0], [1.0, 0.5, -0.5, 0.0, -0.5, 0.0, 0.0, 5.0], 
[0.0, -1.0, 1.0, 0.0, 0.0, -1.0, 0.0, 10.0], [0.0, -2.0, -2.0, 0.0, -1.0, 0.0, 1.0, 10.0]]

Other usefull bits:
Simplex#tableau gets you the current tableau
Simplex#basic_solution gets you the current basic solution
Simplex#max_cycles lets you set maximum number of cycles to run through

See specs for more details.
