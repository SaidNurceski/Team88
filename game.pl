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

kill :-
        location(ghost),
        write('this has definitely no effects'), nl.

kill :-
        write('nothing to kill here'), nl.

die :- !, finish.

finish :-
        nl, write('Please enter halt. command.'), nl, !.

guide :-
        nl,
        write('COMMANDS'), nl,
        write('guide.                   # print guide'), nl,
        write('start.                   # start game'), nl,
        write('n. e. s. w. u. d.        # go in direction north, east, south, west, up, down'), nl,
        write('take(something).         # pick something up'), nl,
        write('drop(something).         # drop something'), nl,
        write('kill.                    # tries to attack'), nl,
        write('look.                    # look around'), nl,
        write('halt.                    # end game'), nl,
        nl.

start :-
        guide,
        look.

description(courtyard) :-
        at(coin, in_hand),
        write('Congratulations, you have found the coin'), nl,
        write('and won the game.'), nl,
        finish, !.

description(courtyard) :-
        write('You are staying in a courtyard.  To the north is a tourture chamber'), nl,
        write('to the south is a room.'), nl,
        write('try to find the coin and bring it back to'), nl,
        write('this courtyard.'), nl.

description(building) :-
        write('You are in a small room.  The exit is to the north.'), nl,
        write('There is a creepy door to the west, but it seems to be'), nl,
        write('unlocked.  There is a smaller door to the east.'), nl.

description(dungeon) :-
        write('You are in a dungeon full of fleas and they look very hungry'), nl,
        write('I would go outside better'), nl.

description(closet) :-
        write('This is nothing but an old storage closet.'), nl.

description(torture_chamber_entrance) :-
        write('You are in the torture chamber.  The exit is to'), nl,
        write('the south; there is a dark, large, round passageway to the east'), nl.

description(torture_chamber) :-
        lives(ghost),
        at(coin, in_hand),
        write('The ghost sees you with the coin and attacks!!!'), nl,
        die.

description(torture_chamber) :-
        lives(ghost),
        write('There is a giant ghost here! I''d leave better'), nl, !.
description(torture_chamber) :-
        write('There is a ghost twitching.'), nl.

description(ghost) :-
        lives(ghost),
        write('You are on top of a giant ghost.'), nl.

description(ghost) :-
        write('Oh!  You''re on top of a giant dead ghost!'), nl.
