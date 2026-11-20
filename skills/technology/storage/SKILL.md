---
name: storage
description: Module Storage — gestion de stockage et de fichiers : volumes, quotas, montages, sauvegardes de données, hiérarchies, accès. Distinct de l'abstraction de persistance du Core (→ persistence).
family: technology
status: Verified
version: 0.1.0
role: Gérer le stockage et les fichiers en domaine (volumes, quotas, montages) avec contrôle d'accès, sans confondre avec la persistance du Core.
limites: Ne remplace pas la persistance du Core (→ persistence). Ne gère pas les secrets (→ vault). Action destructive/réversible → confirmation.
tools: [ ]
---

# storage — procédure (module domaine)

## Objectif
Gérer le **stockage et les fichiers** d'un domaine (volumes, montages, quotas, hiérarchies, accès), de façon
**contrôlée et réversible**, distincte de l'abstraction de persistance du Core.

## Quand l'utiliser
Module **optionnel** (Storage) — pour la gestion *métier* des fichiers/volumes (hors persistance interne du Core).

## Comment faire
1. **Distinguer** : persistance du **Core** (`repository`/moteur, voir `persistence`) ≠ module **Storage** (domaine fichiers/volumes).
2. **Catalogue** des volumes/montages : où, quota, type, utilisation.
3. **Montages** sains : `UUID` (+ `nofail`) dans fstab, `mount -a`, séparation données (`/var/lib`, `/srv`) du système.
4. **Quotas** et limites pour éviter le remplissage qui bloque l'OS.
5. **Contrôle d'accès** files : droits/ACL, moindre privilège, pas de fichier monde-écrivable inutile.
6. **Sauvegardes** (domaine) : 3-2-1 chiffrées, avec **tests de restauration** périodiques (→ `backup`).
7. Actions destructives/réversibles → **confirmation** ; pas de secret dans les chemins/logs.

## Règles
- **Module ≠ Core** : ne pas coupler le stockage métier à la persistance interne.
- **Données** séparées du système ; **quotas** ; **montages** testés avant redémarrage.
- **Contrôle d'accès** files strict ; moindre privilège.
- **Backups** 3-2-1 chiffrés, restauration testée ; pas de secret en clair.

## Vérifier (PASS = preuve)
- Volumes/montages inventoriés, `mount -a` passe, données séparées du système.
- Quotas et droits vérifiés ; aucun espace bloquant l'OS.
- Backup 3-2-1 présent + **test de restauration** OK ; pas de secret dans la télémétrie.
