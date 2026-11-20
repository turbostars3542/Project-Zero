---
name: reverse-engineering
description: MAÎTRE — rétro-ingénierie globale : analyser un logiciel / système existant (informatique, industriel PLC, etc.) pour en comprendre le fonctionnement, l'architecture, les formats et les interfaces, de façon reproductible et autorisée. Pilote des sous-skills spécialisés par type.
family: domain
status: Verified
version: 0.1.0
role: Piloter la rétro-ingénierie : donner le workflow général (7 étapes), les règles communes (autorisation, préservation, preuve), et orienter vers le sous-skill adapté au type (logiciel / PLC / etc.).
limites: Ne modifie pas le système analysé. Autorisation requise. Ne produit pas l'implémentation (→ builder du projet). La procédure détaillée par type est dans les sous-skills (sous-skills/).
tools: [ ]
---

# reverse-engineering — procédure (maître)

## Objectif
Analyser un **logiciel / système existant** pour en comprendre le **fonctionnement, l'architecture, les
formats de fichiers, les protocoles et les interfaces**, de façon **reproductible et vérifiable**, dans un
**cadre autorisé**. Le maître donne la **méthodologie générale** ; les **sous-skills** fournissent les
procédures par **type de cible**.

## Sous-skills (choisir selon le type)
| Cible | Sous-skill | Rôle |
|---|---|---|
| **Logiciel informatique** (binaire, app, fichier, protocole) | `sous-skills/software` | analyse logicielle : 7 étapes, outils (Ghidra, file, strings…), statique/dynamique |
| **Industriel : PLC / automates** (multimarque, migration) | `sous-skills/plc` | reconstruire/moderniser des automates, IEC 61131-3, simulation/validation OT |
| *(autres types — à ajouter selon les besoins)* | — | ex. matériel/électronique |

> **Règle** : pour une procédure détaillée, lire le sous-skill du type concerné ; utiliser le maître pour
> le workflow général et les règles communes.

## Comment faire
Pour toute tâche de rétro-ingénierie : identifier le **type de cible** → aller au **sous-skill** adapté
(software / plc / autre), puis appliquer le **workflow général** ci-dessous avec ses règles.

## Workflow général (7 étapes)
```text
1. Cadrer → 2. Préserver → 3. Trier → 4. Observer → 5. Modéliser → 6. Vérifier → 7. Rapporter
```
1. **Cadrer** : cible, propriétaire/autorisation, but, questions.
2. **Préserver** : copie lecture seule + **hash (sha256)** + date.
3. **Trier** : format, architecture, chaînes, dépendances, composants, interfaces évidentes.
4. **Observer** : tests permis, **une variable à la fois**, en environnement isolé.
5. **Modéliser** : fonctions, états, messages, données (à partir des preuves, pas d'à-priori).
6. **Vérifier** : prédire → changer un paramètre contrôlé → comparer attendu/observé.
7. **Rapporter** : **faits / inférences / inconnus** + étapes reproductibles liées aux preuves.

## Règles communes (PASS = preuve)
- **N'analyser que ce que tu possèdes ou es autorisé à évaluer** ; vérifier **licences** avant réutilisation.
- **Préserver l'original** + hash ; **ne pas altérer la seule copie**.
- **Isoler** l'analyse (laboratoire/VM, hors production) ; un artefact non fiable peut compromettre la machine.
- **Changer une seule variable à la fois** ; un fait doit être **reproductible**.
- **capable ≠ autorisé** : analyser ≠ pouvoir reproduire/distribuer ; respecter les protections.
- Un résultat non prouvé = `NON VÉRIFIÉ` (règle générale, voir `validation`).

## Vérifier (PASS = preuve)
- Artefact **préservé (hash) et autorisé** ; chaque observation a une **preuve**.
- Sous-skill du bon **type** lu et appliqué ; faits/inférences/inconnus séparés dans le rapport.
- Aucune modification de l'original ; analyse faite en environnement isolé.
