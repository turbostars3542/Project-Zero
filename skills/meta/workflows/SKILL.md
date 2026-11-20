---
name: workflows
description: Module Workflows — enchaînement d'étapes/actions contrôlées (files, étapes, états, validation) orchestrées par les contrats du Core. Automatisation avec contrôles et réversibilité.
family: meta
status: Verified
version: 0.1.0
role: Définir et exécuter des workflows (suites d'étapes) de façon contrôlée : états, transitions, validation, sans contourner les contrats du Core.
limites: Ne contourne pas les contrats du Core (→ api/contrats). Ne fait pas la logique métier (→ modules). Étape destructive → confirmation.
tools: [ ]
---

# workflows — procédure (module domaine)

## Objectif
Orchestrer des **workflows** : une suite d'**étapes** contrôlées (état défini, transitions validées),
qui utilisent les **contrats du Core**, avec **validation et réversibilité**.

## Quand l'utiliser
Module **optionnel** (Workflows) — pour automatiser une séquence d'actions métier multi-étapes.

## Comment faire
1. **Modéliser** le workflow en **étapes + états** (machine à états : chaque étape a des transitions validées).
2. **Chaque étape** délègue à la bonne capacité/module via les **contrats** (jamais internals du Core).
3. **Validation** : une étape ne passe à la suivante que si sa **condition/précondition** est remplie (PASS = preuve).
4. **Réversibilité** : planifier comment annuler/revenir (snapshot/backup avant étapes destructives).
5. **Sécurité** : secrets via vault ; actions destructives → confirmation ; pas d'autonomie non validée.
6. **Observabilité** : événements/logs (sans secret) pour suivre l'avancement (→ audit/monitoring).
7. **Micro-étapes** : construire incrémentalement, tester chaque étape avant la suivante.

## Règles
- **États/transitions** explicites ; validation avant chaque transition.
- **Contrats du Core** : pas de contournement des internals.
- **Réversibilité** préparée ; actions destructives → confirmation.
- **Pas d'autonomie prématurée** : n'ajouter une étape que si le besoin est réel.

## Vérifier (PASS = preuve)
- Workflow modélisé avec états/transitions ; chaque étape validée avant la suivante.
- Chaque étape passe par les contrats ; réversibilité planifiée.
- Événements/logs sans secret ; aucune étape destructive sans confirmation.
