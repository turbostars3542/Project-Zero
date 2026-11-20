---
name: troubleshooting
description: Diagnostique la CAUSE RACINE d'un problème après un échec, et propose la correction.
family: meta
status: Verified
version: 0.1.0
role: Trouver la cause racine d'un bug/échec et préconiser la correction ; diagnostic, pas bricolage.
limites: Ne corrige pas direct sans validation (→ plan-mode/act-mode). Ne documente pas les phases (→ documentation).
tools: [ ]
---

# troubleshooting — procédure

## Objectif
Diagnostiquer la **cause racine** d'un problème et proposer la correction, au lieu de bricoler les symptômes.

## Quand l'utiliser
**Après un échec** (test qui ne passe pas, bug, comportement inattendu).

## Comment faire
1. Reproduire le problème et rassembler les preuves (erreur, sortie, logs).
2. Retrouver la **cause racine** (pas juste le symptôme).
3. Proposer la correction ciblée, **bornée** (la plus petite change qui résout).
4. Faire valider / exécuter via la **porte humaine** (plan → act) puis retester.

## Règles
- Ne pas corriger en aveugle ; toujours **comprendre avant de modifier**.
- Une correction doit être la **plus petite nécessaire** (pas de changement de tout le fichier).
- Tester l'hypothèse ; si elle ne résout pas → nouvelle hypothèse (borner, pas de boucle infinie).
- Un échec non résolu est documenté (→ `documentation`).

## Vérifier (PASS = preuve)
- La cause racine est identifiée et étayée (preuve) ; la correction est testée et passe.
- Pas de bricolage / pas de changement destructif non validé.
