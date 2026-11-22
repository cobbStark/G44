:- use_module(library(lists)).

% solution(-S): S is a candidate assignment of the four friends, in the order
% Alex, Ben, Carla, Dana. Each attribute is a permutation of its four values,
% so every value is used exactly once.
solution([p('Alex',D1,L1,P1), p('Ben',D2,L2,P2),
          p('Carla',D3,L3,P3), p('Dana',D4,L4,P4)]) :-
    permutation([research,development,design,testing], [D1,D2,D3,D4]),
    permutation([python,java,'c++',javascript],        [L1,L2,L3,L4]),
    permutation(['AI',web,embedded,data],              [P1,P2,P3,P4]).