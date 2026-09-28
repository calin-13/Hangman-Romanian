Hangman - Functional Programming

Implementation of the classic “Hangman” game in a purely functional style, in Racket (Scheme) and Clojure.

The game state (the word to guess, guessed letters, number of remaining attempts) is passed explicitly between recursive calls, without mutable global variables.

Implemented functional requirements

* State representation - immutable structure (list in Racket, map in Clojure) containing the secret word, guessed letters, and the number of remaining attempts (default 6).
* Display state (afiseaza-stare) - shows the word with unknown letters masked as _, the letters already attempted, and the remaining attempts.
* Input validation (valid-ghicire) - checks whether the input is a single alphabetic character that has not been attempted before. Returns a symbol/keyword indicating the reason when the input is invalid.
* State update (actualizeaza-stare) - returns a new (immutable) state: reveals the positions of a correct letter or decrements the number of attempts.
* Main recursive loop (joaca) - checks for termination, displays the state, reads input, updates the state, and calls itself recursively with the new state.
* Word list - word randomly selected at the beginning from a predefined list (~163 Romanian words without diacritics).

Project structure

Programare functionala/
├── README.md                   ← this file
├── Makefile                    ← quick commands for running and testing
├── racket/
│   └── spanzuratoarea.rkt      ← Racket implementation
├── clojure/
│   └── src/
│       └── spanzuratoarea.clj  ← Clojure implementation
└── teste/
    ├── tests_racket.rkt        ← Racket unit tests (rackunit)
    └── teste_clojure.clj       ← Clojure unit tests (clojure.test)

How to run the game

Using Makefile (recommended)

make run-racket    # starts the game in Racket
make run-clojure   # starts the game in Clojure

Racket (manual)

You need Racket installed (version 8.0+ recommended).

racket racket/spanzuratoarea.rkt

Clojure (manual)

You need Clojure CLI installed.

clojure -Sdeps '{:paths ["clojure/src"]}' \
  -M -e "(load-file \"clojure/src/spanzuratoarea.clj\")(spanzuratoarea/porneste-joc)"

How to run the tests

Using Makefile (recommended)

make test          # runs both test suites
make test-racket   # Racket only
make test-clojure  # Clojure only

Racket tests (manual)

racket teste/tests_racket.rkt

If all tests pass, you will see: Toate testele au trecut cu succes.

Clojure tests (manual)

clojure -Sdeps '{:paths ["clojure/src" "teste"]}' \
  -M -e "(load-file \"teste/teste_clojure.clj\")"

The result displays how many assertions passed and how many failed.

Design decisions

Key differences between implementations

Aspect	Racket	Clojure
State structure	list with 3 positions	map with keys :cuvant, :litere, :incercari
Letter collection	list	set (#{})
Error tags	symbols ('nu-e-litera)	keywords (:nu-e-litera)
Recursion	direct call (native TCO)	explicit recur (required by JVM)
Immutable update	manual construction with cons/list	native update, assoc, conj
Membership test	member (O(n))	contains? on set (O(1))

Functional principles followed

* Immutability - no function mutates the arguments it receives; all return new values.
* Pure/impure separation - functions that perform I/O (afiseaza-stare, citeste-litera) are isolated and thin; the logic is in pure functions, easy to test.
* No mutable global variables - the only global define/def declarations are constants (the word list) or function definitions.
* Recursion instead of loops - joaca calls itself recursively with the updated state.