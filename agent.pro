% COMP9414 Assignment for Semester 2, 2015
%
% Done by: Ivan Teong (z3386180)
%          hw3group Number: 29
% 
% Assignment Name: Project 3, Option 1: Prolog (BDI Agent)
%
% In this assignment, you will implement the basic functions of a simple BDI Agent that operates in a Gridworld, 
% and by doing so, learn about the ideas underlying BDI agents.

% ########################################QUESTION 1#################################################

% Write a Prolog procedure trigger(Events, Goals) which takes a list of events, each of the form junk(X,Y,S), 
% and computes the corresponding list of goals for the agent, each of the form goal(X,Y,S).


% When calling copy, works its way down to the base case, setting Goals to an empty list.
% Then works itself back up and keeps appending the head H of known list [H|T1] to the
% beginning of variable list [H|T2], continuing until the original case is reached, where
% the list Goals will contain a full copy of the list Events:

copy(Events, Goals) :- trigger(Events, Goals).

% Base case sets the copy list to empty when original list is empty:

trigger([],[]) :-!.

% Recursive case takes H from list Events and add it to the head of list Goals:

trigger([H|T1], [H|T2]) :-
	trigger(T1, T2).




% #########################################QUESTION 2################################################

% Write a Prolog procedure: incorporate_goals(Goals, Beliefs, Intentions, Intentions1).
% There are four arguments: 
% 1) a list of goals each of the form goal(X,Y,S)
% 2) a list of beliefs (containing one term of the form at(X,Y))
% 3) the current list of intentions each of the form [goal(X,Y,S), Plan]
% 4) a list to be computed which contains the new goals inserted into the current list of intentions in increasing
%    order of distance, using the value of the item to break ties. More precisely, a new goal should be placed immediately 
%    before the first goal in the list that is further away from the agent's current position, or which is at the same distance
%    from the agent but of lower value, without reordering the current list of goals.
% Note that because of repeated perception of the same event, only new goals should be inserted into the list of intentions. The
% plan associated with each new goal should be the empty plan (represented as the empty list).


% Base case when there is no more goals in list Goals, when recursion has been completed after
% going through all the goals.

incorporate_goals([], _, Intentions, Intentions) :-!.




% Recursive case where we check to see whether the goal is a new goal: This is not a new goal,
% as it is already a member of the list of goals in list Intentions. Continue checking the rest
% of the goals by calling incorporate_goals again recursively.

incorporate_goals([goal(X,Y,S)|RestofGoals], Beliefs, Intentions, Intentions1) :-
    member([goal(X,Y,S),_], Intentions),
    incorporate_goals(RestofGoals, Beliefs, Intentions, Intentions1),!.

% Recursive case where we check to see whether the goal is a new goal: This is a new goal, as it is not a
% member of Intentions, so continue insertion into Intentions by calling incorporate_goals_now first to check 
% the conditions before incorporating this goal into Intentions continuously and checking the other goals recursively.

incorporate_goals([goal(X,Y,S)|RestofGoals], Beliefs, Intentions, Intentions1) :-
    incorporate_goals_now(goal(X,Y,S), Beliefs, Intentions, UpdateIntentions), % insert goals into correct position based on conditions.
    incorporate_goals(RestofGoals, Beliefs, UpdateIntentions, Intentions1). % update Intentions for main function and check other goals.




% Insert the new goal (with shorter distance to Beliefs or if equal, a higher value) in Intentions format (Goal with Plan)
% into Intentions before the intentions with a longer distance to Beliefs or if equal, a lower value. Intentions should
% be from shortest to longest distance from Beliefs from left to right, or in descending order based on highest value to
% lowest value for those with same distance to Beliefs.

% Base case when it is a new goal, and the plan will be empty represented by empty list.
incorporate_goals_now(goal(X,Y,S), _, [], [[goal(X,Y,S), []]]) :-!.

incorporate_goals_now(goal(X1,Y1,S1), [at(X, Y)], [[goal(X2,Y2,S2),Plan]|RestofIntentions], [[goal(X2,Y2,S2),Plan]|RestofIntentions1]):-
    distance((X, Y), (X1, Y1), D_New),
    distance((X, Y), (X2, Y2), D_List),
    D_New > D_List,
    incorporate_goals_now(goal(X1,Y1,S1), [at(X, Y)], RestofIntentions, RestofIntentions1),!.

