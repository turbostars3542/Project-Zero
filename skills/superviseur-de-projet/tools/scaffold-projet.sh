#!/usr/bin/env bash
#
# scaffold-projet.sh — outil LOCAL de création des fichiers principaux d'un nouveau projet.
# Aucun LLM : génère des fichiers .md propres (avec placeholders <…>) dans un dossier cible.
#
# Référence : reference-nouveau-projet.md (dans le dossier du skill superviseur-de-projet).
#
# Sécurité (modèle Projet Zero) :
#   - check (lecture)     : auto (lecture seule, ne modifie rien)
#   - new   (write)       : crée des fichiers → ne PAS écraser sans --confirm
#   - Aucune action destructive intégrée (pas de suppression).
#
# Usage : ./scaffold-projet.sh check <dossier-projet>
#         ./scaffold-projet.sh new <dossier-projet> [--project-name <nom>] [--confirm]
set -euo pipefail

PROJPATH="${2:-}"
ACTION="${1:-}"
PROJECT_NAME="${PROJECT_NAME:-}"
CATEGORY=""
CONFIRM="no"
shift 2 || true # retire ACTION et PROJPATH

while [ $# -gt 0 ]; do
  case "$1" in
    --project-name) PROJECT_NAME="${2:-}"; shift 2 ;;
    --category)     CATEGORY="${2:-}"; shift 2 ;;
    --confirm)      CONFIRM="yes"; shift ;;
    *) echo "Option inconnue : $1"; exit 1 ;;
  esac
done

usage() {
  echo "Usage: $0 <check|new|next> <cible> [options]"
  echo "  check <dossier>                         # fichiers principaux présents / manquants (lecture seule)"
  echo "  deep <dossier>                          # valide aussi le CONTENU (frontmatter, placeholders, décisions)"
  echo "  new <dossier> [--project-name <nom>] [--confirm]   # crée les fichiers principaux"
  echo "  next <fichier.md> --category <PREFIX>   # prochain numéro pour la catégorie (auto-incrément)"
}

# do_next — prochain numéro disponible pour une catégorie (auto-incrément).
# Exemples :
#   next REQUIREMENTS.md --category REQ-FONC  → "REQ-FONC-0002"
#   next RULES.md --category RUL-SEC          → "RUL-SEC-0002"
#   next SECURITY.md --category SEC-EXE       → "SEC-EXE-0003"
#   next DECISIONS.md --category DEC          → "DEC-000X" (séquentiel, pas de catégorie)
do_next() {
  [ -n "$PROJPATH" ] || { usage; exit 1; }
  [ -n "$CATEGORY" ] || { echo "ERREUR : --category requis (ex. REQ-FONC, RUL-SEC, SEC-EXE, DEC)."; exit 1; }
  [ -f "$PROJPATH" ] || { echo "ERREUR : fichier introuvable -> $PROJPATH"; exit 1; }
  local n next max
  # plus haut nombre existant pour ce préfixe, sinon on repart de 0 (→ 0001)
  max=$(grep -oE "${CATEGORY}-[0-9]+" "$PROJPATH" | grep -oE "[0-9]+$" | sort -n | tail -1)
  [ -n "$max" ] && n="$max" || n=0
  next=$((n + 1))
  printf '%s-%04d\n' "$CATEGORY" "$next"
}

# Les fichiers principaux (reference-nouveau-projet.md, §A) + README
FILES_MAIN=(README.md PROJECT.md REQUIREMENTS.md ARCHITECTURE.md RULES.md SECURITY.md DECISIONS.md CHANGELOG.md ROADMAP.md DEPENDANCES.md SKILL.md)

