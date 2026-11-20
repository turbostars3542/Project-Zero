#!/usr/bin/env bash
#
# deps.sh — installe / liste les dépendances DÉCLARÉES selon la LANGUE.
# Ne lit QUE la section « Bibliothèques autorisées » de DEPENDANCES.md (déterminé par le superviseur).
#
# Usage :
#   ./deps.sh list    <langue> [<projet>] [--file <fichier>]
#   ./deps.sh install <langue> <projet>  [--file <fichier>] [--confirm]
#   (langue : python|rust|cpp|bash — défaut python)
set -uo pipefail

ACTION="${1:-}"
shift || true
FILE=""
CONFIRM="no"
LANG=""
PROJ="."

while [ $# -gt 0 ]; do
  case "$1" in
    --file)    FILE="${2:-}"; shift 2 ;;
    --confirm) CONFIRM="yes"; shift ;;
    -*)        echo "Option inconnue : $1"; exit 1 ;;
    *)         if [ -z "$LANG" ]; then LANG="$1"; shift; elif [ "$PROJ" = "." ]; then PROJ="$1"; shift; else echo "Trop d'arguments : $1"; exit 1; fi ;;
  esac
done
LANG="${LANG:-python}"

# Détermine le fichier de dépendances
if [ -z "$FILE" ]; then FILE="$PROJ/DEPENDANCES.md"; fi
[ -f "$FILE" ] || { echo "ERREUR : fichier de dépendances absent -> $FILE"; echo "(le superviseur le détermine / génère)."; exit 1; }

usage() {
  echo "Usage: $0 <list|install> <langue> [<projet>] [--file <fichier>] [--confirm]"
}

# parse_libs — section « Bibliothèques autorisées » uniquement (les skills s'activent, ne s'installent pas)
parse_libs() {
  awk '/^## Biblioth/ { inlib=1; next } /^## / { inlib=0 }
       inlib && !/^#/ && !/^$/ && $0 !~ /^```/ {
         sub(/^[-*•]?[ ]*/,""); sub(/\(skill:[^)]*\)/,""); sub(/:.*$/,""); gsub(/[[:space:]]+/,""); if($0!="")print
       }' "$FILE"
}

do_list() {
  case "$PROJ" in *".."*) echo "ERREUR : chemin invalide (traversal)."; exit 1;; esac
  echo "Dépendances DÉCLARÉES dans '$FILE' (langue : $LANG) :"
  local n=0
  while IFS= read -r pkg; do [ -n "$pkg" ] && { echo "  - $pkg"; n=$((n+1)); }; done < <(parse_libs)
  [ "$n" -eq 0 ] && echo "  (aucune dépendance déclarée)"
  echo "→ $n dépendance(s)."
}

do_install() {
  case "$PROJ" in *".."*) echo "ERREUR : chemin invalide (traversal)."; exit 1;; esac
  [ "$CONFIRM" = "yes" ] || { echo "BLOQUÉ : installer est une mutation. Relance avec --confirm."; exit 1; }
  [ -d "$PROJ" ] || { echo "ERREUR : dossier inaccessible -> $PROJ"; exit 1; }
  local installed=0
  while IFS= read -r pkg; do
    [ -n "$pkg" ] || continue
    case "$LANG" in
      python)
        command -v uv >/dev/null 2>&1 || { echo "ERREUR : uv requis (pip install uv)."; exit 1; }
        ( cd "$PROJ" && uv add "$pkg" ) || { echo "ÉCHEC sur $pkg."; exit 1; }
        ;;
      rust)
        command -v cargo >/dev/null 2>&1 || { echo "ERREUR : cargo requis (rustup)."; exit 1; }
        [ -f "$PROJ/Cargo.toml" ] || { echo "ERREUR : pas de Cargo.toml dans '$PROJ'."; exit 1; }
        cargo add --manifest-path "$PROJ/Cargo.toml" "$pkg" || { echo "ÉCHEC sur $pkg."; exit 1; }
        ;;
      cpp)
        echo "SKIP : C++ → déclarer '$pkg' dans CMakeLists.txt / vcpkg / Conan (pas d'install auto)."
        ;;
      bash)
        echo "SKIP : Bash → pas de dépendance externe auto pour '$pkg'."
        ;;
      *) echo "Langue inconnue : $LANG"; exit 1 ;;
    esac
    installed=$((installed+1))
  done < <(parse_libs)
  echo "OK : $installed dépendance(s) traitée(s)."
  echo "RAPPEL : chaque écriture passe la porte humaine + Policy/Risk ; tester ensuite."
}

case "$ACTION" in
  list)    do_list ;;
  install) do_install ;;
  *)       usage; exit 1 ;;
esac
