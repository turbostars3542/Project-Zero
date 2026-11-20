# snapshot.sh — comment ça marche

## Rôle
Outil **local** qui fait les 3 actions de sauvegarde, **sans LLM** (zéro token).
Il est lancé par l'IA ou manuellement, à la demande.

## Actions
```bash
./snapshot.sh create                          # créer un snapshot horodaté + manifest
./snapshot.sh list                            # lister les snapshots (lecture seule)
./snapshot.sh restore <nom> --confirm         # restaurer (destructif → confirmation)
```

| Action | Effet | Sécurité |
|---|---|---|
| `create` | copie horodatée + `manifest.sha256` (intégrité) | write — peut être confirmé |
| `list` | liste les snapshots | lecture seule — auto |
| `restore` | remet un snapshot | **destructive** — **exige `--confirm`** |

## Sécurité (modèle Projet Zero)
- `capable ≠ autorisé` : le script sait *faire* `restore`, mais ne s'exécute que si confirmé.
- **Destructif ≠ auto** : `restore` **refuse** sans `--confirm`.
- **Anti-traversal** : un nom de snapshot avec `..` ou `/` est refusé (reste confiné à `.backups/`).
- **Vérification** : un restore réussi s'appuie sur le `manifest.sha256` (hash) — séparer PROUVÉ de NON VÉRIFIÉ.

## Comment l'IA l'utilise
1. Elle **lit** `SKILL.md` du skill (rôle + procédure).
2. Quand il faut agir **localement**, elle lance `tools/snapshot.sh <action>` → **économie de tokens**.
3. Pour une action **destructive**, elle s'arrête et **demande la confirmation** avant de relancer avec `--confirm`.
