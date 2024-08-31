:- lib(ic).
:- lib(branch_and_bound).




maxsat(NVars, NClauses, Density, F, Vars, Μ):-
	seed(1),create_formula(NVars, NClauses, Density, F),
	length(Vars,NVars), Vars#::[0,1],
	transaction(F,Vars,[],Clauses),
	Cost #= sum(Clauses), %find the already cost
	bb_min(search(Vars, 0, input_order, indomain, complete, []), Cost, _),
	Μ is (NClauses - Cost). 
	
	
transaction([],_,Clauses,Clauses).
transaction([H|T],Vars,Clauses1,Clauses):-
	trans(H,Vars,0,H1,1),
	S1#=(H1#=0), %if zero S1 is 1 , and if != 0 S1 =0
	append(Clauses1,[S1],Clauses2),
	transaction(T,Vars,Clauses2,Clauses).
	
trans([],_,_,0,1).
trans([],_,Clause,Clause,_).
trans([H|T],Vars,Clause1,Clause,N):- %if variable is possitive
	N #>= 1,
	H #> 0,
	N1 is N+1,
	nth1(H,Vars,X),
	Clause2 #= Clause1 + X,
	trans(T,Vars,Clause2,Clause,N1).
trans([H|T],Vars,Clause1,Clause,N):- %if variable is negative
	N #>= 1,
	H #< 0,
	N1 is N+1,
	H1 is -H,
	nth1(H1,Vars,X),
	Clause2 #= Clause1 + (1-X),
	trans(T,Vars,Clause2,Clause,N1).





create_formula(NVars, NClauses, Density, Formula) :-
   formula(NVars, 1, NClauses, Density, Formula).

formula(_, C, NClauses, _, []) :-
   C > NClauses.
formula(NVars, C, NClauses, Density, [Clause|Formula]) :-
   C =< NClauses,
   one_clause(1, NVars, Density, Clause),
   C1 is C + 1,
   formula(NVars, C1, NClauses, Density, Formula).

one_clause(V, NVars, _, []) :-
   V > NVars.
one_clause(V, NVars, Density, Clause) :-
   V =< NVars,
   rand(1, 100, Rand1),
   (Rand1 < Density ->
      (rand(1, 100, Rand2),
       (Rand2 < 50 ->
        Literal is V ;
        Literal is -V),
       Clause = [Literal|NewClause]) ;
      Clause = NewClause),
   V1 is V + 1,
   one_clause(V1, NVars, Density, NewClause).

rand(N1, N2, R) :-
   random(R1),
   R is R1 mod (N2 - N1 + 1) + N1.

nth1(1, [X|_], X). 
nth1(N, [_|T], X) :-
    N > 1,           
    N1 is N - 1,     
    nth1(N1, T, X).	