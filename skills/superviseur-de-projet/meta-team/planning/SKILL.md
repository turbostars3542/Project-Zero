---
name: planning
description: Dossier de plan : roadmap, tâches, dépendances, priorités et suivi (pur — planifie et suit, ne valide pas).
family: meta
status: Verified
version: 0.1.0
role: Décomposer l'objectif en étapes/tâches, prioriser, documenter le plan et le suivre.
limites: Ne cadre pas (→ analyse-de-problemes). Ne conçoit pas la structure (→ architecture). Ne valide pas (→ validation).
tools: [ ]
---

# planning — procédure

## Objectif
Produire le plan (roadmap, tâches, dépendances, priorités) **en micro-étapes** et en **suivre** l'avancement.

## Quand l'utiliser
Après le cadrage (`PROBLEM.md`), quand il faut organiser le travail.

## Comment faire
1. Reprendre le cadrage (`PROBLEM.md`) et l'objectif.
2. **Décomposer en MICRO-ÉTAPES** : petites capacités fonctionnelles indépendantes et ordonnées, chacune vérifiable avant la suivante.
3. Prioriser (ordre de réalisation), identifier les jalons.
4. Documenter le plan (roadmap, tâches) et le **suivi**.
5. Suivre l'avancement (phases, découvertes, erreurs).

### Décomposition en micro-étapes (règles)
- Chaque fonctionnalité = une étape distincte, divisée en micro-étapes ordonnées.
- **Cycle d'une micro-étape** :
```text
PLANIFIER → MODIFIER → TESTER → DOCUMENTER → BACKUP IMMÉDIAT → VÉRIFIER → VALIDER → ÉTAPE SUIVANTE
```
- Ne **jamais** décomposer « tout d'un coup » ni créer une étape à l'avance tant que la précédente n'est pas validée.
- Une étape ne passe que si elle **fonctionne → testée → documentée → sauvegardée → validée** (→ validation).

## Règles
- Récupère le problème **cadré** avant de planifier ; sinon retour à `analyse-de-problemes`.
- `'Validé'` exige une **preuve**, jamais une simple affirmation.
- Ne pas dévier vers le cadrage, la conception (→ architecture) ou la validation (→ validation).
- Découper **en micro-étapes** ; pas de construction à l'avance (construction progressive).

## Vérifier (PASS = preuve)
- Le plan couvre l'objectif cadré ; dépendances et priorités cohérentes.
- Les jalons marqués **Validé** ont une preuve ; sinon → NON VÉRIFIÉ.
