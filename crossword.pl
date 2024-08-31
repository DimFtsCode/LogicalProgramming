dimension(5).
black(1, 3).
black(2, 3).
black(3, 2).
black(4, 3).
black(5, 1).
black(5, 5).
words([adam,al,as,do,ik,lis,ma,oker,ore,pirus,po,so,ur]).

create_matrix(Matrix) :-
    dimension(N),
    create_matrix(N,0, N, Matrix).

create_matrix(N,N, _, []).
create_matrix(N,N1, M, [Row|Rest]) :-
    N1 < N,
	create_row(N1,M,0, Row),
    N2 is N1 + 1,
    create_matrix(N,N2, M, Rest).

create_row(_,M,M,[]).
create_row(N,M,M1,[Var|Rest]) :-
    M1 < M,
	Mt is M1+1,
	Nt is N+1,
	\+ black(Nt,Mt),
    M2 is M1 + 1,
    Var = _,
    create_row(N,M,M2, Rest).

create_row(N,M,M1,[Var|Rest]) :-
    M1 < M,
	Mt is M1+1,
	Nt is N+1,
	black(Nt,Mt),
    M2 is M1 + 1,
    Var = black,
    create_row(N,M,M2, Rest).

crossword(Matrix):-
	create_matrix(Matrix).
	

w_t_a(CodeList):-
	words(Words),
	words_to_ascii(Words,CodeList).
	
words_to_ascii([],[]).
words_to_ascii([Word|Rest],[N-Codes|CodeList]):-
	name(Word,Codes),
	length(Codes,N),
	words_to_ascii(Rest,CodeList).
	
column_to_row(0,_,Rotated,Rotated).
column_to_row(N,Matrix,Rt,Rotated):-
	column_n(N,Matrix,Column),
	N1 is N - 1,
	column_to_row(N1,Matrix,[Column|Rt],Rotated).
	

column_n(_,[],[]).
column_n(N,[X|R],[NthX| S]) :-
    nth1(N,X,NthX),
    column_n(N,R,S).

find_words(Matrix,FindWords):-
	find_words(Matrix,FindWords,RestFindWords),
	dimension(N),
	column_to_row(N,Matrix,[],RotatedMatrix),
	find_words(RotatedMatrix,RestFindWords,[]).
	
find_words([],Fw,Fw).
find_words([H|Tl],Fw,FwTail):-
	find_words_line(H,Fw,Fw1),
	find_words(Tl,Fw1,FwTail).
find_words_line([],Words,Words).	
find_words_line([V1,V2|Tail],Words1,Words):-
	var(V1),var(V2),!,
	find_after(Tail,Af,After),
	append([V1],[V2],Both),
	append(Both,After,Words2),
	find_words_line([V1,V2|Tail],Words2,Words).
find_words_line([_|Tail],Words1,Words):-
	find_words_line(Tail,Words1,Words).

find_after([H|T],
	


	
	

	
nth1(1, [X|_], X). 
nth1(N, [_|T], X) :-
    N > 1,           
    N1 is N - 1,     
    nth1(N1, T, X).	