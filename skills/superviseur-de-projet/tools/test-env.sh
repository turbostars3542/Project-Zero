#!/usr/bin/env bash
#
# test-env.sh — ENVIRONNEMENT DE TEST FERMÉ (isolé) pour la supervision.
# L'agent peut tester des commandes/scripts DANS un bac à sable, sans rien modifier
# sur le vrai projet. Rien ne sort du sandbox sans une promotion explicite (humain).
#
# Sécurité (modèle Projet Zero) :
#   - create (write)  : crée le sandbox (isolé)
#   - run    (exec)   : exécute une commande CONFÉNÉE au sandbox
#   - list   (read)   : auto
#   - clear  (destructif) : exige --confirm
#
# Usage :
#   ./test-env.sh create <projet> [--copy]     # crée .sandbox (vide ou copie)
#   ./test-env.sh run <projet> -- <cmd...>     # exécute <cmd> DANS le sandbox
#   ./test-env.sh list <projet>                # contenu du sandbox
#   ./test-env.sh clear <projet> --confirm     # vide le sandbox (destructif)
set -uo pipefail

ACTION="${1:-}"
PROJ="${2:-.}"
[ $# -ge 2 ] && shift 2 || shift || true
COPY="no"
CONFIRM="no"
CMD_SKIP=0

while [ $# -gt 0 ]; do
  case "$1" in
    --copy)    COPY="yes"; shift ;;
    --confirm) CONFIRM="yes"; shift ;;
    --)        CMD_SKIP=1; shift; break ;;
    *)         echo "Option inconnue : $1"; exit 1 ;;
  esac
done

SANDBOX="$PROJ/.sandbox"
usage() {
  echo "Usage: $0 <create|run|list|clear> <projet> [--copy|--confirm|-- <cmd...>]"
}

# anti-traversal sur PROJECT (et que le dossier existe)
case "$PROJ" in *".."*) echo "ERREUR : chemin invalide (traversal)."; exit 1;; esac
[ -d "$PROJ" ] || { echo "ERREUR : projet inexistant -> $PROJ"; exit 1; }

do_create() {
  if [ -d "$SANDBOX" ] && [ -n "$(ls -A "$SANDBOX" 2>/dev/null)" ] && [ "$CONFIRM" != "yes" ]; then
    echo "BLOQUÉ : '$SANDBOX' existe et n'est pas vide (relance avec --confirm pour le réécrire)."
    exit 1
  fi
  rm -rf "$SANDBOX" 2>/dev/null || true
  mkdir -p "$SANDBOX"
  if [ "$COPY" = "yes" ]; then
    cp -a "$PROJ/." "$SANDBOX/" 2>/dev/null
    # on ne copie pas le sandbox lui-même (pas de récursion)
    rm -rf "$SANDBOX/.sandbox" 2>/dev/null || true
    echo "OK : sandbox créé (copie du projet) -> $SANDBOX"
  else
    echo "OK : sandbox vide créé -> $SANDBOX"
  fi
  echo "→ testez avec 'run <projet> -- <commande>' ; rien n'est appliqué au vrai projet."
}

do_run() {
  [ -d "$SANDBOX" ] || { echo "ERREUR : sandbox absent (crée-le : test-env.sh create <projet>)."; exit 1; }
  if [ "$CMD_SKIP" = "0" ]; then echo "ERREUR : sépare la commande avec -- (ex. ... run <projet> -- python3 main.py)"; exit 1; fi
  echo ">>> [sandbox] exécution dans '$SANDBOX' : $*"
  (cd "$SANDBOX" && exec "$@")
  local rc=$?
  echo ">>> exit code: $rc (isolé : le vrai projet '$PROJ' n'est pas affecté)"
  return $rc
}

do_list() {
  [ -d "$SANDBOX" ] || { echo "(sandbox absent : test-env.sh create <projet>)"; exit 0; }
  echo "Contenu de '$SANDBOX' :"
  (cd "$SANDBOX" && find . -maxdepth 2 | sed 's|^\./|  |' | head -40)
}

do_clear() {
  [ "$CONFIRM" = "yes" ] || { echo "BLOQUÉ : clear est destructif. Relance avec --confirm."; exit 1; }
  [ -d "$SANDBOX" ] || { echo "(sandbox déjà absent)"; exit 0; }
  rm -rf "$SANDBOX"
  echo "OK : sandbox vidé -> $SANDBOX"
}

case "$ACTION" in
  create) do_create ;;
  run)    do_run "$@" ;;
  list)   do_list ;;
  clear)  do_clear ;;
  *)      usage; exit 1 ;;
esac
