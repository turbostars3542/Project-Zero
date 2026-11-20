---
name: projet-zero
description: "Banque de skills autonomes, méthode traditionnelle. Chaque skill est un dossier contenant un SKILL.md (YAML court + procédure) que toute app IA lit directement sans moteur Python ni MCP. Outils locaux dans tools/. Aucun moteur à modifier : ajouter un skill = ajouter un dossier."
---

# SKILL — Projet Zero (banque de skills, sans moteur)

> Point d'entrée pour toute app IA (Bionic, Claude, Codex, agent autonome…). **Aucun moteur** : chaque
> skill est un **`SKILL.md`** (`YAML` court + procédure) que l'app lit **directement**.

## 1. Ce que c'est
- **Skill** : un dossier `skills/<famille>/<skill>/` contenant :
  `SKILL.md` (obligatoire : identité + procédure) · `tools/` (optionnel : scripts locaux + README) ·
  `data/` (optionnel : base locale) · `sous-skills/` (optionnel : équipe pilotée par le maître).
- **Skill maître** → **sous-skills** : décomposition du travail (équipe / sous-agents), ex. `superviseur-de-projet`.
- **Principe** : il n'y a **pas de moteur** à modifier — toute capacité s'ajoute en **ajoutant un dossier**.

## 2. Comment une app IA lit un skill
1. Lire **`SKILL.md`** racine (ce fichier) pour comprendre le projet.
2. `discover` : parcourir `skills/` pour voir les dossiers disponibles (le `name`/`description` suffisent pour choisir).
3. Ouvrir le **`SKILL.md`** du skill choisi → lire la procédure (étapes, règles, limites, vérifications).
4. Si le skill a une **action exécutable locale** : utiliser les scripts dans **`tools/`**
   (ex. `backup/tools/snapshot.sh create|list|restore`) en parallèle — **zéro token**.
5. Toute action **destructive → confirmation humaine** (`capable ≠ autorisé`).

## 3. Règles pour l'IA
- **Aucun moteur** : ne pas chercher de `src/engine/` ni de client MCP — tout est dans les `SKILL.md`.
- **Un skill = un dossier** ; on ne modifie jamais un skill au-delà de son périmètre.
- **`Capable ≠ autorisé`** : déclarer une capacité ne donne aucun droit ; toute action sensible passe par
  confirmation (`documentation/SECURITY.md`).
- **Économie de tokens** : les étapes déterministes se font via les scripts locaux `tools/`, pas par le LLM.
- **Honnêteté** : ne jamais inventer un résultat ; signaler ce qui n'a pas été exécuté. **PASS = preuve**.

## 4. Références
- `documentation/SECURITY.md` — règles de sécurité pour créer un skill.
- `documentation/templates/skill/SKILL_TEMPLATE.md` — gabarit unique pour créer un skill.
- Skill maître de référence : `skills/superviseur-de-projet/` (équipe meta).
- Exemple de référence : `skills/superviseur-de-projet/meta-team/backup/` (`SKILL.md` + `tools/snapshot.sh`).
