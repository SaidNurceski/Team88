/* Adventure Game:Escape from School, by Balint,Said,Markus */

:- dynamic at/2, i_am_at/1.

/* Define the initial location */
i_am_at(classroom).

/* Define the paths between locations */
path(classroom, n, hallway).
path(classroom, e, library).
path(classroom, s, cafeteria).

path(hallway, s, classroom).
path(hallway, e, gymnasium).
path(hallway, w, science_lab).

path(library, w, classroom).
path(gymnasium, w, hallway).
path(cafeteria, n, classroom).

/* Define the objects and their locations */
at(backpack, classroom).
at(book, library).
at(keys, gymnasium).
at(lab_coat, science_lab).

/* Define the actions */
take(X) :-
    at(X, in_hand),
    write('You''re already holding it!'),
    nl, !.

take(X) :-
    i_am_at(Place),
    at(X, Place),
    retract(at(X, Place)),
    assert(at(X, in_hand)),
    write('OK.'),
    nl, !.

take(_) :-
    write('I don''t see it here.'),
    nl.

drop(X) :-
    at(X, in_hand),
    i_am_at(Place),
    retract(at(X, in_hand)),
    assert(at(X, Place)),
    write('OK.'),
    nl, !.

drop(_) :-
    write('You aren''t holding it!'),
    nl.

go(Direction) :-
    i_am_at(Here),
    path(Here, Direction, There),
    retract(i_am_at(Here)),
    assert(i_am_at(There)),
    look, !.

go(_) :-
    write('You can''t go that way.').

look :-
    i_am_at(Place),
    describe(Place),
    nl,
    notice_objects_at(Place),
    nl.

notice_objects_at(Place) :-
    at(X, Place),
    write('There is a '), write(X), write(' here.'), nl,
    fail.

notice_objects_at(_).

describe(classroom) :-
    write('You are in a dusty classroom. The desks are covered in papers'), nl,
    write('and books. The exit is to the north.'), nl.

describe(hallway) :-
    write('You are in a dimly lit hallway. Lockers line the walls.'), nl,
    write('The exit is to the south, and there are paths to the east and west.'), nl.

describe(library) :-
    write('You are in the library. Shelves of books tower above you.'), nl,
    write('The exit is to the west.'), nl.

describe(gymnasium) :-
    write('You are in the abandoned gymnasium. The basketball court is'), nl,
    write('covered in dust. The exit is to the west.'), nl.

describe(cafeteria) :-
    write('You are in the cafeteria. Tables and chairs are scattered'), nl,
    write('around. The exit is to the north.'), nl.

start :-
    instructions,
    look.

instructions :-
    nl,
    write('Welcome to the Lost School Escape Game!'), nl,
    write('Enter commands using standard Prolog syntax.'), nl,
    write('Available commands are:'), nl,
    write('start.                   -- to start the game.'), nl,
    write('n.  s.  e.  w.           -- to go in that direction.'), nl,
    write('take(Object).            -- to pick up an object.'), nl,
    write('drop(Object).            -- to put down an object.'), nl,
    write('look.                    -- to look around you again.'), nl,
    write('instructions.            -- to see this message again.'), nl,
    write('halt.                    -- to end the game and quit.'), nl,
    nl.