incorporate_goals_now(goal(X1,Y1,S1), [at(X, Y)], [[goal(X2,Y2,S2),Plan]|RestofIntentions], [[goal(X1,Y1,S1),[]]|RestofIntentions1]):-
    distance((X, Y), (X1, Y1), D_New),
    distance((X, Y), (X2, Y2), D_List),
    D_New < D_List,
    RestofIntentions1 = [[goal(X2,Y2,S2),Plan]|RestofIntentions],!.

incorporate_goals_now(goal(X1,Y1,S1), [at(X, Y)], [[goal(X2,Y2,S2),Plan]|RestofIntentions], [[goal(X2,Y2,S2),Plan]|RestofIntentions1]):-
    distance((X, Y), (X1, Y1), D_New),
    distance((X, Y), (X2, Y2), D_List),
    D_New is D_List,
    S1 =< S2,
    incorporate_goals_now(goal(X1,Y1,S1), [at(X, Y)], RestofIntentions, RestofIntentions1),!.

incorporate_goals_now(goal(X1,Y1,S1), [at(X, Y)], [[goal(X2,Y2,S2),Plan]|RestofIntentions], [[goal(X1,Y1,S1),[]]|RestofIntentions1]):-
    distance((X, Y), (X1, Y1), D_New),
    distance((X, Y), (X2, Y2), D_List),
    D_New is D_List,
    S1 > S2,
    RestofIntentions1 = [[goal(X2,Y2,S2),Plan]|RestofIntentions],!.




% #########################################QUESTION 3################################################

% Write a Prolog procedure, select_action(Beliefs, Intentions, Intentions1, Action), which takes the agent's beliefs (a singleton
% list containing a term for the agent's location) and the list of intentions, and computes an action to be taken by the agent 
% and the updated list of intentions.
% The intention selected by the agent is the first on the list of intentions (if any). If the first action in this plan is 
% applicable, the agent selects this action and updates the plan to remove the selected action. If there is no associated plan 
% (i.e. the plan is the empty list) or the first action in the plan for the first intention is not applicable in the current state, 
% the agent constructs a new plan to go from its current position to the goal state and pick up the junk there (this plan will be a 
% list of move actions followed by a pick up action), selects the first action in this new plan, and updates the list of intentions 
% to incorporate the new plan (minus the selected first action). 
% Due to the fact that there are no obstacles in the world, the exact path the agent takes towards the goal does not matter, so 
% choose any convenient way of implementing this procedure. The procedure applicable is defined in gridworld.pro


select_action([at(5, 5)], [], [], move(6, 5)). % if agent is in the middle.

select_action([at(X, Y)], [], [], move(Xnew, Ynew)) :- % if agent is elsewhere other than middle, move towards middle.
    X < 5, Xnew is X + 1, Ynew = Y;
    X > 5, Xnew is X - 1, Ynew = Y;
    Y < 5, Ynew is Y + 1, Xnew = X;
    Y > 5, Ynew is Y - 1, Xnew = X.




% The intention selected by the agent is the first on the list of Intentions (if any). If the first action in the Plan of selected
% Intention is applicable, the agent selects this action and updates the plan in Intentions to remove the selected action.

select_action(Beliefs, [Intentions|RestofIntentions], [[Goal, RestofActions]|RestofIntentions], Action) :-
    extract_goal_and_plan(Intentions, Goal, [Action|RestofActions]), % extract the first action from the list of actions in Plan.
    applicable(Beliefs, Action). % check whether the selected first action is an applicable action.

% If the first action in the Plan for the first selected intention is not applicable in the current state, the agent constructs a 
% new plan to go from its current position to the goal state and pick up the junk there (this plan will be a list of move actions
% followed by an pick up action), selects the first action in this new plan, and updates the list of intentions to incorporate the
% new plan (minus the selected first action).

select_action(Beliefs, [Intentions|RestofIntentions], [[Goal, NewPlan1]|RestofIntentions], Action) :-
    extract_goal_and_plan(Intentions, Goal, [NotApplicableAction|_]),
    not(applicable(Beliefs, NotApplicableAction)),
    new_plan(Goal, Beliefs, NewPlan),
    incorporate_new_plan_without_selected_action(NewPlan, NewPlan1, Action).

% If there is no associated plan (the plan is an empty list), the agent constructs a new plan to go from its current position to 
% the goal state and pick up the junk there (this plan will be a list of move actions followed by an pick up action), selects the 
% first action in this new plan, and updates the list of intentions to incorporate the new plan (minus the selected first action).

