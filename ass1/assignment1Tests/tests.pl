sumsq_div3or5_tests :-
    not(sumsq_div3or5([], 0)),
    write('Failed sumsq_div3or5([], 0)'), nl.
sumsq_div3or5_tests :-
    not(sumsq_div3or5([0], 0)),
    write('Failed sumsq_div3or5([0], 0)'), nl.
sumsq_div3or5_tests :-
    sumsq_div3or5(0, 0),
    write('Failed sumsq_div3or5(0, 0) - did not return false on incorrect input'), nl.
sumsq_div3or5_tests :-
    not(sumsq_div3or5([1], 0)),
    write('Failed sumsq_div3or5([1], 0)'), nl.
sumsq_div3or5_tests :-
    not(sumsq_div3or5([3], 9)),
    write('Failed sumsq_div3or5([3], 9)'), nl.
sumsq_div3or5_tests :-
    not(sumsq_div3or5([5], 25)),
    write('Failed sumsq_div3or5([5], 25)'), nl.
sumsq_div3or5_tests :-
    not(sumsq_div3or5([1, 2, 3], 9)),
    write('Failed sumsq_div3or5([1, 2, 3], 9)'), nl.
sumsq_div3or5_tests :-
    not(sumsq_div3or5([3, 6, 9], 126)),
    write('Failed sumsq_div3or5([3, 6, 9], 126)'), nl.
sumsq_div3or5_tests :-
    not(sumsq_div3or5([3, 5, 6, 10, 11], 170)),
    write('Failed sumsq_div3or5([3, 5, 6, 10, 11], 170)'), nl.
sumsq_div3or5_tests :-
    not(sumsq_div3or5([1, 3, 5, 2, 4, 6, 8, 7, 12], 214)),
    write('Failed sumsq_div3or5([1, 3, 5, 2, 4, 6, 8, 7, 12], 214)'), nl.
sumsq_div3or5_tests :-
    not(sumsq_div3or5([5, 4, 3, 2, 1], 34)),
    write('Failed sumsq_div3or5([5, 4, 3, 2, 1], 34)'), nl.
sumsq_div3or5_tests :-
    not(sumsq_div3or5([1, 1, 2, 2, 3, 3, 4, 4, 5, 5], 68)),
    write('Failed sumsq_div3or5([1, 1, 2, 2, 3, 3, 4, 4, 5, 5], 68)'), nl.
sumsq_div3or5_tests :-
    write('sumsq_div3or5 tests passed'), nl, nl.

same_name_tests :-
    same_name(pat, brian),
    write('Failed same_name(pat, brian) - returned true'), nl.
same_name_tests :-
    not(same_name(jenny, jim)),
    write('Failed same_name(jenny, jim) - returned false'), nl.
same_name_tests :-
    not(same_name(mA1, mA1)),
    write('Failed same_name(mA1, mA1) - returned false'), nl.
same_name_tests :-
    not(same_name(wA1, wA1)),
    write('Failed same_name(wA1, wA1) - returned false'), nl.
same_name_tests :-
    write('basic same_name tests passed'), nl, nl.

log_table_tests :-
    not(log_table([], [])), % not sure if this is correct
    write('Failed log_table([], [])'), nl.
log_table_tests :-
    log_table(1, [1, 0.0]),
    write('Failed log_table(1, [1, 0.0]) - did not return false on incorrect input'), nl.
log_table_tests :-
    not(log_table([1], [[1, 0.0]])),
    write('Failed log_table([1], [[1, 0.0]])'), nl.
log_table_tests :-
    not(log_table([1, 2], [[1, 0.0], [2, 0.6931471805599453]])),
    write('Failed log_table([1, 2], [[1, 0.0], [2, 0.6931471805599453]])'), nl.
log_table_tests :-
    not(log_table([1, 2, 3, 2, 1], [[1, 0.0], [2, 0.6931471805599453], [3, 1.0986122886681098], [2, 0.6931471805599453], [1, 0.0]])),
    write('Failed log_table([1, 2, 3, 2, 1], [[1, 0.0], [2, 0.6931471805599453], [3, 1.09861229], [2, 0.6931471805599453], [1, 0.0]])'), nl.
log_table_tests :-
    write('log_table tests passed'), nl, nl.

runs_tests :-
    not(runs([], [])), % not sure if this is correct
    write('Failed runs([], [])'), nl.
runs_tests :-
    not(runs([1], [[1]])), 
    write('Failed runs([1], [[1]])'), nl.
runs_tests :-
    not(runs([1, 2], [[1, 2]])),
    write('Failed runs([1, 2], [[1, 2]])'), nl.
runs_tests :-
    not(runs([1, 2, 1], [[1, 2], [1]])),
    write('Failed runs([1, 2, 1], [[1, 2], [1]])'), nl.
