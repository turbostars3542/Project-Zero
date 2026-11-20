#!/usr/bin/env bash
#
# snapshot.sh — outil LOCAL de backup (aucun LLM). Actions : create | list | verify | restore | clean.
#
# Sécurité (modèle Projet Zero) :
#   - create  (write)      : fait le job (copie en excluant .backups, jamais d'explosion)
#   - list    (read)       : auto (lecture seule)
#   - verify  (read)       : auto (intégrité sha256 — ne modifie rien)
#   - restore (destructif) : JAMAIS auto → exige --confirm (restaure du snapshot vers le projet)
#   - clean   (destructif) : JAMAIS auto → exige --confirm (rotation : ne garde que les N derniers)
#
# Usage :
#   ./snapshot.sh create
#   ./snapshot.sh list
#   ./snapshot.sh verify [snapshot]
#   ./snapshot.sh restore <snapshot> --confirm
#   ./snapshot.sh clean --keep <N> --confirm
set -euo pipefail

BACKUP_DIR=".backups"
ACTION="${1:-}"
SNAPSHOT="${2:-}"

usage() {
  echo "Usage:"
  echo "  $0 create"
  echo "  $0 list"
  echo "  $0 verify [snapshot]"
  echo "  $0 restore <snapshot> --confirm"
  echo "  $0 clean --keep <N> --confirm"
}
# --- helpers ---------------------------------------------------------------
has_flag() { # has_flag <flag> ...
  local f; for f in "${@:2}"; do [ "$f" = "$1" ] && return 0; done; return 1
}
safe_name() { # anti-traversal : refuse '..' ou '/' dans un nom de snapshot
  case "$1" in
    *".."*|*"/"*) echo "ERREUR : nom invalide (traversal refusé)"; exit 1;;
  esac
}

# --- create ----------------------------------------------------------------
do_create() {
  local stamp dest
  stamp="$(date +%Y%m%d_%H%M%S)"
  dest="$BACKUP_DIR/snapshot_$stamp"
  mkdir -p "$dest"
  # copier l'état du projet en EXCLUANT .backups (sinon explosion exponentielle de doublons)
  if command -v rsync >/dev/null 2>&1; then
    rsync -a --exclude="/$BACKUP_DIR/" ./ "$dest/"
  else
    # fallback : copie + purge du .backups que cp aurait embarqué
    cp -r . "$dest" 2>/dev/null || true
    rm -rf "$dest/$BACKUP_DIR" 2>/dev/null || true
  fi
  # manifest (hash sha256) pour l'intégrité : on hache depuis la copie (référence stable)
  find "$dest" -type f -not -name manifest.sha256 -exec sha256sum {} \; \
    | sed "s#$dest/##" > "$dest/manifest.sha256" 2>/dev/null || true
  echo "OK : snapshot créé -> $dest"
}

# --- list ------------------------------------------------------------------
do_list() {
  if [ -d "$BACKUP_DIR" ]; then
    for d in "$BACKUP_DIR"/snapshot_*; do
      [ -d "$d" ] || continue
      n=$(find "$d" -type f -not -name manifest.sha256 2>/dev/null | wc -l)
      printf '%-26s %5d fichiers\n' "$(basename "$d")" "$n"
    done
  else
    echo "(aucun snapshot pour l'instant)"
  fi
}

# --- verify ----------------------------------------------------------------
do_verify() {
  local src=""
  if [ -n "$SNAPSHOT" ]; then
    safe_name "$SNAPSHOT"
    src="$BACKUP_DIR/$SNAPSHOT"
  else
    # dernier snapshot (ls renvoie déjà le chemin complet -> ne pas redoubler le préfixe)
    src=$(ls -1dt "$BACKUP_DIR"/snapshot_* 2>/dev/null | head -1) || true
  fi
  [ -d "${src:-}" ] || { echo "ERREUR : snapshot introuvable (${src:-?})"; exit 1; }
  echo "Vérification de '$src'…"
  local bad=0 total=0
  while IFS= read -r line; do
    [ -z "$line" ] && continue
    expected="${line%%  *}"; rel="${line#*  }"
    total=$((total+1))
    if [ -f "$src/$rel" ]; then
      got=$(sha256sum "$src/$rel" | awk '{print $1}')
      [ "$got" = "$expected" ] || { echo "  [CASSÉ] $rel"; bad=$((bad+1)); }
    else
      echo "  [MANQUANT] $rel"; bad=$((bad+1))
    fi
  done < "$src/manifest.sha256"
  echo "Résultat : $((total-bad))/$total OK."
  [ "$bad" -eq 0 ] && echo "VERIFY: PASS" || { echo "VERIFY: NON CONFORME ($bad problème)"; exit 1; }
}

# --- restore ---------------------------------------------------------------
do_restore() {
  [ -n "$SNAPSHOT" ] || { echo "ERREUR : restore requiert un nom de snapshot."; usage; exit 1; }
  safe_name "$SNAPSHOT"
  has_flag "--confirm" "$@" || { echo "BLOQUÉ : restaurer est destructif. Relance avec --confirm."; exit 1; }
  local src="$BACKUP_DIR/$SNAPSHOT"
  [ -d "$src" ] || { echo "ERREUR : snapshot inconnu -> $src"; exit 1; }
  echo "OK : restauration de '$SNAPSHOT'…"
  if command -v rsync >/dev/null 2>&1; then
    rsync -a --delete --exclude="/$BACKUP_DIR/" "$src/" ./
  else
    # fallback : copie simple sans supprimer les fichiers déjà absents
    find "$src" -type f -not -name manifest.sha256 -print0 | while IFS= read -r -d '' f; do
      rel="${f#"$src"/}"
      mkdir -p "$(dirname "$rel")"
      cp "$f" "$rel"
    done
  fi
  echo "Restauration terminée depuis '$SNAPSHOT'."
}

# --- clean (rotation) ------------------------------------------------------
do_clean() {
  local keep=3 _prev=""
  for i in "$@"; do
    if [ "$_prev" = "--keep" ]; then keep="$i"; _prev=""; continue; fi
    case "$i" in
      --keep) _prev="--keep" ;;
    esac
  done
  has_flag "--confirm" "$@" || { echo "BLOQUÉ : clean supprime des snapshots. Relance avec --confirm."; exit 1; }
  [ "$keep" -ge 1 ] 2>/dev/null || { echo "ERREUR : --keep doit être un entier >= 1 (ex. --keep 3)"; exit 1; }
  # ordre chronologique (les plus anciens en premier)
  local snap_list=()
  for d in $(ls -1d "$BACKUP_DIR"/snapshot_* 2>/dev/null | sort); do snap_list+=("$d"); done
  local total=${#snap_list[@]}
  local to_remove=$((total > keep ? total - keep : 0))
  if [ "$to_remove" -eq 0 ]; then echo "Rien à supprimer : $total snapshots (<= $keep gardés)."; return 0; fi
  echo "Suppression de $to_remove snapshot(s) ancien(s), garde des $keep plus récents :"
  for ((i=0; i<to_remove; i++)); do
    echo "  - ${snap_list[$i]}"
    rm -rf "${snap_list[$i]}"
  done
  echo "Fait : ${total} -> $keep snapshot(s)."
}

case "$ACTION" in
  create)  do_create ;;
  list)    do_list ;;
  verify)  do_verify "$@" ;;
  restore) do_restore "$@" ;;
  clean)   do_clean "$@" ;;
  *)       usage; exit 1 ;;
esac
