---
name: validation
description: Vérifie un résultat sur preuves (build/tests/run) et rend un verdict PASS / FAILED / NOT_AVAILABLE (DoD).
family: meta
status: Verified
version: 0.1.0
role: Donner un verdict étayé sur preuves réelles ; la décision finale reste humaine.
limites: Ne remplace pas l'autorité humaine. Ne valide jamais sans preuve journalisée.
tools: [ ]
---

# validation — procédure

## Objectif
Vérifier un livrable **sur preuves** et rendre un verdict clair.

## Quand l'utiliser
À la fin d'un travail, avant de le considérer « validé ».

## Comment faire
1. Récupérer les critères à valider et les **preuves** attendues.
2. Exécuter/vérifier (build, tests, run) selon les critères.
3. Rendre un verdict :
   - **PASS** / **ACCEPT** : preuve positive présente.
   - **REQUEST_CHANGES** : des écarts, mais corrigeables.
   - **FAILED** / **REJECT** : une preuve attendue est en échec.
   - **NOT_AVAILABLE** : un contrôle requis n'a pas pu être exécuté.

## Vérification indépendante
- **Ne pas croire un rapport seul** : re-exécuter les tests / re-vérifier sur preuves réelles.
- Produire des **findings** (INFO → CRITICAL) rattachés à des preuves, avec un verdict clair.
- Le verdict d'une couche ne délie pas la suivante (chaîne de validation).

## Règles
- `'Validé'` exige une **preuve journalisée**. Jamais par inspection visuelle.
- Chaque preuve est rattachée au **critère exact** qu'elle vérifie.
- **Boucle obligatoire** : on ne valide une micro-étape qu'avec une preuve réelle ;
  sans preuve → `NOT_AVAILABLE` (jamais `PASS` par convention).
- Un résultat non prouvé = **NON VÉRIFIÉ** ; la décision finale reste **humaine**.

## Vérifier (PASS = preuve)
- Verdict rattaché à des preuves **réelles** et reproductibles.
- PASS / FAILED / NOT_AVAILABLE bien distingués.
- Porte de validation fermée tant qu'une preuve requise manque.
