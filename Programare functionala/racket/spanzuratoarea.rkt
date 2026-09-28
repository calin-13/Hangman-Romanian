#lang racket

;; ============================================================
;; Spanzuratoarea - Implementare in stil functional (Racket)
;; ============================================================
;; Starea jocului este o lista imutabila transmisa explicit
;; intre apelurile recursive. Fara variabile globale mutabile.
;; ============================================================

;; ---------- Lista de cuvinte predefinita ----------
;; Cuvinte romanesti fara diacritice pentru simplitate la input.
(define cuvinte
  '("programare"
    "recursie"
    "calculator"
    "tastatura"
    "fereastra"
    "biblioteca"
    "student"
    "laborator"
    "algoritm"
    "variabila"
    "matematica"
    "informatica"
    "functie"
    "limbaj"
    "compilator"
    "clojure"
    "racket"
    "scheme"
    "paradigma"
    "functional"
    "imutabil"
    "recursiv"
    "lambda"
    "expresie"
    "evaluare"
    "parametru"
    "argument"
    "constanta"
    "structura"
    "memorie"
    "procesor"
    "monitor"
    "imprimanta"
    "retea"
    "internet"
    "browser"
    "server"
    "client"
    "baza"
    "interogare"
    "tabel"
    "coloana"
    "criptare"
    "securitate"
    "parola"
    "utilizator"
    "sistem"
    "operare"
    "kernel"
    "proces"
    "fisier"
    "director"
    "terminal"
    "consola"
    "depanare"
    "eroare"
    "exceptie"
    "modul"
    "pachet"
    "versiune"
    "universitate"
    "facultate"
    "examen"
    "nota"
    "profesor"
    "seminar"
    "curs"
    "proiect"
    "tema"
    "cerinta"
    "raport"
    "prezentare"
    "echipa"
    "colaborare"
    "birou"
    "scaun"
    "masa"
    "carte"
    "caiet"
    "creion"
    "guma"
    "telefon"
    "ceas"
    "bucuresti"
    "cluj"
    "iasi"
    "timisoara"
    "constanta"
    "brasov"
    "sibiu"
    "romania"
    "munte"
    "padure"
    "rau"
    "lac"
    "marea"
    "oras"
    "sat"
    "strada"
    "parc"
    "gradina"
    "floare"
    "copac"
    "frunza"
    "pisica"
    "caine"
    "veverita"
    "vulpe"
    "iepure"
    "broasca"
    "fluture"
    "albina"
    "furnica"
    "soare"
    "luna"
    "stea"
    "nor"
    "ploaie"
    "zapada"
    "vant"
    "furtuna"
    "primavara"
    "toamna"
    "iarna"
    "dimineata"
    "seara"
    "noapte"
    "muzica"
    "chitara"
    "pian"
    "vioara"
    "cantec"
    "poezie"
    "povestire"
    "roman"
    "autor"
    "scriitor"
    "pictor"
    "tablou"
    "culoare"
    "portocaliu"
    "violet"
    "galben"
    "verde"
    "albastru"
    "bucatarie"
    "cuptor"
    "frigider"
    "farfurie"
    "lingura"
    "furculita"
    "paine"
    "branza"
    "ciocolata"
    "cafea"
    "ceai"
    "portocala"
    "capsuna"
    "zmeura"
    "castravete"
    "morcov"
    "cartof"
    "ciuperca"))

;; Alege un cuvant aleator din lista primita.
(define (alege-cuvant lista)
  (list-ref lista (random (length lista))))

;; ---------- Reprezentarea starii ----------
;; O stare este o lista de forma:
;;   (list cuvant-secret litere-ghicite incercari-ramase)
;; unde:
;;   - cuvant-secret     : lista de caractere
;;   - litere-ghicite    : lista de caractere (folosita ca set logic)
;;   - incercari-ramase  : numar natural

