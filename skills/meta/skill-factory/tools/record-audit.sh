#!/usr/bin/env bash
#
# record-audit.sh — consigne une opération dans le journal d'audit _meta/audit.log.md (append-only).
# Écriture contrôlée : l'utilisateur/AI confirme la ligne. Ne s'utilise qu'après une opération réelle
# (validation, intégration, rejet, archivage) — pas un outil de lecture.
#
# Usage : ./record-audit.sh --skill <nom> --action <action> [--verdict <v>] [--reason <raison>] [--by <qui>]
set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
FACTORY_DIR="$(dirname "$SCRIPT_DIR")"
LOGFILE="$FACTORY_DIR/_meta/audit.log.md"

skill=""; action=""; verdict=""; reason=""; by="Humain"
prev=""
for a in "$@"; do
  case "$prev" in
    --skill)   skill="$a";   prev=""; continue ;;
    --action)  action="$a";  prev=""; continue ;;
    --verdict) verdict="$a"; prev=""; continue ;;
    --reason)  reason="$a";  prev=""; continue ;;
    --by)      by="$a";      prev=""; continue ;;
  esac
  case "$a" in
    --skill|--action|--verdict|--reason|--by) prev="$a" ;;
    *) echo "Option inconnue : $a"; exit 1 ;;
  esac
done

[ -n "$skill" ] && [ -n "$action" ] || { echo "ERREUR : --skill et --action requis."; exit 1; }
[ -z "$verdict" ] && verdict="·"
[ -z "$reason" ] && reason="·"

echo "Ligne à consigner :"
echo "  | $(date +%F) | $skill | $action | $verdict | $reason | $by |"
echo -n "Ajouter au journal d'audit ? (écriture — taper OUI pour confirmer) : "
read -r ok
[ "$ok" = "OUI" ] || { echo "Annulé."; exit 0; }

# insérer avant la dernière ligne du tableau (avant la ligne <!-- ... -->)
sed -i "/^<!-- nouvelles entrées ci-dessous -->/i | $(date +%F) | $skill | $action | $verdict | $reason | $by |" "$LOGFILE"
echo "OK : consigné dans $LOGFILE"
