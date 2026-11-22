:- consult('../code/G44_q1.pl').

check(Name, Goal) :-
    (   call(Goal) -> format("PASS: ~w~n", [Name])
    ;   format("FAIL: ~w~n", [Name])
    ).

test_all :-
    check(candidates_13824, (aggregate_all(count, solution(_), N1), N1 =:= 13824)),
    check(no_clues_13824, (count_solutions([], N2), N2 =:= 13824)),
    check(clues_1_8_three, (count_solutions([1,2,3,4,5,6,7,8], N3), N3 =:= 3)),
    S = [p('Alex',design,java,'AI'), p('Ben',development,javascript,web),
         p('Carla',research,'c++',data), p('Dana',testing,python,embedded)],
    forall(member(C, [1,2,3,4,5,6,7,8]),
           ( atom_concat(main_solution_clue_, C, Name),
             check(Name, clue(C, S)) )).