# Generarea unui Limbaj - Limba Romana

Proiect implementat in SWI-Prolog folosind **DCG (Definite Clause Grammars)**.
DCG este un mecanism Prolog care permite definirea regulilor de productie ale
unei gramatici direct ca clauze, iar Prolog genereaza automat predicatele de
parsare corespunzatoare. Acelasi set de reguli poate fi folosit atat pentru
**verificare** cat si pentru **generare** prin backtracking.

## Descrierea Problemei

Pornind de la o gramatica formala cu simboluri terminale, neterminale si
reguli de productie, sa se genereze expresii corecte gramatical in limba romana.

Problema consta in definirea unei gramatici formale pentru limba romana si
implementarea unui sistem care poate genera propozitii valide si verifica
daca o secventa de cuvinte respecta regulile gramaticale. Sistemul trebuie
sa respecte acordul gramatical intre partile propozitiei (gen, numar, persoana).

## Solutie

Gramatica a fost implementata in Prolog folosind DCG (Definite Clause Grammars),
un mecanism care permite definirea regulilor de productie direct ca clauze Prolog.
Fiecare regula DCG descrie cum se construieste un simbol neterminal din alte
simboluri, iar Prolog genereaza automat predicatele de parsare corespunzatoare.

Acordul gramatical este implementat prin propagarea atributelor (gen, numar,
persoana) intre simbolurile gramaticii. De exemplu, subiectul transmite numarul
si persoana catre predicat, iar articolul transmite genul si numarul catre
substantiv si adjectiv.

---

## Structura Proiectului

```
tema4-prolog/
|
|-- cod/
|   |-- gramatica.pl         % Regulile DCG si lexiconul limbii
|   |-- generare.pl          % Predicatele de generare a propozitiilor
|   |-- verificare.pl        % Predicatul de verificare a corectitudinii
|   |-- teste.pl             % Teste manuale pentru toate predicatele
|-- doc/
|   |-- generare_limba_romana.ipynb  % Documentatie cu exemple ilustrative
|-- teste/
|   |-- rezultate_teste.txt  % Rezultatele rularii testelor manuale
|-- README.md                % Acest fisier
```

### gramatica.pl

Contine lexiconul (simbolurile terminale) si regulile DCG (simbolurile neterminale).
Lexiconul include substantive cu gen si numar, verbe conjugate la toate cele trei
persoane si ambele numere, adjective cu acord in gen si numar, articole, pronume
personale, adverbe si prepozitii. Regulile DCG descriu structura propozitiei si
propaga atributele de acord intre componente.

### generare.pl

Contine predicatele pentru generarea propozitiilor valide. Foloseste regulile DCG
din gramatica pentru a enumera propozitii corecte. Ofera generare sistematica,
generare aleatoare si afisare formatata.

### verificare.pl

Contine predicatele pentru verificarea corectitudinii unei propozitii date ca
lista de cuvinte. Foloseste aceleasi reguli DCG ca generarea, dar in sens invers,
pentru a verifica daca o secventa de cuvinte respecta gramatica.

### teste.pl

Contine teste manuale organizate pe categorii: verificare de baza, acord
gramatical, pronume personale, complemente, adverbe si cazuri limita.
Se ruleaza apeland ruleaza_teste/0. Fiecare test verifica atat propozitii
valide cat si propozitii invalide si afiseaza PASS sau FAIL.

---

## Gramatica

### Simboluri Neterminale

| Simbol        | Descriere                     |
|---------------|-------------------------------|
| propozitie    | O propozitie completa         |
| sintagma_nom  | Sintagma nominala (subiect)   |
| sintagma_verb | Sintagma verbala (predicat)   |
| complement    | Complement prepozitional      |

### Simboluri Terminale

- Substantive (cu gen si numar): baiat, fata, carte, copil, casa, masa, scoala, prieten, floare, ...
- Verbe (cu persoana si numar): citesc/citesti/citeste/citim/cititi, merg/mergi/merge/mergem/mergeti, ...
- Adjective (cu gen si numar): mare, frumos, frumoasa, mic, bun, destept, ...
- Articole (cu gen si numar): un, o, niste
- Pronume personale: eu, tu, el, ea, noi, voi, ei, ele
- Adverbe: repede, bine, acolo, acasa, devreme, mult
- Prepozitii: la, in, cu, pe, din, pentru

### Reguli de Productie

```
propozitie       --> sintagma_nom, sintagma_verb
sintagma_nom     --> articol, substantiv
sintagma_nom     --> articol, substantiv, adjectiv
sintagma_nom     --> pronume
sintagma_verb    --> verb
sintagma_verb    --> verb, adverb
sintagma_verb    --> verb, sintagma_nom
sintagma_verb    --> verb, sintagma_nom, adverb
sintagma_verb    --> verb, complement
sintagma_verb    --> verb, sintagma_nom, complement
complement       --> prepozitie, sintagma_nom
```

---

## Acordul Gramatical

Sistemul verifica acordul gramatical intre:

- Articol - Substantiv: acord in gen si numar
  - un baiat (masculin, singular) [OK]
  - o fata (feminin, singular) [OK]
- Substantiv - Adjectiv: acord in gen si numar
  - baiat frumos (masculin, singular) [OK]
  - fata frumoasa (feminin, singular) [OK]
- Subiect - Predicat: acord in numar si persoana
  - un baiat citeste (singular, persoana 3) [OK]
  - niste baieti citesc (plural, persoana 3) [OK]
  - eu citesc (singular, persoana 1) [OK]
  - tu citesti (singular, persoana 2) [OK]
  - noi citim (plural, persoana 1) [OK]
  - voi cititi (plural, persoana 2) [OK]

---

## Utilizare

### Incarcarea proiectului

```prolog
?- [cod/teste].
```

### Generarea unei propozitii

```prolog
?- genereaza(P).
P = [un, baiat, citeste] ;
P = [eu, merg, repede] ;
P = [tu, citesti, o, carte] ;

?- genereaza_random(P).
P = [o, fata, frumoasa, scrie, o, carte]

?- afiseaza_n(5).
eu merg acasa.
tu citesti bine.
noi mergem la o scoala.
un baiat frumos vede o fata.
ele scriu niste carti.
```

### Verificarea unei propozitii

```prolog
?- propozitie([eu, citesc, o, carte]).
true.

?- propozitie([eu, citeste, o, carte]).
false.

?- propozitie([tu, mergi, repede]).
true.
```

### Rulare Teste

```prolog
?- [cod/teste].
?- ruleaza_teste.
```

---

## Cerinte Acoperite

| Cerinta                                     | Status |
|---------------------------------------------|--------|
| Definirea terminalilor si neterminalilor     | [x]    |
| Implementarea regulilor gramaticale de baza  | [x]    |
| Acordul gramatical (gen, numar, persoana)    | [x]    |
| Predicat de generare a propozitiilor         | [x]    |
| Predicat de verificare                       | [x]    |
| Varietatea propozitiilor generate            | [x]    |
| Documentatie                                 | [x]    |

Legenda: [x] complet | [~] partial | [ ] de facut

# Membri:
- Palaghia Andrei
- Iosif Alexandru
- Barbu Calin
- Munteanu Marius