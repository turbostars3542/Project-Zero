---
name: conversation-export
description: Maintient UN SEUL fichier de discussions combiné (`discussions/DISCUSSIONS.md`), mis à jour avec des VERSIONS (semver + changelog). Chaque session ajoute une entrée datée.
family: meta
status: Verified
version: 0.2.0
role: Consigner toutes les sessions dans un fichier combiné et versionné, pour traçabilité et reprise.
limites: Ne décide pas (→ DELIB / SUIVI). Ne documente que ce qui s'est réellement passé. Fichier unique = source ; les anciens fichiers datés sont archivés.
tools: [ ]
---

# conversation-export — procédure

## Objectif
Maintenir **`discussions/DISCUSSIONS.md`** : un **fichier unique, combiné et versionné** qui recueille
toutes les sessions. On **met à jour** ce fichier (pas de nouveaux fichiers datés), en **incrémentant
la version** et en notant le changement.

## Quand l'utiliser
En fin de session (ou à chaque étape marquante dont on veut garder trace).

## Comment faire
1. **Lire** le fichier `discussions/DISCUSSIONS.md` (entête : version + changelog + sessions).
2. **Ajouter / mettre à jour une entrée datée** en tête de « ## Sessions » :
   `### <AAAA-MM-JJ> — <sujet>` puis **résumé** (fait · décisions · état d'arrivée · prochaines étapes),
   et références vers `SUIVI.md` / `IDEES.md` / décisions.
3. **Incrémenter la version** :
   - nouvelle session → **MINEUR** (ex. `1.2.0` → `1.3.0`) ;
   - correction/complément d'une entrée existante → **CORRECTIF** (`1.3.0` → `1.3.1`) ;
   - refonte de la structure du fichier → **MAJEUR**.
4. Ajouter la ligne au **## Changelog** (version · date · changement).
5. **Ne pas créer** de nouveau fichier : on enrichit l'**unique** `DISCUSSIONS.md`.

## Règles
- **Fichier unique** : pas de multiplication de `discussion-*.md` ; les anciens sont archivés (`discussions/_archive/`).
- **Aucune invention** : on consigne ce qui s'est réellement passé.
- Ne pas créer les décisions ici (→ `SUIVI.md` / registre) ; les référencer.
- Chaque mise à jour = **version + changelog** à jour (cohérent avec `skill-factory/VERSIONING.md`).

## Vérifier (PASS = preuve)
- `DISCUSSIONS.md` reflète l'état réel ; version + changelog à jour ; entrée datée ajoutée.
- Aucun nouveau fichier individuel créé ; anciens datés archivés.