# do_deep — validation du CONTENU (pas seulement la présence). Lecture seule.
do_deep() {
  [ -n "$PROJPATH" ] || { usage; exit 1; }
  [ -d "$PROJPATH" ] || { echo "ERREUR : dossier inexistant -> $PROJPATH"; exit 1; }
  local issue=0 warn=0
  echo "Validation du contenu de '$PROJPATH' :"
  # 1. frontmatter YAML dans SKILL.md
  if [ -f "$PROJPATH/SKILL.md" ]; then
    if head -1 "$PROJPATH/SKILL.md" | grep -q '^---' && grep -qE '^name:' "$PROJPATH/SKILL.md"; then
      printf '  [OK]   SKILL.md : frontmatter YAML (name) présent\n'
    else
      printf '  [A PROUVER] SKILL.md : frontmatter YAML attendu (--- + name:)\n'; issue=$((issue+1))
    fi
  else
    printf '  [MANQUANT] SKILL.md\n'; issue=$((issue+1))
  fi
  # 2. placeholders <…> non complétés (avertissements)
  for file in "$PROJPATH"/*.md; do
    [ -f "$file" ] || continue
    if grep -qE '<[A-ZÀ-Ỹ][^>]*>' "$file" 2>/dev/null; then
      printf '  [i]    %s : placeholders <…> restants (à compléter)\n' "$(basename "$file")"; warn=$((warn+1))
    fi
  done
  # 3. DECISIONS.md : numéro + Décideur + date
  if [ -f "$PROJPATH/DECISIONS.md" ]; then
    if grep -qE 'DEC-[0-9]+' "$PROJPATH/DECISIONS.md" && grep -qiE 'Décideur' "$PROJPATH/DECISIONS.md" \
       && grep -qE '20[0-9]{2}-[0-9]{2}-[0-9]{2}' "$PROJPATH/DECISIONS.md"; then
      printf '  [OK]   DECISIONS.md : numérotées + Décideur + date\n'
    else
      printf '  [i]    DECISIONS.md : ajouter numéro DEC + Décideur + date\n'; warn=$((warn+1))
    fi
  fi
  printf '  [i]    Conventions ID REQ/RUL/SEC/DEC-… : à vérifier manuellement\n'
  echo "→ $issue problème(s), $warn avertissement(s)."
  if [ "$issue" -eq 0 ]; then echo "PASS : structure + contenu de base valides."; else echo "NON VÉRIFIÉ : corriger les problèmes ci-dessus (PASS = preuve)."; fi
}

confirm_or_abort() {
  # capable ≠ autorisé : pour protéger un dossier non vide, exiger --confirm
  if [ -d "$PROJPATH" ] && [ -n "$(ls -A "$PROJPATH" 2>/dev/null)" ] && [ "$CONFIRM" != "yes" ]; then
    echo "BLOQUÉ : '$PROJPATH' existe et n'est pas vide."
    echo "Relancez avec --confirm pour écrire dans un dossier existant (les fichiers existants ne sont PAS écrasés)."
    exit 1
  fi
}

do_check() {
  [ -n "$PROJPATH" ] || { usage; exit 1; }
  echo "Fichiers principaux attendus dans '$PROJPATH' :"
  ok=0; miss=0
  for f in "${FILES_MAIN[@]}"; do
    if [ -f "$PROJPATH/$f" ]; then printf "  [OK]   %s\n" "$f"; ok=$((ok+1));
    else printf "  [MANQUANT] %s\n" "$f"; miss=$((miss+1)); fi
  done
  echo "→ $ok présents, $miss manquants."
  # anti-traversal : nom de dossier vérifié
  case "$PROJPATH" in *".."*) echo "ERREUR : chemin invalide (traversal refusé)."; exit 1;; esac
}

write_file() {
  # write_file <nom> <contenu> — n'écrase JAMAIS un fichier existant
  local name="$1"; local content="$2"; local dest="$PROJPATH/$name"
  if [ -f "$dest" ]; then
    echo "  (garde) $name existe déjà — non écrasé"
    return
  fi
  printf '%s\n' "$content" > "$dest"
  echo "  créé : $name"
}

do_new() {
  [ -n "$PROJPATH" ] || { usage; exit 1; }
  case "$PROJPATH" in *".."*) echo "ERREUR : chemin invalide (traversal refusé)."; exit 1;; esac
  confirm_or_abort
  mkdir -p "$PROJPATH"
  local N="${PROJECT_NAME:-<PROJET>}"

  # --- SOURCE UNIQUE : copier depuis documentation/templates/projet (si présent) ---
  local SCRIPTS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
  local TEMPLATES_DIR="$SCRIPTS_DIR/../../../documentation/templates/projet"
  if [ -d "$TEMPLATES_DIR" ]; then
    local tpl base dest
    for tpl in "$TEMPLATES_DIR"/*.md; do
      [ -f "$tpl" ] || continue
      base="$(basename "$tpl")"
      dest="$PROJPATH/$base"
      if [ -f "$dest" ]; then echo "  (garde) $base existe déjà — non écrasé"; continue; fi
      sed -e "s/{{N}}/$N/g" -e "s/{{SLUG}}/${N,,}/g" -e "s/{{DATE}}/$(date +%F)/g" "$tpl" > "$dest"
      echo "  créé : $base"
    done
    echo
    echo "OK : fichiers créés depuis les gabarits (documentation/templates/projet)."
    echo "Complétez les placeholders <…> ; ordre piloté par le superviseur (reference-nouveau-projet.md, §C)."
    return
  else
    echo "  (gabarits non trouvés → squelettes embarqués de secours)"
  fi

  # --- README.md (secours) --------------------------------------------------
  write_file "README.md" "# $N
> Présentation du projet, usage par l'IA, démarrage. (Gabarit — à compléter)
"

  # --- PROJECT.md ------------------------------------------------------------
  write_file "PROJECT.md" "# PROJECT — $N
> Document de contrôle racine. Source de vérité : objectif, but, état courant, relations.
> Conventions d'ID : \`REQ-<cat>-NNNN\`, \`RUL-<cat>-NNNN\`, \`SEC-<cat>-NNNN\`, \`DEC-NNNN\`.

## Objectif
<une phrase : pourquoi ce projet existe>

## But
<ce que le projet doit offrir / la valeur>

## État actuel
<étape / statut courant>

## Principe
L'utilisateur définit la direction, les besoins et les contraintes. L'IA exécute dans ce cadre.

## En relation
\`REQUIREMENTS.md\` · \`ARCHITECTURE.md\` · \`RULES.md\` · \`SECURITY.md\` · \`DECISIONS.md\` · \`CHANGELOG.md\` · \`SKILL.md\`
"

  # --- REQUIREMENTS.md ---------------------------------------------------------
  write_file "REQUIREMENTS.md" "# Requirements — $N
> Document de contrôle racine. Chaque exigence porte un ID unique \`REQ-<CATÉGORIE>-<NNNN>\`.

## Exigences
### REQ-FONC — Fonctionnel
- **REQ-FONC-0001** : <description>
### REQ-TECH — Technique
- **REQ-TECH-0001** : <description>
### REQ-SEC — Sécurité
- **REQ-SEC-0001** : \`capable ≠ autorisé\` ; exécution sous permission.
"

  # --- ARCHITECTURE.md ----------------------------------------------------------
  write_file "ARCHITECTURE.md" "# Architecture — $N
> Document de contrôle racine. Structure standard (réutilisable) + architecture du projet.

## Structure standard (tout projet)
\`\`\`text
PROJECT/
├── PROJECT.md · REQUIREMENTS.md · ARCHITECTURE.md · RULES.md · SECURITY.md · DECISIONS.md · CHANGELOG.md · SKILL.md
├── documentation/
├── src/
├── tests/
├── config/
└── scripts/
\`\`\`
Les fichiers de contrôle racine sont constants ; les dossiers s'adaptent au type de projet.

## Architecture du projet
<schéma + couches / composants du projet>.
"

  # --- RULES.md ----------------------------------------------------------------
  write_file "RULES.md" "# Rules — Règles (${N})
> Chaque règle porte un ID \`RUL-<CATÉGORIE>-<NNNN>\`. Préfixe = catégorie ; numéro par catégorie, sans plafond.

## Règles
### RUL-PROJ — Respect du projet
- **RUL-PROJ-0001** : respecter objectifs, exigences et contraintes des documents du projet.
### RUL-CHANGE — Changements
- **RUL-CHANGE-0001** : comprendre avant de modifier ; ne pas inventer ; changements limités à la tâche.
### RUL-STRUC — Structure
- **RUL-STRUC-0001** : respecter \`ARCHITECTURE.md\` ; signaler tout changement structurel important.
### RUL-SEC — Sécurité / permissions
- **RUL-SEC-0001** : \`tools ≠ permissions\` ; \`capable ≠ autorisé\` ; mutations destructives → validation humaine.
### RUL-VAL — Validation
- **RUL-VAL-0001** : tester quand pertinent ; vérifier sur preuve (PASS = preuve).
### RUL-DOC — Documentation
- **RUL-DOC-0001** : mettre à jour la doc et le changelog quand le comportement change.
### RUL-COMM — Transparence
- **RUL-COMM-0001** : indiquer ce qui a été modifié, testé, les décisions et le reste à faire.
### RUL-SIMP — Simplicité
- **RUL-SIMP-0001** : privilégier une solution simple, maintenable et cohérente.
"

  # --- SECURITY.md ---------------------------------------------------------------
  write_file "SECURITY.md" "# Sécurité — $N
> Politique de sécurité. Dernière mise à jour : $(date +%F).

## 1. Principe fondamental
**capable ≠ autorisé** (et **tools ≠ permissions**) : déclarer un outil/capacité ne donne pas le droit de l'exécuter.
Autres principes : moindre privilège, défense en profondeur, **par défaut le refus** (fail-closed).

## 2. Modèle de décision
| Statut | Signification | Exécution |
|---|---|---|
| ALLOW | permission accordée | autorisée |
| NEED_CONFIRM | permission demandée / action humaine requise | **aucune exécution** sans confirmation |
| DENY | capacité non déclarée ou refusée | **jamais exécutée** |

## 3. Niveaux d'un outil
- read_only → lecture / diagnostic.
- mutate → écriture → **jamais auto**, confirmation.
- destructive → irréversible → **jamais auto + validation humaine**.

## 4. Mode par défaut
- **dry-run** par défaut (actions planifiées, non lancées) ; execute sous permission.
- Toute action destructive exige --confirm / confirmation humaine.
- **PASS = preuve** : un résultat non prouvé = NON VÉRIFIÉ.

## 5. Règles de sécurité (IDs)
Chaque règle porte un ID SEC-<CATÉGORIE>-<NNNN> (numéro par catégorie, repart à 0001).
### SEC-POL — Principes
- **SEC-POL-0001** : capable ≠ autorisé ; tools ≠ permissions.
- **SEC-POL-0002** : moindre privilège ; fail-closed (refus par défaut).
### SEC-ENV — Environnement
- **SEC-ENV-0001** : aucun secret en clair ; valider les entrées.
### SEC-EXE — Exécution
- **SEC-EXE-0001** : dry-run par défaut ; execute sous permission.
- **SEC-EXE-0002** : toute action destructive → confirmation humaine.
"

  # --- DECISIONS.md ----------------------------------------------------------------
  write_file "DECISIONS.md" "# Décisions — journal ($N)
> Chaque décision porte un ID \`DEC-<NNNN>\` (séquentiel) + **Décideur** (Humain | IA) + date.
> Règle : ne jamais effacer l'historique ; une nouvelle décision remplace et référence la précédente.

## Journal
### DEC-0001 — Première décision
- **Date :** $(date +%F) · **Statut :** Confirmé · **Décideur :** Humain
- **Contexte :** <pourquoi>
- **Décision :** <quoi>
- **Raison :** <pourquoi>
- **Impact :** <effet>
"

  # --- CHANGELOG.md ----------------------------------------------------------------
  write_file "CHANGELOG.md" "# Journal des modifications — $N
## Objectif
Conserver un historique clair des changements importants.

## Format
Chaque entrée : **Date** · **Version/étape** · **Résumé** · **Modifications** · **Notes**.

## Historique
### $(date +%F) — Création du projet
**Modifications**
- Création des fichiers principaux (scaffold-projet.sh).
- <entrées suivantes à compléter>
"

  # --- SKILL.md (racine) ------------------------------------------------------------
  write_file "SKILL.md" "---
name: ${N,,}
description: Compétence IA pour $N — point d'entrée (à compléter : rôle, permissions, outils).
---

# SKILL — $N (point d'entrée pour agents IA)
> Ce fichier explique à une IA comment travailler dans ce projet.

## 1. Ce qu'est le projet
<une phrase>. Source de vérité : \`PROJECT.md\` ; règles détaillées dans \`RULES.md\` / \`SECURITY.md\`.

## 2. Pour démarrer
- Lire \`PROJECT.md\` puis \`REQUIREMENTS.md\`.
- Suivre \`RULES.md\` et \`SECURITY.md\` (\`capable ≠ autorisé\`, \`PASS = preuve\`).
- Toute exécution passe la **porte humaine** (plan → act) — modèle superviseur-de-projet.

## 3. Principes
- \`tools ≠ permissions\` ; \`capable ≠ autorisé\` ; dry-run par défaut ; mutation → confirmation.
- Documenter et mettre à jour \`DECISIONS.md\` / \`CHANGELOG.md\` à chaque changement réel.
"

  # --- ROADMAP.md ------------------------------------------------------------------
  write_file "ROADMAP.md" "# ROADMAP — $N

> **Le projet ne se construit pas d'un seul coup.** Il est construit par **micro-étapes** :
> chaque capacité fonctionne → est testée → documentée → sauvegardée → validée avant la suivante.
> Cycle obligatoire : \`PLANIFIER → MODIFIER → TESTER → DOCUMENTER → BACKUP → VÉRIFIER → VALIDER → ÉTAPE SUIVANTE\`.

---

## 1. Vision du projet
\`\`\`text
<FONCTIONNALITÉ 1>
    ↓ <FONCTIONNALITÉ 2>
    ↓ <…>
\`\`\`

## 2. État actuel

| Phase / capacité | Statut | Preuve |
|---|---|---|
| <P1 — première capacité> | En cours | <test / sortie réelle> |
| <…> | Proposé | — |

## 3. Prochaine micro-étape (en cours)
### Objectif de l'étape
<ce que doit faire la micro-étape>

### Cycle à respecter
\`\`\`text
PLANIFIER → MODIFIER → TESTER → DOCUMENTER → BACKUP → VÉRIFIER → VALIDER
\`\`\`
"

  # --- DEPENDANCES.md ----------------------------------------------------------------
  write_file "DEPENDANCES.md" "# DEPENDANCES — $N

> **Déterminé par le superviseur-de-projet** : il y écrit **quels skills** le projet a besoin
> et **quelles bibliothèques** ces skills utiliseront. Les skills s'**activent** ; les bibliothèques
> s'**installent** (après confirmation, \`deps.sh install --confirm\`).

## Skills requis
\`\`\`text
# <skill> : <pourquoi il est nécessaire>
meta/superviseur-de-projet   : supervision (toujours actif)
\`\`\`

## Bibliothèques autorisées
\`\`\`text
# <paquet> : <raison>   (pour le skill concerné)
\`\`\`

## Règles
- Le superviseur décide les skills/librairies ; une lib doit être déclarée ici **avant** d'être utilisée.
- Toute installation passe la **porte humaine** (\`deps.sh install --confirm\`) + \`Policy → Risk\`.
"

  echo
  echo "OK : fichiers principaux créés dans '$PROJPATH' (projet '$N')."
  echo "Complétez les placeholders <…> ; l'ordre de création est piloté par le superviseur (reference-nouveau-projet.md, §C)."
}

case "$ACTION" in
  check) do_check ;;
  deep)  do_deep ;;
  new)   do_new ;;
  next)  do_next ;;
  *)     usage; exit 1 ;;
esac

