
% Recursive case where we check to see whether the goal is a new goal: This is not a new goal,
% as it is already a member of the list of goals in list Intentions. Continue checking the rest
% of the goals by calling incorporate_goals again recursively.
incorporate_goals([goal(X,Y,S)|RestofGoals], Beliefs, Intentions, Intentions1) :-
	member([goal(X,Y,S),_], Intentions),
	incorporate_goals(Rest0fGoals, Beliefs, Intentions, Intentions1),!.

% Recursive case where we check to see whether the goal is a new goal: This is a new goal, as it is not a
% member of Intentions, so continue insertion into Intentions by calling incorporate_goals_now first to check 
% the conditions before incorporating this goal into Intentions continuously and checking the other goals recursively.
incorporate_goals([goal(X,Y,S)|RestofGoals], Beliefs, Intentions, Intentions1) :-
	not(member([goal(X,Y,S),_], Intentions)),
	incorporate_goals_now(goal(X,Y,S), Beliefs, Intentions, UpdateIntentions),
	incorporate_goals(RestofGoals, Beliefs, UpdateIntentions, Intentions1),!.


% Recursive case where we check whether the new goal's distance from agent's current position (Beliefs) is lesser
% than the 1st goal in the list Goals. If it is, then put it before the 1st goal in Intentions1.
incorporate_goals_now(goal(X,Y,S), [at(A,B)], [[goal(X1,Y1,S1),_]|RestofIntentions], [[goal(X,Y,S),_],[goal(X1,Y1,S1),_]|RestofIntentions]) :-
	distance((X,Y), (A,B), D_CurrentGoal),
	distance((X1,Y1), (A,B), D_1stGoalList),
	D_CurrentGoal < D_1stGoalList,!.

% Check whether the new goal's distance from agent's current position (Beliefs) is more than
% the 1st goal in the list Goals. If it is, then ignore this goal in Intentions (not inserting it into Intentions1) and call 
% incorporate_goals_now again to compare new goals with rest of Intentions.
incorporate_goals_now(goal(X,Y,S), [at(A,B)], [[goal(X1,Y1,S1),_]|RestofIntentions], [[goal(X1,Y1,S1),_]|RestofIntentions1] :-
	distance((X,Y), (A,B), D_CurrentGoal),
	distance((X1,Y1), (A,B), D_1stGoalList),
	D_CurrentGoal > D_1stGoalList,
	incorporate_goals_now(goal(X,Y,S), [at(A,B)], RestofIntentions, RestofIntentions1).




% Check whether the new goal's distance from agent's current position (Beliefs) is equal to
% the 1st goal in the list Goals. If it is, then check whether its value is higher than that
% of the 1st goal in the list Goals. If it is, then put it before the 1st goal.
incorporate_goals_now(goal(X,Y,S), [at(A,B)], [[goal(X1,Y1,S1),_]|RestofIntentions], [[goal(X,Y,S),_],[goal(X1,Y1,S1),_]|RestofIntentions]) :-
	distance((X,Y), (A,B), D_CurrentGoal),
	distance((X1,Y1), (A,B), D_1stGoalList),
	D_CurrentGoal = D_1stGoalList,
	S > S1,!.

% Check whether the new goal's distance from agent's current position (Beliefs) is equal to
% the 1st goal in the list Goals. If it is, then check whether its value is lower than that
% of the 1st goal in the list Goals. If it is, then ignore this goal in Intentions (not inserting it into Intentions1) and call 
% incorporate_goals_now again to compare new goals with rest of Intentions.
incorporate_goals_now(goal(X,Y,S), [at(A,B)], [[goal(X1,Y1,S1),_]|RestofIntentions], [[goal(X1,Y1,S1),_]|RestofIntentions1] :-
	distance((X,Y), (A,B), D_CurrentGoal),
	distance((X1,Y1), (A,B), D_1stGoalList),
	D_CurrentGoal = D_1stGoalList,
	S < S1,
	incorporate_goals_now(goal(X,Y,S), [at(A,B)], RestofIntentions, RestofIntentions1).