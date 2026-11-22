% CS F301 Assignment 2, Problem P2: Form a Valid Arithmetic Equation
% Group G44.
%
% Given a list of non-negative integers, place + - * / and exactly one =
% between them (numbers used once, in order, optional parentheses) so that
% both sides have the same integer value.
%
% Allowed libraries: lists, apply, yall, aggregate.
% No assert/retract, no global variables, nothing printed.

:- use_module(library(lists)).

% split_list(+List, -Left, -Right)
% Declarative reading: Left and Right are both non-empty, and appending
% Left and Right gives List. In other words, Left is a non-empty proper
% prefix of List and Right is the non-empty rest.
% On backtracking it gives every such split, shortest Left first.
% Fails for lists of length 0 or 1, because there is no split with both
% parts non-empty.
split_list(List, Left, Right) :-
    Left = [_|_],
    Right = [_|_],
    append(Left, Right, List).

% expr(+Nums, -Tree, -Value)
% Declarative reading: Tree is an expression tree that uses every number of
% the non-empty list Nums exactly once, in order, joined by + - * /, and
% Value is its integer value.
% A tree is either a number N (a leaf) or a term L+R, L-R, L*R or L/R whose
% operands are trees. The value is computed while the tree is built; no
% string is ever made or parsed.
% Recursive reading: a single number is its own tree; otherwise split Nums
% into two non-empty parts, build a tree for each, and join them with one
% operator whose result is defined (see apply_op/6).
expr([N], N, N).
expr(Nums, Tree, Value) :-
    split_list(Nums, LeftNums, RightNums),
    expr(LeftNums, LeftTree, LeftValue),
    expr(RightNums, RightTree, RightValue),
    apply_op(LeftTree, LeftValue, RightTree, RightValue, Tree, Value).

% apply_op(+LT, +LV, +RT, +RV, -Tree, -Value)
% Declarative reading: Tree joins LT and RT with one of + - * /, and Value
% is that operator applied to LV and RV. Division is allowed only when RV
% is not zero and LV is an exact multiple of RV, so Value is always an
% integer. Each clause gives one operator.
apply_op(LT, LV, RT, RV, LT+RT, V) :- V is LV + RV.
apply_op(LT, LV, RT, RV, LT-RT, V) :- V is LV - RV.
apply_op(LT, LV, RT, RV, LT*RT, V) :- V is LV * RV.
apply_op(LT, LV, RT, RV, LT/RT, V) :-
    RV =\= 0,
    LV mod RV =:= 0,
    V is LV // RV.
