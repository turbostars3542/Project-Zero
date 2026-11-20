---
name: vault
description: Module Vault — gestion de secrets : stockage chiffré des secrets, contrôle d'accès moindre privilège, rotation, révocation, expire/lease, audit d'accès, récupération d'urgence de l'admin. Sources : OWASP, HashiCorp Vault, Microsoft.
family: technology
status: Verified
version: 0.1.0
role: Gérer les secrets (tokens, clés, mots de passe, certificats) de façon centralisée, chiffrée et auditable : création, rotation, révocation, expiration, moindre privilège.
limites: Ne décide pas seul des politiques (→ policy/risk). Ne gère que les secrets, pas l'identité RBAC complète (→ sessions-security). Stockage chiffré requis (→ persistence/security).
tools: [ ]
---

# vault — procédure (module secrets)

## Objectif
Centraliser la gestion des **secrets** (mots de passe, clés, tokens, certificats) dans un **stockage
chiffré** avec **contrôle d'accès granulaire**, **rotation**, **révocation**, **expiration (lease)** et
**audit** des accès — pour réduire l'exposition et faciliter la récupération.

## Quand l'utiliser
Module **optionnel** (Vault) — quand une application/service a besoin de secrets chiffrés, rotation et
audit, sans mettre les secrets dans le code, les logs ou la config.

## Comment faire
1. **Stockage chiffré** : chiffrer les secrets **au repos** et **en transit** (enveloppes/clés de chiffrement) ;
   jamais en clair dans le code, la config ou les logs.
2. **Contrôle d'accès** : **moindre privilège** (rôle/opération granular par secret) ; deny par défaut.
3. **Cycle de vie des secrets** : **Création → Rotation → Révocation → Expiration**.
4. **Rotation** : automatiser si possible ; pour les clés, préférer blue/green (nouvelle + ancienne) pour
   ne pas casser les consommateurs ; secrets utilisateur seulement sur suspicion (NIST).
5. **Expiration/lease** : associer un **lease** ; révocation automatique à expiration ; **secrets dynamiques**
   (générés à la demande) si possible pour réduire la réutilisation.
6. **Révocation** : possible par secret/type/utilisateur ; utile en cas d'intrusion.
7. **Audit d'accès** : journaliser *qui* accède *à quoi* *quand* (→ audit) — pour détecter tout usage anormal.
8. **Récupération d'urgence admin** : procédure sûre pour retrouver l'accès si le mécanisme principal échoue
   (sans backdoor).

## Règles
- **Moindre privilège** : pas d'accès général aux secrets ; fine granularité.
- **Rotation régulière** et **révocation** en cas d'exposition ; **lease/expiration**.
- **Aucun secret** dans code/config/logs/erreur ; chiffrement au repos + transit.
- **Audit** de chaque accès ; **récupération** explicite et tracée (jamais de backdoor).
- **capable ≠ autorisé** : un secret est accordé par politique, pas par possession d'autre chose.

## Vérifier (PASS = preuve)
- Secrets chiffrés au repos/transit ; pas de secret en clair dans code/config/logs.
- Rotation + révocation + expiration testées ; lease fonctionnel.
- Audit d'accès présent ; récupération d'urgence validée (sans backdoor).
