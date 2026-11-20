---
name: coding-project
description: PROFIL DE PROJET pour le développement logiciel (contexte code). S'utilise AVEC un mode (plan-mode par défaut / act-mode après porte humaine). Définit la structure standard, les skills activés, les conventions d'identifiants et le cycle de phases d'un projet de code.
family: profile
status: Verified
version: 0.1.0
role: Cadrer un projet de développement logiciel : structure type, skills du socle, identifiants uniques, phases et règles du contexte code.
limites: Ne fait pas le travail des skills métier (→ skills activés). Ne décide pas seul (→ superviseur + porte humaine). S'applique AVEC un mode (plan/act). Ne sélectionne pas encore les frameworks précis.
tools: [ ]
---

# coding-project — profil de projet (contexte code)

> Profil de **type de projet** pour le développement logiciel. S'utilise **avec** un mode
> (`plan-mode` par défaut, `act-mode` après porte humaine). S'appuie sur `profile`, `plan-mode`,
> `act-mode` et la supervision (`superviseur-de-projet`).

## Objectif
Définir ce qu'est un **projet de développement logiciel** dans Projet Zero :
- la **structure standard** du dépôt ;
- les **skills du socle** à activer (qui fait quoi) ;
- les **conventions d'identifiants** uniques ;
- le **cycle de phases** (cadrage → … → suivi) ;
- les **règles de contexte** (capacité ≠ autorisation, porte humaine, preuve).

## Quand l'utiliser
Au **démarrage d'un projet de code**, pour cadrer le contexte. Permanent tant que le projet est actif
(comme tout profil). C'est la base sur laquelle reposent d'autres profils.

## Comment faire
### 1. Poser la structure standard
Fichiers de contrôle racine : `REQUIREMENTS.md` · `RULES.md` · `SECURITY.md` · `CHANGELOG.md` · `SKILL.md`
Dossiers : `src/` · `tests/` · `documentation/` · `config/` · `scripts/`

### 2. Activer les skills du socle (contexte acteur)
| Skill | Rôle |
|---|---|
| `python` | implémenter le code |
| `testing` | exécuter les tests |
| `validation` | vérifier sur preuves (DoD) |
| `documentation` | maintenir la documentation |
| `security` | revue de sécurité (lecture seule) |
| `troubleshooting` | diagnostic cause-racine |
| `backup` | sauvegarde / restauration locale |

> Ajuster la liste selon le langage/domaine réel (ex. `language` pour changer de langage).

### 3. Convention d'identifiants uniques
- `REQUIREMENTS.md` → `REQ-<CAT>-NNNN`
- `RULES.md` → `RUL-<CAT>-NNNN`
- `SECURITY.md` → `SEC-<CAT>-NNNN`
- `DECISIONS.md` → `DEC-NNNN` (séquentiel)
Numéros **uniques dans le projet**, jamais de doublon (utiliser `scaffold-projet.sh next`).

### 4. Cycle d'un projet de code
```text
cadrage (analyse-de-problemes, planning)
    ↓ conception (architecture)
    ↓ implémentation (architecture, python)
    ↓ validation (testing, validation)
    ↓ documentation (documentation)
    ↓ suivi (planning, backup, troubleshooting)
```
Chaque phase respecte le cycle micro-étapes
`PLANIFIER → MODIFIER → TESTER → DOCUMENTER → BACKUP → VÉRIFIER → VALIDER`.

## Règles du profil
- **Porte humaine avant exécution** (`human_gate_before_act`).
- **tools ≠ permissions**, **capable ≠ autorisé**.
- **Aucun secret dans le code** (`no_secret_in_code`).
- **Plan indépendant de l'implémentation** (`plan_implementation_agnostic`).
- **Valider les entrées, anti-traversal**.
- **Identifiants uniques, jamais de doublon**.
- **Milestone validée uniquement avec preuve** (`milestone_validated_only_with_proof`, PASS = preuve).
- **dry-run par défaut ; execute sous permission**.

## Vérifier (PASS = preuve)
- Structure standard posée (5 fichiers de contrôle + dossiers `src/tests/documentation/config/scripts`).
- Skills du socle activés ; identifiants uniques respectés (pas de doublon).
- Chaque phase clôturée a une preuve (tests, sortie) — sinon `NON VÉRIFIÉ`.
- Aucune exécution / action destructive sans porte humaine.
