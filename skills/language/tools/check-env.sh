#!/usr/bin/env bash
#
# check-env.sh — détecte l'outillage selon la LANGUE (lecture seule). Aucun effet.
# Usage : ./check-env.sh [langue]   (langue : python|rust|cpp|bash|all — défaut "all")
set -uo pipefail

LANG="$(echo "${1:-all}" | tr '[:upper:]' '[:lower:]')"

echo "== Outillage disponible (langue : $LANG) =="

check() { # check <label> "cmd"
  command -v "$2" >/dev/null 2>&1 && echo "  $1 : présent ($(command -v "$2"))" || echo "  $1 : absent"
}

do_python() {
  echo "## Python"
  python3 --version 2>&1 | sed 's/^/  runtime  : /'
  { [ "$(command -v python3)" ] && echo "  python3 : présent"; } || echo "  python3 : absent"
  check "uv       " uv
  check "pip      " pip3
  check "ruff     " ruff
  check "mypy     " mypy
  check "pytest   " pytest
}
do_rust() {
  echo "## Rust"
  { rustc --version 2>/dev/null | sed 's/^/  rustc    : /'; } || echo "  rustc    : absent"
  check "cargo    " cargo
  check "rustup   " rustup
}
do_cpp() {
  echo "## C++ (dont Unreal Engine 5)"
  check "g++      " g++
  check "clang++  " clang++
  check "cmake    " cmake
  check "make     " make
  echo "  (Unreal Engine 5 : éditeur UE5 + C++ / Blueprints)"
}
do_bash() {
  echo "## Bash / automatisation"
  { bash --version 2>/dev/null | head -1 | sed 's/^/  bash     : /'; }
  check "shellcheck" shellcheck
}

case "$LANG" in
  all)     do_python; do_rust; do_cpp; do_bash ;;
  python)  do_python ;;
  rust)    do_rust ;;
  cpp)     do_cpp ;;
  bash)    do_bash ;;
  *) echo "Langue inconnue : $LANG (python|rust|cpp|bash|all)"; exit 1 ;;
esac
