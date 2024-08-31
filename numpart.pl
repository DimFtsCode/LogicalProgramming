:- lib(ic).

sum_list([],Sum,Sum).
sum_list([H|T],Sum1,Sum):-
	Sum2 is Sum1 + H,
	sum_list(T,Sum2,Sum).

sum_sq([],Sum,Sum).
sum_sq([H|T],Sum1,Sum):-
	Sum2 is Sum1 + (H * H),
	sum_list1(T,Sum2,Sum).

func(N,Sum):-
	Sum is (N*(N+1))//4. 
	
func1(N,SumSq):-
	SumSq is (N * (N + 1) * (2*N + 1) // 12).
	
	
numpart(N,L1,L2):-
	numpart(N,L1),
	N1 is N//2,
	length(L2,N1),
	sec_list_creation(N,L1,[],L3),
	reverse(L3,L2).
	
numpart(N,L1):-
	N1 is N//2,
	length(L1,N1),
	L1 #:: 1..N,
	alldifferent(L1),
	generate(L1),
	constrain(N,L1).
	
constrain(N,L1):-
	ordered(L1),
	element(1,L1,1),
	sum_list(L1,0,Sum),
	sum_sq(L1,0,Sumsq),
	func(N,Sum1),
	func1(N,Sumsq1),
	Sum #= Sum1, Sumsq #= Sumsq1.
	
	
generate(Sol) :- 
	search(Sol, 0, first_fail, indomain, complete, []).

ordered([_]).
ordered([X,Y|L]) :- X =< Y, ordered([Y|L]).


element_exists(Element, [Element|_]).
element_exists(Element, [_|Tail]) :- element_exists(Element, Tail).

sec_list_creation(0,_,L2,L2):-!.
sec_list_creation(N,L1,L2,ResultList):-
	(element_exists(N,L1) ->
	N1 is N-1,
	sec_list_creation(N1,L1,L2,ResultList)) ;
	( append(L2, [N],L3),
	N1 is N-1,
	sec_list_creation(N1,L1,L3,ResultList)).
	