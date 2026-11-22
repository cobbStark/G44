%BLOCK 1

:- use_module(library(lists)).

% solution(-S): S is a candidate assignment of the four friends, in the order
% Alex, Ben, Carla, Dana. Each attribute is a permutation of its four values.
solution([p('Alex',D1,L1,P1), p('Ben',D2,L2,P2),
          p('Carla',D3,L3,P3), p('Dana',D4,L4,P4)]) :-
    permutation([research,development,design,testing], [D1,D2,D3,D4]),
    permutation([python,java,'c++',javascript],        [L1,L2,L3,L4]),
    permutation(['AI',web,embedded,data],              [P1,P2,P3,P4]).

%BLOCK 2

% clue 1: the AI-project friend is not in research and is not Dana.
clue(1, S) :- member(p(Name, Dept, _, 'AI'), S), Dept \= research, Name \= 'Dana'.

% clue 2: Alex is not in development and does not prefer C++.
clue(2, S) :- member(p('Alex', Dept, Lang, _), S), Dept \= development, Lang \= 'c++'.

% clue 3: the testing friend likes Python.
clue(3, S) :- member(p(_, testing, python, _), S).

% clue 4: Ben prefers web and is not in testing.
clue(4, S) :- member(p('Ben', Dept, _, web), S), Dept \= testing.

%BLOCK 3

% clue 5: the Java friend works in the design department.
clue(5, S) :- member(p(_, design, java, _), S).

% clue 6: Carla's project is not embedded and her department is not development.
clue(6, S) :- member(p('Carla', Dept, _, Proj), S), Proj \= embedded, Dept \= development.

% clue 7: Dana's language is not Java, and she works in research or testing.
clue(7, S) :- member(p('Dana', Dept, Lang, _), S), Lang \= java, ( Dept = research ; Dept = testing ).

% clue 8: the data-project friend works in research and does not use JavaScript.
clue(8, S) :- member(p(_, research, Lang, data), S), Lang \= javascript.

%BLOCK 4

% main: finds one solution S from solution/1 that satisfies clue(N, S) for
% every N from 1 to 8, then prints one line per friend (Alex, Ben, Carla,
% Dana) in the form: Name = [Dept, Lang, Project].
main :-
    once(( solution(S),
           forall(between(1, 8, N), clue(N, S)) )),
    forall(member(p(Name, Dept, Lang, Proj), S),
           format("~w = [~w, ~w, ~w]~n", [Name, Dept, Lang, Proj])).

%BLOCK 5

% count_solutions(+Active, -N): N is the number of solutions S of solution/1
% that satisfy every clue whose number is listed in Active, ignoring all
% other clues.
count_solutions(Active, N) :-
    findall(S,
            ( solution(S),
              forall(member(C, Active), clue(C, S)) ),
            Solutions),
    length(Solutions, N).