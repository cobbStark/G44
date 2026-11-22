:- consult('../code/G44_q1.pl').

% check(+Name, :Goal): prints PASS or FAIL for the named test.
check(Name, Goal) :-
    (   call(Goal) -> format("PASS: ~w~n", [Name])
    ;   format("FAIL: ~w~n", [Name])
    ).

% The three solutions of clues 1 to 8.
% s1 is the one main/0 prints; s2 is the one clue 9 keeps.
sol(s1, [p('Alex',design,java,'AI'), p('Ben',development,javascript,web),
         p('Carla',research,'c++',data), p('Dana',testing,python,embedded)]).
sol(s2, [p('Alex',design,java,embedded), p('Ben',development,javascript,web),
         p('Carla',testing,python,'AI'), p('Dana',research,'c++',data)]).
sol(s3, [p('Alex',testing,python,embedded), p('Ben',development,javascript,web),
         p('Carla',design,java,'AI'), p('Dana',research,'c++',data)]).

% test_all: runs every P1 test and prints one line per test.
test_all :-
    % counts
    check(candidates_13824, (aggregate_all(count, solution(_), N1), N1 =:= 13824)),
    check(no_clues_13824, (count_solutions([], N2), N2 =:= 13824)),
    check(clues_1_8_three, (count_solutions([1,2,3,4,5,6,7,8], N3), N3 =:= 3)),
    check(clues_1_9_one, (count_solutions([1,2,3,4,5,6,7,8,9], N4), N4 =:= 1)),
    % every candidate uses each value once (spot check on the first candidate)
    check(candidate_shape, (solution([p('Alex',_,_,_), p('Ben',_,_,_),
                                      p('Carla',_,_,_), p('Dana',_,_,_)]))),
    % all three known solutions satisfy clues 1 to 8
    forall(( member(Id, [s1,s2,s3]), member(C, [1,2,3,4,5,6,7,8]) ),
           ( sol(Id, S),
             format(atom(Name), "~w_clue_~w", [Id, C]),
             check(Name, clue(C, S)) )),
    % clue 9 is true only in s2
    sol(s1, S1), sol(s2, S2), sol(s3, S3),
    check(clue9_false_on_s1, \+ clue(9, S1)),
    check(clue9_true_on_s2,  clue(9, S2)),
    check(clue9_false_on_s3, \+ clue(9, S3)),
    % a deliberately wrong assignment must break at least one clue
    Bad = [p('Alex',research,python,'AI'), p('Ben',testing,java,web),
           p('Carla',design,'c++',embedded), p('Dana',development,javascript,data)],
    check(bad_solution_rejected, \+ forall(member(C2, [1,2,3,4,5,6,7,8]), clue(C2, Bad))).