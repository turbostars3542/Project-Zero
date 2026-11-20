---
name: file-manager
description: Module File Manager — gestion de fichiers en domaine : arborescences, permissions, mouvements, réversibilité, sauvegardes. Distinct de la persistance du Core.
family: technology
status: Verified
version: 0.1.0
role: Gérer les fichiers en domaine (arbres, permissions, copie/mouvement, tri) de façon sûre et réversible, distincte de la persistance du Core.
limites: Ne remplace pas la persistance du Core (→ persistence). Ne gère pas les secrets dans les fichiers (→ vault). Suppression/copie réversible → confirmation.
tools: [ ]
---

# file-manager — procédure (module domaine)

## Objectif
Gérer les **fichiers en domaine** (arbres, permissions, copie/mouvement/suppression) de façon **sûre et
réversible**, distincte de l'abstraction de persistance du Core.

## Quand l'utiliser
Module **optionnel** (File Manager) — pour gérer des fichiers métier (hors persistance interne du Core).

## Comment faire
1. **Distinguer** : gestion de fichiers **métier** (module) ≠ persistance **Core** (→ `persistence`).
2. **Inventaire/tri** : arborescence claire, déplacements logiques, pas de doublons inutiles.
3. **Permissions** : droits/ACL, moindre privilège, pas de fichier monde-écrivable inutile.
4. **Réversibilité** : avant suppression/déplacement massif → **sauvegarde** (→ `backup`) et plan d'annulation.
5. **Manipulations** : copier→vérifier→supprimer l'original (jamais supprimer avant vérification).
6. **Aucun secret** dans chemins/fichiers/logs ; secrets gérés par `vault`.
7. Suppression définitive → **confirmation** (irréversible).

## Règles
- **Module ≠ Core** ; gestion fichiers métier découplée de la persistance interne.
- **Réversibilité** : sauvegarde + vérification avant suppression/déplacement.
- **Permissions** strictes ; moindre privilège.
- **Pas de secret** ; action destructive → confirmation.

## Vérifier (PASS = preuve)
- Inventaire clair ; permissions sûres (pas de monde-écrivable inutile).
- Suppression/Déplacement précédé d'une sauvegarde vérifiée ; réversible.
- Aucun secret dans chemins/logs.
