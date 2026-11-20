# superviseur-de-projet — README du skill

> Le skill maître de supervision, **actif en permanence pour chaque projet**.
> Ce fichier explique le skill et **tous ses sous-skills** (`meta-team/`), ses outils (`tools/`)
> et ses références. C'est la **porte d'entrée unique** pour comprendre ce qui se trouve ici.

---

## À quoi sert ce skill

**Superviser un projet** en continu : organiser l'équipe meta, garantir l'ordre des étapes,
veiller à la cohérence et au cap, et faire respecter la **porte humaine** (plan → act).
C'est le **skill central** vers lequel les autres projets se réfèrent pour bien démarrer.

**Principe fort** : le projet est construit **par MICRO-ÉTAPES** (cycle
`PLANIFIER → MODIFIER → TESTER → DOCUMENTER → BACKUP → VÉRIFIER → VALIDER → ÉTAPE SUIVANTE`),
jamais « d'un seul coup ».

---

## Structure

```
superviseur-de-projet/
├── SKILL.md                     # LE skill maître (procédure complète)
├── README.md                    # CE document — explique le skill et ses sous-skills
├── reference-nouveau-projet.md  # référence : fichiers principaux + permissions + ordre de création
├── tools/                       # outils LOCAUX (zéro token)
│   ├── scaffold-projet.sh       # check / deep / new / next (créer, vérifier, numéroter)
│   ├── check-permissions.sh     # who / may (qui peut lire/écrire/modifier)
│   └── test-env.sh              # environnement de test FERMÉ (create/run/list/clear)
└── meta-team/                   # les sous-skills (l'équipe)
```

---

## Suivi des documents : qui fait quoi
> Chaque document du skill a un **rôle** et un **propriétaire** (écrit/maintenu par — matrice
> des permissions, `reference-nouveau-projet.md` §B). « 🧑 *(+ humain)* » = modification exige la
> **porte humaine** (plan → act).

| Document | Rôle — à quoi il sert | Qui l'écrit/maintenne |
|---|---|---|
| `SKILL.md` | Procédure du superviseur (cap, micro-étapes, handoffs) | superviseur-de-projet 🧑 |
| `README.md` | Cette porte d'entrée : explique le skill + sous-skills + outils | superviseur-de-projet |
| `reference-nouveau-projet.md` | Fichiers principaux + permissions + ordre de création | superviseur-de-projet 🧑 |
| `tools/scaffold-projet.sh` | Créer/vérifier/valider/numéroter les projets | superviseur-de-projet 🧑 |
| `tools/check-permissions.sh` | Qui peut lire/écrire/modifier (ALLOW/NEED_CONFIRM/DENY) | superviseur-de-projet 🧑 |
| `meta-team/*/SKILL.md` | Chaque sous-skill (rôle + limites) | le sous-skill lui-même |

#### Documents qu'un nouveau projet reçoit (gabarits de `documentation/templates/projet/`)

| Fichier du projet | Rôle — à quoi il sert | Écrit par (sous-skill) |
|---|---|---|
| `README.md` | Présentation / usage IA | documentation |
| `PROJECT.md` | Source de vérité (objectif, but, état) | superviseur-de-projet 🧑 |
| `REQUIREMENTS.md` | Exigences (`REQ-…`) | analyse-de-problemes |
| `ARCHITECTURE.md` | Structure + architecture | architecture |
| `RULES.md` | Règles du projet (`RUL-…`) | superviseur-de-projet 🧑 |
| `SECURITY.md` | Sécurité (`SEC-…`, capable ≠ autorisé) | security |
| `DECISIONS.md` | Journal des décisions (`DEC-…`) | documentation |
| `CHANGELOG.md` | Changelog | documentation |
| `ROADMAP.md` | Feuille de route (micro-étapes) | planning |
| `DEPENDANCES.md` | Skills requis + bibliothèques autorisées (→ skills métier) | superviseur-de-projet 🧑 |
| `SKILL.md` (racine) | Compétence IA du projet | superviseur-de-projet 🧑 |

---

## Les sous-skills (`meta-team/`)

L'équipe meta travaille **ensemble** comme une équipe. Chaque membre a **un rôle et des
limites** (qui fait quoi, qui NE fait PAS). Le superviseur organise, les membres exécutent.

### Rôles de travail (métier)

