---
name: profile
description: PERMANENT pour chaque projet — indique la posture du moment de la meta-team (mode plan par défaut, mode act après porte humaine) et coordonne la bascule entre les profils de mode.
family: meta
status: Verified
version: 0.1.0
role: Savoir et dire QUEL mode est actif ; coordonner la bascule plan ↔ act (porte humaine).
limites: Ne fait pas le travail des membres. Ne sélectionne pas encore de profil métier. Ne donne aucune permission.
tools: [ ]
---

# profile — procédure

## Objectif
Faire savoir **dans quel mode** la meta-team se trouve et piloter la bascule, pour garantir
que **rien ne s'exécute sans passer la porte humaine**.

> **Permanent :** ce skill est actif pour **chaque projet**, en continu — au même titre que le
> superviseur-de-projet. Tout projet passe par la porte plan → act ; profile ne se désactive jamais.

## Quand l'utiliser
En permanence (posture à connaître), et à chaque demande : savoir s'il faut **réfléchir** ou **exécuter**.

## Comment faire
1. **Identifier la demande** : réflexion/planification ou exécution d'actions ?
2. **Déclarer le mode actif** :
   - **plan-mode** (PAR DÉFAUT) : toute demande de planifier/cadrer/concevoir.
   - **act-mode** : exécution d'un plan **déjà validé** par l'humain, demandée **explicitement**.
3. **Bascule** : une exécution n'est autorisée qu'après **confirmation humaine explicite** (porte humaine).
4. **Retour** : après une exécution, revenir en posture par défaut (plan-mode).

## Règles
- Posture par défaut = **plan-mode** (réflexion, pas d'exécution).
- **Porte humaine :** passer en act-mode exige une **activation explicite + confirmation** de l'utilisateur, jamais automatique.
- **capable ≠ autorisé :** le mode act exécute sous permission, pas de droit acquis par la sélection seule.
- L'exécution se fait par **micro-étapes** puis **retour en plan-mode**.

## Modèle d'identité (rôle → permissions → outils → autonomie → périmètre)
Un mode se rattache à une **identité** claire, pour savoir **qui** est autorisé à quoi :
1. **Rôle** : ce que l'identité est censée faire.
2. **Permissions** : `allow` / `deny` (**deny gagne**, **deny par défaut**).
3. **Outils** : quels outils elle **peut** utiliser (besoin ≠ droit).
4. **Autonomie** : gagnée progressivement, jamais donnée d'avance.
5. **Périmètre** : bornes (chemins, actions, environnements) où elle peut agir.
Chaque demande est évaluée contre cette **identité** → `ALLOW / DENY / CONFIRM_REQUIRED` (voir `policy`, `risk`).

## Vérifier (PASS = preuve)
- Le mode actif déclaré correspond à la demande réelle.
- Aucune action d'exécution sans confirmation humaine explicite ; retour en plan-mode à la fin.
