% teste.pl - Teste pentru predicatele principale

:- use_module(gramatica).
:- [generare, verificare].

% Ruleaza toate testele.
ruleaza_teste :-
    write('=== Teste Verificare ==='), nl,
    teste_verificare,
    nl,
    write('=== Teste Acord Gramatical ==='), nl,
    teste_acord,
    nl,
    write('=== Teste Pronume Personale ==='), nl,
    teste_pronume,
    nl,
    write('=== Teste Complement ==='), nl,
    teste_complement,
    nl,
    write('=== Teste Adverbe ==='), nl,
    teste_adverbe,
    nl,
    write('=== Teste Edge-Case ==='), nl,
    teste_edge,
    nl,
    write('=== Teste Generare ==='), nl,
    teste_generare,
    nl,
    write('=== Toate testele finalizate ==='), nl.

% Teste verificare - propozitii valide si invalide.
teste_verificare :-
    test_valid([un, baiat, citeste]),
    test_valid([o, fata, scrie]),
    test_valid([un, copil, merge, la, o, scoala]),
    test_valid([o, fata, frumoasa, citeste, o, carte]),
    test_invalid([un, fata, citeste]),
    test_invalid([o, baiat, scrie]),
    test_invalid([citeste, un, baiat]),
    test_invalid([]).

% Teste acord gramatical.
teste_acord :-
    % acord articol-substantiv
    test_valid([un, om, merge]),
    test_valid([o, masa, merge]),
    test_valid([niste, baieti, citesc]),
    test_valid([niste, fete, scriu]),
    test_invalid([un, casa, merge]),
    test_invalid([o, copil, citeste]),
    % acord substantiv-adjectiv
    test_valid([un, baiat, frumos, merge]),
    test_valid([o, fata, frumoasa, merge]),
    test_valid([niste, baieti, frumosi, merg]),
    test_invalid([un, baiat, frumoasa, merge]),
    test_invalid([o, fata, frumos, scrie]),
    % acord subiect-verb (numar)
    test_valid([un, baiat, citeste]),
    test_valid([niste, baieti, citesc]),
    test_invalid([un, baiat, citesc]),
    test_invalid([niste, fete, scrie]).

% Teste pronume personale cu acord la persoana.
teste_pronume :-
    % persoana 1 singular
    test_valid([eu, citesc]),
    test_valid([eu, merg, la, o, scoala]),
    test_valid([eu, vad, un, prieten]),
    % persoana 2 singular
    test_valid([tu, citesti]),
    test_valid([tu, mergi, acasa]),
    test_valid([tu, scrii, o, carte]),
    % persoana 3 singular
    test_valid([el, citeste]),
    test_valid([ea, scrie]),
    % persoana 1 plural
    test_valid([noi, citim]),
    test_valid([noi, mergem, la, o, masa]),
    % persoana 2 plural
    test_valid([voi, cititi]),
    test_valid([voi, scrieti, o, carte]),
    % persoana 3 plural
    test_valid([ei, citesc]),
    test_valid([ele, scriu]),
    % acord gresit persoana
    test_invalid([eu, citeste]),
    test_invalid([tu, citesc]),
    test_invalid([eu, cititi]),
    test_invalid([noi, citeste]).

% Teste complement direct si prepozitional.
teste_complement :-
    test_valid([un, baiat, citeste, o, carte]),
    test_valid([o, fata, vede, un, copil]),
    test_valid([un, copil, merge, la, o, scoala]),
    test_valid([o, fata, scrie, in, o, casa]),
    test_valid([un, baiat, scrie, o, carte, la, o, masa]),
    test_valid([o, fata, citeste, o, carte, in, o, casa]),
    test_valid([eu, cumpar, o, carte, pentru, un, prieten]),
    test_valid([noi, mergem, cu, niste, prieteni]).

% Teste adverbe.
teste_adverbe :-
    test_valid([eu, merg, repede]),
    test_valid([tu, citesti, bine]),
    test_valid([el, merge, acolo]),
    test_valid([ea, scrie, mult]),
    test_valid([noi, mergem, acasa]),
    test_valid([un, baiat, merge, repede]),
    test_valid([o, fata, citeste, o, carte, bine]),
    test_invalid([eu, repede, merg]),
    test_invalid([repede, eu, merg]).

% Teste edge-case.
teste_edge :-
    test_invalid([]),
    test_invalid([citeste]),
    test_invalid([un, baiat]),
    test_invalid([un, un, baiat, citeste]),
    test_invalid([o, fata, scrie, scrie]),
    test_invalid([baiat, citeste]).

test_valid(P) :-
    ( propozitie(P) ->
        write('  PASS: '), afiseaza_lista(P)
    ;
        write('  FAIL (ar trebui valid): '), afiseaza_lista(P)
    ).

test_invalid(P) :-
    ( propozitie(P) ->
        write('  FAIL (ar trebui invalid): '), afiseaza_lista(P)
    ;
        write('  PASS (corect invalid): '), afiseaza_lista(P)
    ).

% Teste generare - genereaza 5 propozitii aleatorii.
teste_generare :-
    write('  Generez 5 propozitii aleatorii:'), nl,
    afiseaza_n(5).