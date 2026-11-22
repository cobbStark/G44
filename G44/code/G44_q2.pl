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

% op_prec(?Op, ?Prec)
% Declarative reading: Prec is the precedence of operator Op. A larger
% number binds tighter, so * and / bind tighter than + and -.
op_prec(+, 1).
op_prec(-, 1).
op_prec(*, 2).
op_prec(/, 2).

% tree_prec(+Tree, -Prec)
% Declarative reading: Prec is the precedence of the top operator of Tree.
% A single number gets precedence 3, higher than every operator, so it is
% never put in parentheses.
tree_prec(N, 3) :-
    integer(N).
tree_prec(Tree, Prec) :-
    compound(Tree),
    Tree =.. [Op, _, _],
    op_prec(Op, Prec).

% tree_codes(+Tree, -Codes)
% Declarative reading: Codes is the code list of Tree written in the
% canonical form, with no spaces. Nothing is printed; the caller turns
% Codes into a string.
tree_codes(Tree, Codes) :-
    phrase(tree_dcg(Tree), Codes).

% tree_dcg(+Tree)//
% Recursive reading: a number is written in decimal; a node L Op R is
% written as its left operand, the operator symbol, then its right operand,
% each one put in parentheses as the canonical rule says.
tree_dcg(N) -->
    { integer(N) },
    { number_codes(N, Digits) },
    Digits.
tree_dcg(Tree) -->
    { compound(Tree),
      Tree =.. [Op, L, R],
      op_prec(Op, Prec),
      atom_codes(Op, OpCodes) },
    left_operand(L, Prec),
    OpCodes,
    right_operand(R, Prec).

% left_operand(+Tree, +ParentPrec)//
% A left operand is in parentheses only if its precedence is LOWER than
% its parent's (operators are left-associative).
left_operand(Tree, ParentPrec) -->
    { tree_prec(Tree, Prec) },
    (   { Prec < ParentPrec }
    ->  "(", tree_dcg(Tree), ")"
    ;   tree_dcg(Tree)
    ).

% right_operand(+Tree, +ParentPrec)//
% A right operand is in parentheses if its precedence is the SAME as or
% LOWER than its parent's.
right_operand(Tree, ParentPrec) -->
    { tree_prec(Tree, Prec) },
    (   { Prec =< ParentPrec }
    ->  "(", tree_dcg(Tree), ")"
    ;   tree_dcg(Tree)
    ).
