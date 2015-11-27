
!!section banner
 #####   #####
#     # #     #
      # #     #
 #####   ######
#             #
#       #     #
#######  #####

Teong, Shu Hao Ivan                     29

Submissions:-

S 0     Sun May 31 21:28:27 2015        29 all hw3prolog 0:-2

Tue Jun 09 19:13:08 2015                ## williams.orchestra.cse.unsw.EDU.AU ##
!!section listing
/bin/rm: cannot remove `*.pro': No such file or directory
agent.pro

===============================================================================
-rw-r----- 1 cs9414 cs9414 13021 Jun  9 19:13 student.pro
===============================================================================

     1  % COMP9414 Assignment for Semester 2, 2015
     2  %
     3  % Done by: Ivan Teong (z3386180)
     4  %          hw3group Number: 29
     5  %
     6  % Assignment Name: Project 3, Option 1: Prolog (BDI Agent)
     7  %
     8  % In this assignment, you will implement the basic functions of a simple BDI Agent that operates in a Gridworld,
     9  % and by doing so, learn about the ideas underlying BDI agents.
    10
    11  % ########################################QUESTION 1#################################################
    12
    13  % Write a Prolog procedure trigger(Events, Goals) which takes a list of events, each of the form junk(X,Y,S),
    14  % and computes the corresponding list of goals for the agent, each of the form goal(X,Y,S).
    15
    16
    17  % When calling copy, works its way down to the base case, setting Goals to an empty list.
    18  % Then works itself back up and keeps appending the head H of known list [H|T1] to the
    19  % beginning of variable list [H|T2], continuing until the original case is reached, where
    20  % the list Goals will contain a full copy of the list Events:
    21
    22  copy(Events, Goals) :- trigger(Events, Goals).
    23
    24  % Base case sets the copy list to empty when original list is empty:
    25
    26  trigger([],[]) :-!.
    27
    28  % Recursive case takes H from list Events and add it to the head of list Goals:
    29
    30  trigger([H|T1], [H|T2]) :-
    31          trigger(T1, T2).
    32
           ^
           + ==================================================== +
           + trigger([junk(X,Y,S)|Events], [goal(X,Y,S)|Goals] :- +
           +       trigger(Events, Goals).                        +
           + ==================================================== +
    33
    34
    35
    36  % #########################################QUESTION 2################################################
    37
    38  % Write a Prolog procedure: incorporate_goals(Goals, Beliefs, Intentions, Intentions1).
    39  % There are four arguments:
    40  % 1) a list of goals each of the form goal(X,Y,S)
    41  % 2) a list of beliefs (containing one term of the form at(X,Y))
    42  % 3) the current list of intentions each of the form [goal(X,Y,S), Plan]
    43  % 4) a list to be computed which contains the new goals inserted into the current list of intentions in increasing
    44  %    order of distance, using the value of the item to break ties. More precisely, a new goal should be placed immediately
    45  %    before the first goal in the list that is further away from the agent's current position, or which is at the same distance
    46  %    from the agent but of lower value, without reordering the current list of goals.
    47  % Note that because of repeated perception of the same event, only new goals should be inserted into the list of intentions. The
    48  % plan associated with each new goal should be the empty plan (represented as the empty list).
    49
    50
    51  % Base case when there is no more goals in list Goals, when recursion has been completed after
    52  % going through all the goals.
    53
    54  incorporate_goals([], _, Intentions, Intentions) :-!.
    55
    56
    57
    58
    59  % Recursive case where we check to see whether the goal is a new goal: This is not a new goal,
    60  % as it is already a member of the list of goals in list Intentions. Continue checking the rest
    61  % of the goals by calling incorporate_goals again recursively.
    62
    63  incorporate_goals([goal(X,Y,S)|RestofGoals], Beliefs, Intentions, Intentions1) :-
    64      member([goal(X,Y,S),_], Intentions),
    65      incorporate_goals(RestofGoals, Beliefs, Intentions, Intentions1),!.
    66
    67  % Recursive case where we check to see whether the goal is a new goal: This is a new goal, as it is not a
    68  % member of Intentions, so continue insertion into Intentions by calling incorporate_goals_now first to check
    69  % the conditions before incorporating this goal into Intentions continuously and checking the other goals recursively.
    70
    71  incorporate_goals([goal(X,Y,S)|RestofGoals], Beliefs, Intentions, Intentions1) :-
    72      incorporate_goals_now(goal(X,Y,S), Beliefs, Intentions, UpdateIntentions), % insert goals into correct position based on conditions.
    73      incorporate_goals(RestofGoals, Beliefs, UpdateIntentions, Intentions1). % update Intentions for main function and check other goals.
    74
    75
    76
    77
    78  % Insert the new goal (with shorter distance to Beliefs or if equal, a higher value) in Intentions format (Goal with Plan)
    79  % into Intentions before the intentions with a longer distance to Beliefs or if equal, a lower value. Intentions should
    80  % be from shortest to longest distance from Beliefs from left to right, or in descending order based on highest value to
    81  % lowest value for those with same distance to Beliefs.
    82
    83  % Base case when it is a new goal, and the plan will be empty represented by empty list.
    84  incorporate_goals_now(goal(X,Y,S), _, [], [[goal(X,Y,S), []]]) :-!.
    85
    86  incorporate_goals_now(goal(X1,Y1,S1), [at(X, Y)], [[goal(X2,Y2,S2),Plan]|RestofIntentions], [[goal(X2,Y2,S2),Plan]|RestofIntentions1]):-
    87      distance((X, Y), (X1, Y1), D_New),
    88      distance((X, Y), (X2, Y2), D_List),
    89      D_New > D_List,
    90      incorporate_goals_now(goal(X1,Y1,S1), [at(X, Y)], RestofIntentions, RestofIntentions1),!.
    91
    92  incorporate_goals_now(goal(X1,Y1,S1), [at(X, Y)], [[goal(X2,Y2,S2),Plan]|RestofIntentions], [[goal(X1,Y1,S1),[]]|RestofIntentions1]):-
    93      distance((X, Y), (X1, Y1), D_New),
    94      distance((X, Y), (X2, Y2), D_List),
    95      D_New < D_List,
    96      RestofIntentions1 = [[goal(X2,Y2,S2),Plan]|RestofIntentions],!.
    97
    98  incorporate_goals_now(goal(X1,Y1,S1), [at(X, Y)], [[goal(X2,Y2,S2),Plan]|RestofIntentions], [[goal(X2,Y2,S2),Plan]|RestofIntentions1]):-
    99      distance((X, Y), (X1, Y1), D_New),
   100      distance((X, Y), (X2, Y2), D_List),
   101      D_New is D_List,
   102      S1 =< S2,
   103      incorporate_goals_now(goal(X1,Y1,S1), [at(X, Y)], RestofIntentions, RestofIntentions1),!.
   104
   105  incorporate_goals_now(goal(X1,Y1,S1), [at(X, Y)], [[goal(X2,Y2,S2),Plan]|RestofIntentions], [[goal(X1,Y1,S1),[]]|RestofIntentions1]):-
   106      distance((X, Y), (X1, Y1), D_New),
   107      distance((X, Y), (X2, Y2), D_List),
   108      D_New is D_List,
   109      S1 > S2,
   110      RestofIntentions1 = [[goal(X2,Y2,S2),Plan]|RestofIntentions],!.
   111
   112
   113
   114
   115  % #########################################QUESTION 3################################################
   116
   117  % Write a Prolog procedure, select_action(Beliefs, Intentions, Intentions1, Action), which takes the agent's beliefs (a singleton
   118  % list containing a term for the agent's location) and the list of intentions, and computes an action to be taken by the agent
   119  % and the updated list of intentions.
   120  % The intention selected by the agent is the first on the list of intentions (if any). If the first action in this plan is
   121  % applicable, the agent selects this action and updates the plan to remove the selected action. If there is no associated plan
   122  % (i.e. the plan is the empty list) or the first action in the plan for the first intention is not applicable in the current state,
   123  % the agent constructs a new plan to go from its current position to the goal state and pick up the junk there (this plan will be a
   124  % list of move actions followed by a pick up action), selects the first action in this new plan, and updates the list of intentions
   125  % to incorporate the new plan (minus the selected first action).
   126  % Due to the fact that there are no obstacles in the world, the exact path the agent takes towards the goal does not matter, so
   127  % choose any convenient way of implementing this procedure. The procedure applicable is defined in gridworld.pro
   128
   129
   130  select_action([at(5, 5)], [], [], move(6, 5)). % if agent is in the middle.
   131
   132  select_action([at(X, Y)], [], [], move(Xnew, Ynew)) :- % if agent is elsewhere other than middle, move towards middle.
   133      X < 5, Xnew is X + 1, Ynew = Y;
   134      X > 5, Xnew is X - 1, Ynew = Y;
   135      Y < 5, Ynew is Y + 1, Xnew = X;
   136      Y > 5, Ynew is Y - 1, Xnew = X.
   137
   138
   139
   140
   141  % The intention selected by the agent is the first on the list of Intentions (if any). If the first action in the Plan of selected
   142  % Intention is applicable, the agent selects this action and updates the plan in Intentions to remove the selected action.
   143
   144  select_action(Beliefs, [Intentions|RestofIntentions], [[Goal, RestofActions]|RestofIntentions], Action) :-
   145      extract_goal_and_plan(Intentions, Goal, [Action|RestofActions]), % extract the first action from the list of actions in Plan.
   146      applicable(Beliefs, Action). % check whether the selected first action is an applicable action.
   147
   148  % If the first action in the Plan for the first selected intention is not applicable in the current state, the agent constructs a
   149  % new plan to go from its current position to the goal state and pick up the junk there (this plan will be a list of move actions
   150  % followed by an pick up action), selects the first action in this new plan, and updates the list of intentions to incorporate the
   151  % new plan (minus the selected first action).
   152
   153  select_action(Beliefs, [Intentions|RestofIntentions], [[Goal, NewPlan1]|RestofIntentions], Action) :-
   154      extract_goal_and_plan(Intentions, Goal, [NotApplicableAction|_]),
   155      not(applicable(Beliefs, NotApplicableAction)),
   156      new_plan(Goal, Beliefs, NewPlan),
   157      incorporate_new_plan_without_selected_action(NewPlan, NewPlan1, Action).
   158
   159  % If there is no associated plan (the plan is an empty list), the agent constructs a new plan to go from its current position to
   160  % the goal state and pick up the junk there (this plan will be a list of move actions followed by an pick up action), selects the
   161  % first action in this new plan, and updates the list of intentions to incorporate the new plan (minus the selected first action).
   162
   163  select_action(Beliefs, [[Goal, []]|RestofIntentions], [[Goal, NewPlan1]|RestofIntentions], Action) :-
   164      new_plan(Goal, Beliefs, NewPlan),
   165      extract_goal_and_plan([Goal, NewPlan], Goal, [Action|RestofActions]),
   166      incorporate_new_plan_without_selected_action(NewPlan, NewPlan1, Action).
   167
   168
   169
   170
   171  % Extract Goal and Plan from the selected Intention.
   172
   173  extract_goal_and_plan([Goal|Plan], Goal, Plan).
   174
   175  % Extracts first action from new Plan (NewPlan) and returns the new Plan without the extracted action (NewPlan1).
   176
   177  incorporate_new_plan_without_selected_action([Action|NewPlan1], NewPlan1, Action).
   178
   179
   180
   181
   182  % A list of move() actions followed by a pickup() action, depending on the agent's proximity to the goal and where it is at
   183  % (Beliefs). This is constructed to pick up the junk at the goal state, when there is no associated plan or when the first
   184  % action in the plan for first intention is not applicable in the current state.
   185
   186  new_plan(Goal, Beliefs, Plan) :-
   187      new_plan(Goal, Beliefs, [], Plan). % accumulator for partially-formed plan seeded as an empty list.
   188
   189  new_plan(goal(X, Y, _), [at(X, Y)], PartialPlan, Plan) :-
   190      reverse([pickup(X, Y)|PartialPlan], Plan).
   191
   192  new_plan(Goal, [at(X, Y)], PartialPlan, Plan) :-
   193      valid_move(X, Y, move(Xnew, Ynew)), % move only one square horizontally or vertically.
   194      right_direction(move(Xnew, Ynew), Goal, at(X, Y)), % check to see if move is in the right direction towards goal.
   195      new_plan(Goal, [at(Xnew, Ynew)], [move(Xnew, Ynew)|PartialPlan], Plan). % insert new plan into partially-formed plan.
   196
   197
   198
   199
   200  % Reverse list by adding the elements to ReversedList in reverse order to PartiallyReversedList.
   201
   202  reverse(List, ReversedList) :-       % To reverse a list of any length, simply invoke the worker predicate with the accumulator
   203      reverse(List, [], ReversedList). % seeded as an empty list.
   204
   205  reverse([], ReversedList, ReversedList). % if the list is empty, the accumulator contains the reversed list.
   206
   207  reverse([Head|Tail], PartiallyReversedList, ReversedList) :-   % if the list is not empty, we reverse the list by recursing down
   208      reverse(Tail, [Head|PartiallyReversedList], ReversedList). % with the head of the list prepended to the accumulator.
   209
   210  % Determines all the valid moves for a given X, Y coordinate.
   211
   212  valid_move(X, Y, Move) :-
   213      Dx is X + 1, Move = move(Dx, Y);
   214      Dx is X - 1, Move = move(Dx, Y);
   215      Dy is Y + 1, Move = move(X, Dy);
   216      Dy is Y - 1, Move = move(X, Dy).
   217
   218  % Heuristic function to determine if the move selected is in the right direction, where the move is closer to the goal
   219  % (goal(X,Y,S)) as compared to that of the agent's current position (Beliefs) from the goal.
   220
   221  right_direction(move(Xm, Ym), goal(Xg, Yg, _), at(X, Y)) :-
   222      distance((Xm, Ym), (Xg, Yg), D_Move_Goal),
   223      distance((X, Y), (Xg, Yg), D_Beliefs_Goal),
   224      D_Move_Goal < D_Beliefs_Goal.
   225
   226
   227
   228
   229  % #########################################QUESTION 4################################################
   230  % Write two Prolog procedures:
   231  % 1) update_beliefs(Observation, Beliefs, Beliefs1)
   232  % 2) update_intentions(Observation, Intentions, Intentions1)
   233  % Compute the lists of beliefs and intentions resulting from the agent's observations.
   234  % These are very simple procedures (one line for each possible observation type)!
   235
   236
   237  % Change value of Beliefs1 to include that of Observation value in list form.
   238  update_beliefs(Observation, Beliefs, Beliefs1) :-
   239          Observation = at(X,Y),
   240      Beliefs1 = [Observation].
   241
   242  % Ignore the cleaned() observations that is already used to clean junk, or else there will be unnecessary loops and repetition.
   243  update_beliefs(_, Beliefs, Beliefs).
   244
   245
   246
   247
   248  % Update Intentions based on Observation. Remove the goal once the junk has been cleaned, assuming that it is still the last goal
   249  % to be reached.
   250  update_intentions(cleaned(X, Y), [[goal(X, Y, _)|_]|RestofIntentions], RestofIntentions).
   251
   252  % Stop this procedure to prevent backtracking to where we have already visited.
   253  update_intentions(_, Intentions, Intentions).
   254
   255
   256
   257
   258

!!section tests
** Test 1: trigger([], [])
--------------------------------
** Test passed
--------------------------------
** Test 2: trigger([junk(1,1,1), junk(2,2,2)], Goals).
--------------------------------
** Test failed (student's output above, expected output below). Output difference:-
1c1
< Goals = [junk(1, 1, 1), junk(2, 2, 2)].
---
> Goals = [goal(1, 1, 1), goal(2, 2, 2)].
--------------------------------
** Test 3: incorporate_goals([], [at(0,0)], [[goal(1,1,1), []]], Intentions).
--------------------------------
** Test passed
--------------------------------
** Test 4: incorporate_goals([goal(7,3,8)], [at(1,1)],[[goal(8,10,4), []]], Intentions).
--------------------------------
** Test passed
--------------------------------
** Test 5: incorporate_goals([goal(0,3,6)],[at(2,2)],[[goal(3,2,8),[]],[goal(8,10,4),[]]], Intentions).
--------------------------------
** Test passed
--------------------------------
** Test 6: incorporate_goals([goal(1,1,1)],[at(3,3)],[[goal(3,2,8),[move(3,2),pickup(3,2)]],[goal(1,1,1),[]]], Intentions).
--------------------------------
** Test passed
--------------------------------
** Test 7: incorporate_goals([goal(1,2,2)],[at(2,3)],[[goal(4,3,4),[move(3,3),move(4,3),pickup(4,3)]]], Intentions).
--------------------------------
** Test passed
--------------------------------
** Test 8: incorporate_goals([goal(1,4,5)],[at(2,3)],[[goal(4,3,4),[move(3,3),move(4,3),pickup(4,3)]]], Intentions).
--------------------------------
** Test passed
--------------------------------
** Test 9: incorporate_goals([goal(0,0,4),goal(1,1,3)],[at(6,1)],[[goal(6,0,4),[move(6,0),pickup(6,0)]]], Intentions).
--------------------------------
** Test passed
--------------------------------
** Test 10: incorporate_goals([goal(3,3,4),goal(5,5,4)],[at(4,5)],[[goal(7,0,4),[]],[goal(0,0,4),[]],[goal(1,2,1),[]]], Intentions).
--------------------------------
** Test passed
--------------------------------
** Test 11: select_action([at(4,0)], [], [], move(X,Y))
--------------------------------
** Test passed
--------------------------------
** Test 12: select_action([at(4,0)],[[goal(4,0,6),[pickup(4,0)]]], Intentions, Action).
--------------------------------
** Test passed
--------------------------------
** Test 13: select_action([at(4,0)],[[goal(4,0,6),[move(4,0),pickup(4,0)]]], Intentions, Action).
--------------------------------
** Test passed
--------------------------------
** Test 14: select_action([at(0,0)],[[goal(4,0,6),[]]], Intentions, Action).
--------------------------------
** Test passed
--------------------------------
** Test 15: select_action([at(4,0)],[[goal(4,4,6),[move(4,4),pickup(4,4)]]], Intentions, Action).
--------------------------------
** Test passed
--------------------------------
** Test 16: select_action([at(2,3)],[[goal(4,4,6),[]]],[[goal(4,4,6),[move(3,4),move(4,4),pickup(4,4)]]],move(2,4)); .. move(3,3).
--------------------------------
** Test passed
--------------------------------
** Test 17: update_beliefs(at(2,2), _, Beliefs)
--------------------------------
** Test passed
--------------------------------
** Test 18: update_beliefs(cleaned(2,2), [at(2,2)], Beliefs)
--------------------------------
** Test passed
--------------------------------
** Test 19: update_intentions(at(3,4), [[goal(4,5,6), []]], Intentions).
--------------------------------
** Test passed
--------------------------------
** Test 20: update_intentions(cleaned(3,4),[[goal(3,4,5),[]],[goal(4,5,6),[]]], Intentions).
--------------------------------
** Test passed
--------------------------------
!!section assess

!!perftab       ** PERFORMANCE ANALYSIS **

Test  1 (0.5)   trigger([], [])  ..  ..  ..  ..  ..  ..  ..  ..  ..  ..  ..  ..  ..  ..  ..  ..  ..  ..  ..  ..  ..  ..  ..  ..  ..  ..  ..  !!PASSed
Test  2 (0.5)   trigger([junk(1,1,1), junk(2,2,2)], Goals).  ..  ..  ..  ..  ..  ..  ..  ..  ..  ..  ..  ..  ..  ..  ..  ..  ..  ..  ..  ..  !!FAILed (-0.5)
Test  3 (0.5)   incorporate_goals([], [at(0,0)], [[goal(1,1,1), []]], Intentions).   ..  ..  ..  ..  ..  ..  ..  ..  ..  ..  ..  ..  ..  ..  !!PASSed
Test  4 (0.5)   incorporate_goals([goal(7,3,8)], [at(1,1)],[[goal(8,10,4), []]], Intentions). .  ..  ..  ..  ..  ..  ..  ..  ..  ..  ..  ..  !!PASSed
Test  5 (0.5)   incorporate_goals([goal(0,3,6)],[at(2,2)],[[goal(3,2,8),[]],[goal(8,10,4),[]]], Intentions). ..  ..  ..  ..  ..  ..  ..  ..  !!PASSed
Test  6 (0.5)   incorporate_goals([goal(1,1,1)],[at(3,3)],[[goal(3,2,8),[move(3,2),pickup(3,2)]],[goal(1,1,1),[]]], Intentions). ..  ..  ..  !!PASSed
Test  7 (0.5)   incorporate_goals([goal(1,2,2)],[at(2,3)],[[goal(4,3,4),[move(3,3),move(4,3),pickup(4,3)]]], Intentions). .  ..  ..  ..  ..  !!PASSed
Test  8 (0.5)   incorporate_goals([goal(1,4,5)],[at(2,3)],[[goal(4,3,4),[move(3,3),move(4,3),pickup(4,3)]]], Intentions). .  ..  ..  ..  ..  !!PASSed
Test  9 (0.5)   incorporate_goals([goal(0,0,4),goal(1,1,3)],[at(6,1)],[[goal(6,0,4),[move(6,0),pickup(6,0)]]], Intentions).  ..  ..  ..  ..  !!PASSed
Test 10 (0.5)   incorporate_goals([goal(3,3,4),goal(5,5,4)],[at(4,5)],[[goal(7,0,4),[]],[goal(0,0,4),[]],[goal(1,2,1),[]]], Intentions). ..  !!PASSed
Test 11 (0.5)   select_action([at(4,0)], [], [], move(X,Y))  ..  ..  ..  ..  ..  ..  ..  ..  ..  ..  ..  ..  ..  ..  ..  ..  ..  ..  ..  ..  !!PASSed
Test 12 (0.5)   select_action([at(4,0)],[[goal(4,0,6),[pickup(4,0)]]], Intentions, Action).  ..  ..  ..  ..  ..  ..  ..  ..  ..  ..  ..  ..  !!PASSed
Test 13 (0.5)   select_action([at(4,0)],[[goal(4,0,6),[move(4,0),pickup(4,0)]]], Intentions, Action). .  ..  ..  ..  ..  ..  ..  ..  ..  ..  !!PASSed
Test 14 (0.5)   select_action([at(0,0)],[[goal(4,0,6),[]]], Intentions, Action). ..  ..  ..  ..  ..  ..  ..  ..  ..  ..  ..  ..  ..  ..  ..  !!PASSed
Test 15 (0.5)   select_action([at(4,0)],[[goal(4,4,6),[move(4,4),pickup(4,4)]]], Intentions, Action). .  ..  ..  ..  ..  ..  ..  ..  ..  ..  !!PASSed
Test 16 (0.5)   select_action([at(2,3)],[[goal(4,4,6),[]]],[[goal(4,4,6),[move(3,4),move(4,4),pickup(4,4)]]],move(2,4)); .. move(3,3).   ..  !!PASSed
Test 17 (0.25)  update_beliefs(at(2,2), _, Beliefs)  ..  ..  ..  ..  ..  ..  ..  ..  ..  ..  ..  ..  ..  ..  ..  ..  ..  ..  ..  ..  ..  ..  !!PASSed
Test 18 (0.25)  update_beliefs(cleaned(2,2), [at(2,2)], Beliefs) ..  ..  ..  ..  ..  ..  ..  ..  ..  ..  ..  ..  ..  ..  ..  ..  ..  ..  ..  !!PASSed
Test 19 (0.25)  update_intentions(at(3,4), [[goal(4,5,6), []]], Intentions). ..  ..  ..  ..  ..  ..  ..  ..  ..  ..  ..  ..  ..  ..  ..  ..  !!PASSed
Test 20 (0.25)  update_intentions(cleaned(3,4),[[goal(3,4,5),[]],[goal(4,5,6),[]]], Intentions). ..  ..  ..  ..  ..  ..  ..  ..  ..  ..  ..  !!PASSed

!!perfmark      ** TOTAL PERFORMANCE MARK:    8.5/9
                                          ^
                                          + ========== +
                                          + Good Work! +
                                          + ========== +

!!marktab       **  MARKER'S  ASSESSMENT  **

          Comments and Programming Style  (3)   3

!!finalmark     **  FINAL  ASSIGNMENT  MARK:    11.5/12

Teong, Shu Hao Ivan                     29


Marked by blair on Tue Jun  9 19:35:43 2015
