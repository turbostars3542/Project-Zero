---
name: testing
description: Exécute des TESTS RÉELS (unitaires, outils de test) et en rapporte les résultats.
family: meta
status: Verified
version: 0.1.0
role: Exécuter les tests réels et rapporter les résultats ; ne pas affirmer sans exécution.
limites: Ne rend pas le verdict final (→ validation). Ne corrige pas le code (→ skill métier).
tools: [ ]
---

# testing — procédure

## Objectif
**Exécuter de vrais tests** et rapporter les résultats (pas d'affirmation, que des preuves).

## Quand l'utiliser
Après une implémentation / modification, avant de valider.

## Comment faire
1. Reprendre les critères / exigences à tester.
2. Lancer les tests réels (unitaires, intégration, l'outil du langage — voir `language`).
3. Collecter les résultats (passés / échecs, sortie, coverage).
4. Rapporter proprement (ce qui a été testé, résultat, preuve).

## Règles
- **Jamais d'affirmation** : un test doit être **exécuté**, pas supposé.
- Chaque résultat est rattaché au critère qu'il vérifie.
- Ne pas corriger le code soi-même (→ skill métier / troubleshooting) ; juste tester et rapporter.
- Un test peut se faire **dans un environnement de test fermé** (voir supervisor tests) pour l'isole.

## Vérifier (PASS = preuve)
- Les tests ont réellement tourné et le rapport montre résultats + preuves (sortie, coverage).
- Aucun « devrait passer » sans exécution réelle.
