---
name: sessions-security
description: Sessions et sécurité avancée — sessions persistées/expirantes, jeton opaque fort (CSPRNG), révision/invalidation, MFA (TOTP) / WebAuthn, recovery sûr, protection du dernier admin (failsafe). Sources : OWASP, NIST 800-63, passkeys.
family: domain
status: Verified
version: 0.1.0
role: Renforcer la sécurité de session et l'authentification avancée : sessions persistées/expirantes, tokens, MFA/WebAuthn, recovery sûr, protection des derniers accès administratifs.
limites: Ne remplace pas l'auth/RBAC de base (→ security). Ne stocke pas les secrets (→ vault/security). Ne décide pas des politiques (→ policy/risk).
tools: [ ]
---

# sessions-security — procédure

## Objectif
Gérer **sessions et sécurité avancée** au-dessus de l'identité/RBAC de base : sessions robustes,
tokens, MFA/WebAuthn, recovery, et protection des derniers accès administratifs (failsafe).

## Quand l'utiliser
Quand un core a auth/RBAC de base et qu'il faut le **durcir** : sessions persistées/expirantes, MFA,
recovery, protection du dernier admin/owner.

## Comment faire
### Sessions (OWASP / NIST)
1. **Jeton opaque fort** : ≥ **64 bits d'entropie**, généré par **CSPRNG** (`OsRng`), jamais séquentiel.
2. **Stockage** : ne garder que le **hash** du jeton côté serveur (pas le jeton brut).
3. **Métadonnées** : user id, création, dernier usage, expiration, hints (device/ip).
4. **Expiration double** : **idle timeout** (inactivité) + **absolute timeout** (durée max), forcées côté **serveur**.
5. **Révision** : nouveau jeton après login/élévation/rotations ; **invocation** à logout, reset, activité suspecte.
6. **Persistance** (si voulu) : via repository (voir `persistence`) ; sinon invalidation au redémarrage (NIST : token de session non persistant).

## MFA / WebAuthn (OWASP / passkeys)
- **TOTP** : seed haute entropie, montré **une fois** à l'enrôlement ; **stocké chiffré** ; accepter le pas
  courant + au plus un précédent ; anti-rejeu (pas 2× même code sur le même pas) ; limites de tentatives.
- **Passkeys/WebAuthn** : résistants au phishing ; vérifier le **flag user-verification** côté serveur ;
  utiliser une **librairie maintenue** (ne pas implémenter CBOR/COSE/attestation soi-même).
- **Requérir MFA** au minimum pour les comptes privilégiés et les actions sensibles.

## Recovery & failsafe admin
- **Recovery** : procédure explicite et tracée ; jamais de backdoor ni de contournement caché.
- **Protection du dernier admin/owner** : refuser de désactiver/retirer le **dernier** accès administratif
  (failsafe) ; en cas de refus, **état inchangé**.

## Règles
- **Fail-safe** : on ne se retrouve jamais sans accès administratif valide.
- **Aucun backdoor** ; toute récupération est explicite et tracée.
- **Secrets** jamais en clair ni dans logs/erreurs ; tokens/codes/seed protégés.
- **capable ≠ autorisé** : une session valide ne donne pas tous les droits (→ policy/risk).
- **Expiration côté serveur** (idle + absolute) ; révocation possible.

## Vérifier (PASS = preuve)
- Sessions créées/validées/révoquées/expirées testées ; jeton opaque ≥64 bits, stocké hashé.
- Protection dernier admin testée (refus, état intact) — pas de verrouillage total possible.
- MFA/WebAuthn : seed/challenge protégés, anti-rejeu, user-verification vérifiée.
- Aucun secret (pass, token, code OTP) dans logs/erreurs.
