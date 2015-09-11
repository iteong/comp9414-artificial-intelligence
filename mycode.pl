% Program:  mycode.pl
% Source:   Prolog
%
% Purpose:  This is the Assignment 1 program of COMP9414 where we write Prolog
%           procedures to perform some list and tree operations.
%
% Type:     Assignment 1 - Prolog Programming
%
% Written:  Shu Hao Ivan Teong z3386180



% QUESTION 1:
% sumsq_div3or5(Numbers, Sum) :- Sums squares of only numbers divisible by 5
% or by 3, in a list of (positive or negative) whole numbers

% Using higher-order predicates and defined predicates of div and sqr in
% list with more than one element, first we filter numbers in list Numbers
% that is divisible by 3 and 5 using the include function into list L3 and
% list L5, as well as our defined predicate div, then merge the 2 lists into
% LF using append function. Then utilise the map function to square all the
% elements in list LF using our defined predicate which is sqr into list LF2, 
% then add all the elements in list LF2 using the sumlist function 

sumsq_div3or5(Numbers, Sum) :-
    include(div(3), Numbers, L3),
    include(div(5), Numbers, L5),
    append(L3, L5, LF),
    maplist(sqr, LF, LF2),
    sumlist(LF2, Sum).

div(N,M) :-
    0 is M mod N.

sqr(X,Y) :-
    Y is X * X.



% QUESTION 2:
% same_name(Person1, Person2) :- Both persons are sharing the same family name
%

% Person1 and Person2 have the same father
same_name(Person1, Person2) :-
    parent(Parent, Person1),
    parent(Parent, Person2),
    male(Parent),
    Person1 \= Person2.

% Person1 is the father of Person2
same_name(Person1, Person2) :-
    parent(Person1, Person2),
    male(Person1),
    Person1 \= Person2.

% Person2 is the father of Person1
same_name(Person1, Person2) :-
    parent(Person2, Person1),
    male(Person2),
    Person1 \= Person2.

% Person1 is the father of X, who
% is the father of Person2 
same_name(Person1, Person2) :-
    parent(Person1, X),
    parent(X, Person2),
    male(Person1),
    male(X),
    Person1 \= Person2.

% Person2 is the father of X, who
% is the father of Person1
same_name(Person1, Person2) :-
    parent(Person2, X),
    parent(X, Person1),
    male(Person2),
    male(X),
    Person1 \= Person2.



% QUESTION 3:
% log_table(NumberList, ResultList) :- Binds ResultList to the list of pairs
% consisting of a number and its log, for each number in NumberList.

log_table(NumberList, ResultList) :-
    maplist(lg, NumberList, LoggedList),
    pair(NumberList, LoggedList, ResultList).

% Terminating conditions for pairing empty lists
pair([], [H|T], [H|T]).

pair(List, [], List).

% Recursive step for pairing non-empty lists
pair([H1|T1], [H2|T2], [[H1,H2]|T]) :-
    pair(T1,T2,T).

% Defining a predicate for logged numbers to be used
lg(X,Y) :-
    Y is log(X).



% QUESTION 4:
% runs(List, RunList) :- Write a predicate runs(List, RunList) that converts a
% list of numbers into the corresponding list of runs.


% Uses a cut to output an empty list if List is an empty list and stop it from
% backtracking
runs([], []):-!.

% For the list with more than 1 element, get the tail T of the list and put it
% into list T1, and then use the defined predicate ins to combine the head
% and the tail of the list into RunList output in the format and constraints
% created in the ins predicate recursively
runs([H|T], RunList):-
    runs(T, T1),
    ins(H, T1, RunList).

% Uses cut to stop the program from backtracking if head is variable A, tail is
% an empty list, and RunList output will be the variable A placed inside an 
% empty list in the list
ins(A, [], [[A]]):-!.

% Combine the elements of the list into a sublist as long as the next element in
% the list is bigger than the first element in the sublist, otherwise create a
% new sublist after the initial sublist recursively in the list
ins(A, [[H|T]|T2], [[A, H|T]|T2]):-
    H >= A, !.
ins(A, T2, [[A]|T2])


% QUESTION 5:
% tree_eval(Value, Tree, Eval) :- Write a predicate tree_eval(Value, Tree, Eval)% that binds Eval to the result of evaluating the expression-tree Tree, with the% variable z set equal to the specified Value.

% When there is a number in the middle of the tree at a node that is a leaf,
% retain the numerical value and let Value be anonymous variable with no 
% name, unifies to anything without any effect and be a singleton variable
tree_eval(_Num, tree(empty,X,empty), Eval) :- 
    number(X),
    Eval is X.

% When there is a variable in the middle of the tree at a node that is a leaf,
% change the variable z into the value X inputted by the user.
tree_eval(Num, tree(empty,X,empty), Eval) :- 
    X=z, 
    Eval is Num. 

% General case for recursive branches of binary tree
tree_eval(Value, tree(tree(LL,LOp,LR),Op,tree(RL,ROp,RR)), Eval) :-
    tree_eval(Value, tree(LL,LOp,LR), LEval),
    tree_eval(Value, tree(RL,ROp,RR), REval),
    Expr=..[Op,LEval,REval],
    Eval is Expr.


parent(jim, brian).
parent(brian, jenny).
parent(pat, brian).
female(pat).
female(jenny).
male(jim).
male(brian).



