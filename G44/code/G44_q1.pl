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