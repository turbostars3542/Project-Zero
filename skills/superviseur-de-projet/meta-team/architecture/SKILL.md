---
name: architecture
description: Définit la structure du projet (dossiers, modules, dépendances entre composants) et l'ARCHITECTURE.md.
family: meta
status: Verified
version: 0.1.0
role: Concevoir la structure standard et l'architecture du projet, sans coder.
limites: Ne code pas (→ skill métier). Ne teste pas. Ne valide pas (→ validation).
tools: [ ]
---

# architecture — procédure

## Objectif
Poser la **structure** et l'**architecture** du projet (comment c'est organisé), avant d'implémenter.

## Quand l'utiliser
Après le cadrage, avant l'implémentation : quand il faut organiser le code/fichiers.

## Comment faire
1. Reprendre le cadrage (`PROBLEM.md`) et le plan.
2. Définir la **structure** (dossiers, modules, packages, fichiers principaux).
3. Définir les **dépendances / flux** entre composants (qui utilise quoi).
4. Documenter dans `ARCHITECTURE.md` (structure standard + architecture concrète).
5. Vérifier que la structure reste **simple** (pas d'over-engineering, construction progressive).

## Règles
- **Construction progressive** : ne pas créer de structure « au cas où » ; seulement ce dont l'étape a besoin.
- Respecter la **structure standard** (les fichiers principaux constants + dossiers selon le type de projet).
- Tout changement structurel important doit être signalé/documenté (voir `RULES.md`).

## Vérifier (PASS = preuve)
- `ARCHITECTURE.md` décrit la structure réelle ; aucune complexité inutile.
- La structure est cohérente avec le problème cadré et le plan.
