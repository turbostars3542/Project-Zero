---
name: act-mode
description: Mode exécution — activé EXPLICITEMENT après confirmation humaine (porte humaine). Exécute les actions validées par micro-étapes, teste, documente, sauvegarde, puis revient en plan-mode.
family: meta
status: Verified
version: 0.1.0
role: Exécuter un plan validé par de petites étapes, avec test + documentation + sauvegarde, puis rendre la main au plan-mode.
limites: Ne démarre pas sans activation explicite + confirmation humaine. Exécution sous permission (capable ≠ autorisé). Ne planifie pas à la place des autres (→ planning).
tools: [ ]
---

# act-mode — procédure (exécution, après porte humaine)

## Objectif
Exécuter les actions du plan **validé**, par **petites étapes vérifiées**, puis **revenir en plan-mode**.

## Quand l'utiliser
Seulement quand un plan est **validé** et que l'utilisateur **active explicitement** le mode act
avec **confirmation** (la porte humaine).

## Comment faire
1. **Activation** : l'utilisateur active act-mode + confirme (porte humaine passée).
2. **Exécuter** les actions par **micro-étapes** (petites capacités fonctionnelles indépendantes).
3. **Tester** chaque étape (tests réels, pas d'affirmation).
4. **Documenter** ce qui est fait et **sauvegarder** (→ documentation, backup).
5. **Retour en plan-mode** : la posture par défaut (réflexion) reprend.

## Règles
- Toute écriture/exécution reste sous **permission** (`capable ≠ autorisé`) ; pas d'autorisation acquise d'avance.
- **Chaîne de contrôle** : chaque écriture/exécution passe `Permissions → Policy → Risk` (voir `policy`, `risk`).
- Ne jamais sauter une micro-étape ou un test : chaque modification → test → backup.
- À la fin, **revenir en plan-mode** (ne pas rester en exécution).
- Skills actifs typiques : skills métier → `testing` → `validation` → `documentation` → `backup`.

## Environnement (LAB/TEST/STAGING/PRODUCTION)
- L'exécution se fait dans un **environnement validé** (un seul actif).
- Niveau par défaut : **LAB/TEST** pour les essais ; **PRODUCTION** pour ce qui est validé.
- **Transition validée** : avance ordonnée ; retour en PRODUCTION → **confirmation humaine**.
- On **n'exécute pas** en PRODUCTION avant validation complète (`validation` = PAS).

## Bornage & kill-switch
- **Bornage** : chaque exécution est bornée (nombre d'actions, temps, profondeur) — pas de boucle infinie.
- **Kill-switch** : possibilité d'**arrêt d'urgence externe** à tout moment ; on s'arrête, on sauvegarde, on documente.

## Vérifier (PASS = preuve)
- L'activation + confirmation humaine sont documentées (porte humaine).
- Chaque étape a produit une preuve réelle (test passé, résultat vérifié, backup).
- La posture est revenue en plan-mode à la fin.