;; Constructor: creeaza o stare noua pornind de la un cuvant (string)
;; si, optional, numarul de incercari (implicit 6).
(define (creeaza-stare cuvant [incercari 6])
  (list (string->list cuvant) '() incercari))

;; Selectori: extrag componente din starea imutabila.
(define (stare-cuvant s)    (first s))
(define (stare-litere s)    (second s))
(define (stare-incercari s) (third s))

;; ---------- Afisarea starii ----------
;; Returneaza cuvantul cu literele neghicite mascate ca '_'.
;; Functie pura: nu face I/O, doar transformare de date.
(define (cuvant-mascat cuvant litere)
  (list->string
   (map (lambda (c)
          (if (member c litere) c #\_))
        cuvant)))

;; Afiseaza starea curenta pe stdout. Este singura functie cu efect
;; lateral din aceasta sectiune; restul raman pure.
(define (afiseaza-stare s)
  (define cuvant    (stare-cuvant s))
  (define litere    (stare-litere s))
  (define incercari (stare-incercari s))
  (printf "~n")
  (printf "Cuvant:            ~a~n"
          (string-join
           (map string (string->list (cuvant-mascat cuvant litere)))
           " "))
  (printf "Litere incercate:  ~a~n"
          (if (null? litere)
              "(niciuna)"
              (string-join (map string (reverse litere)) ", ")))
  (printf "Incercari ramase:  ~a~n" incercari))

;; ---------- Validarea input-ului ----------
;; Functie pura. Returneaza:
;;   #t            - daca input-ul este o litera valida si neincercata
;;   simbol motiv  - altfel (pentru mesaje clare de eroare)
;;
;; Am ales sa returnam un simbol in loc de #f ca sa transmitem
;; contextul erorii (de ce e invalid), nu doar ca e invalid.
(define (valid-ghicire? input s)
  (cond
    [(not (= (string-length input) 1))
     'nu-e-un-singur-caracter]
    [(not (char-alphabetic? (string-ref input 0)))
     'nu-e-litera]
    [(member (char-downcase (string-ref input 0)) (stare-litere s))
     'deja-incercata]
    [else #t]))

;; Traduce motivul intr-un mesaj lizibil pentru utilizator.
(define (mesaj-eroare motiv)
  (case motiv
    [(nu-e-un-singur-caracter) "Introdu exact un singur caracter."]
    [(nu-e-litera)             "Trebuie sa fie o litera alfabetica."]
    [(deja-incercata)          "Ai incercat deja aceasta litera."]
    [else                      "Input invalid."]))

;; ---------- Actualizarea starii (imutabila) ----------
;; Functie pura. Primeste starea curenta si o litera, returneaza
;; O STARE NOUA - starea veche nu este modificata nicaieri.
;;
;; Reguli:
;;   - litera este mereu adaugata la lista literelor incercate
;;   - daca litera exista in cuvant, incercarile raman aceleasi
;;   - daca litera nu exista, incercarile se decrementeaza cu 1
(define (actualizeaza-stare s litera)
  (define cuvant     (stare-cuvant s))
  (define litere     (stare-litere s))
  (define incercari  (stare-incercari s))
  (define litere-noi (cons litera litere))
  (if (member litera cuvant)
      (list cuvant litere-noi incercari)
      (list cuvant litere-noi (- incercari 1))))

;; ---------- Conditii de terminare ----------
;; Castigat = toate literele cuvantului sunt in literele ghicite.
;; andmap = "for all" peste o lista.
(define (castigat? s)
  (andmap (lambda (c) (member c (stare-litere s)))
          (stare-cuvant s)))

;; Pierdut = nu mai sunt incercari ramase.
(define (pierdut? s)
  (<= (stare-incercari s) 0))

;; ---------- Citire input ----------
;; Functie cu efect lateral: citeste o linie de la utilizator,
;; o curata si o normalizeaza la lowercase.
(define (citeste-litera)
  (display "Litera ta: ")
  (flush-output)
  (define linie (read-line))
  (if (eof-object? linie)
      ""
      (string-downcase (string-trim linie))))

;; ---------- Bucla principala recursiva ----------
;; Nucleul jocului. Primeste o stare si:
;;   1. afiseaza starea curenta
;;   2. verifica daca jocul s-a terminat (castig/pierdere)
;;   3. altfel, citeste o litera, o valideaza, actualizeaza starea
;;      si se autoapeleaza cu starea noua
;;
;; Recursivitatea e substitutul buclei while imperative: starea
;; "curge" prin apeluri succesive, niciodata modificata in loc.
(define (joaca s)
  (afiseaza-stare s)
  (cond
    [(castigat? s)
     (printf "~nFelicitari! Ai ghicit cuvantul: ~a~n"
             (list->string (stare-cuvant s)))]
    [(pierdut? s)
     (printf "~nAi pierdut! Cuvantul era: ~a~n"
             (list->string (stare-cuvant s)))]
    [else
     (define input (citeste-litera))
     (define rezultat (valid-ghicire? input s))
     (cond
       [(eq? rezultat #t)
        (define litera (char-downcase (string-ref input 0)))
        (joaca (actualizeaza-stare s litera))]
       [else
        (printf "~a~n" (mesaj-eroare rezultat))
        (joaca s)])]))

;; ---------- Punctul de pornire ----------
;; Porneste un joc nou cu un cuvant aleator.
(define (porneste-joc)
  (printf "~n=== Spanzuratoarea ===~n")
  (joaca (creeaza-stare (alege-cuvant cuvinte))))

;; Exportam identificatorii ca sa poata fi folositi de alte module.
(provide cuvinte
         alege-cuvant
         creeaza-stare
         stare-cuvant
         stare-litere
         stare-incercari
         cuvant-mascat
         afiseaza-stare
         valid-ghicire?
         mesaj-eroare
         actualizeaza-stare
         castigat?
         pierdut?
         citeste-litera
         joaca
         porneste-joc)

;; Porneste automat jocul cand fisierul e rulat direct.
(module+ main
  (porneste-joc))