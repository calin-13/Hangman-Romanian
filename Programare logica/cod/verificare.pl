% verificare.pl - Verificarea corectitudinii propozitiilor

:- use_module(gramatica).

% Verifica daca o lista de cuvinte este o propozitie valida.
propozitie(Cuvinte) :-
    is_list(Cuvinte),
    Cuvinte \= [],
    propozitie(Cuvinte, []).

% Verifica si afiseaza rezultatul.
verifica_si_explica(Cuvinte) :-
    ( propozitie(Cuvinte) ->
        write('[OK] Propozitie valida: '),
        afiseaza_lista(Cuvinte)
    ;
        write('[X] Propozitie invalida: '),
        afiseaza_lista(Cuvinte)
    ).

% Afiseaza o lista de cuvinte.
afiseaza_lista([]) :- nl.
afiseaza_lista([X]) :- write(X), nl.
afiseaza_lista([X|Rest]) :-
    write(X), write(' '),
    afiseaza_lista(Rest).