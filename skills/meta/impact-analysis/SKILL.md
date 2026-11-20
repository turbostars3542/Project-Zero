---
name: impact-analysis
description: Analyse d'impact & dry-run avant action — avant une opération importante : Permissions → Dépendances → Impact → Dry Run → Confirmation → Exécution → Vérification → Rollback. Évite de rendre le système inutilisable sans avertissement. Sources : SRE, change management, principes opérationnels.
family: meta
status: Verified
version: 0.1.0
role: Analyser, avant une opération, ses dépendances et son impact, faire un dry-run, et décider si une confirmation/rollback est nécessaire.
limites: Ne décide pas seul (→ porte humaine). Ne fait pas l'exécution (→ act-mode). Ne fait pas le rollback (→ rollback).
tools: [ ]
---

# impact-analysis — procédure (analyse d'impact + dry run)

## Objectif
Avant une **opération importante**, évaluer son **impact** et ses **dépendances**, faire un **dry-run**,
puis décider si une **confirmation / un plan de rollback** est nécessaire. Évite qu'une action rende le
système **inutilisable sans avertissement**.

## Quand l'utiliser
Avant toute action à **risque** ou dont les **effets de bord** sont mal connus — la chaîne :
`Action → Permissions → Dépendances → Impact → Dry Run → Confirmation (si nécessaire) → Exécution → Vérification → Rollback (si nécessaire)`.

## Comment faire
### 1. Vérifier les permissions
- `capable ≠ autorisé` ; passer par la chaîne de décision (→ `policy`/`risk`).

### 2. Identifier les dépendances
- Quels systèmes/services/ressources sont touchés (directement/indirectement) ?
- Y a-t-il des dépendances dont une autre équipe est propriétaire (régression invisible localement) ?

### 3. Évaluer l'impact
- Réversibilité (→ `rollback`) : Réversible / Partiel / Irréversible.
- Étendue (blast radius) : qui/quoi affecté ? Peut-on le restreindre ?
- Impact sur les données/schéma/l'état (le plus risqué).

### 4. Dry-run
- Simuler l'action sans effet de bord réel ; vérifier le plan/la sortie avant d'exécuter.
- Si l'action risquerait de rendre le serveur inutilisable : **ne pas l'exécuter sans avertissement clair**.

### 5. Confirmer / décider
- Risque faible & réversible → possible à exécuter (avec porte).
- Risque moyen/élevé ou irréversible → **confirmation humaine** obligatoire (+ plan de rollback).
- Jamais d'exécution sans avoir répondu à « que se passe-t-il en cas de problème ? ».

### 6. Exécuter → vérifier → rollback si besoin
- Après exécution : **vérifier le résultat réel** (→ `verification-after-action`) ; sinon rollback/alerte.

## Règles
- **Avant toute action risquée** : analyser impact + dépendances + dry-run.
- **Jamais de mise hors-service sans avertissement** ; confirmation pour ce qui est risqué/irréversible.
- **Dépendances** : identifier même celles hors de son périmètre (régression croisée).
- **Plan de rollback** prêt (→ `rollback`) pour toute opération susceptible d'échouer.

## Vérifier (PASS = preuve)
- Impact + dépendances analysés AVANT l'action ; dry-run fait pour les actions simulables.
- Risque irréversible/moyen-élevé → confirmation humaine documentée + plan de rollback.
- Aucune action exécutée sans avoir défini le comportement en cas d'échec.
