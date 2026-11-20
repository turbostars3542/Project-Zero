---
name: containers
description: Module Conteneurs — orchestrer/administrer des conteneurs et images (Docker/Podman) : images, conteneurs, réseaux, volumes, moindre privilège, isolation, pas de secret en image.
family: technology
status: Verified
version: 0.1.0
role: Créer, exécuter et superviser des conteneurs en toute sécurité : images vérifiées, isolation, moindre privilège, volumes, réseau.
limites: Ne gère pas les secrets (→ vault). Ne fait pas le monitoring (→ monitoring). Action destructive (suppression) → confirmation.
tools: [ ]
---

# containers — procédure (module domaine)

## Objectif
Administrer des **conteneurs** (images, conteneurs, réseaux, volumes) de façon **sécurisée** : images
fiables, **moindre privilège**, **isolation**, volumes contrôlés, pas de secret embarqué dans l'image.

## Quand l'utiliser
Module **optionnel** (Conteneurs) — pour exécuter des services isolés en conteneurs.

## Comment faire
1. **Images** : partir d'images **officielles/pourvues de confiance**, pinner les versions, scanner les vulnérabilités.
2. **Aucun secret dans l'image** : les secrets passent via l'orchestration (→ vault), jamais via des variables en dur/`.env` committé.
3. **Moindre privilège** : non-root (`User=`/`USER`), pas de privilèges élevés inutiles, capabilities réduites, read-only où possible.
4. **Isolation** : limiter le réseau (pas `--network host` inutile), limiter volumes/mounts.
5. **Durcissement d'exécution** : `--pids-limit`, `--memory`, `no-new-privileges`, read-only rootfs.
6. **Cycle de vie** : build/pull/run/stop/rm ; logs sans secret ; restart policy contrôlée.
7. **Réseau/volumes** : réseau filtré, volumes nommés ; backup des données (→ `backup`/`storage`).
8. Suppression (image/conteneur/volume) → **confirmation** si irréversible.

## Règles
- **Images fiables et pinnenées** ; pas de secret embarqué.
- **Moindre privilège + isolation** (non-root, capabilities réduites, réseau/volumes bornés).
- **Logs/recherche** sans secret ; restart policy contrôlée.
- Action destructive → confirmation.

## Vérifier (PASS = preuve)
- Images officielles/versées ; aucun secret dans l'image/env committé.
- Conteneurs non-root, capabilities réduites, réseau/volumes bornés.
- Backups des données et logs sans secret ; aucune fuite de secret.