runs_tests :-
    not(runs([1, 1, 2, 2, 1, 1], [[1, 1, 2, 2], [1, 1]])),
    write('Failed runs([1, 1, 2, 2, 1, 1], [[1, 1, 2, 2], [1, 1]])'), nl.
runs_tests :-
    not(runs([5, 4, 3, 2, 1], [[5], [4], [3], [2], [1]])),
    write('Failed runs([5, 4, 3, 2, 1], [[5], [4], [3], [2], [1]])'), nl.
runs_tests :-
    not(runs([-1, 0, 1, 0, 0, -1], [[-1, 0, 1], [0, 0], [-1]])),
    write('Failed runs([-1, 0, 1, 0, 0, -1], [[-1, 0, 1], [0, 0], [-1]])'), nl.
runs_tests :-
    not(runs([3,4,5,4,2,7,5,6,6,8,3], [[3, 4, 5], [4], [2, 7], [5, 6, 6, 8], [3]])),
    write('Failed runs([3,4,5,4,2,7,5,6,6,8,3], [[3, 4, 5], [4], [2, 7], [5, 6, 6, 8], [3]])'), nl.
runs_tests :-
    write('runs tests passed'), nl, nl.

tree_eval_tests :-
    not(tree_eval(0, tree(empty, z, empty), 0)),
    write('Failed: tree_eval(0, tree, 0)'), nl, 
    write('tree:       z'), nl.
tree_eval_tests :-
    not(tree_eval(100, tree(empty, 2, empty), 2)),
    write('Failed: tree_eval(100, tree, 2)'), nl, 
    write('tree:       2'), nl.
tree_eval_tests :-
    not(tree_eval(100, tree(tree(empty, 4, empty), '+', tree(empty, 6, empty)), 10)),
    write('Failed: tree_eval(100, tree, 10)'), nl, 
    write('tree:       +'), nl,
    write('           / \\'), nl,
    write('          4   6'), nl.
tree_eval_tests :-
    not(tree_eval(3, tree(tree(empty, z, empty), '*', tree(empty, z, empty)), 9)),
    write('Failed: tree_eval(3, tree, 9'), nl, 
    write('tree:       *'), nl,
    write('           / \\'), nl,
    write('          z   z'), nl.
tree_eval_tests :-
    not(tree_eval(5, tree(tree(tree(empty, 10, empty), '-', tree(empty, z, empty)), '+', tree(empty, 6, empty)), 11)),
    write('Failed: tree_eval(5, tree, 5)'), nl, 
    write('tree:       +'), nl,
    write('           / \\'), nl,
    write('          -   6'), nl,
    write('         / \\'), nl,
    write('        10  z'), nl.
tree_eval_tests :-
    not(tree_eval(2, tree(tree(empty,z,empty), '+',tree(tree(empty,1,empty), '/',tree(empty,z,empty))), 2.5)),
    write('Failed: tree_eval(2, tree, 2.5)'), nl,
    write('tree:       +'), nl,
    write('           / \\'), nl,
    write('          z   /'), nl,
    write('             / \\'), nl,
    write('            1   z'), nl.
tree_eval_tests :-
    not(tree_eval(1, tree(tree(empty,z,empty), '+', tree(tree(empty, z, empty), '-', tree(empty, z, empty))), 1)),
    write('Failed: tree_eval(1, tree, 0)'), nl,
    write('tree:       +'), nl,
    write('           / \\'), nl,
    write('          z   -'), nl,
    write('             / \\'), nl,
    write('            +   z'), nl,
    write('           / \\'), nl,
    write('          z   z'), nl.
tree_eval_tests :-
    not(tree_eval(0, tree(tree(tree(tree(empty, 5, empty), '+', tree(empty, z, empty)), '/', tree(empty, -8, empty)),
        '*', tree(tree(empty, 4, empty), '*', tree(empty, 4, empty))), -10.0)),
    write('Failed: tree_eval(0, tree, -10)'), nl,
    write('tree:       *'), nl,
    write('          /   \\'), nl,
    write('         /     *'), nl,
    write('        / \\   / \\'), nl,
    write('       +  -8 4   4'), nl,
    write('      / \\'), nl,
    write('     5   z'), nl.
tree_eval_tests :-
    write('tree_eval tests passed'), nl, nl.

tests :-
    write(' *** Testing sumsq_div3or5 *** '), nl,
    sumsq_div3or5_tests,
    write(' *** Testing same_name *** '), nl,
    same_name_tests,
    write(' *** Testing more same_name *** '), nl,
    more_same_name_tests,
    write(' *** Testing log_table *** '), nl,
    log_table_tests,
    write(' *** Testing runs *** '), nl,
    runs_tests,
    write(' *** Testing  tree_eval *** '), nl,
    tree_eval_tests.
