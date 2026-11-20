---
name: linux
description: Module Platform/Linux — administration d'un système Linux : comptes/groupes/sudo, systemd, permissions/ACL, SSH, durcissement (durcissement en couches), moindre privilège, récupération par console. Module optionnel de type core de service.
family: technology
status: Verified
version: 0.1.0
role: Administrer et durcir un système Linux de manière sûre et minimale : identités, services, permissions, SSH, récupération — sans dépendre d'un outil de supervision (Linux reste administrable directement).
limites: Ne remplace pas le terminal ni le CLI (→ cli). Ne gère pas les secrets (→ vault). Action destructive → confirmation. Ne pas durcir à l'excès au détriment de la récupération (→ recouvrer par console/SSH).
tools: [ ]
---

# linux — procédure (module Platform)

## Objectif
Administrer un système **Linux** de façon **sûre, minimaliste et réversible**, avec un **durcissement en
couches**, en gardant toujours un **chemin de récupération** (SSH/console) même si un outil est indisponible.

## Quand l'utiliser
Module **optionnel** (Platform) — jamais une dépendance du Core. Outil de supervision indisponible ≠ Linux
inadministrable ; on peut toujours administrer le système directement.

## Comment faire
### 1. Comptes, groupes, sudo
- **Comptes nommés**, jamais root au quotidien ; clés SSH avec passphrase ; pas de compte partagé.
- `sudo` limité aux commandes nécessaires, édité via `visudo` dans `/etc/sudoers.d/` (syntaxe à vérifier).
- Comptes de service **sans shell**, un par application.

### 2. Services (systemd)
- Gérer via `systemctl` ; ne **pas** éditer les unités de `/usr/lib/systemd/system/` → utiliser des
  **drop-ins** (`systemctl edit`).
- `Restart=on-failure`, sandboxing : `PrivateTmp`, `PrivateNetwork`, `ProtectSystem`, `User=/DynamicUser=`.
- Utiliser `systemd-analyze security` pour mesurer l'exposition.

### 3. Permissions et fichiers
- `umask` **027** (ou 077) ; fichiers monde-écrivables rares (hors `/tmp`).
- Vérifier `setuid`/`socket`/world-writable ; restreindre `/etc/shadow` (jamais lisible par un simple user).
- Points de montage : `noexec`, `nosuid`, `nodev` sur `/tmp`, `/dev/shm` ; ACL si nécessaire.

### 4. SSH & accès distant
- **Clé uniquement** (pas de mot de passe) ; `PermitRootLogin no`, `MaxAuthTries 3`, `AllowGroups`.
- Activer le durcissement **après** avoir testé la clé ; garder une **session de secours** ouverte pendant les tests.

### 5. Durcissement (couches, en ordre)
1. Identités (comptes, sudo, PAM, MFA) ; 2. SSH ; 3. permissions/système de fichiers ;
4. pare-feu (default-deny, ne garder que le nécessaire) ; 5. confinement (systemd sandbox / SELinux / AppArmor) ;
6. mises à jour de sécurité automatiques + redémarrage planifié.

### 6. Récupération
- Toujours préserver un **accès de secours** (console/root local, console) — même si l'outil d'orchestration échoue.
- `mount -a` avant redémarrage ; UUID+nofail dans fstab ; test de restauration régulier.

## Règles
- **Linux indépendant** : jamais de dépendance critique à un outil ; récupération toujours possible.
- **Moindre privilège** : accès restreint, sudo limité, audit des comptes privilégiés (pas de uid 0 inutile).
- **Durcissement en couches** et par étapes (ne pas casser l'accès).
- Actions **destructives/réversibles** → confirmation ; scripts `set -euo pipefail` + shellcheck.
- **Pas de secret** dans logs/config.

## Vérifier (PASS = preuve)
- Comptes/groupes/sudo vérifiés ; services sous systemd avec drop-ins + sandbox mesuré.
- Permissions fichier sûres (`/etc/shadow` non lisible, pas de monde-écrivable inutile).
- SSH durci (clé, no root, allowlist) ; **chemin de récupération** (console/SSH) validé.
- Un chemin de secours fonctionne même avec l'outil indisponible.
