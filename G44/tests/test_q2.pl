% Tests for Problem P2 (G44/code/G44_q2.pl), written with plunit.
%
% Run from the G44/G44 folder:
%   swipl -g run_tests -t halt tests/test_q2.pl
%
% The relative path below is resolved against this file's folder, so the
% command works from any working directory.

:- use_module(library(plunit)).
:- use_module(library(lists)).
:- ensure_loaded('../code/G44_q2.pl').

% The seven equations the spec gives for [4,2,5,3].
spec_4253(["4*2-5=3", "4*2=5+3", "4-2=5-3", "4/2=5-3",
           "4=2*(5-3)", "4=2+(5-3)", "4=2+5-3"]).

% no_spaces(+S): string S contains no space character.
no_spaces(S) :-
    \+ sub_string(S, _, _, _, " ").

% ---------------------------------------------------------------------
:- begin_tests(spec_examples).

% Example 1: generate_equation([4,2,5,3], E) gives one of the seven.
test(generate_4253) :-
    generate_equation([4,2,5,3], E),
    string(E),
    spec_4253(All),
    memberchk(E, All).

% Example 2: all_equations([4,2,5,3], Es) gives exactly the seven, in order.
test(all_4253) :-
    spec_4253(Expected),
    all_equations([4,2,5,3], Es),
    assertion(Es == Expected).

% Example 3: [2,3,4] has no equation.
test(generate_234_fails, [fail]) :-
    generate_equation([2,3,4], _).

test(all_234_empty) :-
    all_equations([2,3,4], Es),
    assertion(Es == []).

% Example 4: [2,4,8] has exactly one equation.
test(all_248) :-
    all_equations([2,4,8], Es),
    assertion(Es == ["2*4=8"]).

:- end_tests(spec_examples).

% ---------------------------------------------------------------------
:- begin_tests(count).

test(count_4253) :-
    count_equations([4,2,5,3], N),
    assertion(N == 7).

test(count_234) :-
    count_equations([2,3,4], N),
    assertion(N == 0).

test(count_248) :-
    count_equations([2,4,8], N),
    assertion(N == 1).

% count_equations/2 always equals the length of all_equations/2.
test(count_matches_length) :-
    forall(member(L, [[4,2,5,3], [1,1,1], [0,0,0], [1,2,3,4,5]]),
           ( all_equations(L, Es),
             length(Es, Len),
             count_equations(L, N),
             assertion(N == Len) )).

:- end_tests(count).

% ---------------------------------------------------------------------
:- begin_tests(edge_cases).

% Empty list: generate fails, all gives [], count gives 0.
test(empty_generate_fails, [fail]) :-
    generate_equation([], _).

test(empty_all) :-
    all_equations([], Es),
    assertion(Es == []).

test(empty_count) :-
    count_equations([], N),
    assertion(N == 0).

% Single number: no place for "=", so no equation.
test(single_generate_fails, [fail]) :-
    generate_equation([5], _).

test(single_all) :-
    all_equations([5], Es),
    assertion(Es == []).

% Division by zero: 0/0 is never allowed, so the only equations for
% [0,0,0] use + - *.
test(div_by_zero_top_level) :-
    all_equations([0,0,0], Es),
    assertion(Es == ["0*0=0", "0+0=0", "0-0=0",
                     "0=0*0", "0=0+0", "0=0-0"]).

% Division by zero inside a sub-expression: 4/(2-2) is never formed.
test(div_by_zero_nested) :-
    all_equations([4,2,2,1], Es),
    assertion(\+ memberchk("4/(2-2)=1", Es)),
    assertion(\+ (member(E, Es), sub_string(E, _, _, _, "/(2-2)"))).

% Inexact division: 7/2 would truncate to 3, but it must be rejected,
% so [7,2,3] has no equation at all.
test(inexact_division) :-
    all_equations([7,2,3], Es),
    assertion(Es == []).

test(inexact_division_generate_fails, [fail]) :-
    generate_equation([7,2,3], _).

% Exact division is kept, even inside a sub-expression.
test(exact_division_nested) :-
    all_equations([8,4,2,4], Es),
    assertion(memberchk("8/(4/2)=4", Es)).

% Negative intermediate values: 3-5 = -2 = 2-4.
test(negative_intermediate) :-
    all_equations([3,5,2,4], Es),
    assertion(memberchk("3-5=2-4", Es)).

% Negative value divided exactly: (3-5)/2 = -1 = 1-2.
test(negative_exact_division) :-
    all_equations([3,5,2,1,2], Es),
    assertion(memberchk("(3-5)/2=1-2", Es)).

% A bound Equation is checked, not just generated.
test(generate_checks_bound_valid) :-
    generate_equation([4,2,5,3], "4=2+5-3").

test(generate_checks_bound_invalid, [fail]) :-
    generate_equation([4,2,5,3], "4=2+5+3").

:- end_tests(edge_cases).

% ---------------------------------------------------------------------
:- begin_tests(output_format).

% Every equation is an SWI-Prolog string with no spaces and exactly one "=".
test(strings_no_spaces) :-
    forall(member(L, [[4,2,5,3], [2,4,8], [0,0,0], [3,5,2,4],
                      [10,2,5,1], [1,2,3,4,5]]),
           ( all_equations(L, Es),
             forall(member(E, Es),
                    ( assertion(string(E)),
                      assertion(no_spaces(E)),
                      assertion(aggregate_all(count,
                                    sub_string(E, _, _, _, "="), 1)) )) )).

% Multi-digit numbers are written in decimal and never joined.
test(multi_digit) :-
    all_equations([10,2,5], Es),
    assertion(memberchk("10=2*5", Es)),
    assertion(memberchk("10/2=5", Es)).

% The output is sorted with no duplicates.
test(sorted_no_duplicates) :-
    all_equations([1,2,3,4,5], Es),
    sort(Es, Sorted),
    assertion(Es == Sorted).

:- end_tests(output_format).
