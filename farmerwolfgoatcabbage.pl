% opposite/2
% opposite(++side1, --side2)
% true якщо side2 протилежний берег до side1
opposite(left, right).
opposite(right, left).

% початковий та кінцевий стан
% state(farmer, wolf, goat, cabbage)
% кожен елемент: left або right
start_state(state(left, left, left, left)).
goal_state(state(right, right, right, right)).

% forbidden/1
% forbidden(+state)
% істинно, якщо стан заборонений умовами задачі
% вовк залишає козу без фермера або коза залишає капусту без фермера
forbidden(state(f, w, g, _)) :-
    w = g,
    f \= w.
forbidden(state(f, _, g, c)) :-
    g = c,
    f \= g.

% allowed/1
% allowed(+state)
% стан дозволений, якщо не є забороненим
allowed(state(F,W,G,C)) :-
    \+ forbidden(state(F,W,G,C)).

% move/3
% move(++state, ?action, --next_state)
% можливі ходи фермера
% action: nothing, wolf, goat, cabbage

% фермер пливе сам
move(state(F,W,G,C), nothing, state(F2,W,G,C)) :-
    opposite(F,F2).

% фермер везе вовка
move(state(F,F,G,C), wolf, state(F2,F2,G,C)) :-
    opposite(F,F2).

% фермер везе козу
move(state(F,W,F,C), goat, state(F2,W,F2,C)) :-
    opposite(F,F2).

% фермер везе капусту
move(state(F,W,G,F), cabbage, state(F2,W,G,F2)) :-
    opposite(F,F2).

% path/4
% path(++current, ++goal, +visited, --path)
% рекурсивний пошук шляху без зациклення
path(state(F,W,G,C), state(F,W,G,C), _, [state(F,W,G,C)]).
path(Current, Goal, Visited, [Current|Path]) :-
    move(Current, _, Next),
    allowed(Next),
    \+ member(Next, Visited),
    path(Next, Goal, [Next|Visited], Path).

% solution/1
% solution(--path)
% мінімальний розв'язок задачі
solution(Path) :-
    start_state(Start),
    goal_state(Goal),
    between(1,20,_),
    path(Start, Goal, [Start], Path),
    !.

% print_path/1
% print_path(+path)
% вивід шляху у форматі state(farmer, wolf, goat, cabbage)
print_path([]).
print_path([state(F,W,G,C)|T]) :-
    format('state(farmer:~w, wolf:~w, goat:~w, cabbage:~w)~n', [F,W,G,C]),
    print_path(T).

% приклади використання
/** <examples>
?- solution(Path), print_path(Path).
?- solution(Path).
?- path(state(left,left,left,left), state(right,right,right,right),
[state(left,left,left,left)], Path).
*/
