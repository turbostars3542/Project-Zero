---
name: scheduler-tasks
description: Tâches et planification — primitive Tasks (états Pending/Running/Success/Failed/Cancelled) + Scheduler (one-shot, activation/désactivation, détection d'échéance), events, transitions contrôlées. Sources : design state machines, distributed schedulers, tokio.
family: technology
status: Verified
version: 0.1.0
role: Fournir une primitive générique de tâches (états contrôlés, transitions validées) et un planificateur minimal (one-shot, échéances) qui déclenche les tâches, sans coupler au transport.
limites: Ne gère pas la persistance des tâches/scheduler (→ persistence). Ne fait pas de workers/queue/API (→ api, futures). Le scheduler minimal est in-memory.
tools: [ ]
---

# scheduler-tasks — procédure

## Objectif
Offrir une **primitive de tâches** (état, transitions contrôlées) et un **scheduler minimal** qui
déclenche des tâches à des échéances, avec des événements publiés sur l'EventBus.

## Quand l'utiliser
Quand un core doit exécuter des **actions contrôlées** (tâches, planification, workers). Débuter petit
(primitive + scheduler in-memory) avant d'ajouter persistance/queue/API.

## Comment faire
1. **Task** : id, statut, timestamps, résultat/erreur (le **payload** de la tâche ≠ son exécution).
2. **États** (machine à états) : `Pending/Running/Success/Failed/Cancelled` ; transitions **validées** ;
   états **terminaux** non réversibles. Implémenter chaque transition comme une fonction séparée
   (`transition_running_success`, etc.) — pas de `match` fragile pour le passage d'état.
3. **TaskManager** : créer/lancer, transitions contrôlées, **événements** (`task.created`, `task.state`).
4. **Scheduler** (minimal) : planifier une tâche **one-shot** (date/heure), activer/désactiver,
   détecter l'échéance (`due`), déclencher via le TaskManager. Ne pas exécuter de tâche **sous le verrou** du scheduler.
5. **Événements/observabilité** : un changement d'état produit un événement ET un log (sans secret).
6. **Architecture** : `Scheduler → TaskManager → Task → EventBus`.

## Règles (Core)
- **Transitions contrôlées** : état → état uniquement via transition validée ; terminaux non réversibles.
- **Séparer scheduling et exécution** : le scheduler décide *quand*, l'exécuteur *fait*.
- **Minimal d'abord** : in-memory (sans workers, queue, persistance) ; étendre si besoin réel.
- **Pas de tâche sous le verrou** du scheduler (un gros job ne bloque pas la planification).
- Événements/logs **sans secret** ; échéance manquée / échec → état documenté (pas de blocage silencieux).
- Réentrance/temporel : stocker l'instant en UTC ; définir la politique d'échéance manquée.

## Vérifier (PASS = preuve)
- Tests : transitions d'état **valides** + **invalides refusées** ; tâches créées/lancées/résolues.
- Scheduler : planification one-shot déclenchée à échéance (test), activation/désactivation.
- Événements publiés ; aucun secret dans les événements/logs.
