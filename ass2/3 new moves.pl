

Get 20 moves, 23 moves and 26 moves


start6(Pos),solve(Pos,Sol,N),showsol(Sol).
start6([1/3,3/1,1/2,2/1,3/2,2/3,2/2,3/3,1/1]).   %  20 moves

          State             
      +-----------+
 1    | 8   2     |
 2    | 3   6   5 |       
 3    | 1   4   7 |
      +-----------+
        1   2   3


start7(Pos),solve(Pos,Sol,N),showsol(Sol).
start7([2/1,3/2,1/3,3/1,2/2,2/3,1/2,3/3,1/1]).   %  23 moves

          State             
      +-----------+
 1    | 8   6   2 |
 2    |     4   5 |       
 3    | 3   1   7 |
      +-----------+
        1   2   3



start8(Pos),solve(Pos,Sol,N),showsol(Sol).
start8([2/2,3/3,1/2,3/1,3/2,1/3,1/1,2/3,2/1]).   %  26 moves

          State             
      +-----------+
 1    | 6   2   5 |
 2    | 8       7 |       
 3    | 3   4   1 |
      +-----------+
        1   2   3




          State             Representation - Goal State
      +-----------+
 1    | 1   2   3 |
 2    | 4   5   6 |       [3/3, 1/1, 1/2, 1/3, 2/1, 2/2, 2/3, 3/1, 3/2]
 3    | 7   8     |
      +-----------+
        1   2   3



2.5.1 Straight­Line Distance (Straight­Line Heuristic)
- Admissible:
□ This is always the shortest distance between two points, so it is guaranteed to never over­
estimate the distance. 

- Consistent:
□ The path cost always increases by 1 for each step.
□ The straight­line distance always decreases by at most 1 for each step.

- Since the straight­line distance is the shortest distance between two nodes, any other admissible
heuristic will dominate it.

The first one is Euclidean distance. The distance can be defined as a straight line between 2 points. 

On a square grid that allows any direction of movement, you might or might not want Euclidean distance (L2). 
If A* is finding paths on the grid but you are allowing movement not on the grid, you may want to consider other 
representations of the map.
http://theory.stanford.edu/~amitp/GameProgramming/Heuristics.html



2.5.2 The Sum of the Absolute Differences of the X and Y Values. (XY Heuristic)
- Admissible:
□ In the best case, where there are no walls between the current node and the target node, this
will be the exact number of steps needed to get to the target.
□ In the case where there are walls in the way, the number of steps will increase while this heuristic value will be unchanged.

- Consistent:
□ The path cost always increases by 1 for each step.
□ The estimated distance always decreases by 1 for each step.

Finally, a third heuristic is called the Manhattan distance (also known as the taxicab distance or L1 distance) is computed as follows
D(n,g)=|xn −xg|+|yn −yg|.
That is the total travel in either direction. Notice that if there are no obstacles, this heuristic is in fact exact. Clearly, introducing
 obstacles can only increase the length of the optimal path to get to the goal. Thus, this heuristic is also admissible.

 The last one is also known as L1 distance. The distance between two points is the sum of the (absolute) differences of their coordinates. 
 E.g. it only costs 1 unit for a straight move, but 2 if one wants to take a crossed move.

On a square grid that allows 4 directions of movement, use Manhattan distance (L1).



A second admissible heuristic is the max distance (also known as the L∞ distance) of the node to the goal point, computed as follows. Denote the 
coordinates of the goal by g = (xg,yg) and the coordinates of
the node n under consideration by n = (xn, yn), then the max distance is D(n,g)=max{|xn −xg|,|yn −yg|},
where | · | is the absolute value operator. That is, the L∞ distance is the maximum travel distance in either direction x or direction y on the map. 
Clearly, the steps required the get to the goal is at least the maximum of travel in either direction. Thus, this heuristic is admissible.

In Chebyshev distance, all 8 adjacent cells from the given point can be reached by one unit.

On a square grid that allows 8 directions of movement, use Diagonal distance (L∞).

