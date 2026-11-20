---
name: rollback
description: Rollback / réversibilité — principe transversal : classer Réversible/Partiel/Irréversible, sauvegarder avant modification, tester le rollback, blue/green, roll-forward si nécessaire. Sources : SRE/Google, AWS, Microsoft, IXC.
family: meta
status: Verified
version: 0.1.0
role: Garantir la réversibilité des opérations : classifier, sauvegarder avant, tester le rollback, et décider rollback/roll-forward.
limites: Ne fait pas le backup luimme (→ backup). Ne rend pas seul le verdict (→ validation). Une opération irréversible ne peut pas être rendue réversible par ce skill.
tools: [ ]
---

# rollback — procédure (principe transversal)

## Objectif
Faire du **rollback un principe transversal et fondamental** : toute opération importante doit pouvoir
être **annulée** (ou au minimum son risque d'irréversibilité connu). Sources : SRE/Google (« rollbacks are
normal »), AWS Builder, Microsoft Well-Architected.

## Quand l'utiliser
Avant **toute modification importante** et à chaque étape risquée — cycle : `état → sauvegarde → modification → validation → test → succès/rollback`.

## Comment faire
### 1. Classifier chaque opération
- 🟢 **Réversible** — retour à l'état précédent disponible (rollback facile).
- 🟡 **Partiellement réversible** — seule une partie peut être annulée.
- 🔴 **Irréversible** — impossible de revenir automatiquement. → **avertissement** + confirmation renforcée.
> **Ne pas prétendre réversible ce qui ne l'est pas.** Si réversibilité incertaine → la classer explicitement.

### 2. Sauvegarder / versionner avant
- **Backup immédiat** avant modification (→ `backup`) ; enregistrer l'état + point de rollback.

### 3. Tester le rollback
- **Tester régulièrement** le rollback (SRE : « rollbacks are normal ») — si ça fait longtemps qu'on n'a pas
  roulé en arrière, le faire exprès ; détecter les pièges d'incompatibilité.

### 4. Stratégies
- **Blue/green** : garder l'ancien environnement en parallèle → bascule rapide. Ne supprimer l'ancien
  qu'après validation complète.
- **Canary** : déployer sur une petite part d'abord, observer, puis étendre ou revenir.
- **Two-phase** (schéma/données) : séparer le changement en `expand → migrate → contract` pour garder un
  rollback possible (ex. ne pas lâcher l'ancienne colonne d'un coup).
- **Immutable** : déployer une nouvelle infra en parallèle plutôt que modifier en place (si adapté).

### 5. Rollback vs roll-forward
- **Rollback** : revenir à un état connu-bon (préféré par SRE en cas de bug grave).
- **Roll-forward** : corriger par une nouvelle version (moins préféré si incertain ; peut éloigner du connu-bon).
- Prévoir un **plan de rollback exécutable** par l'on-call (pas besoin de jugement senior).

### 6. Vérifier l'état après
- « Commande sans erreur » ≠ « succès » : **vérifier le résultat réel** (→ `verification-after-action`).
- Échec ou objectif non atteint → **rollback / récupération / alerte**.

## Règles
- **Réversibilité explicite** : classifier Réversible/Partiel/Irréversible ; jamais de fausse assurance.
- **Backup avant** ; **tester le rollback** régulièrement.
- **Blue/green + canary** pour réduire le blast radius ; ne pas supprimer l'ancien avant validation.
- **Rollback est normal** ; aucune culpabilité ; c'est le bon réflexe fiabilité.
- Opération irréversible → **avertissement + confirmation renforcée**.

## Vérifier (PASS = preuve)
- Chaque opération importante a une **classification de réversibilité** explicite.
- Backup/point de rollback existant avant modification ; plan de rollback documenté et exécutable.
- Rollback **testé** récemment ; après une action, **résultat réel vérifié** (pas juste l'absence d'erreur).
