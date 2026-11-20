# Banque de skills — INDEX

> **Porte d'entrée de la banque.** Liste des skills disponibles, leur famille, leur rôle et leur statut.
> Chaque skill = un dossier avec un `SKILL.md`. Lire cet index avant de chercher ou créer une compétence
> (éviter les doublons ; voir `skill-factory` pour gérer la banque).

## Skills principaux

| Skill | Famille | Rôle | Statut |
|---|---|---|---|
| `superviseur-de-projet` | meta | Superviser les projets (maître → équipe meta) | Verified *(en usage)* |
| `language` | language | Développer dans tous les langages (Python, Rust, C++/UE5, Bash, Go, Web, Java-Mod + Rust avancé Core) | Verified · 0.3.0 |
| `skill-factory` | meta | Gérer la banque (inventaire → recherche → synthèse → construction → validation) | Draft |
| `coding-project` | profile | Profil de type projet — développement logiciel (contexte code) | Verified · 0.1.0 |

## Skills Core système (technology / domain) — socle pour un core de service
| Skill | Famille | Rôle | Statut |
|---|---|---|---|
| `persistence` | technology | SQLite/rusqlite, migrations, WAL, fail-closed | Verified · 0.1.0 |
| `api` | technology | API versionnée (transport/contrats), sécurité | Verified · 0.1.0 |
| `scheduler-tasks` | technology | Tâches (machine à états) + scheduler minimal | Verified · 0.1.0 |
| `cli` | technology | Couche mince CLI (clap, stdout/stderr, secrets) | Verified · 0.1.0 |
| `sessions-security` | domain | Sessions, MFA/TOTP, WebAuthn, recovery, dernier admin | Verified · 0.1.0 |
| `linux` | technology | Module Platform/Linux : admin, durcissement, récupération | Verified · 0.1.0 |
| `vault` | technology | Secrets chiffrés : rotation, révocation, audit | Verified · 0.1.0 |
| `monitoring` | technology | Observabilité : métriques, logs, alertes actionnables | Verified · 0.1.0 |
| `storage` · `network` · `containers` · `virtualisation` · `hardware` · `file-manager` | technology | Modules infra (stockage/réseau/conteneurs/VM/matériel/fichiers) | Verified · 0.1.0 |
| `audit` · `workflows` · `notifications` | meta/technology | Audit, workflows, notifications | Verified · 0.1.0 |

## Sous-skills de `superviseur-de-projet` (meta-team, 16)
analyse-de-problemes · planning · architecture · testing · validation · documentation · security ·
policy · risk · troubleshooting · backup · orchestration · conversation-export · profile · plan-mode · act-mode

> Rôle détaillé de chaque membre : voir `superviseur-de-projet/README.md`.

## Sous-skills de `skill-factory` (6)
| Skill | Rôle |
|---|---|
| `inventory` | Inventorier la banque (doublons, obsolètes) |
| `gap-analyzer` | Détecter les écarts besoins ↔ banque + plan priorisé |
| `researcher` | Recherche multi-sources (fiabilité ≠ par défaut) |
| `synthesizer` | Synthèse (faits/hypothèses, contradictions, traçabilité) |
| `builder` | Créer/améliorer les skills au format Projet Zero |
| `validator` | Valider (structure, méta, sécurité, dépendances) → Verified/rejet |

## Conventions (rappel)
- **Un skill = un dossier** : `SKILL.md` (frontmatter + procédure) + optionnel `tools/`, `data/`, `sous-skills/`.
- **Familles** : `language, technology, domain, meta, governance, profile, pack`.
- **Statuts** : Research · Draft · Testing · Verified · Archived.
- **Sécurité** : `capable ≠ autorisé`, `--confirm`, anti-traversal, PASS = preuve, pas de secret.
- **Gestion de la banque** → `skill-factory` ; **supervision des projets** → `superviseur-de-projet`.

## Outils de gestion
| Outil | Où | Rôle |
|---|---|---|
| `skills/meta/skill-factory/tools/validate-skill.sh` | skill-factory | contrôle local structure/métadonnées d'un skill |
| `skills/superviseur-de-projet/tools/*` | superviseur | scaffolder, permissions, environnement de test |

> Index créé le 2026-11-18. À tenir à jour à chaque ajout/modification de skill (voir skill-factory).
