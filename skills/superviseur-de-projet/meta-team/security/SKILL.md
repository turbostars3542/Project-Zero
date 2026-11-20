---
name: security
description: Revue de sécurité lecture seule (secrets, injections, traversals, permissions). Détecte, ne modifie rien.
family: meta
status: Verified
version: 0.1.0
role: Passer en revue le code/les fichiers et signaler les risques, sans rien corriger.
limites: Ne corrige pas (lecture seule). Détection ≠ exhaustive — signaler les limites.
tools: [ ]
---

# security — procédure

## Objectif
Détecter et signaler les risques de sécurité **sans jamais modifier** le projet.

## Quand l'utiliser
Comme garde-fou transversal, et avant toute mise en production.

## Comment faire
1. Examiner les fichiers / code en **lecture seule**.
2. Chercher : secrets exposés, injections / entrées non fiables, **traversals** (chemins), permissions.
3. Classer les risques (impact / probabilité).
4. Produire un **rapport** (où, quoi, impact, recommandation) SANS rien modifier.

## Règles
- **Lecture seule** : `capable ≠ autorisé` — détecter un risque **ne donne pas le droit** de le corriger.
- Détecter ≠ exhaustive : signaler les limites de la revue.
- La correction relève d'un skill d'implémentation (ou de `troubleshooting`).
- **deny gagne / deny par défaut (fail-closed)** : toute décision absente, inconnue ou invalide → refus,
  jamais un `ALLOW` d'office ; un refus n'est pas contournable par une autre couche.
- **Chaîne de contrôle** : `Permissions → Policy → Risk` avant exécution (voir `policy`, `risk`).

## Audit trail
- Consigner les **actions sensibles** (écritures, exécutions, refus, confirmations) dans un **journal d'audit séparé** (hors rotation des logs opérationnels), pour pouvoir **rejouer et justifier**
l'historique.
- Chaque entrée : quoi, qui, quand, décision, preuve — sans secret.

## Vérifier (PASS = preuve)
- Rapport clair, sourcé (fichier / ligne), classé.
- **Aucune modification** effectuée durant la revue.
