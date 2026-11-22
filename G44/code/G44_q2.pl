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