select_action(Beliefs, [[Goal, []]|RestofIntentions], [[Goal, NewPlan1]|RestofIntentions], Action) :-
    new_plan(Goal, Beliefs, NewPlan),
    extract_goal_and_plan([Goal, NewPlan], Goal, [Action|RestofActions]),
    incorporate_new_plan_without_selected_action(NewPlan, NewPlan1, Action).




% Extract Goal and Plan from the selected Intention.

extract_goal_and_plan([Goal|Plan], Goal, Plan).

% Extracts first action from new Plan (NewPlan) and returns the new Plan without the extracted action (NewPlan1).

incorporate_new_plan_without_selected_action([Action|NewPlan1], NewPlan1, Action).




% A list of move() actions followed by a pickup() action, depending on the agent's proximity to the goal and where it is at 
% (Beliefs). This is constructed to pick up the junk at the goal state, when there is no associated plan or when the first 
% action in the plan for first intention is not applicable in the current state.

new_plan(Goal, Beliefs, Plan) :-
    new_plan(Goal, Beliefs, [], Plan). % accumulator for partially-formed plan seeded as an empty list.

new_plan(goal(X, Y, _), [at(X, Y)], PartialPlan, Plan) :-
    reverse([pickup(X, Y)|PartialPlan], Plan).

new_plan(Goal, [at(X, Y)], PartialPlan, Plan) :-
    valid_move(X, Y, move(Xnew, Ynew)), % move only one square horizontally or vertically.
    right_direction(move(Xnew, Ynew), Goal, at(X, Y)), % check to see if move is in the right direction towards goal.
    new_plan(Goal, [at(Xnew, Ynew)], [move(Xnew, Ynew)|PartialPlan], Plan). % insert new plan into partially-formed plan.




% Reverse list by adding the elements to ReversedList in reverse order to PartiallyReversedList.

reverse(List, ReversedList) :-       % To reverse a list of any length, simply invoke the worker predicate with the accumulator
    reverse(List, [], ReversedList). % seeded as an empty list.

reverse([], ReversedList, ReversedList). % if the list is empty, the accumulator contains the reversed list.

reverse([Head|Tail], PartiallyReversedList, ReversedList) :-   % if the list is not empty, we reverse the list by recursing down 
    reverse(Tail, [Head|PartiallyReversedList], ReversedList). % with the head of the list prepended to the accumulator.

% Determines all the valid moves for a given X, Y coordinate.

valid_move(X, Y, Move) :-
    Dx is X + 1, Move = move(Dx, Y);
    Dx is X - 1, Move = move(Dx, Y);
    Dy is Y + 1, Move = move(X, Dy);
    Dy is Y - 1, Move = move(X, Dy).

% Heuristic function to determine if the move selected is in the right direction, where the move is closer to the goal 
% (goal(X,Y,S)) as compared to that of the agent's current position (Beliefs) from the goal.

right_direction(move(Xm, Ym), goal(Xg, Yg, _), at(X, Y)) :-
    distance((Xm, Ym), (Xg, Yg), D_Move_Goal),
    distance((X, Y), (Xg, Yg), D_Beliefs_Goal),
    D_Move_Goal < D_Beliefs_Goal.




% #########################################QUESTION 4################################################
% Write two Prolog procedures:
% 1) update_beliefs(Observation, Beliefs, Beliefs1)
% 2) update_intentions(Observation, Intentions, Intentions1)
% Compute the lists of beliefs and intentions resulting from the agent's observations.
% These are very simple procedures (one line for each possible observation type)!


% Change value of Beliefs1 to include that of Observation value in list form.
update_beliefs(Observation, Beliefs, Beliefs1) :-
	Observation = at(X,Y),
    Beliefs1 = [Observation].

% Ignore the cleaned() observations that is already used to clean junk, or else there will be unnecessary loops and repetition.
update_beliefs(_, Beliefs, Beliefs).




% Update Intentions based on Observation. Remove the goal once the junk has been cleaned, assuming that it is still the last goal
% to be reached.
update_intentions(cleaned(X, Y), [[goal(X, Y, _)|_]|RestofIntentions], RestofIntentions).

% Stop this procedure to prevent backtracking to where we have already visited.
update_intentions(_, Intentions, Intentions).





