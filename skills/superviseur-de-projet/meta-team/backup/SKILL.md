---
name: backup
description: Sauvegarde / restauration de l'état du projet (snapshots locaux). Rôle de préservation des versions.
family: meta
status: Verified
version: 0.2.0
role: Préserver l'état du projet : créer, lister, vérifier l'intégrité, restaurer et épurer les snapshots.
limites: Ne modifie pas le contenu du projet. Ne rend pas de verdict (→ validation).
tools: [ snapshot ]
---

# backup — procédure

## Objectif
Préserver l'état du projet par des **snapshots** (copies horodatées + manifest), pour pouvoir
**restaurer** en cas de besoin.

## Quand l'utiliser
**Avant toute modification risquée** et **après chaque micro-étape** (cycle : … → BACKUP → …).

## Comment faire
1. Avant une modification : créer un snapshot **horodaté** (`create`).
2. Vérifier l'intégrité du snapshot (`verify`) : manifest sha256 → PASS/PASS.
3. Après modification réussie : nouveau snapshot (point de bascule).
4. Maîtriser le volume : `clean --keep <N>` (rotation, garde les N plus récents).
5. En cas de souci : **restaurer** (`restore`) — destructif → `--confirm` obligatoire.

## Exemple
```bash
tools/snapshot.sh create                  # snapshot horodaté + manifest (exclut .backups)
tools/snapshot.sh list                    # lister (nom + nb fichiers)
tools/snapshot.sh verify [snapshot]       # intégrité sha256 (default : dernier)
tools/snapshot.sh restore <snapshot> --confirm  # restaurer (destructif → --confirm)
tools/snapshot.sh clean --keep 3 --confirm      # rotation : ne garde que les 3 plus récents
```

## Règles
- **Backup obligatoire** après chaque modification (cycle micro-étape).
- **Exclut `.backups/`** de la copie (évite l'explosion exponentielle de doublons).
- Restauration et nettoyage sont **destructifs** → `--confirm` obligatoire.
- **Anti-traversal** : noms de snapshots confinés (pas de `..` ni `/`).
- Les outils de dev (`rsync`) sont préférés ; fallback = `cp` + purge.

## Vérifier (PASS = preuve)
- Un snapshot récent existe et passe `verify` (manifest hash OK) avant/après modification.
- `verify` → PASS ; aucune restauration/nettoyage fait sans confirmation.
- Un seul niveau de snapshots (aucune imbrication : `ls` plat dans `.backups/`).
