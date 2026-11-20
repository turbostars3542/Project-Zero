#!/usr/bin/env bash
#
# validate-skill.sh — contrôle LOCAL d'un skill (structure + métadonnées) — lecture seule.
# Matérialise les contrôles de base du skill-validator (voir REFERENCE.md §6).
# Lecture seule ; on ne modifie rien.
#
# Usage : ./validate-skill.sh <dossier-du-skill>
set -uo pipefail

DIR="${1:-.}"
[ -f "$DIR/SKILL.md" ] || { echo "NON VÉRIFIÉ : pas de SKILL.md dans '$DIR'."; exit 1; }
F="/$DIR/SKILL.md"

# enlever le chemin absolu pour les messages
SKILL="$DIR/SKILL.md"
issue=0; warn=0

need() { grep -q "^${1}:" "$SKILL" && echo "  [OK]   ${1}: présent" || { echo "  [A PROUVER] ${1}: manquant"; issue=$((issue+1)); }; }

echo "== Validation structurelle de '$SKILL' =="
need "name"
need "family"
for f in description role limites; do
  if grep -qE "^${f}" "$SKILL"; then echo "  [OK]   ${f}: présent"; else echo "  [A PROUVER] ${f}: manquant"; issue=$((issue+1)); fi
done

# famille valide ?
fam=$(grep -E "^family:" "$SKILL" | head -1 | sed 's/.*family:[[:space:]]*//')
case "$fam" in
  language|technology|domain|meta|governance|profile|pack) echo "  [OK]   family '$fam' valide" ;;
  "") echo "  [A PROUVER] family manquante"; issue=$((issue+1)) ;;
  *)  echo "  [A PROUVER] family '$fam' invalide (attendu: language|technology|domain|meta|governance|profile|pack)"; issue=$((issue+1)) ;;
esac

# outillage déclaré : chaque outil listé doit exister dans le dossier tools/ du skill (P6)
tools_line=$(grep -E "^tools:" "$SKILL" | head -1)
if grep -qE "^tools:\s*\[.*[^]]" "$SKILL"; then
  # extraire les noms entre [ ]
  for t in $(echo "$tools_line" | sed -E 's/.*\[([^]]*)\].*/\1/' | tr ',' ' '); do
    t=$(echo "$t" | xargs)
    [ -z "$t" ] && continue
    if [ -f "$DIR/tools/$t.sh" ]; then
      echo "  [OK]   outil '$t' présent (tools/$t.sh)"
    else
      echo "  [À VÉRIFIER] outil '$t' déclaré mais tools/$t.sh introuvable"; warn=$((warn+1))
    fi
  done
else
  echo "  [OK]   tools: aucun outil référencé (ou list vide)"
fi

# version (P6) : recommandé, non bloquant
if grep -qE "^version:" "$SKILL"; then
  echo "  [OK]   version: présente"
else
  echo "  [i]    version: absente (recommandé pour le registre)"; warn=$((warn+1))
fi

# procédure (sections essentielles)
for s in "## Objectif" "## Comment faire" "## Vérifier"; do
  grep -qF "$s" "$SKILL" && echo "  [OK]   section '${s}' présente" || { echo "  [i]    section '${s}' absente"; warn=$((warn+1)); }
done

# pas de marqueur de secret évident
if grep -niE "password|secret_api|api_key *=" "$SKILL" | grep -v "aucun secret" | grep -v "pas de secret" >/dev/null 2>&1; then
  echo "  [A PROUVER] présence possible de secret à vérifier"; issue=$((issue+1))
else
  echo "  [OK]   pas de secret évident"
fi

echo
if [ "$issue" -eq 0 ]; then echo "PASS : structure + métadonnées de base valides (${warn} avertissement(s)).";
else echo "NON VÉRIFIÉ : ${issue} problème(s), ${warn} avertissement(s) — corriger avant intégration (PASS = preuve)."; fi
