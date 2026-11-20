#!/usr/bin/env bash
#
# list-installed.sh — affiche ce qui est INSTALLÉ dans l'environnement (lecture seule).
# Complémentaire : ici on liste les paquets installés ; les DÉCLARÉES sont dans DEPENDANCES.md.
#
# Usage : ./list-installed.sh [<dossier-projet>] [--all]
#   <dossier>  : si DEPENDANCES.md présent, montre les déclarées (section bibliothèques)
#   --all      : liste TOUT l'env (tous paquets), sinon liste le projet
set -uo pipefail

PROJ="${1:-.}"
ALL=0
if [ "${@: -1}" = "--all" ] || [ "${2:-}" = "--all" ]; then ALL=1; fi

echo "== Paquets installés dans l'environnement =="

if command -v uv >/dev/null 2>&1; then
  echo "-- (uv) paquets installés :"
  if [ "$ALL" = "1" ] || [ ! -f "$PROJ/pyproject.toml" ]; then
    uv pip list 2>/dev/null || echo "   (aucun / env non initialisé)"
  else
    uv pip list 2>/dev/null | head -20 || echo "   (aucun / env non initialisé)"
  fi
elif command -v pip3 >/dev/null 2>&1; then
  echo "-- (pip) paquets installés :"
  if [ "$ALL" = "1" ]; then pip3 list 2>/dev/null
  else pip3 list --format=freeze 2>/dev/null | head -20; fi
elif python3 -m pip list >/dev/null 2>&1; then
  echo "-- (python3 -m pip) paquets installés :"
  if [ "$ALL" = "1" ]; then python3 -m pip list 2>/dev/null
  else python3 -m pip list --format=freeze 2>/dev/null | head -20; fi
else
  echo "   ni uv ni pip3 : impossible de lister les paquets installés (pip/uv absents de l'env)."
fi

echo
echo "== Dépendances DÉCLARÉES (le fichier décidé par le superviseur) =="
if [ -f "$PROJ/DEPENDANCES.md" ]; then
  awk '/^## Biblioth/ {inlib=1;next} /^## / {inlib=0}
       inlib && !/^#/ && !/^$/ && $0 !~ /^```/ {sub(/^[-*•]?[ ]*/,""); sub(/\(skill:[^)]*\)/,""); sub(/:.*$/,""); gsub(/[[:space:]]+/,""); if($0!="")print}' "$PROJ/DEPENDANCES.md" \
    | sed 's/^/   - /'
else
  echo "   (pas de DEPENDANCES.md dans '$PROJ' — le superviseur le détermine.)"
fi

echo
echo "== Note : ce qui manque vs ce qui est déclaré → installer via 'deps.sh … --confirm' =="
