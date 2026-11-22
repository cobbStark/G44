# P1 Report

**Clues 1 to 8.** `count_solutions([1,2,3,4,5,6,7,8], N)` gives N = 3. The original puzzle is therefore under-constrained: it has three solutions, not one. Ben (development, javascript, web) is the same in all three. They differ only in how Alex, Carla and Dana are assigned to research, design and testing, and to the projects AI, embedded and data.

**Clue 9.** We added: "The friend who prefers the embedded project works in the design department." It is true only in the solution where Alex has (design, java, embedded) and Carla has (testing, python, AI), and false in the other two. With it, `count_solutions([1,2,3,4,5,6,7,8,9], N)` gives N = 1.

Note: `main/0` prints the first solution found for clues 1 to 8, which clue 9 rules out. P1.a only requires clues 1 to 8, so this is intended.