:- dynamic at/2, location/1, lives/1.
:- retractall(at(_, _)), retractall(location(_)), retractall(lives(_)).

location(courtyard).

path(ghost, d, torture_chamber).
path(torture_chamber, u, ghost).
path(torture_chamber, w, torture_chamber_entrance).
path(torture_chamber_entrance, e, torture_chamber).
path(torture_chamber_entrance, s, courtyard).
path(courtyard, n, torture_chamber_entrance) :- at(lantern, in_hand).
path(courtyard, n, torture_chamber_entrance) :-
        write('You cannot go into torture chamber without a light'), nl, !, fail.
path(courtyard, s, building).
path(building, n, courtyard).
path(building, w, dungeon).
path(dungeon, e, building).
path(closet, w, building).
path(building, e, closet) :- at(key, in_hand).
path(building, e, closet) :-
        write('The door seems to be locked'), nl, fail.

at(coin, ghost).
at(key, torture_chamber_entrance).
at(lantern, building).
at(sword, closet).

lives(ghost).

take(X) :-
        at(X, in_hand), write('You''re already holding it!'), nl, !.

take(X) :-
        location(Place),
        at(X, Place),
        retract(at(X, Place)),
        assert(at(X, in_hand)),
        write('OK.'),
        nl, !.

take(_) :-
        write('I don''t see it here.'), nl.

drop(X) :-
        at(X, in_hand),
        location(Place),
        retract(at(X, in_hand)),
        assert(at(X, Place)),
        write('OK.'),
        nl, !.

drop(_) :-
        write('You aren''t holding it!'), nl.

n :- go(n).
s :- go(s).
e :- go(e).
w :- go(w).
u :- go(u).
d :- go(d).

go(Direction) :-
        location(Here),
        path(Here, Direction, There),
        retract(location(Here)),
        assert(location(There)),
        look, !.

go(_) :-
        write('You cannot go there.').

look :-
        location(Place),
        description(Place),
        nl,
        print_objects(Place),
        nl.

print_objects(Place) :-
        at(X, Place),
        write('Here is a '), write(X), nl,
        fail.

print_objects(_).

kill :-
        location(dungeon),
        write('BAD! You have just been eaten by a flock of fleas.'), nl,
        !, die.

kill :-
        location(torture_chamber),
        write('This isn''t working. The ghost will wake up in this case.').

kill :-
        location(ghost),
        at(sword, in_hand),
        retract(lives(ghost)),
        write('You killed the ghost successfully :-)'), nl,
        write('Now, get out of the dust!'),
        nl, !.
