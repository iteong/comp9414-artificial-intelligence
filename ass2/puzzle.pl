% Bratko Figure 12.6. Problem-specific procedures for the eight puzzle
% to be used with the A-star best-first search of Bratko Figure 12.3.

/* Problem-specific procedures for the eight puzzle

  Current state is represented as a list of positions of tiles
  in the form R/C, with the first item corresponding to the
  position of "empty" and the rest to those of the tiles 1-8.

Example:

          State             Representation
      +-----------+
 1    | 1   2   3 |
 2    | 4   5   6 |       [3/3, 1/1, 1/2, 1/3, 2/1, 2/2, 2/3, 3/1, 3/2]
 3    | 7   8     |
      +-----------+
        1   2   3

 Moves are handled by swapping the positions of "empty" and one of its
  neighbours.
*/

% s(Node, SuccessorNode, Cost)

s([Empty|Tiles], [Tile|Tiles1], 1) :-        % All arc costs are 1
    swap(Empty, Tile, Tiles, Tiles1).        % Swap Empty and Tile in Tiles

swap(Empty, Tile, [Tile|Ts], [Empty|Ts]) :-  % Swap allowed if Man Dist = 1
   mandist(Empty, Tile, 1).

swap(Empty, Tile, [T1|Ts], [T1|Ts1]) :-
    swap(Empty, Tile, Ts, Ts1).

mandist(X/Y, X1/Y1, D) :-      % D is Manhattan Dist between two positions
    dif(X, X1, Dx),
    dif(Y, Y1, Dy),
    D is Dx + Dy.

dif(A, B, D) :-                % D is |A-B|
    D is A-B, D >= 0, !.

dif(A, B, D) :-                % D is |A-B|
    D is B-A.


hamdist(X/Y, X/Y, H) :-   % H is the Hamming Distance, the number of misplaced tiles
    H is 0, !.            % if X and Y for initial and final positions the same,
                          % add nothing to H counter and stop at cut.

hamdist(_/_, _/_, H) :-   % H is the Hamming Distance, the number of misplaced tiles
    H is 1, !.              % else (if X and Y for initial and final positions differ),
                            % add 1 to H counter and stop at cut (use _ to prevent singleton
                            % variable error).


goal([3/3,1/1,1/2,1/3,2/1,2/2,2/3,3/1,3/2]).

% Display a solution path as a list of board positions

showsol([]).

showsol([P|L]) :-
    showsol(L),
    nl, write('---'),
    showpos(P).

% Display a board position

showpos([S0,S1,S2,S3,S4,S5,S6,S7,S8]) :-
    member(R, [1,2,3]), nl,           % Order to display Row
    member(C, [1,2,3]),               % Order to display Col
    member(Tile-R/C,                  % Tile currently at position R/C
            [' '-S0,1-S1,2-S2,3-S3,4-S4,5-S5,6-S6,7-S7,8-S8]),
    write(Tile),
    fail                              % Backtrack to next position
    ;
    true.                             % All positions displayed

% Start positions for some puzzles

start1([3/2,1/1,1/2,1/3,2/1,3/3,2/2,3/1,2/3]).   %   5 moves

          State             
      +-----------+
 1    | 1   2   3 |
 2    | 4   6   8 |       
 3    | 7       5 |
      +-----------+
        1   2   3

start2([2/3,1/1,1/2,1/3,3/1,2/2,3/3,3/2,2/1]).   %   7 moves

          State             
      +-----------+
 1    | 1   2   3 |
 2    | 8   5     |       
 3    | 4   7   6 |
      +-----------+
        1   2   3

start3([3/1,2/2,1/1,2/3,1/3,3/2,1/2,2/1,3/3]).   %  12 moves

          State             
      +-----------+
 1    | 2   6   4 |
 2    | 7   1   3 |       
 3    |     5   8 |
      +-----------+
        1   2   3

start4([2/1,1/3,3/1,2/3,3/2,1/1,1/2,2/2,3/3]).   %  15 moves

          State             
      +-----------+
 1    | 5   6   1 |
 2    |     7   3 |       
 3    | 2   4   8 |
      +-----------+
        1   2   3

start5([2/2,2/3,1/2,3/3,1/3,2/1,3/2,1/1,3/1]).   %  18 moves

          State             
      +-----------+
 1    | 7   2   4 |
 2    | 5       1 |       
 3    | 8   6   3 |
      +-----------+
        1   2   3


% Example query: ?- start1(Pos), solve(Pos, Sol), showsol(Sol).

% --------------------------------------------------------------------
% The rest is needed only for A*Search (To compute the heuristic)
% --------------------------------------------------------------------

% Heuristic estimate h is the sum of distances of each tile
% from its "home" position.

h([_Empty|Tiles], H) :-
    goal([_Empty1|GoalPositions]),
    totdist(Tiles, GoalPositions, D),  % Total dist from home positions
    H is D.

totdist([], [], 0).

totdist([Tile|Tiles], [Position|Positions], D) :-
%    mandist(Tile, Position, D1), % commenting out mandist for hamdist
    hamdist(Tiles, Positions, D1),
    totdist(Tiles, Positions, D2),
    D is D1 + D2.




    





