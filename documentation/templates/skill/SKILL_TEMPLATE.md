# SKILL_TEMPLATE — gabarit unique pour créer un skill

> **Un skill = un dossier, le plus simple possible.** Le cœur est **`SKILL.md`** (identité + procédure).
> Tout le reste (outils, données, sous-skills) est optionnel et à sa place.
>
> **Sécurité :** appliquer `documentation/SECURITY.md` à chaque skill (capable ≠ autorisé,
> destructif → confirmation, anti-traversal, PASS = preuve).

---

## A. Structure (le moins de fichiers possible)

```
skills/<famille>/<skill>/
├── SKILL.md            # LE skill : identité (YAML) + procédure — obligatoire
├── tools/              # optionnel : UNIQUEMENT si action locale
│   └── <tout>          #   un script par groupe d'actions + un README
│       ├── <nom>.sh    #   exécution locale (zéro token)
│       └── README.md   #   explique comment ça marche
├── data/               # optionnel : connaissances / données
└── sous-skills/        # optionnel : skills que le maître pilote (équipe)
    └── <sous-skill>/SKILL.md
```

> **Règle :** aucun dossier ni fichier inutile. Si ce n'est pas nécessaire, ne pas le créer.

---

## B. `SKILL.md` — le fichier principal

```markdown
---
name: <slug>
description: <ce que ça fait, 1 phrase>
role: <ce qu'il FAIT dans l'équipe>
limites: <ce qu'il NE fait PAS>            # frontières nettes
tools: [ <nom_script> ]                    # s'il lance des actions locales
---

# <Nom> — procédure

## Objectif
<ce que le skill permet d'accomplir>

## Quand l'utiliser
<dans quel contexte / quel signal le déclencher>

## Comment faire
1. <étape 1>
2. <étape 2>
3. <étape 3>

## Règles
- <contraintes / limites / contexte>

## Vérifier (PASS = preuve)
- <condition vérifiable : hash, sortie, résultat réel>
```

---

## C. Équipe / sous-skills (le maître pilote ses sous-skills)

Un **skill maître** peut regrouper des **sous-skills** qui travaillent **ensemble comme une équipe**.
Chaque sous-skill est un **dossier** avec son propre `SKILL.md` (même format), dans `sous-skills/`.

```
skills/<famille>/<maître>/
├── SKILL.md                 # le maître : son rôle, et comment il pilote l'équipe
└── sous-skills/
    ├── <skill-A>/SKILL.md   # un membre de l'équipe
    ├── <skill-B>/SKILL.md   # un autre
    └── ...
```

### Règles d'équipe
- **Chaque skill a un rôle et des limites** (frontières) : savoir qui fait quoi et qui NE fait PAS.
- **Le maître** décrit dans son `SKILL.md` : comment il décompose la tâche, qui fait quoi, et comment il combine/réfèrence ses sous-skills.
- Les sous-skills **se référencent** entre eux (ex. `limites:` « ne cadre pas → voir analyse-de-problemes ») pour travailler en chaîne.
- **Le maître coordonne**, il ne fait pas le travail des membres (chacun le sien).

### Exemple (équipe meta)
```
meta-team/
├── analyse-de-problemes/   # qui cadre
├── planning/               # qui planifie
├── architecture/           # qui structure
├── testing/ · validation/  # qui vérifie
├── documentation/ · backup/
└── orchestration/          # qui coordonne l'équipe
```

---

## D. `tools/` — action locale (optionnel)

- Un **script par groupe d'actions** (ex. `snapshot.sh` fait `create | list | restore`).
- **Sécurité** : une action **destructive** exige `--confirm` / confirmation humaine (SECURITY.md).
- Chaque script a son `README.md` (quoi, comment, sécurité).

```bash
#!/usr/bin/env bash
# <nom>.sh — actions : <a>, <b>, <c> (sécurité : destructif = --confirm)
set -euo pipefail
case "${1:-}" in
  <a>) echo "fait a" ;;
  <b>) echo "fait b" ;;
  <c>) [ "${2:-}" = "--confirm" ] || { echo "BLOQUÉ : <c> exige --confirm"; exit 1; }
       echo "fait c (confirmé)" ;;
  *) echo "usage: $0 <a|b|c>"; exit 1 ;;
esac
```

## `tools/README.md` :
```markdown
# <nom>.sh — comment ça marche
## Rôle
## Actions (table : action / effet / sécurité)
## Sécurité (capable ≠ autorisé, destructif → --confirm)
## Comment l'IA l'utilise
```

---

## E. Règles de création (rappel)

1. **Penser d'abord à ce que le skill fait** (rôle + limites) → dans `SKILL.md`.
2. **N'ajouter `tools/` que si** une action locale est réellement utile (économie de tokens).
3. **Grouper** les actions proches dans un **seul script** (moins de fichiers).
4. **Documenter la sécurité** dans le README + appliquer `SECURITY.md`.
5. **Ne rien créer d'inutile** (moins de fichiers = plus simple).

---

## F. Références
- `documentation/SECURITY.md` — règles de sécurité à appliquer à chaque skill.
- `documentation/templates/` — autres gabarits (knowledge, tool, planning) à usage de référence.
- Exemple concret : `skills/meta/backup/` (SKILL.md + tools/snapshot.sh).
