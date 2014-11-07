init_agent:-
retractall(arrow(_)),
assert(arrow(1)),
retractall(gold(_)),
assert(gold(0)),
retractall(c_loc(_,_)),
assert(c_loc(1,1)),
retractall(p_loc(_,_)),
assert(p_loc(1,1)),
retractall(orietation(_)),
assert(orietation(east)),
retractall(safe(_,_)),
assert(safe(1,1)),
retractall(stench(_,_)),
assert(stench(0,0)),
retractall(breeze(_,_)),
assert(breeze(0,0)),
retractall(score(_)),
assert(score(0)),
retractall(nopit(_,_)),
assert(nopit(1,1)),
retractall(nowumpus(_,_)),
assert(nowumpus(1,1)),
retractall(random_time(_)),
assert(random_time(0)).


run_agent(Percept,Action):-
c_loc(X,Y),orietation(Orient),
check_status(Percept),
check_safe(X,Y),
select_action(Percept,Action),
display_world.

check_safe(X,Y):-
c_loc(X,Y),assert(safe(X,Y)),
fail.

check_safe(X,Y):-
c_loc(X,Y),
X1 is X+1,X0 is X-1,Y1 is Y+1, Y0 is Y-1,
(
(X1=<4,not(safe(X1,Y)),nopit(X1,Y),nowumpus(X1,Y),assert(safe(X1,Y)));
(X0>=1,not(safe(X0,Y)),nopit(X0,Y),nowumpus(X0,Y),assert(safe(X0,Y)));
(Y1=<4,not(safe(X,Y1)),nopit(X,Y1),nowumpus(X,Y1),assert(safe(X,Y1)));
(Y0>=1,not(safe(X,Y0)),nopit(X,Y0),nowumpus(X,Y0),assert(safe(X,Y0)))
),
fail.

check_safe(X,Y).


check_status([yes,_,_,_,_]):-
c_loc(X,Y),
assert(stench(X,Y)),
fail.

check_status([no,_,_,_,_]):-
c_loc(X,Y),
X1 is X+1,X0 is X-1,Y1 is Y+1, Y0 is Y-1,
(
(X1=<4,assert(nowumpus(X1,Y)));
(X0>=1,assert(nowumpus(X0,Y)));
(Y1=<4,assert(nowumpus(X,Y1)));
(Y0>=1,assert(nowumpus(X,Y0)))
),
fail.

check_status([_,yes,_,_,_]):-
c_loc(X,Y),
assert(breeze(X,Y)),
fail.

check_status([_,no,_,_,_]):-
c_loc(X,Y),
X1 is X+1,X0 is X-1,Y1 is Y+1, Y0 is Y-1,
(
(X1=<4,assert(nopit(X1,Y)));
(X0>=1,assert(nopit(X0,Y)));
(Y1=<4,assert(nopit(X,Y1)));
(Y0>=1,assert(nopit(X,Y0)))
),
fail.

check_status([_,_,_,_,_]).

select_action([_,_,no,_,_],goforward):-
c_loc(X,Y),orietation(Orient),
X1 is X+1,X0 is X-1,Y1 is Y+1, Y0 is Y-1,
(
(Orient=east,X1=<4,safe(X1,Y),retract(c_loc(X,Y)),assert(c_loc(X1,Y)));
(Orient=west,X0>=1,safe(X0,Y),retract(c_loc(X,Y)),assert(c_loc(X0,Y)));
(Orient=north,Y1=<4,safe(X,Y1),retract(c_loc(X,Y)),assert(c_loc(X,Y1)));
(Orient=south,Y0>=1,safe(X,Y0),retract(c_loc(X,Y)),assert(c_loc(X,Y0)))
),
retract(p_loc(_,_)),assert(p_loc(X,Y)),write('goforward').

select_action([_,_,yes,_,_],grab):-  
gold(X),
X1 is X+1,
retract(gold(_)),
assert(gold(X1)),write('got gold').

select_action([_,_,_,_,_],climb):-
(gold(X1),X1>0,
c_loc(1,1),write('win'));
(c_loc(1,1),random_time(X),X>=10).

select_action([_,_,no,_,_],Action):-
not(c_loc(1,1)),random_time(X),X<10,
orietation(Orient),
random_between(0,1,R),
(
(R=0,Action = turnleft,((Orient=east,retract(orietation(east)),assert(orietation(north)));
	(Orient=west,retract(orietation(west)),assert(orietation(south)));
	(Orient=north,retract(orietation(north)),assert(orietation(west)));
	(Orient=south,retract(orietation(south)),assert(orietation(east)))
	),write('turnleft')
);
(R=1,Action = turnright,((Orient=east,retract(orietation(east)),assert(orietation(south)));
	(Orient=west,retract(orietation(west)),assert(orietation(north)));
	(Orient=north,retract(orietation(north)),assert(orietation(east)));
	(Orient=south,retract(orietation(south)),assert(orietation(west)))
	),write('turnright')
)
).


select_action([_,_,no,_,_],Action):-
c_loc(1,1),random_time(X),X<10,
orietation(Orient),
random_between(0,1,R),
(
(R=0,Action = turnleft,((Orient=east,retract(orietation(east)),assert(orietation(north)));
	(Orient=west,retract(orietation(west)),assert(orietation(south)));
	(Orient=north,retract(orietation(north)),assert(orietation(west)));
	(Orient=south,retract(orietation(south)),assert(orietation(east)))
	),write('turnleft')
);
(R=1,Action = turnright,((Orient=east,retract(orietation(east)),assert(orietation(south)));
	(Orient=west,retract(orietation(west)),assert(orietation(north)));
	(Orient=north,retract(orietation(north)),assert(orietation(east)));
	(Orient=south,retract(orietation(south)),assert(orietation(west)))
	),write('turnright')
)
),retractall(random_time(_)),
X1 is X+1,
assert(random_time(X1)).




select_action([_,_,_,yes,_],Action):-
c_loc(X,Y),orietation(Orient),
p_loc(X,Y),
random_between(0,1,R),
(
(R=0,Action = turnleft,((Orient=east,retract(orietation(east)),assert(orietation(north)));
	(Orient=west,retract(orietation(west)),assert(orietation(south)));
	(Orient=north,retract(orietation(north)),assert(orietation(west)));
	(Orient=south,retract(orietation(south)),assert(orietation(east)))
	)
);
(R=1,Action = turnright,((Orient=east,retract(orietation(east)),assert(orietation(south)));
	(Orient=west,retract(orietation(west)),assert(orietation(north)));
	(Orient=north,retract(orietation(north)),assert(orietation(east)));
	(Orient=south,retract(orietation(south)),assert(orietation(west)))
	)
)
),
retract(c_loc(_,_)),assert(c_loc(X,Y)).