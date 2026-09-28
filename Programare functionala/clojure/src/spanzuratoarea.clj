;; ============================================================
;; Spanzuratoarea - Implementare in stil functional (Clojure)
;; ============================================================
;; Starea jocului este un map imutabil transmis explicit
;; intre apelurile recursive. Fara variabile globale mutabile.
;; ============================================================

(ns spanzuratoarea
  (:require [clojure.string :as str])
  (:gen-class))

;; ---------- Lista de cuvinte predefinita ----------
(def cuvinte
  ["programare"
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
   "biblioteca"
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
   "ciuperca"])

;; Alege un cuvant aleator din vectorul primit.
(defn alege-cuvant [lista]
  (nth lista (rand-int (count lista))))

;; ---------- Reprezentarea starii ----------
;; O stare este un map cu cheile:
;;   :cuvant    - vector de caractere (cuvantul secret)
;;   :litere    - set de caractere (O(1) lookup, spre deosebire de lista Racket)
;;   :incercari - numar natural (incercari ramase)

(defn creeaza-stare
  ([cuvant] (creeaza-stare cuvant 6))
  ([cuvant incercari]
   {:cuvant    (vec cuvant)
    :litere    #{}
    :incercari incercari}))

;; Selectori
(defn stare-cuvant    [s] (:cuvant s))
(defn stare-litere    [s] (:litere s))
(defn stare-incercari [s] (:incercari s))

;; ---------- Afisarea starii ----------
;; Functie pura: returneaza cuvantul mascat, fara I/O.
(defn cuvant-mascat [cuvant litere]
  (apply str (map #(if (contains? litere %) % \_) cuvant)))

;; Afiseaza starea curenta - singura functie cu efect lateral din sectiune.
(defn afiseaza-stare [s]
  (let [cuvant    (stare-cuvant s)
        litere    (stare-litere s)
        incercari (stare-incercari s)]
    (println)
    (println (str "Cuvant:            "
                  (str/join " " (map str (cuvant-mascat cuvant litere))))) 
    (println (str "Litere incercate:  "
                  (if (empty? litere)
                    "(niciuna)"
                    (str/join ", " (sort (map str litere)))))) 
    (println (str "Incercari ramase:  " incercari)))) 

;; ---------- Validarea input-ului ----------
;; Functie pura. Returneaza:
;;   true             - input valid si neincercat
;;   keyword :motiv   - altfel (Clojure foloseste keywords, Racket folosea simboluri)
(defn valid-ghicire? [input s]
  (cond
    (not= (count input) 1)
    :nu-e-un-singur-caracter

    ;; (first input) e sigur non-nil aici, deoarece count = 1
    (not (Character/isLetter (char (first input))))
    :nu-e-litera

    (contains? (stare-litere s) (Character/toLowerCase (char (first input))))
    :deja-incercata

    :else true))

(defn mesaj-eroare [motiv]
  (case motiv
    :nu-e-un-singur-caracter "Introdu exact un singur caracter."
    :nu-e-litera             "Trebuie sa fie o litera alfabetica."
    :deja-incercata          "Ai incercat deja aceasta litera."
    "Input invalid."))

;; ---------- Actualizarea starii (imutabila) ----------
;; Functie pura. Returneaza o STARE NOUA via assoc/update/conj.
;; Clojure are update+conj nativ; Racket construia manual cu cons/list.
(defn actualizeaza-stare [s litera]
  (let [s-nou (update s :litere conj litera)]
    (if (some #{litera} (stare-cuvant s))
      s-nou
      (update s-nou :incercari dec))))

;; ---------- Conditii de terminare ----------
(defn castigat? [s]
  (every? #(contains? (stare-litere s) %) (stare-cuvant s)))

(defn pierdut? [s]
  (<= (stare-incercari s) 0))

;; ---------- Citire input ----------
(defn citeste-litera []
  (print "Litera ta: ")
  (flush)
  (let [linie (read-line)]
    (if (nil? linie)
      ""
      (str/lower-case (str/trim linie)))))

;; ---------- Bucla principala recursiva ----------
;; Folosim loop/recur in loc de apel direct recursiv, deoarece JVM nu
;; garanteaza TCO automat (spre deosebire de Racket care il face nativ).
(defn joaca [stare-initiala]
  (loop [s stare-initiala]
    (afiseaza-stare s)
    (cond
      (castigat? s)
      (println (str "\nFelicitari! Ai ghicit cuvantul: "
                    (apply str (stare-cuvant s))))

      (pierdut? s)
      (println (str "\nAi pierdut! Cuvantul era: "
                    (apply str (stare-cuvant s))))

      :else
      (let [input    (citeste-litera)
            rezultat (valid-ghicire? input s)]
        (if (true? rezultat)
          (recur (actualizeaza-stare s (Character/toLowerCase (char (first input)))))
          (do
            (println (mesaj-eroare rezultat))
            (recur s)))))))

;; ---------- Punctul de pornire ----------
(defn porneste-joc []
  (println "\n=== Spanzuratoarea ===")
  (joaca (creeaza-stare (alege-cuvant cuvinte))))

(defn -main [& _args]
  (porneste-joc))