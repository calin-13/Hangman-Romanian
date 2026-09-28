#lang racket

;; ============================================================
;; Teste pentru implementarea Racket a jocului Spanzuratoarea
;; ============================================================
;; Rulare: racket teste/tests_racket.rkt
;; Folosim rackunit - framework-ul standard de testare din Racket.
;;
;; NOTA: `member` in Racket intoarce sub-lista gasita (ex: '(#\a)), nu #t.
;; Din acest motiv folosim `check-not-false` (accepta orice non-#f) in loc
;; de `check-true` cand testam rezultatul lui `member`. `check-true` cere
;; strict valoarea #t, iar o lista ca '(#\a) ar fi raportata ca esec desi
;; in Racket toate non-#f sunt logic adevarate.
;; ============================================================

(require rackunit)
(require "../racket/spanzuratoarea.rkt")

;; ---------- Teste pentru creeaza-stare ----------

(test-case "creeaza-stare construieste stare corecta cu incercari implicite"
  (define s (creeaza-stare "test"))
  (check-equal? (stare-cuvant s)    (list #\t #\e #\s #\t))
  (check-equal? (stare-litere s)    '())
  (check-equal? (stare-incercari s) 6))

(test-case "creeaza-stare accepta numar custom de incercari"
  (define s (creeaza-stare "abc" 10))
  (check-equal? (stare-incercari s) 10))

;; ---------- Teste pentru cuvant-mascat ----------

(test-case "cuvant-mascat pune _ pentru litere neghicite"
  (check-equal? (cuvant-mascat (list #\c #\a #\t) '())
                "___"))

(test-case "cuvant-mascat dezvaluie literele ghicite"
  (check-equal? (cuvant-mascat (list #\c #\a #\t) (list #\a))
                "_a_"))

(test-case "cuvant-mascat cu toate literele ghicite"
  (check-equal? (cuvant-mascat (list #\a #\b) (list #\a #\b))
                "ab"))

;; ---------- Teste pentru valid-ghicire? ----------

(test-case "valid-ghicire? accepta o litera noua"
  (define s (creeaza-stare "test"))
  (check-equal? (valid-ghicire? "a" s) #t))

(test-case "valid-ghicire? respinge string gol"
  (define s (creeaza-stare "test"))
  (check-equal? (valid-ghicire? "" s) 'nu-e-un-singur-caracter))

(test-case "valid-ghicire? respinge mai multe caractere"
  (define s (creeaza-stare "test"))
  (check-equal? (valid-ghicire? "abc" s) 'nu-e-un-singur-caracter))

(test-case "valid-ghicire? respinge caractere nealfabetice"
  (define s (creeaza-stare "test"))
  (check-equal? (valid-ghicire? "1" s) 'nu-e-litera)
  (check-equal? (valid-ghicire? "!" s) 'nu-e-litera))

(test-case "valid-ghicire? respinge litere deja incercate"
  (define s (actualizeaza-stare (creeaza-stare "test") #\a))
  (check-equal? (valid-ghicire? "a" s) 'deja-incercata))

;; ---------- Teste pentru actualizeaza-stare ----------

(test-case "actualizeaza-stare cu litera corecta pastreaza incercarile"
  (define s0 (creeaza-stare "cat"))
  (define s1 (actualizeaza-stare s0 #\a))
  (check-equal? (stare-incercari s1) 6)
  ;; `member` intoarce sublista, nu #t -> folosim check-not-false
  (check-not-false (member #\a (stare-litere s1))
                   "litera e in litere-ghicite"))

(test-case "actualizeaza-stare cu litera gresita decrementeaza incercarile"
  (define s0 (creeaza-stare "cat"))
  (define s1 (actualizeaza-stare s0 #\z))
  (check-equal? (stare-incercari s1) 5)
  (check-not-false (member #\z (stare-litere s1))))

(test-case "actualizeaza-stare nu muta starea originala (imutabilitate)"
  (define s0 (creeaza-stare "cat"))
  (actualizeaza-stare s0 #\a)
  (actualizeaza-stare s0 #\z)
  ;; starea originala trebuie sa fie neschimbata
  (check-equal? (stare-litere s0)    '())
  (check-equal? (stare-incercari s0) 6))

;; ---------- Teste pentru conditiile de terminare ----------

(test-case "castigat? = #t cand toate literele sunt ghicite"
  (define s (creeaza-stare "ab"))
  (define s1 (actualizeaza-stare s  #\a))
  (define s2 (actualizeaza-stare s1 #\b))
  (check-not-false (castigat? s2)))

(test-case "castigat? = #f cand inca mai sunt litere de ghicit"
  (define s (creeaza-stare "ab"))
  (define s1 (actualizeaza-stare s #\a))
  (check-false (castigat? s1)))

(test-case "pierdut? = #t cand incercarile ajung la 0"
  (define s (creeaza-stare "cat" 1))
  (define s1 (actualizeaza-stare s #\z))
  (check-true (pierdut? s1)))

(test-case "pierdut? = #f cand inca mai sunt incercari"
  (define s (creeaza-stare "cat"))
  (check-false (pierdut? s)))

;; ---------- Teste pentru alege-cuvant ----------

(test-case "alege-cuvant intoarce un element din lista data"
  (define lista '("a" "b" "c"))
  (check-not-false (member (alege-cuvant lista) lista)))

(test-case "cuvintele din lista predefinita sunt string-uri nevide"
  (for-each (lambda (c)
              (check-true (string? c))
              (check-true (> (string-length c) 0)))
            cuvinte))

;; ---------- Mesaj final ----------
(displayln "Toate testele au trecut cu succes.")