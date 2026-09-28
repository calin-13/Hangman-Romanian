# Spanzuratoarea - Programare Functionala

Implementare a jocului clasic "Spanzuratoarea" in stil pur functional, in **Racket** (Scheme) si **Clojure**.

Starea jocului (cuvantul de ghicit, literele ghicite, numarul de incercari ramase) este transmisa explicit intre apelurile recursive, **fara variabile globale mutabile**.

## Cerinte functionale implementate

- **Reprezentarea starii** - structura imutabila (lista in Racket, map in Clojure) continand cuvantul secret, literele ghicite si numarul de incercari ramase (implicit 6).
- **Afisare stare** (`afiseaza-stare`) - arata cuvantul cu litere necunoscute mascate ca `_`, literele deja incercate si incercarile ramase.
- **Validare input** (`valid-ghicire`) - verifica daca intrarea este un singur caracter alfabetic, neincercat anterior. Returneaza simbol/keyword cu motivul cand input-ul este invalid.
- **Actualizare stare** (`actualizeaza-stare`) - returneaza o stare **noua** (imutabila): dezvaluie pozitiile literei corecte sau decrementeaza incercarile.
- **Bucla principala recursiva** (`joaca`) - verifica terminarea, afiseaza starea, citeste input, actualizeaza si se autoapeleaza cu noua stare.
- **Lista de cuvinte** - cuvant ales aleator la inceput dintr-o lista predefinita (~163 cuvinte romanesti fara diacritice).

## Structura proiectului

```
Programare functionala/
├── README.md                   ← acest fisier
├── Makefile                    ← comenzi rapide pentru rulare si testare
├── racket/
│   └── spanzuratoarea.rkt      ← implementare Racket
├── clojure/
│   └── src/
│       └── spanzuratoarea.clj  ← implementare Clojure
└── teste/
    ├── tests_racket.rkt        ← teste unitare Racket (rackunit)
    └── teste_clojure.clj       ← teste unitare Clojure (clojure.test)
```

## Cum rulezi jocul

### Folosind Makefile (recomandat)

```bash
make run-racket    # porneste jocul in Racket
make run-clojure   # porneste jocul in Clojure
```

### Racket (manual)

Ai nevoie de [Racket](https://racket-lang.org/) instalat (versiunea 8.0+ recomandata).

```bash
racket racket/spanzuratoarea.rkt
```

### Clojure (manual)

Ai nevoie de [Clojure CLI](https://clojure.org/guides/install_clojure) instalat.

```bash
clojure -Sdeps '{:paths ["clojure/src"]}' \
  -M -e "(load-file \"clojure/src/spanzuratoarea.clj\")(spanzuratoarea/porneste-joc)"
```

## Cum rulezi testele

### Folosind Makefile (recomandat)

```bash
make test          # ruleaza ambele suite
make test-racket   # doar Racket
make test-clojure  # doar Clojure
```

### Teste Racket (manual)

```bash
racket teste/tests_racket.rkt
```

Daca toate testele trec, vei vedea: `Toate testele au trecut cu succes.`

### Teste Clojure (manual)

```bash
clojure -Sdeps '{:paths ["clojure/src" "teste"]}' \
  -M -e "(load-file \"teste/teste_clojure.clj\")"
```

Rezultatul afiseaza cate aserturi au trecut si cate au esuat.

## Decizii de design

### Diferente cheie intre implementari

| Aspect                   | Racket                              | Clojure                                             |
|--------------------------|-------------------------------------|-----------------------------------------------------|
| Structura stare          | `list` cu 3 pozitii                 | `map` cu cheile `:cuvant`, `:litere`, `:incercari`  |
| Colectie litere          | `list`                              | `set` (`#{}`)                                       |
| Tag-uri erori            | simboluri (`'nu-e-litera`)          | keywords (`:nu-e-litera`)                           |
| Recursie                 | apel direct (TCO nativ)             | `recur` explicit (JVM necesita)                     |
| Update imutabil          | construire manuala cu `cons`/`list` | `update`, `assoc`, `conj` native                    |
| Test apartenenta         | `member` (O(n))                     | `contains?` pe set (O(1))                           |

### Principii functionale respectate

- **Imutabilitate** - nicio functie nu muta argumentele primite; toate returneaza valori noi.
- **Separarea pur/impur** - functiile care fac I/O (`afiseaza-stare`, `citeste-litera`) sunt izolate si subtiri; logica e in functii pure, usor de testat.
- **Fara variabile globale mutabile** - singurele `define`/`def` globale sunt constante (lista de cuvinte) sau definitii de functii.
- **Recursie in loc de bucle** - `joaca` se autoapeleaza cu starea actualizata.

## Echipa

- Palaghia Andrei
- Iosif Alexandru
- Munteanu Marius
- Barbu Calin

## Link git

https://github.com/marius-27/Spanzuratoarea.git
