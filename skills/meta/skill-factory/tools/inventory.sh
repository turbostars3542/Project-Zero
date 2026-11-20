#!/usr/bin/env bash
#
# inventory.sh — INVENTAIRE AUTOMATISÉ de la banque de skills (lecture seule).
# Produit : liste des skills (chemin, name, family, description, status, version, tools)
# et un registre exploitable (registry.md) dans _meta/ du skill-factory.
#
# Usage : ./inventory.sh [--bank <racine-des-skills>] [--out <fichier>] [--no-register]
set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
FACTORY_DIR="$(dirname "$SCRIPT_DIR")"                 # .../skill-factory
BANK="${1:+}"
BANK=""
OUT=""
NOREG=0

# parsing simple
prev=""
for a in "$@"; do
  case "$prev" in
    --bank) BANK="$a"; prev=""; continue ;;
    --out)  OUT="$a";   prev=""; continue ;;
  esac
  case "$a" in
    --bank) prev="--bank" ;;
    --out)  prev="--out" ;;
    --no-register) NOREG=1 ;;
    *) echo "Option inconnue : $a"; exit 1 ;;
  esac
done

[ -n "$BANK" ] || BANK="$(cd "$FACTORY_DIR/../.." && pwd)"   # = <projet>/skills
META="$FACTORY_DIR/_meta"
[ -d "$BANK" ] || { echo "ERREUR : banque introuvable -> $BANK"; exit 1; }
case "$BANK" in *".."*) echo "Traversal refusé"; exit 1;; esac

# lecture seule des métadonnées (frontmatter) d'un SKILL.md
front() { # front <file> <field>
  awk -v want="$2" '
    /^---$/ { c++; next }
    c==1 && $0 ~ "^" want ":" { line=$0; sub(/^[^:]*:[[:space:]]*/,"",line); print line; exit }
  ' "$1"
}

tmp=$(mktemp)
# parcourir la banque : tous les SKILL.md, en excluant _meta, _archive, caches, .git
find "$BANK" -name SKILL.md \
  -not -path "*_archive*" -not -path "*/_meta/*" \
  -not -path "*/.git/*" -not -path "*__pycache__*" \
  | sort > "$tmp"

count=0
{
  echo "# Registre des skills (généré par inventory.sh)"
  echo "> Généré le $(date +%F). Ne pas éditer à la main : recompiler via inventory.sh (le frontmatter reste la source de vérité)."
  echo
  echo "| Skill | Family | Statut | Version | Chemin |"
  echo "|---|---|---|---|---|"
  while IFS= read -r f; do
    rel="${f#"$BANK"/}"
    name=$(front "$f" name); fam=$(front "$f" family); st=$(front "$f" status); ver=$(front "$f" version)
    # nettoyer (enlever les guillemets éventuels)
    name="${name//\"/}"; fam="${fam//\"/}"; st="${st//\"/}"; ver="${ver//\"/}"
    [ -z "$st" ] && st="Draft"
    [ -z "$ver" ] && ver="-"
    printf '| `%s` | %s | %s | %s | `%s` |\n' "$name" "$fam" "$st" "$ver" "$rel"
    count=$((count+1))
  done < "$tmp"
  echo
  echo "TOTAL : $count skill(s)."
} > "${OUT:-/dev/stdout}"

# écrire le registre dans _meta (si demandé)
if [ "$NOREG" = "0" ]; then
  mkdir -p "$META"
  { "${OUT:+echo}" >/dev/null; } 2>/dev/null
  # régénérer le registre directement
  {
    echo "# Registre des skills (généré par inventory.sh)"
    echo "> Généré le $(date +%F). Ne pas éditer à la main (frontmatter = source de vérité)."
    echo
    echo "| Skill | Family | Statut | Version | Chemin |"
    echo "|---|---|---|---|---|"
    while IFS= read -r f; do
      rel="${f#"$BANK"/}"
      name=$(front "$f" name); fam=$(front "$f" family); st=$(front "$f" status); ver=$(front "$f" version)
      name="${name//\"/}"; fam="${fam//\"/}"; st="${st//\"/}"; ver="${ver//\"/}"
      [ -z "$st" ] && st="Draft"
      [ -z "$ver" ] && ver="-"
      printf '| `%s` | %s | %s | %s | `%s` |\n' "$name" "$fam" "$st" "$ver" "$rel"
    done < "$tmp"
    echo
    echo "TOTAL : $count skill(s)."
  } > "$META/registry.md"
  echo "→ Registre écrit : $META/registry.md ($count skills)"
fi
rm -f "$tmp"
