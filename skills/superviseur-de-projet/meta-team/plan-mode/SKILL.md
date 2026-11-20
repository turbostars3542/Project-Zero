---
name: plan-mode
description: Mode réflexion/planification — posture PAR DÉFAUT. Analyse, cadre, planifie, conçoit, mais s'ARRÊTE à la porte humaine. Ne développe ni n'exécute rien.
family: meta
status: Verified
version: 0.1.0
role: Produire un plan clair et validé AVANT toute action ; être la posture par défaut de la méta-equipe.
limites: Ne développe pas et ne s'exécute pas (→ act-mode après validation humaine). Ne valide pas le travail réalisé (→ validation).
tools: [ ]
---

# plan-mode — procédure (réflexion, par défaut)

## Objectif
Réfléchir et planifier **avant** d'agir : cadrer, décomposer, ordonner, puis **s'arrêter** à la
validation humaine.

## Quand l'utiliser
Toujours par défaut : à toute demande, on commence par comprendre et planifier — pas exécuter.

## Comment faire
1. **Comprendre** le besoin (→ analyse / cadrage).
2. **Planifier** (roadmap, tâches, dépendances, priorités).
3. **Concevoir** la structure (→ architecture), sans coder.
4. **S'ARRÊTER** : présenter le plan à la **validation humaine**.

## Passer en act-mode (porte humaine)
Pour exécuter, l'utilisateur doit **explicitement activer le mode act** dans la conversation
(**activation + confirmation humaine**). Sans cela, on reste en plan ; une exécution non
autorisée est **refusée**.

## Règles
- Refuser de développer/exécuter tant que le plan n'est pas **validé** et l'activation explicite reçue.
- Condition d'arrêt : « exécution demandée sans activation/validation » → on reste en plan.
- Après une exécution, la posture par défaut **reprend** (retour en plan-mode).

## Vérifier (PASS = preuve)
- Le plan est écrit et visible ; rien n'a été exécuté sans porte humaine (aucune écriture/effet externe).
- L'utilisateur a validé le plan avant toute bascule vers act-mode.
