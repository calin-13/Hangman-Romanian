# ============================================================
# Makefile pentru proiectul Spanzuratoarea (Windows)
# ============================================================
# Rulare:
#   make              - afiseaza acest ajutor
#   make run-racket   - porneste jocul in Racket
#   make run-clojure  - porneste jocul in Clojure
#   make test-racket  - ruleaza testele Racket
#   make test-clojure - ruleaza testele Clojure
#   make test         - ruleaza ambele suite de teste
#   make check        - verifica ca Racket si Clojure sunt instalate
#   make clean        - sterge fisierele temporare/compilate
# ============================================================

# Folosim PowerShell ca shell pe Windows
SHELL = powershell.exe
.SHELLFLAGS = -NoProfile -Command

.PHONY: help run run-racket run-clojure test test-racket test-clojure check clean

# Target implicit: afiseaza ajutorul cand rulezi doar `make`
help:
	@Write-Host ''
	@Write-Host 'Proiect Spanzuratoarea - Programare Functionala'
	@Write-Host '================================================'
	@Write-Host ''
	@Write-Host '  make run-racket    - porneste jocul in Racket'
	@Write-Host '  make run-clojure   - porneste jocul in Clojure'
	@Write-Host '  make test-racket   - ruleaza testele Racket'
	@Write-Host '  make test-clojure  - ruleaza testele Clojure'
	@Write-Host '  make test          - ruleaza ambele suite de teste'
	@Write-Host '  make check         - verifica daca Racket si Clojure sunt instalate'
	@Write-Host '  make clean         - sterge fisierele temporare'
	@Write-Host ''

# ---------- Rulare joc ----------

run-racket:
	@Write-Host '>>> Pornesc jocul in Racket...'
	@racket racket/spanzuratoarea.rkt

run-clojure:
	@Write-Host '>>> Pornesc jocul in Clojure...'
	@clojure -Sdeps '{:paths [\"clojure/src\"]}' -M -e '(load-file \"clojure/src/spanzuratoarea.clj\")(spanzuratoarea/porneste-joc)'

# Alias: `make run` porneste Racket-ul (prima implementare)
run: run-racket

# ---------- Rulare teste ----------

test-racket:
	@Write-Host '>>> Rulez testele Racket...'
	@racket teste/tests_racket.rkt

test-clojure:
	@Write-Host '>>> Rulez testele Clojure...'
	@clojure -Sdeps '{:paths [\"clojure/src\" \"teste\"]}' -M -e '(load-file \"teste/teste_clojure.clj\")'

# Ruleaza ambele suite, una dupa alta
test: test-racket test-clojure
	@Write-Host ''
	@Write-Host '>>> Toate testele au fost rulate.'

# ---------- Verificari ----------

check:
	@Write-Host '>>> Verific daca Racket este instalat...'
	@if (Get-Command racket -ErrorAction SilentlyContinue) { racket --version } else { Write-Host 'Racket NU e instalat. Descarca de pe https://racket-lang.org/' }
	@Write-Host ''
	@Write-Host '>>> Verific daca Clojure este instalat...'
	@if (Get-Command clojure -ErrorAction SilentlyContinue) { clojure --version } else { Write-Host 'Clojure NU e instalat. Descarca de pe https://clojure.org/guides/install_clojure' }

# ---------- Curatare ----------

clean:
	@Write-Host '>>> Sterg fisierele temporare...'
	@Get-ChildItem -Recurse -Directory -Filter 'compiled' -ErrorAction SilentlyContinue | Remove-Item -Recurse -Force -ErrorAction SilentlyContinue
	@Get-ChildItem -Recurse -Directory -Filter '.cpcache' -ErrorAction SilentlyContinue | Remove-Item -Recurse -Force -ErrorAction SilentlyContinue
	@Get-ChildItem -Recurse -Directory -Filter 'target' -ErrorAction SilentlyContinue | Remove-Item -Recurse -Force -ErrorAction SilentlyContinue
	@Get-ChildItem -Recurse -Include '*.zo','*.dep' -ErrorAction SilentlyContinue | Remove-Item -Force -ErrorAction SilentlyContinue
	@Write-Host '>>> Gata.'