---
name: orchestration
description: Coordinate l'équipe : décompose une tâche, distribue aux skills, récupère, vérifie borné et combine. 0 permission.
family: meta
status: Verified
version: 0.1.0
role: Coordonner les skills sans fusionner leurs responsabilités ; produire un résultat combiné.
limites: Ne peut pas accorder de privilège ni exécuter d'outils lui-même (0 permission). API ≠ autorisation.
tools: [ ]
---

# orchestration — procédure

## Objectif
Coordonner l'équipe : décomposer → distribuer → récupérer → vérifier → combiner.

## Quand l'utiliser
Quand une tâche demande plusieurs skills de l'équipe.

## Comment faire
1. Identifier la tâche (explicite ou déduite).
2. **Décomposer** en sous-tâches selon les skills disponibles.
3. **Distribuer** chaque sous-tâche à un skill existant.
4. **Récupérer** les résultats (bornés : max_retries / max_stalled).
5. **Vérifier** de façon bornée (arrêt si rejet).
6. **Combiner** et produire un résumé : COMPLETED / PARTIAL / FAILED / ERROR.

## Mode plan / act (coordination)
- Orchestration **respecte la porte humaine** gérée par `profile` (plan-mode / act-mode).
- En **plan-mode** : elle décompose/distribue les **réflexions** (analyse, plan, architecture) — pas d'exécution.
- En **act-mode** (après validation humaine) : elle distribue les **exécutions** validées, par micro-étapes.
- Elle **ne bascule pas elle-même** les modes : la bascule appartient à `profile` + la porte humaine.

## Règles
- **Coordonner sans fusionner** les responsabilités.
- **0 permission** : ne peut pas accorder de privilèges ni exécuter des outils.
- **Bornage** : chaque orchestration est bornée (max_retries / max_stalled, quotas actions/temps/profondeur) — jamais de boucle infinie.
- **Kill-switch** : possibilité d'**arrêt d'urgence externe** à tout moment ; on arrête proprement, on sauvegarde, on trace.
- Tâche vide → ERROR ; capacité inconnue → échec borné.
- Chaque sous-tâche passe par un **skill existant** ; pas de contournement.
- Respecter le mode actif : pas d'exécution en plan-mode, ni d'outil local sans porter la main au bon membre.
- Chaque sous-tâche validée exige une **preuve** (→ `validation`, PASS = preuve) ; toute écriture/exécution passe `Policy → Risk` (voir `policy`, `risk`).

## Vérifier (PASS = preuve)
- Chaque sous-tâche passe par un skill existant ; résultat combiné et vérifié borné.
- Pas de boucle ; résultats bornés et tracés.