| Sous-skill | Rôle | Limites |
|---|---|---|
| `analyse-de-problemes` | Cadre le besoin (`PROBLEM.md`, exigences) | ne planifie pas, ne valide pas |
| `planning` | Roadmap / tâches / suivi **en micro-étapes** | ne cadre pas, ne valide pas |
| `architecture` | Structure du projet | ne teste pas, ne valide pas |
| `testing` | Exécute les tests réels | ne valide pas le verdict |
| `validation` | Verdict sur **preuves** (`PASS = preuve`) | ne produit pas les faits |
| `documentation` | Documente l'état réel, décisions, changelog | ne valide pas les livrables |
| `troubleshooting` | Diagnostic cause-racine après échec | ne documente pas les phases |
| `security` | Revue lecture seule (sécurité, deny gagne, audit trail) | ne donne aucune permission |
| `policy` | Couche de règles `ALLOW/DENY/CONFIRM_REQUIRED` (deny gagne, pass-through) | n'exécute rien, ne donne aucune permission |
| `risk` | Classe le risque `LOW/MEDIUM/HIGH` → confirmation / blocage | n'autorise jamais un refus, n'exécute rien |
| `backup` | Sauvegarde / restauration (outil `snapshot.sh`) | ne modifie pas le contenu |
| `orchestration` | Coordonne l'équipe quand la tâche est distribuée | ne fusionne pas, 0 permission |
| `conversation-export` | Exporte les sessions / discussions | ne décide pas |

### Modes & profils (permanents, chaque projet)

| Sous-skill | Rôle | Notes |
|---|---|---|
| `profile` | Indique **quel mode** est actif | permanent, chaque projet |
| `plan-mode` | Réflexion / planification (posture PAR DÉFAUT) | s'arrête à la porte humaine |
| `act-mode` | Exécution, après activation + confirmation humaine | exécute par micro-étapes, retour en plan-mode |

> **Porte humaine** : plan-mode (défaut) → validation humaine → act-mode → exécution → retour plan-mode.

---

## Les outils (`tools/`)

Outils **locaux** (aucun LLM, zéro token) invoqués par l'IA/l'app en parallèle.

| Outil | Actions | Rôle |
|---|---|---|
| `scaffold-projet.sh` | `check` · `deep` · `new` · `next` | Crée/vérifie les fichiers principaux, valide le contenu, gère la numérotation |
| `check-permissions.sh` | `who` · `may` | Répond *« qui peut lire/écrire/modifier X ? »* → ALLOW / NEED_CONFIRM / DENY |
| `test-env.sh` | `create` · `run` · `list` · `clear` | **Environnement de test FERMÉ** : teste des commandes dans un sandbox isolé sans toucher le vrai projet |

### `test-env.sh` (environnement de test fermé)
- `create <projet> [--copy]` : crée `.sandbox` (vide ou copie du projet).
- `run <projet> -- <cmd>` : exécute la commande **dans** le sandbox (le vrai projet n'est pas affecté).
- `list <projet>` : contenu du sandbox (lecture).
- `clear <projet> --confirm` : vide le sandbox (**destructif → `--confirm`**).

### `scaffold-projet.sh`
- `check <dossier>` : fichiers présents / manquants (lecture seule).
- `deep <dossier>` : valide aussi le **contenu** (frontmatter YAML, placeholders, décisions) → `PASS` ou `NON VÉRIFIÉ`.
- `new <dossier> [--project-name <nom>] [--confirm]` : génère les **10 fichiers principaux**
  **depuis les gabarits** (source unique : `documentation/templates/projet/`) ; ne jamais écraser sans `--confirm`.
- `next <fichier> --category <PREFIX>` : prochain numéro pour une catégorie → `REQ-…`, `RUL-…`, `SEC-…`, `DEC-…`.

### `check-permissions.sh` (matérialise `capable ≠ autorisé`)
- `who <fichier>` : propriétaire + qui lit.
- `may <sous-skill> <fichier> <read|write|modify>` : `ALLOW` / `NEED_CONFIRM` / `DENY`.
  Modélise la matrice de `reference-nouveau-projet.md` (§B).

> **Gabarits = source unique** : `documentation/templates/projet/` (les 10 fichiers).
> Les éditer là, puis `new` les copie avec substitution (`{{N}}`, `{{SLUG}}`, `{{DATE}}`).
> Les squelettes embarqués ne servent que de **secours** si ce dossier est absent.

---

## Référence

- **`reference-nouveau-projet.md`** : au démarrage d'un nouveau projet → liste des fichiers
  principaux, gabarits, **matrice de permissions** (lire/écrire/modifier), ordre de création.

---

## Comment l'utiliser

1. Lire `SKILL.md` (procédure du superviseur) et `README.md` (vue d'ensemble).
2. Démarrer un nouveau projet → `reference-nouveau-projet.md` + `tools/scaffold-projet.sh new`
   (génère les fichiers principaux **y compris `ROADMAP.md`**, la feuille de route du projet en micro-étapes).
3. À chaque tâche, activer les bons sous-skills (métier + modes) selon la porte humaine.
