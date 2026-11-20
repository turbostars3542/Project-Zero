---
name: risk
description: Classe le risque d'une action (LOW / MEDIUM / HIGH) et impose confirmation ou blocage, APRÈS la politique et AVANT l'exécution (le risque n'autorise jamais un refus).
family: meta
status: Verified
version: 0.1.0
role: Évaluer le risque avant modification/exécution et décider ALLOW / CONFIRM_REQUIRED / BLOCKED ; associer un rollback si nécessaire.
limites: Ne peut jamais autoriser ce que permissions/politique refusent. N'exécute rien. Ne remplace ni la permission ni la politique.
tools: [ ]
---

# risk — procédure

## Objectif
Classer le **risque** d'une action et imposer confirmation/blocage avant exécution.
Modèle : Risk Engine, évalué au point d'action.

## Quand l'utiliser
Avant **toute écriture / exécution** (après la politique, avant l'exécution), pour décider si on
peut agir, si on exige confirmation, ou si c'est bloqué.

## Comment faire
1. Prendre l'action (déjà passée par Permissions → Policy).
2. Classer le **niveau de risque** (LOW / MEDIUM / HIGH).
3. Rendre la décision : `ALLOW` / `CONFIRM_REQUIRED` (+ rollback) / `BLOCKED`.
4. Ne jamais autoriser ce qui a été refusé plus haut ; ne pas exécuter soi-même.

## Niveaux et décisions
| Niveau | Actions typiques | Décision |
|---|---|---|
| **LOW** | lecture / recherche | `ALLOW` |
| **MEDIUM** | écriture / modification | `CONFIRM_REQUIRED` + **rollback** |
| **HIGH** | exécution / terminal, affaiblissement sécurité | `CONFIRM_REQUIRED`, parfois `BLOCKED` |

## Règles
- **Le risque n'autorise jamais** ce que permissions/politique refusent (deny gagne sur toute la chaîne).
- **BLOCKED** → refus ; **CONFIRM_REQUIRED** sans confirmation → pas d'exécution.
- **Rollback** : une action à risque moyen est associée à un **backup immédiat** récupérable (→ `backup`).
- **Aucune primitive d'exécution** ; le risque ne fait qu'évaluer.
- Toute action **inconnue** → fail-closed (jamais autorisée d'office).

## Chaîne de décision
`Permissions → Policy → Risk → exécution` — le refus d'un niveau bloque la suite.

## Vérifier (PASS = preuve)
- Chaque écriture/exécution a une évaluation de risque tracée (niveau + décision + rollback).
- Un risque `BLOCKED`/refusé n'est jamais outrepassé par une autre couche.
