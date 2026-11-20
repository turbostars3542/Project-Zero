---
name: documentation
description: Maintient la documentation (guide, skills, outils, changelog, reprise, décisions / ADR).
family: meta
status: Verified
version: 0.1.0
role: Documenter la réalité (état réel, changements, décisions), sans rien inventer.
limites: Ne valide pas les livrables (→ validation). Ne produit pas les faits, il les documente.
tools: [ ]
---

# documentation — procédure

## Objectif
Garder la documentation à jour et refléter la **réalité**.

## Quand l'utiliser
À chaque changement réel (code, skills, outils, décisions).

## Comment faire
1. Identifier les changements réels à refléter (code, skills, outils, décisions).
2. Déterminer **où** documenter (guide principal, skills, outils, changelog, reprise).
3. Mettre à jour en gardant la cohérence (pas de doublon / pas de référence morte).
4. Consigner les décisions (ADR → **Décideur Humain|IA** + date).

## Règles
- Ne jamais documenter un résultat non prouvé / **ne rien inventer**.
- Éviter une **seconde source de vérité** (référence unique par sujet).
- Une décision / ADR porte un Décideur et une date.

## Vérifier (PASS = preuve)
- La doc reflète l'état réel ; aucune référence morte ; pas de redondance.
- Les décisions sont horodatées et nomment leur Décideur.
