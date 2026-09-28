% gramatica.pl - Reguli DCG pentru limba romana

:- module(gramatica, [
    propozitie//0,
    sintagma_nom//2,
    sintagma_verb//2,
    complement//0
]).

% Simboluri terminale

% Substantive

substantiv(baiat,    masculin, singular).
substantiv(baieti,   masculin, plural).
substantiv(copil,    masculin, singular).
substantiv(copii,    masculin, plural).
substantiv(om,       masculin, singular).
substantiv(oameni,   masculin, plural).
substantiv(prieten,  masculin, singular).
substantiv(prieteni, masculin, plural).

substantiv(fata,     feminin, singular).
substantiv(fete,     feminin, plural).
substantiv(carte,    feminin, singular).
substantiv(carti,    feminin, plural).
substantiv(casa,     feminin, singular).
substantiv(case,     feminin, plural).
substantiv(masa,     feminin, singular).
substantiv(mese,     feminin, plural).
substantiv(scoala,   feminin, singular).
substantiv(scoli,    feminin, plural).
substantiv(floare,   feminin, singular).
substantiv(flori,    feminin, plural).

% Articole nehotarate

articol(un,    masculin, singular).
articol(o,     feminin,  singular).
articol(niste, _,        plural).

% Pronume personale (Forma, Numar, Persoana)

pronume(eu,   singular, 1).
pronume(tu,   singular, 2).
pronume(el,   singular, 3).
pronume(ea,   singular, 3).
pronume(noi,  plural,   1).
pronume(voi,  plural,   2).
pronume(ei,   plural,   3).
pronume(ele,  plural,   3).

% Verbe (Forma, Numar, Persoana)

verb(citesc,   singular, 1).
verb(citesti,  singular, 2).
verb(citeste,  singular, 3).
verb(citim,    plural,   1).
verb(cititi,   plural,   2).
verb(citesc,   plural,   3).

verb(scriu,    singular, 1).
verb(scrii,    singular, 2).
verb(scrie,    singular, 3).
verb(scriem,   plural,   1).
verb(scrieti,  plural,   2).
verb(scriu,    plural,   3).

verb(mananc,   singular, 1).
verb(mananci,  singular, 2).
verb(mananca,  singular, 3).
verb(mancam,   plural,   1).
verb(mancati,  plural,   2).
verb(mananca,  plural,   3).

verb(merg,     singular, 1).
verb(mergi,    singular, 2).
verb(merge,    singular, 3).
verb(mergem,   plural,   1).
verb(mergeti,  plural,   2).
verb(merg,     plural,   3).

verb(vad,      singular, 1).
verb(vezi,     singular, 2).
verb(vede,     singular, 3).
verb(vedem,    plural,   1).
verb(vedeti,   plural,   2).
verb(vad,      plural,   3).

verb(cumpar,   singular, 1).
verb(cumperi,  singular, 2).
verb(cumpara,  singular, 3).
verb(cumparam, plural,   1).
verb(cumparati,plural,   2).
verb(cumpara,  plural,   3).

% Adjective

adjectiv(mare,     _,        singular).
adjectiv(mari,     _,        plural).
adjectiv(mic,      masculin, singular).
adjectiv(mica,     feminin,  singular).
adjectiv(mici,     _,        plural).
adjectiv(frumos,   masculin, singular).
adjectiv(frumoasa, feminin,  singular).
adjectiv(frumosi,  masculin, plural).
adjectiv(frumoase, feminin,  plural).
adjectiv(bun,      masculin, singular).
adjectiv(buna,     feminin,  singular).
adjectiv(buni,     masculin, plural).
adjectiv(bune,     feminin,  plural).
adjectiv(destept,  masculin, singular).
adjectiv(desteapta,feminin,  singular).

% Adverbe

adverb(repede).
adverb(bine).
adverb(acolo).
adverb(acasa).
adverb(devreme).
adverb(mult).

% Prepozitii

prepozitie(la).
prepozitie(in).
prepozitie(cu).
prepozitie(pe).
prepozitie(din).
prepozitie(pentru).

% Reguli DCG

% Propozitie

propozitie -->
    sintagma_nom(Numar, Persoana),
    sintagma_verb(Numar, Persoana).

% Sintagma Nominala

sintagma_nom(Numar, 3) -->
    [Art],
    { articol(Art, Gen, Numar) },
    [Sub],
    { substantiv(Sub, Gen, Numar) }.

sintagma_nom(Numar, 3) -->
    [Art],
    { articol(Art, Gen, Numar) },
    [Sub],
    { substantiv(Sub, Gen, Numar) },
    [Adj],
    { adjectiv(Adj, Gen, Numar) }.

sintagma_nom(Numar, Persoana) -->
    [Pron],
    { pronume(Pron, Numar, Persoana) }.

% Sintagma Verbala

sintagma_verb(Numar, Persoana) -->
    [V],
    { verb(V, Numar, Persoana) }.

sintagma_verb(Numar, Persoana) -->
    [V],
    { verb(V, Numar, Persoana) },
    [Adv],
    { adverb(Adv) }.

sintagma_verb(Numar, Persoana) -->
    [V],
    { verb(V, Numar, Persoana) },
    sintagma_nom(_, _).

sintagma_verb(Numar, Persoana) -->
    [V],
    { verb(V, Numar, Persoana) },
    sintagma_nom(_, _),
    [Adv],
    { adverb(Adv) }.

sintagma_verb(Numar, Persoana) -->
    [V],
    { verb(V, Numar, Persoana) },
    complement.

sintagma_verb(Numar, Persoana) -->
    [V],
    { verb(V, Numar, Persoana) },
    sintagma_nom(_, _),
    complement.

% Complement prepozitional

complement -->
    [Prep],
    { prepozitie(Prep) },
    sintagma_nom(_, _).