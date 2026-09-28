(ns teste-clojure
  (:require [clojure.test :refer [deftest testing is run-tests]]
            [spanzuratoarea :as sp]))

;; ============================================================
;; Teste pentru implementarea Clojure a jocului Spanzuratoarea
;; ============================================================
;; Rulare: clojure -M teste/teste_clojure.clj
;; Folosim clojure.test - framework-ul standard din Clojure.
;; ============================================================

;; ---------- Teste pentru creeaza-stare ----------

(deftest test-creeaza-stare
  (testing "construieste stare corecta cu incercari implicite"
    (let [s (sp/creeaza-stare "test")]
      (is (= (:cuvant s)    [\t \e \s \t]))
      (is (= (:litere s)    #{}))
      (is (= (:incercari s) 6))))

  (testing "accepta numar custom de incercari"
    (let [s (sp/creeaza-stare "abc" 10)]
      (is (= (:incercari s) 10)))))

;; ---------- Teste pentru cuvant-mascat ----------

(deftest test-cuvant-mascat
  (testing "pune _ pentru litere neghicite"
    (is (= (sp/cuvant-mascat [\c \a \t] #{})
           "___")))

  (testing "dezvaluie literele ghicite"
    (is (= (sp/cuvant-mascat [\c \a \t] #{\a})
           "_a_")))

  (testing "cu toate literele ghicite"
    (is (= (sp/cuvant-mascat [\a \b] #{\a \b})
           "ab"))))

;; ---------- Teste pentru valid-ghicire? ----------

(deftest test-valid-ghicire
  (let [s (sp/creeaza-stare "test")]
    (testing "accepta o litera noua"
      (is (= (sp/valid-ghicire? "a" s) true)))

    (testing "respinge string gol"
      (is (= (sp/valid-ghicire? "" s) :nu-e-un-singur-caracter)))

    (testing "respinge mai multe caractere"
      (is (= (sp/valid-ghicire? "abc" s) :nu-e-un-singur-caracter)))

    (testing "respinge caractere nealfabetice"
      (is (= (sp/valid-ghicire? "1" s) :nu-e-litera))
      (is (= (sp/valid-ghicire? "!" s) :nu-e-litera))))

  (testing "respinge litere deja incercate"
    (let [s (sp/actualizeaza-stare (sp/creeaza-stare "test") \a)]
      (is (= (sp/valid-ghicire? "a" s) :deja-incercata)))))

;; ---------- Teste pentru actualizeaza-stare ----------

(deftest test-actualizeaza-stare
  (testing "cu litera corecta pastreaza incercarile"
    (let [s0 (sp/creeaza-stare "cat")
          s1 (sp/actualizeaza-stare s0 \a)]
      (is (= (:incercari s1) 6))
      (is (contains? (:litere s1) \a))))

  (testing "cu litera gresita decrementeaza incercarile"
    (let [s0 (sp/creeaza-stare "cat")
          s1 (sp/actualizeaza-stare s0 \z)]
      (is (= (:incercari s1) 5))
      (is (contains? (:litere s1) \z))))

  (testing "nu muta starea originala (imutabilitate)"
    (let [s0 (sp/creeaza-stare "cat")]
      (sp/actualizeaza-stare s0 \a)
      (sp/actualizeaza-stare s0 \z)
      ;; starea originala trebuie sa fie neschimbata
      (is (= (:litere s0)    #{}))
      (is (= (:incercari s0) 6)))))

;; ---------- Teste pentru conditiile de terminare ----------

(deftest test-castigat
  (testing "= true cand toate literele sunt ghicite"
    (let [s  (sp/creeaza-stare "ab")
          s1 (sp/actualizeaza-stare s  \a)
          s2 (sp/actualizeaza-stare s1 \b)]
      (is (sp/castigat? s2))))

  (testing "= false cand inca mai sunt litere de ghicit"
    (let [s  (sp/creeaza-stare "ab")
          s1 (sp/actualizeaza-stare s \a)]
      (is (not (sp/castigat? s1))))))

(deftest test-pierdut
  (testing "= true cand incercarile ajung la 0"
    (let [s  (sp/creeaza-stare "cat" 1)
          s1 (sp/actualizeaza-stare s \z)]
      (is (sp/pierdut? s1))))

  (testing "= false cand inca mai sunt incercari"
    (let [s (sp/creeaza-stare "cat")]
      (is (not (sp/pierdut? s))))))

;; ---------- Teste pentru alege-cuvant si lista cuvinte ----------

(deftest test-alege-cuvant
  (testing "intoarce un element din lista data"
    (let [lista  ["a" "b" "c"]
          ales   (sp/alege-cuvant lista)]
      (is (some #(= % ales) lista)))))

(deftest test-cuvinte
  (testing "toate cuvintele din lista sunt string-uri nevide"
    (doseq [c sp/cuvinte]
      (is (string? c))
      (is (pos? (count c))))))

;; ---------- Rulare automata ----------
;; Daca fisierul e rulat direct (nu doar incarcat), ruleaza testele.
(when (= *file* (System/getProperty "babashka.file"))
  (run-tests 'teste-clojure))

;; Pentru Clojure CLI standard:
(run-tests 'teste-clojure)