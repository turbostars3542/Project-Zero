---
name: virtualisation
description: Module Virtualisation — gestion de machines virtuelles et hyperviseurs : ressources, snapshots, isolation, moindre privilège, sauvegardes. Pour orchestrer des machines virtuelles quand le besoin est réel.
family: technology
status: Verified
version: 0.1.0
role: Administrer des machines virtuelles et un hyperviseur de façon sûre : ressources bornées, isolation, snapshots, sauvegardes, moindre privilège.
limites: Ne gère pas les conteneurs (→ containers). Ne gère pas le stockage (→ storage). Action destructive (suppression VM/snapshot) → confirmation.
tools: [ ]
---

# virtualisation — procédure (module domaine)

## Objectif
Administrer la **virtualisation** (machines virtuelles, hyperviseur) de façon **sûre et réversible** :
ressources **bornées**, **isolation**, **snapshots**, sauvegardes, moindre privilège.

## Quand l'utiliser
Module **optionnel** (Virtualisation) — quand plusieurs environnements isolés (VMs) sont nécessaires.

## Comment faire
1. **Ressources bornées** : CPU/RAM/disque par VM (pas de famine de l'hôte).
2. **Isolation** : séparation entre VMs ; pas d'accès non nécessaire à l'hôte.
3. **Snapshots** : avant changements risqués (réversibilité) ; purger les vieux snapshots.
4. **Sauvegardes** des VMs/état (→ `backup`/`storage`) avec tests de restauration.
5. **Moindre privilège** : accès admin de l'hyperviseur restreint ; pas de secret en clair dans config.
6. **Réseau virtuel** borné (voir `network`).
7. Suppression de VM/snapshot → **confirmation** (irréversible).

## Règles
- **Ressources bornées** ; **isolation** entre VMs.
- **Snapshots** avant risque ; **backups** testés.
- **Moindre privilège** ; pas de secret en clair.
- Action destructive → confirmation.

## Vérifier (PASS = preuve)
- Limites de ressources appliquées ; isolation respectée.
- Snapshots/backups présents et restauration testée.
- Aucun secret en clair ; accès admin restreint.
