---
name: skill-builder
description: Crée et améliore des skills AU FORMAT Projet Zero, à partir d'une synthèse — autonomes, pédagogiques, avec exemples, limites et dépendances. Évite le trop général / fragmenté.
role: Produire un SKILL.md conforme, clair, réutilisable et autonome, à partir de la synthèse.
limites: Ne décide pas s'il faut créer (→ gap-analyzer/maître). Ne fait pas la recherche ni la synthèse (→ researcher/synthesizer). Ne valide pas lui-même (→ validator).
tools: [ ]
family: meta
version: 0.1.0
---

# skill-builder — procédure

## Objectif
**Écrire** (ou **améliorer**) un skill conforme au format Projet Zero, à partir d'une synthèse validée
et d'une décision de l'utilisateur.

## Quand l'utiliser
Après `synthesizer`, quand la décision est « créer » ou « améliorer ».

## Comment faire
1. Définir la **portée** (ni trop générale, ni inutilement fragmentée).
2. Rédiger le **SKILL.md** : frontmatter v2 (`name, description, role, limites, tools[], family`)
   + procédure (`Objectif / Quand l'utiliser / Comment faire / Règles / Vérifier (PASS = preuve)`).
3. Rendre les **instructions claires et pédagogiques** ; ajouter des **exemples concrets**.
4. Documenter **limites** et **dépendances** (requires/tools/autres skills).
5. Préparer **métadonnées & version** : déclarer `family` (obligatoire) + `version` (recommandé) + `status: Draft`.
6. Garder le skill **autonome** et **réutilisable** d'un projet à l'autre (pas de chemin perso en dur).
7. Soumettre à `validator` (ne pas se valider soi-même).

## Exemple de squelette (format v2)
```markdown
---
name: <slug>
description: <ce que ça fait (1 phrase), orienté action>
role: <ce qu'il FAIT>
limites: <ce qu'il ne fait PAS>
tools: [ ]
family: <language|technology|domain|meta|governance|profile|pack>
---
# <Nom> — procédure
## Objectif / ## Quand l'utiliser / ## Comment faire / ## Règles / ## Vérifier (PASS = preuve)
```

## Règles
- **Respecter intégralement** le format et les conventions Projet Zero (voir REFERENCE).
- **Pas de skill « fourre-tout »** (trop général = inutile) **ni de fragmentation** excessive.
- **Autonomie** : contient ce qu'il faut (procédure, exemples) ; évite les dépendances inutiles.
- S'appuyer sur la **synthèse** (ne pas inventer) ; faits vs hypothèses respectés.
- **Sécurité des scripts** s'il y a `tools/` : capable≠autorisé, anti-traversal, --confirm, pas de secret.

## Vérifier (PASS = preuve)
- Le `SKILL.md` est conforme (frontmatter + procédure complète), autonome, avec exemples et limites.
- Statut initial `Draft` ; prêt pour la validation par `validator`.
