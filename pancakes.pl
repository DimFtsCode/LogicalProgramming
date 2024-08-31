% Simple dfs(1)

pancakes_dfs(State,Operators,States) :-
   dfs(State,[],[State], States,Operators).

dfs(State,Operators, States, States,Operators) :-
   sort(State,Sorted),
   State = Sorted.
dfs(State1,Operators1,SoFarStates, States,Operators) :-
   move(State1, State2),
   \+ member(State2, SoFarStates),
   append(SoFarStates, [State2], NewSoFarStates),
   append1(Operators1,State2,Operators2),
   dfs(State2,Operators2, NewSoFarStates, States,Operators). 




move(State1,State2):-
	append(Front,Back,State1),
	reverse(Front,Front1),
	append(Front1,Back,State2).



trace.

append1(List,[H|T],List1):-
	append(List,[H],List1).

% Idfs in pancakes problem (2)


pancakes_dfs1(State,Operators,States) :-
    solve_pancakes_iter(State,0, States,Operators).
   
solve_pancakes_iter(State,Lim,States,Operators):-
	ldfs(State,[], [State],Lim, States,Operators). % if i put cut only one solution

solve_pancakes_iter(State,Lim,States,Operators):-
	Lim1 is Lim+1,
	solve_pancakes_iter(State,Lim1,States,Operators).
   

ldfs(State,Operators, States,_, States,Operators) :-
    sort(State,Sorted),
    State = Sorted.
ldfs(State1,Operators1,SoFarStates,Lim, States,Operators) :-
    Lim > 0,
	Lim1 is Lim-1,
    move(State1, State2),
    \+ member(State2, SoFarStates),
    append(SoFarStates, [State2], NewSoFarStates),
    append1(Operators1,State2,Operators2),
    ldfs(State2,Operators2, NewSoFarStates,Lim1, States,Operators). 