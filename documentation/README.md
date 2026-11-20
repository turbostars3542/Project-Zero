# Projet Zero — documentation

> Index du dossier `documentation/`. Pour le moteur et son usage, voir le **README racine**
> (`../README.md`) et le point d'entrée IA (`../SKILL.md`).

## Contenu

| Élément | Rôle |
|---|---|
| `templates/skill/SKILL_TEMPLATE.md` | Gabarit unique de création d'un skill (format v2) |
| `templates/planning/` | Gabarits de planification (PROBLEM, ROADMAP, RULES, SUIVI, TASKS) |
| `templates/projet/` | Gabarits des fichiers principaux d'un nouveau projet (utilisés par le scaffolder) |

> Les gabarits **v1** (PATRON, rag_local, TOOL_TEMPLATE, KNOWLEDGE_LANGUAGE_TEMPLATE,
> EXEMPLES) ne sont plus utilisés ; seul le format v2 reste.

## Rôle

- `documentation/templates/` = le **moule** (modèles à copier pour créer un skill, un gabarit de plan
  ou les fichiers d'un projet). On ne l'exécute pas : on s'en sert pour fabriquer le réel (`skills/`).
- **`SKILL_TEMPLATE.md`** = source de référence pour créer un skill (format v2).
- `templates/projet/` = la **source unique** des fichiers générés pour un nouveau projet.
- L'ancien moteur (v1) a été **remplacé** par la méthode traditionnelle (sans moteur).
