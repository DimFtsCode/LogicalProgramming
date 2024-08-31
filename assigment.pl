activity(a01, act(0,3)).
activity(a02, act(0,4)).
activity(a03, act(1,5)).
activity(a04, act(4,6)).
activity(a05, act(6,8)).
activity(a06, act(6,9)).
activity(a07, act(9,10)).
activity(a08, act(9,13)).
activity(a09, act(11,14)).
activity(a10, act(12,15)).
activity(a11, act(14,17)).
activity(a12, act(16,18)).
activity(a13, act(17,19)).
activity(a14, act(18,20)).
activity(a15, act(19,20)).


between(Start, End, Start) :-
    Start =< End.
between(Start, End, Result) :-
    Start < End,
    Next is Start + 1,
    between(Next, End, Result).

min1([X], X).
min1([X,Y|Tail], Min) :-
    X =< Y,
    min1([X|Tail], Min).
min1([X,Y|Tail], Min) :-
    X > Y,
    min1([Y|Tail], Min).

choose_min_pid(NPersons,AId,Assignment,MaxTime,MinValidPid):-
	findall(PId,between(1,NPersons,PId),PIds),
	tester(PIds,AId,Assignment,MaxTime,[],ValidPids),
	min1(ValidPids,MinValidPid).
	

tester(PId,NPersons,_,_,_,ValidPids,ValidPids).
tester(PId,NPersons,AId,Assignment1,MaxTime,ValidPids1,ValidPids):-
	between(PId,NPersons,PId1),
	activity(AId, act(Ab,Ae)),
	gather_apids(Assignment1, PId, APIds),
	valid(Ab,Ae,APIds),
	count_hours(APIds,0,Hours),Hours+(Ae-Ab) =< MaxTime,
	append(ValidPids1,[PId],ValidPids2),
	tester(PId1,NPersons,AId,Assignment1,MaxTime,ValidPids2,ValidPids).
	


count_hours([],Hours,Hours).
count_hours([AId|AIds],Hours1,Hours):-
	activity(AId,act(S1,E1)),
	Hours2 is  Hours1+(E1-S1),
	count_hours(AIds,Hours2,Hours).

print_ASP(_,0,ASP,ASP).
print_ASP(ASA,NPersons,ASP1,ASP):-
	NPersons > 0,
	gather_apids(ASA,NPersons,APIds),
	count_hours(APIds,0,Hours),
	append(ASP1,[NPersons-APIds-Hours],ASP2),
	NPersons1 is NPersons-1,
	print_ASP(ASA,NPersons1,ASP2,ASP).


activity_list(List):-
	findall(Id, activity(Id,_), List).

gather_apids(Assignment, PId, APIds) :-
    findall(AId, member(AId-PId, Assignment), APIds).	
	
assignment(NPersons,MaxTime,ASP,ASA):-
	activity_list(AIds),
	assign(AIds,NPersons,MaxTime,[],ASA),
	print_ASP(ASA,NPersons,[],ASP).
	
	

assign([],_,_,Assignment,Assignment).	
assign([AId|AIds],NPersons,MaxTime,Assignment1,Assignment):-
	choose_min_pid(NPersons,AId,Assignment1,MaxTime,MinValidPid),
	append(Assignment1,[AId-MinValidPid],Assignment2),
	assign(AIds,NPersons,MaxTime,Assignment2,Assignment).
	
valid(_,_,[]).
valid(S1,E1,[APId|APIds]):-
	activity(APId, act(S2,E2)),
	(E2+1 =< S1 ; E1=< S2-1),
	valid(S1,E1,APIds).
	
	
	