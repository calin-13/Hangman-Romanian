% generare.pl - Generare propozitii

:- use_module(gramatica).

% Genereaza o propozitie valida.
genereaza(Propozitie) :-
    propozitie(Propozitie, []).

% Colecteaza Max propozitii (fara a le genera pe toate).
genereaza_max(Max, Lista) :-
    findnsols(Max, P, genereaza(P), Lista), !.

% Genereaza o propozitie aleatoare.
genereaza_random(Propozitie) :-
    genereaza_max(200, Toate),
    length(Toate, Len),
    random_between(1, Len, Index),
    nth1(Index, Toate, Propozitie).

% Genereaza N propozitii distincte.
genereaza_n(N, Propozitii) :-
    genereaza_max(200, Toate),
    random_permutation(Toate, Amestecate),
    length(Toate, Len),
    Min is min(N, Len),
    length(Propozitii, Min),
    append(Propozitii, _, Amestecate).

% Afiseaza o propozitie.
afiseaza_propozitie([]) :- nl.
afiseaza_propozitie([Cuvant]) :-
    write(Cuvant), write('.'), nl.
afiseaza_propozitie([Cuvant|Rest]) :-
    write(Cuvant), write(' '),
    afiseaza_propozitie(Rest).

% Genereaza si afiseaza N propozitii.
afiseaza_n(N) :-
    genereaza_n(N, Propozitii),
    forall(
        member(P, Propozitii),
        afiseaza_propozitie(P)
    ).
