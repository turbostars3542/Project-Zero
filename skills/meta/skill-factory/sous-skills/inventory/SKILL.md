---
name: skill-inventory
description: Inventorie la banque de skills — métadonnées, versions, dépendances, domaines, doublons, incomplets, obsolètes — et produit un inventaire exploitable.
role: Décrire l'état RÉEL de la banque pour que les autres composants (gap-analyzer…) travaillent dessus.
limites: N'analyse pas les écarts (→ gap-analyzer). Ne crée ni ne modifie aucun skill. Inventaire = lecture seule.
tools: [ ]
family: meta
version: 0.1.0
---

# skill-inventory — procédure

## Objectif
Produire un **inventaire structuré** de la banque de skills (état réel, pas supposé).

## Quand l'utiliser
En début de tout process Skill Factory ; à chaque fois qu'on doit savoir ce qui existe.

## Comment faire
1. **Parcourir** la banque (`skills/`) : repérer chaque skill (dossier avec `SKILL.md`).
2. Pour chaque skill, extraire les **métadonnées** : name, description, role, limites, family, tools.
3. Identifier les **versions / statuts** (si présents) et les **dépendances** (`requires`, `tools` référencés).
4. **Cartographier les domaines** (par famille : language, domain, meta…).
5. **Détecter** : doublons (mêmes noms/rôles proches), skills **incomplets** (frontmatter manquant,
   procédure vide), skills **obsolètes** (dépassés / signalés Archived).
6. Écrire l'**inventaire** exploitable (tableau : skill → rôle → famille → statut → doublon? → note).

## Règles
- **Lecture seule** : on décrit, on ne modifie pas.
- **Rien d'inventé** : l'inventaire reflète ce qui est réellement sur disque.
- Ne pas recréer de skills au passage (→ pas le rôle).
- Respecter les exclusions (ne pas fouiller `_archive/` comme banque active).

## Outil (automatisé)
- `../tools/inventory.sh` : génère l'inventaire et le registre `_meta/registry.md` (lecture seule).
- `../tools/dedupe.sh` : signale les doublons/chevauchements présumés (à valider humainement).

## Vérifier (PASS = preuve)
- L'inventaire liste les skills réels (avec leur chemin) ; doublons / incomplets / obsolètes signalés.
- Chaque entrée est vérifiable (le skill existe, les méta correspondent au fichier).
