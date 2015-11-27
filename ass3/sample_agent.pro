% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% Assignment for 9414 Semester 1, 2013
%
% Team: Alexander Whillas, 3446737
%       Andrea Finno, 3393865
% 
% Assignment name: Project 3, Option 1: Prolog (BDI Agent)
%
% In this assignment we will write an implementation of the basic functions of 
% a simple BDI Agent that operates in a Gridworld.
%
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %

% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% [PART 1]
% A predicate that takes a list of events, each of the form junk(X,Y,S), and
% computes the corresponding list of goals for the agent, each of the
% form goal(X,Y,S).
% 
% trigger(+Events, -Goals).
%   Takes a list of Events, each of the form junk(X,Y,S), and computes the
%   corresponding list of Goals for the agent, each of the form goal(X,Y,S).
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %

trigger([], []).
trigger([junk(X, Y, S)|Tail], [goal(X, Y, S)|Goals]) :-
    trigger(Tail, Goals).


% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% [PART 2]
% A predicate which has four arguments:
% - a list of goals each of the form goal(X,Y,S),
% - a list of beliefs (containing one term of the form at(X,Y)),
% - the current list of intentions each of the form [goal(X,Y,S), Plan],
% - a list to be computed which contains the new goals inserted into the
%   current list of intentions in decreasing order of value, using the distance
%   from the agent to break ties.
%
% A new goal will be placed immediately before the first goal in the list that
% has a lower value or which has an equal value and is further away from the
% agent's current position, without reordering the current list of goals.
% 
% incorporate_goals(+Goals, +Beliefs, +Intentions, -Intentions1).
%   Takes Goals list and inserts only the new goals into the Intentions list
%   immediately before an intention with a goal of a lower value. By lower value
%   first, the Score is compared with the Manhattan distance if the scores are
%   the same. The plan associated with each new goal is the empty plan.
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %

% Base case, no more Goals.
incorporate_goals([], _, Intentions, Intentions).

% Goal is already in the Intentions list so skip it.
incorporate_goals([Goal|Tail], Belief, Intentions, Intentions1) :-
    is_member(Goal, Intentions),
    incorporate_goals(Tail, Belief, Intentions, Intentions1).

% We only insert if its not already in the Intentions list.
incorporate_goals([Goal|Tail], Belief, Intentions, Intentions1) :-
    not(is_member(Goal, Intentions)),
    insert_goal(Goal, Intentions, Belief, UpdatedIntentions),
    incorporate_goals(Tail, Belief, UpdatedIntentions, Intentions1).

% insert_goal(+Goal, +Intentions, +Belief, -Intentions1).
%   Insert the Goal, as an Intention (i.e. [goal, plan]), into the Intentions
%   list before the Plan with a goal less than it (not greater than for
%   decending order).

insert_goal(Goal, [Intent|Intentions], Belief, [Intent|Intentions1]):-
    not(gtp(Goal, Intent, Belief)), !, 
    insert_goal(Goal, Intentions, Belief, Intentions1).

insert_goal(X, Intentions, _, [[X, []]|Intentions]).

% is_member(+Goal, +Intentions).
%   Check weather a given Goal is in the Intentions list. Each item in the
%   Intentions list is a two member list of the format [Goal, Plan]. The Plan
%   is a list of actions.

is_member(Goal, [Head|_]) :-
    member(Goal, Head).

is_member(Goal, [Head|Tail]) :-
    not(member(Goal, Head)),
	is_member(Goal, Tail).

% gtp(+Goal, +Plan, -Belief).
%   Goal is greater-than Plan (i.e. Goal1 > [Goal2|_]). The Goal is compared to
%   the Goal in the head of the Plan list and is greater if the Score (3rd
%   param of Goal) is greater, or if values of Score are equal, the one with
%   the shortest distance to the Belief.
%   Note: The greater-than signs have been reversed as we want the list in 
%   decending order.

% Compare scores.
gtp(goal(X1, Y1, S1), [goal(X2, Y2, S2)|_], [at(X, Y)|_]) :-
    distance((X, Y), (X1, Y1), D1),
    distance((X, Y), (X2, Y2), D2),
    D1 < D2.

% Compare distances to Belief.
gtp(goal(X1, Y1, S1), [goal(X2, Y2, S2)|_], [at(X, Y)|_]) :-
    distance((X, Y), (X1, Y1), D1),
    distance((X, Y), (X2, Y2), D2),
    D1 == D2,
    S1 > S2.


% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% [PART 3]
% A predicate which takes the agent's beliefs and the list of intentions,
% and computes an action to be taken by the agent and the updated list
% of intentions.
% 
% select_action(+Beliefs, +Intentions, -Intentions, -Action).
%   Selects the next action for the agent to perform from the list of
%   Intentions. If there are none, then it moves in the Y direction by 1 (just
%   as good as random?).
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %

% If the intentions are empty move towards the middle (5,5) and two-step.
select_action([at(5, 5)], [], [], move(6, 5)).
select_action([at(X, Y)], [], [], move(Xnew, Ynew)) :-
    X < 5, Xnew is X + 1, Ynew = Y;
    X > 5, Xnew is X - 1, Ynew = Y;
    Y < 5, Ynew is Y + 1, Xnew = X;
    Y > 5, Ynew is Y - 1, Xnew = X.

% If the Action is good, use it and update the Intentions list ...
select_action(Beliefs, [Intent|Tail], [[Goal, NextActions]|Tail], Action) :-
    decompose_intention(Intent, Goal, [Action|NextActions]),
    applicable(Beliefs, Action).

% ... otherwise Action is not applicable so create a new Plan for the Goal.
select_action(Beliefs, [Intent|Tail], [[Goal, Plan]|Tail], Action) :-
    decompose_intention(Intent, Goal, [BadAction|_]),
    not(applicable(Beliefs, BadAction)),
    new_plan(Goal, Beliefs, NewPlan),
    next_action(NewPlan, Plan, Action).

% next_action(+ExistingPlan, -Plan, -Action).
%   Pops the first Action off ExistingPlan and returns the Plan without it
%   and the first Action.

next_action([Action|Plan], Plan, Action).

% decompose_intention(+Intention, -Goal, -Plan).
%   Extract Goal and Plan from Intention.

decompose_intention([Goal|Plan], Goal, Plan).

% new_plan(+Goal, +Beliefs, -Plan).
%   Generate a list of move() actions ending with a pickup() action based on
%   where the robot is at() currently.

new_plan(Goal, Beliefs, Plan) :-
    new_plan(Goal, Beliefs, [], Plan).

new_plan(goal(X, Y, _), [at(X, Y)], PartialPlan, Plan) :-
    reverse([pickup(X, Y)|PartialPlan], Plan).

new_plan(Goal, [at(X, Y)], PartialPlan, Plan) :-
    valid_move(X, Y, move(Xnew, Ynew)),
    h(move(Xnew, Ynew), Goal, at(X, Y)),
    new_plan(Goal, [at(Xnew, Ynew)], [move(Xnew, Ynew)|PartialPlan], Plan).

% h(+Move, +Goal, +Belief).
%   Heuristic function to determine weather a Move is in the right direction
%   or not. Since the move distance can only be 1 or -1 this is more or
%   less boolean. More specifically, move has to be closer to the Goal than
%   current robot position.

h(move(X, Y), goal(Xg, Yg, _), at(Xr, Yr)) :-
    distance((X, Y), (Xg, Yg), Dm),
    distance((Xr, Yr), (Xg, Yg), Dr),
    Dm < Dr.

% valid_move(+X, +Y, -Move).
%   Determine all valid moves for a given X, Y coordinate.

valid_move(X, Y, Move) :-
    Dx is X + 1, Move = move(Dx, Y);
    Dx is X - 1, Move = move(Dx, Y);
    Dy is Y + 1, Move = move(X, Dy);
    Dy is Y - 1, Move = move(X, Dy).

% reverse(+List, -Reverse).
% reverse(+List, ?PartReversed, -Reversed).
%   Reversed is obtained by adding the elements of List in reverse order
%   to PartReversed. (See Bratko, 3rd Ed. p.188)

reverse(List, Reversed) :-
    reverse(List, [], Reversed).

reverse([], Reversed, Reversed).

reverse([X|Rest], PartReversed, TotalReversed) :-
    reverse(Rest, [X|PartReversed], TotalReversed).


% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% [PART 4]
% Two predicates, update_beliefs and update_intentions that will compute the
% lists of beliefs and intentions resulting from the agent's observations.
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %

% update_beliefs(+Observation, @Beliefs, -Beliefs1).
%   Update robots Beliefs based on Observations. Replace the old at()
%   with the new at().

update_beliefs(at(X, Y), _, [at(X,Y)]).

% ignore cleaned() observations.
update_beliefs(_, Beliefs, Beliefs).


% update_intentions(+Observation, +Intentions, -Intentions1).
%   Update intentions based on Observations. Remove the goal once the junk has
%   been cleaned. Assuming its still the last goal to have been reached.

update_intentions(cleaned(X, Y), [[goal(X, Y, _)|_]|Intentions1], Intentions1).

% catch the rest to stop backtracking.
update_intentions(_, Intentions, Intentions).