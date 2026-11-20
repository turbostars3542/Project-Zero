#!/usr/bin/env bash
#
# dedupe.sh — DÉTECTION de doublons / chevauchements entre skills (lecture seule).
# Compare `name` et `description` normalisés ; signale les paires suspectes.
# Signalement uniquement : la décision (fusion/archivage) reste humaine.
#
# Usage : ./dedupe.sh [--bank <racine>]
set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
FACTORY_DIR="$(dirname "$SCRIPT_DIR")"
BANK=""
prev=""
for a in "$@"; do
  case "$prev" in
    --bank) BANK="$a"; prev=""; continue ;;
  esac
  case "$a" in
    --bank) prev="--bank" ;;
    *) echo "Option inconnue : $a"; exit 1 ;;
  esac
done
[ -n "$BANK" ] || BANK="$(cd "$FACTORY_DIR/../.." && pwd)"
[ -d "$BANK" ] || { echo "ERREUR : banque introuvable"; exit 1; }
case "$BANK" in *".."*) echo "Traversal refusé"; exit 1;; esac

norm() { # normalise : minuscules, enlève accents, ponctuation, mots vides
  echo "$1" | tr '[:upper:]' '[:lower:]' | sed 's/[àâä]/a/g; s/[éèêë]/e/g; s/[îï]/i/g; s/[ôö]/o/g; s/[ûü]/u/g; s/[ç]/c/g' | tr -cd 'a-z0-9 '
}

# lire name + description normalisées de chaque skill
tmp=$(mktemp)
find "$BANK" -name SKILL.md -not -path "*_archive*" -not -path "*/_meta/*" -not -path "*/.git/*" | sort > "$tmp"
declare -a NAMES FAMS DESCS
declare -A key2idx
idx=0
while IFS= read -r f; do
  # extraire name, family, description
  name=$(awk '/^---$/{c++;next} c==1 && /^name:/{sub(/^name:[[:space:]]*/,"");print;exit}' "$f")
  fam=$(awk '/^---$/{c++;next} c==1 && /^family:/{sub(/^family:[[:space:]]*/,"");print;exit}' "$f")
  desc=$(awk '/^---$/{c++;next} c==1 && /^description:/{sub(/^description:[[:space:]]*/,"");print;exit}' "$f")
  name="${name//\"/}"; fam="${fam//\"/}"; desc="${desc//\"/}"
  NAMES[idx]="$(norm "$name")"; FAMS[idx]="${fam:-(aucune)}"; DESCS[idx]="$(norm "$desc")"
  key2idx["${NAMES[idx]}"]=1
  idx=$((idx+1))
done < "$tmp"
count=$idx

echo "== Détection de doublons / chevauchements (banque : $BANK) =="
echo "  skills analysés : $count"
flag=0
for i in $(seq 0 $((count-1))); do
  for j in $(seq $((i+1)) $((count-1))); do
    [ "$i" = "$j" ] && continue
    # 1) noms identiques OU nom de l'un contenu dans l'autre
    if [ "${NAMES[i]}" = "${NAMES[j]}" ] || \
       [[ "${NAMES[i]}" == *"${NAMES[j]}"* ]] || [[ "${NAMES[j]}" == *"${NAMES[i]}"* ]]; then
      echo "  [DOUBLON/?] famille/chemin proches : '$i' vs '$j'"
      flag=$((flag+1))
    fi
  done
done
# 2) mêmes familles avec descriptions très courtes ou identiques (chevauchement probable)
#    (simple heuristique : descriptions identiques)
declare -A seen
for i in $(seq 0 $((count-1))); do
  d="${DESCS[i]}"
  [ -z "$d" ] && continue
  if [ -n "${seen[$d]:-}" ]; then
    echo "  [CHEVAUCHEMENT?] description identique entre indices '${seen[$d]}' et '$i'"
    flag=$((flag+1))
  else
    seen[$d]="$i"
  fi
done
[ "$flag" -eq 0 ] && echo "  ✓ aucune paire suspecte détectée (heuristique simple)."
echo "Note : heuristique = signalement. Toujours valider humainement avant fusion/archivage."
rm -f "$tmp"
