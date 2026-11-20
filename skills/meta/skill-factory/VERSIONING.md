# VERSIONING — règles de numérotation et d'amélioration des skills

> **Référence obligatoire** pour toute version d'un skill de la banque (via `Skill Factory`).
> Chaque skill déclare `version` + `status` dans son frontmatter ; le registre
> (`_meta/registry.md`) est régénéré par `tools/inventory.sh` pour refléter l'état réel.

---

## 1. Format du numéro de version
Chaque skill porte une version **semver** : `MAJEUR.MINEUR.CORRECTIF` (ex. `1.2.3`).

| Partie | Incrément quand |
|---|---|
| **MAJEUR** | changement **incompatible** ou **refonte** (rôle, procédure principale, contrat changés) |
| **MINEUR** | **amélioration/ajout** rétrocompatible (nouvelle section, meilleure procédure, nouveau tool) |
| **CORRECTIF** | correction de bug, coquille, précision, documentation — sans changer le comportement déclaré |

> Départ conseillé : `0.1.0` (prime version d'un skill actif). Passage à `1.0.0` dès qu'on
> considère la procédure stable et « Verified ».

## 2. Règle (obligatoire)
1. **Tout skill DOIT déclarer `version:` et `status:`** dans son frontmatter (le validateur le vérifie
   `validate-skill.sh` : version recommandée, family obligatoire).
2. **On n'incrémente pas** sans raison : une correction de coquille = `CORRECTIF`, une amélioration
   réelle = `MINEUR` (ou `MAJEUR` si incompatible).
3. **On ne réutilise pas** un numéro : chaque version publiée/validée est unique et conservée en trace.
4. La version **Verified** correspond à l'état effectivement validé (un skill corrigé doit être
   **revalidé** avant de re-pointer sa version).

## 3. Amélioration d'une version (procédure)
Quand on améliore un skill (retour de `validator`, nouveau besoin, meilleure pratique) :
1. Identifier le **type de changement** (MAJEUR / MINEUR / CORRECTIF) → incrément du champ adéquat.
2. **Enregistrer** dans le journal d'audit (`_meta/audit.log.md` via `tools/record-audit.sh`) :
   `skill | action=improve | ancienne→nouvelle version | raison | décideur`.
3. Optionnel : noter l'**amélioration** dans un CHANGELOG du skill (ex. `CHANGELOG.md` dans le dossier
   du skill) pour garder l'historique des raisons.
4. **Revalider** le skill (`validate-skill.sh`) → `PASS`.
5. **Régénérer le registre** (`inventory.sh`) pour que la version y soit à jour.

## 4. Statuts liés
| Statut | Version | Signification |
|---|---|---|
| Research / Draft | `0.x` | en construction, non stable |
| Testing | `0.x` | en cours de validation |
| **Verified** | `≥0.1.0` | validé et intégré (usage) |
| Archived | conservée | version remplacée/obsolète, numéro conservé pour trace |

## 5. Exemple (workflow)
```text
language v0.1.0 → amélioration (ajout pièges) → v0.2.0 MINEUR → validate PASS → Verified
superviseur v0.1.0 Verified → refonte du protocole de handoffs → v1.0.0 MAJEUR → revalider → registre
```
