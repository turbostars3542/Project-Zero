---
name: reference-nouveau-projet
description: Référence de démarrage pour CRÉER les fichiers principaux d'un nouveau projet : la liste des fichiers, les gabarits à copier, les permissions et l'ordre de création piloté par le superviseur.
role: Servir de guide unique pour bootstrapper un projet (les 8 fichiers principaux + README + plan), géré par la méta-equipe.
limites: N'exécute rien. Ne décide pas à la place de l'humain (porte plan → act). Les gabarits vivent dans documentation/templates/ ; la rédaction de chaque fichier revient au sous-skill propriétaire.
tools: [ ]
---

# reference-nouveau-projet — bootstrap d'un projet

> Utiliser ce document à **chaque nouveau projet** : il indique QUELS fichiers principaux créer,
> QUI les écrit, QUI peut les lire/modifier, et DANS QUEL ORDRE.

## A. Les fichiers principaux d'un projet

| # | Fichier | Rôle | Gabarit / source | Écrit par |
|---|---|---|---|---|
| 1 | `PROJECT.md` | Source de vérité : objectif, but, état, relations, conventions ID | `_archive/docs-racine/PROJECT.md` | superviseur-de-projet |
| 2 | `REQUIREMENTS.md` | Exigences (`REQ-<cat>-NNNN`) | `_archive/docs-racine/REQUIREMENTS.md` | analyse-de-problemes |
| 3 | `ARCHITECTURE.md` | Structure standard + architecture | `_archive/docs-racine/ARCHITECTURE.md` | architecture |
| 4 | `RULES.md` | Règles du projet (`RUL-<cat>-NNNN`) | `_archive/docs-racine/RULES.md`, `templates/planning/RULES.md` | superviseur-de-projet |
| 5 | `SECURITY.md` | Sécurité (`SEC-<cat>-NNNN`, capable ≠ autorisé) | `_archive/docs-racine/SECURITY.md`, `documentation/SECURITY.md` | security |
| 6 | `DECISIONS.md` | Journal des décisions / ADR (`DEC-NNNN` + Décideur) | `_archive/docs-racine/DECISIONS.md` | documentation |
| 7 | `CHANGELOG.md` | Changelog | `_archive/docs-racine/CHANGELOG.md` | documentation |
| 8 | `SKILL.md` (racine) | Compétence IA du projet (YAML + procédure) | `documentation/templates/skill/SKILL_TEMPLATE.md` | superviseur-de-projet |
| + | `README.md` | Présentation / usage IA | — | documentation |
| + | `PROBLEM.md` | Cadrage du problème | `templates/planning/PROBLEM.md` | analyse-de-problemes |
| + | `ROADMAP.md` | Feuille de route du projet en **micro-étapes** | `templates/projet/ROADMAP.md` | planning |
| + | `DEPENDANCES.md` | **Skills requis** + **bibliothèques autorisées** (déterminés par le superviseur ; les skills s'activent, les libs s'installent après confirmation) | `templates/projet/DEPENDANCES.md` | superviseur-de-projet 🧑 |
| + | `TASKS.md · SUIVI.md · RULES.md` | Tâches, suivi, règles | `templates/planning/` | planning |

> Les profils de type de projet (coding-project…), une fois créés, servent de référence d'un projet structuré.

## B. Matrice de permissions (lire / écrire / modifier)

Principe : « **capable ≠ autorisé** ». Le **propriétaire** écrit/modifie son fichier ; les autres
**lisent** seulement ; toute *modification* passe la **porte humaine** (plan → act).

| Fichier | ✏️ Écrit | 🔧 Modifie | 👁️ Lit |
|---|---|---|---|
| `PROJECT.md` | superviseur | superviseur (+ humain) | toute l'équipe |
| `REQUIREMENTS.md` | analyse-de-problemes | analyse-de-problemes | équipe + utilisateur |
| `ARCHITECTURE.md` | architecture | architecture | équipe |
| `RULES.md` | superviseur | superviseur (+ humain) | équipe |
| `SECURITY.md` | security | security (+ humain) | équipe |
| `DECISIONS.md` | documentation | documentation | équipe |
| `CHANGELOG.md` | documentation | documentation | équipe |
| `SKILL.md` (racine) | superviseur | superviseur (+ humain) | toute app IA |
| `README.md` | documentation | documentation | équipe |
| `PROBLEM.md` | analyse-de-problemes | analyse-de-problemes | équipe |
| `ROADMAP/TASKS/SUIVI/RULES` | planning | planning | équipe |

> La source de vérité des permissions pour un SKILL = ses `limites:` (qui NE peut PAS) + la
> **porte humaine** : rien ne se modifie sans validation explicite de l'utilisateur.

## C. Ordre de création (ordre de marche / handoffs du superviseur)

```text
1. superviseur           → initie : ouvre le projet, pose PROJECT.md (objectif, cap)
2. analyse-de-problemes  → PROBLEM.md + REQUIREMENTS.md (cadrage, exigences)
3. planning              → ROADMAP.md / TASKS.md / RULES.md / SUIVI.md (plan)
4. architecture          → ARCHITECTURE.md (structure)
5. security              → SECURITY.md (règles + permissions)
6. documentation         → DECISIONS.md / CHANGELOG.md / README.md
7. superviseur           → ferme : SKILL.md racine (compétence IA) + revue du tout
```

Règles de l'ordre :
- On ne crée **pas** un fichier à l'avance sans raison réelle (construction progressive).
- Chaque fichier est validé par son propriétaire avant de passer à l'étape suivante.
- À la fin, le superviseur **vérifie** que la méta-equipe est complète et les 8 fichiers cohérents.

## Comment le superviseur s'en sert
1. Au démarrage d'un nouveau projet → **lire ce document**.
2. Suivre l'ordre (section C) en **déléguant** chaque fichier au sous-skill propriétaire (section A).
3. Appliquer la **matrice de permissions** (section B) : le propriétaire écrit, les autres lisent.
4. Toute création/modification passe la **porte humaine** (plan → act).

## Vérifier (PASS = preuve)
- Les fichiers principaux créés correspondent à la liste (A).
- Chaque fichier a été produit par son propriétaire (A) selon les permissions (B), dans l'ordre (C).
- Aucun fichier créé sans raison réelle ; rien modifié sans porte humaine.
