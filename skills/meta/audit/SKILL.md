---
name: audit
description: Module Audit — piste d'audit fiable des changements et accès importants : événements + logs (sans secret), journal horodaté, non-répudiation, révision. Consomme les events/logs du Core.
family: meta
status: Verified
version: 0.1.0
role: Consigner de façon fiable et traçable les changements/accès importants (horodatés, sans secret, auditable), en consommant les events/logs du Core.
limites: Ne stocke pas les secrets (→ vault). Ne décide pas du contenu (→ les systèmes émettent). Journal séparé de la rotation opérationnelle (→ hors logs de prod).
tools: [ ]
---

# audit — procédure (module)

## Objectif
Produire une **piste d'audit fiable** des **changements et accès importants** : événement + log
**horodatés**, **sans secret**, dans un **journal séparé** de la rotation opérationnelle, pour permettre
la révision et détecter tout usage anormal.

## Quand l'utiliser
Module **optionnel** (Audit) — quand il faut **tracer** qui a fait quoi, quand (administration, accès
secrets, changements sensibles), et le conserver à l'abri du roulement normal des logs.

## Comment faire
1. **Consommer les events/logs du Core** (voir core : Events/Logs) et les **contrats** publics — jamais les internals.
2. **Changements importants** → produire un événement **ET** un log (sans secret).
3. **Horodatage** fiable (temps synchronisé) ; **non-répudiation** au possible (journaux append-only).
4. **Journal séparé** hors rotation opérationnelle (l'audit ne doit pas être écrasé/roté comme les logs de prod).
5. **Structure** cohérente (qui, quoi, quand, contexte) ; sans données sensibles/fuite.
6. **Révision** : pouvoir rechercher et corréler (audit des accès/secrets) ; détecter les anomalies.
7. **Sécurité** : accès en lecture aux audits contrôlé ; pas de secret dans le journal.

## Règles
- **Journal séparé** (hors rotation opérationnelle) ; non-répudiation visée.
- **Sans secret** ; horodaté ; structure cohérente.
- Consomme les **contrats** du Core, pas ses internals.
- **Audit** = preuve de « qui a fait quoi » (PASS = preuve).

## Vérifier (PASS = preuve)
- Changements/accès importants tracés (événement + log horodaté, sans secret).
- Journal d'audit **séparé** et révisable ; corrélation possible.
- Aucune donnée sensible/fuite dans le journal.
