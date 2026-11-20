# Projet Zero — Banque de skills

> **Simple et sans moteur** : les skills sont des **fichiers `SKILL.md`** que toute app IA lit
> **directement** (Bionic, Claude, Codex, agent autonome…). Aucun moteur Python, aucun client MCP,
> aucun serveur à maintenir.

---

## 🇫🇷 Français

**Projet Zero** est une banque de compétences (skills) structurée pour être lue **directement** par
une intelligence artificielle, sans aucun moteur à installer. Chaque compétence est un dossier simple
contenant un fichier `SKILL.md`.

### Comment les IA l'utilisent

1. L'IA lit **`SKILL.md`** — un fichier `.md` avec des métadonnées YAML (`name`, `description`) au début — pour reconnaître la compétence.
2. Elle ouvre ensuite le **`SKILL.md` du dossier du skill** voulu pour connaître la procédure.
3. Si un skill a une action exécutable localement, il expose des **scripts dans `tools/`**
   (ex. `backup/tools/snapshot.sh create`). Ces étapes déterministes tournent **en local**,
   ce qui économise les jetons (tokens).

> **Aucun MCP nécessaire** : l'IA lit les fichiers `.md` directement et exécute les scripts locaux.

### Structure

```
Project-Zero/
├── README.md                # présentation / usage (ce fichier)
├── SKILL.md                 # COMPÉTENCE pour les IA (.md + YAML frontmatter)
├── .gitignore               # fichiers exclus du dépôt (backups, éditeurs…)
├── documentation/
│   ├── README.md · SECURITY.md          # règles de sécurité pour créer un skill
│   └── templates/          # gabarits (skill, planning, projet)
└── skills/<famille>/<skill>/   # UN SKILL = UN DOSSIER
    ├── SKILL.md             # obligatoire : YAML court + procédure
    ├── tools/               # optionnel : script par groupe d'actions + README
    ├── data/                # optionnel : base locale (RAG…)
    └── sous-skills/         # optionnel : sous-skills pilotés (équipe)
```

### Familles de skills

- **`skills/language/`** — langages de programmation et environnement.
- **`skills/technology/`** — sujets techniques (API, CLI, Linux, réseau, stockage, virtualisation, etc.).
- **`skills/domain/`** — métiers et domaines spécialisés (rétro-ingénierie…).
- **`skills/meta/`** — **Skill Factory** : inventaire, analyse des lacunes, recherche, synthèse,
  construction et validation des skills.
- **`skills/profile/`** — profils d'agent (ex. `coding-project`).
- **`skills/superviseur-de-projet/`** — le **skill maître** actif en permanence, qui pilote son équipe
  de sous-skills (planning, architecture, testing, documentation, backup, orchestration…).

### Principes

- **Aucun moteur** : chaque skill = un dossier lisible directement par l'IA, sans exécutable à maintenir.
- **Un skill = un dossier le plus simple** : `SKILL.md` + optionnellement `tools/`, `data/`, `sous-skills/`.
- **Minimalisme** : le moins de fichiers possible ; on fusionne plutôt que dupliquer.
- **Sécurité** (`documentation/SECURITY.md`) : `capable ≠ autorisé` ; action destructive → confirmation
  (`--confirm`) ; **PASS = preuve** (une validation passeur = preuve, pas une simple affirmation).
- **Économie de jetons** : les étapes déterministes tournent **en local** via les scripts `tools/`.
- **Équipe** : le skill maître (`superviseur-de-projet`) décompose et pilote ses sous-skills.

---

## 🇬🇧 English

**Projet Zero** is a **skill bank** designed to be read **directly** by an AI, with **no engine to
install**. Each skill is a simple folder containing a `SKILL.md` file.

### How AIs use it

1. The AI reads **`SKILL.md`** — a file with YAML metadata (`name`, `description`) at the top — to recognize the skill.
2. It then opens the **`SKILL.md` of the desired skill folder** to learn the procedure.
3. If a skill has a locally executable action, it exposes **scripts in `tools/`**
   (e.g. `backup/tools/snapshot.sh create`). These deterministic steps run **locally** to save tokens.

> **No MCP required** : the AI reads the `.md` files directly and runs the local scripts.

### Structure

```
Project-Zero/
├── README.md                # presentation / usage (this file)
├── SKILL.md                 # SKILL for AIs (.md + YAML frontmatter)
├── .gitignore               # files excluded from the repo (backups, editors…)
├── documentation/
│   ├── README.md · SECURITY.md          # security rules to build a skill
│   └── templates/          # templates (skill, planning, project)
└── skills/<family>/<skill>/   # ONE SKILL = ONE FOLDER
    ├── SKILL.md             # required : short YAML + procedure
    ├── tools/               # optional : script per action group + README
    ├── data/                # optional : local base (RAG…)
    └── sous-skills/         # optional : sub-skills driven (team)
```

### Skill families

- **`skills/language/`** — programming languages and environment.
- **`skills/technology/`** — technical topics (API, CLI, Linux, networking, storage, virtualisation, etc.).
- **`skills/domain/`** — trades and specialised domains (reverse engineering…).
- **`skills/meta/`** — **Skill Factory**: inventory, gap analysis, research, synthesis,
  building and validation of skills.
- **`skills/profile/`** — agent profiles (e.g. `coding-project`).
- **`skills/superviseur-de-projet/`** — the **master skill** always active, which drives its team
  of sub-skills (planning, architecture, testing, documentation, backup, orchestration…).

### Principles

- **No engine** : each skill = a folder readable directly by the AI, nothing to maintain.
- **One skill = one simple folder** : `SKILL.md` plus optionally `tools/`, `data/`, `sous-skills/`.
- **Minimalism** : as few files as possible ; merge instead of duplicate.
- **Security** (`documentation/SECURITY.md`) : `capable ≠ authorised` ; destructive action → confirmation
  (`--confirm`) ; **PASS = proof** (a passing validation is proof, not a mere claim).
- **Token savings** : deterministic steps run **locally** via `tools/` scripts.
- **Team** : the master skill (`superviseur-de-projet`) decomposes and drives its sub-skills.

---

## 📄 License

Projet Zero is released as **version 1** (`v1`) and licensed under the
**Creative Commons Attribution 4.0 International** (CC BY 4.0) — see [`LICENSE`](LICENSE).
You are free to **share** and **adapt** the content with appropriate attribution.

---

## 📄 Licence

Projet Zero est publié en **version 1** (`v1`) et distribué sous licence
**Creative Commons Attribution 4.0 International** (CC BY 4.0) — voir [`LICENSE`](LICENSE).
Vous êtes libre de **partager** et **adapter** le contenu en citant l'auteur.
