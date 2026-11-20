#!/usr/bin/env bash
#
# check-permissions.sh — outil LOCAL de permissions (aucun LLM).
# Répond à "qui peut lire / écrire / modifier un fichier ?" selon la matrice de
# reference-nouveau-projet.md (§B). Matérialise "capable ≠ autorisé".
#
# Sécurité : lecture seule uniquement (ne modifie rien).
#
# Usage :
#   ./check-permissions.sh who  <fichier>                      # propriétaire + qui lit
#   ./check-permissions.sh may  <sous-skill> <fichier> <action> # ALLOW / NEED_CONFIRM / DENY
#        action ∈ read | write | modify
set -euo pipefail

ACTION="${1:-}"

usage() {
  echo "Usage: $0 <who|may> ..."
  echo "  who <fichier>                      # qui écrit / modifie / lit ce fichier"
  echo "  may <sous-skill> <fichier> <act>   # ALLOW|NEED_CONFIRM|DENY (act=read|write|modify)"
}

# map_file <fichier> → imprime "owner"  (d'après reference-nouveau-projet.md §B)
map_file() {
  case "${1:-}" in
    PROJECT.md)              echo "superviseur-de-projet" ;;
    REQUIREMENTS.md|PROBLEM.md) echo "analyse-de-problemes" ;;
    ARCHITECTURE.md)         echo "architecture" ;;
    RULES.md)                echo "superviseur-de-projet" ;;
    SECURITY.md)             echo "security" ;;
    DECISIONS.md|CHANGELOG.md|README.md) echo "documentation" ;;
    SKILL.md)                echo "superviseur-de-projet" ;;
    ROADMAP.md|TASKS.md|SUIVI.md) echo "planning" ;;
    *) echo "inconnu" ;;
  esac
}

# Tout membre de la meta-team peut lire ; l'écriture/modification au propriétaire (sous porte humaine).
do_who() {
  local f="${2:-}"
  [ -n "$f" ] || { usage; exit 1; }
  local owner
  owner="$(map_file "$f")"
  echo "Fichier : $f"
  echo "  ✏️ écrit    : $owner"
  echo "  🔧 modifie : $owner (+ validation humaine — porte plan→act)"
  echo "  👁️ lit      : toute l'équipe meta"
}

do_may() {
  local skill="${2:-}" f="${3:-}" act="${4:-}"
  [ -n "$skill" ] && [ -n "$f" ] && [ -n "$act" ] || { usage; exit 1; }
  case "$act" in read|write|modify) ;; *) echo "ERREUR : action=$act (attendu read|write|modify)"; exit 1;; esac
  local owner
  owner="$(map_file "$f")"

  # lecture : tout le monde peut lire
  if [ "$act" = "read" ]; then echo "ALLOW"; return; fi

  # write / modify : seul le propriétaire, et sous porte humaine
  if [ "$skill" = "$owner" ]; then
    # modification = toujours confirmable (porte humaine)
    if [ "$act" = "modify" ]; then echo "NEED_CONFIRM"; else echo "ALLOW"; fi
  else
    echo "DENY"
  fi
}

case "$ACTION" in
  who) do_who "$@" ;;
  may) do_may "$@" ;;
  *)   usage; exit 1 ;;
esac
