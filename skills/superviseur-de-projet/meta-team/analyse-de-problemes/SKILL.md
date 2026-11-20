---
name: analyse-de-problemes
description: Cadre le besoin et le problème avant de planifier (PROBLEM.md, exigences REQ-…, portée).
family: meta
status: Verified
version: 0.1.0
role: Clarifier le « pourquoi » : le besoin réel, la portée, les critères de succès.
limites: Ne planifie pas (→ planning). Ne conçoit pas la structure (→ architecture). Ne valide pas (→ validation).
tools: [ ]
---

# analyse-de-problemes — procédure

## Objectif
**Cadrer le problème** : comprendre le besoin réel, fixer la portée et les critères de succès
avant toute planification.

## Quand l'utiliser
En amont, **avant** de planifier ou développer — quand le besoin n'est pas encore clair.

## Comment faire
1. Réunir les **inputs** (nom, objectif, cadre/utilisateur, contraintes, hors périmètre).
2. Définir le **problème** : besoin réel, qui est affecté, comportement actuel vs attendu.
3. Poser le **résultat attendu** (état final, pas la solution) et les **critères de succès**.
4. Rédiger `PROBLEM.md` et les **exigences** (`REQ-<catégorie>-NNNN`) dans `REQUIREMENTS.md`.
5. Bien marquer le **hors périmètre** (anti scope-creep).

## Règles
- Ne pas découper en tâches tant que les inputs requis sont « Inconnu » (→ retour en analyse).
- Ne rien **inventer** : clarifier avec l'utilisateur/agent, sans supposer.
- Ne pas glisser vers le plan (→ planning) ou la structure (→ architecture).

## Vérifier (PASS = preuve)
- Le problème est cadré et validé par l'utilisateur ; exigences `REQ-…` documentées.
- Le hors périmètre est explicite ; aucun input requis « Inconnu » sans décision.
