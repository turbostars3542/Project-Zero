---
name: verification-after-action
description: Vérification post-action — une commande qui réussit sans erreur n'est pas une opération réussie : définir le résultat attendu AVANT, vérifier le résultat réel via un signal indépendant (état, version, télémétrie), rollback si objectif non atteint. Sources : Google SRE, Dataplicity, Microsoft.
family: meta
status: Verified
version: 0.1.0
role: Vérifier qu'une action a réellement atteint son objectif (pas seulement qu'elle s'est terminée sans erreur) via un signal indépendant, et déclencher rollback/récupération sinon.
limites: Ne fait pas le rollback lui-même (→ rollback). N'effectue pas les tests pré (→ testing). Ne rend pas seul le verdict final (→ validation).
tools: [ ]
---

# verification-after-action — procédure

## Objectif
Garantir qu'une **action est réussie parce que son résultat réel est atteint**, et non parce que la
commande s'est terminée sans erreur. « Un changement de flotte est terminé quand l'état du système est
correct, pas quand le runner dit que la commande a été envoyée » (Dataplicity).

## Quand l'utiliser
Après **toute modification/opération** importante : vérifier que l'objectif est réellement atteint ;
sinon → rollback / récupération / alerte.

## Comment faire
### 1. Définir le résultat attendu AVANT d'exécuter
Pour chaque opération, écrire :
- le **groupe cible** (cohort) ;
- la commande/le changement ;
- les **préconditions** ;
- l'**état résultant attendu** (succès) ;
- le taux d'échec **acceptable** ;
- la **condition d'arrêt/rollback** ;
- le **signal de vérification indépendant**.

### 2. Vérifier via un signal indépendant
Ne pas utiliser le résultat de la commande comme seule preuve. Préférer un **signal distinct** qui
représente le résultat réel :
- état du service/processus ; checksum/version du binaire ;
- version du package / image ; télémétrie produit ; config rapportée ;
- health-check / test de dépendance ; événement de log attendu ; reconnexion après reboot.

### 3. Séparer les résultats explicitement
- `succeeded & verified` ; `command failed` ;
- `command succeeded but verification failed` (⚠️ piège) ;
- `device went offline` ; `never participated` ; `result unknown`.
> « 98 % de succès » peut cacher les 2 % inconnus à investiguer — ne pas les fondre dans le pourcentage.

### 4. Condition d'arrêt / rollback
- Définir des **stop conditions** : ex. >2 % échec de vérification, un device ne revient pas, un signal
  de santé dégrade, une erreur client augmente.
- Ne pas continuer juste parce que l'outil peut cibler plus de devices.

### 5. Agir selon le résultat
- **Échec de vérification** → investiguer / `rollback` / alerte (→ `rollback`, `monitoring`).
- Une action **partiellement réussie** → documenter les inconnus, ne pas les cacher.

## Règles
- **Définir le succès avant**, pas après.
- **Vérifier par un signal indépendant** de l'exécution ; ne pas se fier au code de sortie seul.
- Séparer **succès réel** / **échec** / **inconnu** ; ne pas masquer les inconnus.
- **Stop conditions** claires ; sinon **rollback / alerte**.
- « Zéro erreur de sortie » ≠ succès ⇒ toujours vérifier le résultat réel.

## Vérifier (PASS = preuve)
- Résultat attendu défini AVANT ; vérification par un **signal indépendant**.
- Aucune action traitée « réussie » sur le seul code de retour ; inconnus explicitement séparés.
- Stop conditions / rollback appliqués quand le résultat réel est absent ou mauvais.
