---
name: policy
description: Couche de RÈGLES de contrôle d'accès au-dessus des permissions. Décide ALLOW / DENY / CONFIRM_REQUIRED ; deny gagne ; sans règle → on s'en remet aux permissions (pass-through).
family: meta
status: Verified
version: 0.1.0
role: Appliquer des règles déclaratives : décider la politique d'une action, en renfort des permissions.
limites: Ne peut jamais autoriser ce que les permissions refusent. Ne donne aucune permission. N'exécute rien.
tools: [ ]
---

# policy — procédure

## Objectif
Ajouter une couche de **règles** (plus riche que les permissions) pour décider si une action est
autorisée, exige confirmation, ou est refusée.

## Quand l'utiliser
À chaque action d'écriture/exécution, en complément des permissions : décider la **politique**.
Cohérent avec le modèle de Supervision (Policy au-dessus des permissions).

## Comment faire
1. Recevoir l'action demandée **après** les permissions.
2. Chercher une **règle** correspondante ; s'il n'y en a aucune → **pass-through** (s'en remettre aux permissions).
3. Rendre la décision : `ALLOW` / `DENY` / `CONFIRM_REQUIRED` (deny gagne).
4. Transmettre à la couche suivante (**Risk**) sans exécuter.

## Décisions
- **ALLOW** — la règle autorise l'action.
- **DENY** — la règle refuse ; **deny gagne** (un refus n'est pas contournable par ailleurs).
- **CONFIRM_REQUIRED** — la règle impose une **confirmation humaine** avant exécution.

## Règles
- **deny gagne** : tout refus (permission ou politique) est final et ne peut être ré-autorisé par une autre couche.
- **deny par défaut** / fail-closed : toute action inconnue, absente ou invalide → `DENY` (ou demande confirm), jamais un `ALLOW` d'office.
- **pass-through** : **aucune règle** → on s'en remet aux **permissions** (ne pas inventer une règle).
- **Confirmation** : un `CONFIRM_REQUIRED` n'est **pas contournable** sans confirmation valide.
- **Aucune primitive d'exécution** ; la politique ne lance ni n'exécute rien.

## Chaîne de décision avant exécution
`Permissions → Policy → Risk → exécution` — le refus à un niveau bloque aux niveaux suivants.

## Vérifier (PASS = preuve)
- Chaque action sensible a une décision politique tracée (`ALLOW/DENY/CONFIRM_REQUIRED`).
- Un refus n'est jamais ré-autorisé par une autre couche (deny gagne) ; confirmation exigée le cas échéant.
