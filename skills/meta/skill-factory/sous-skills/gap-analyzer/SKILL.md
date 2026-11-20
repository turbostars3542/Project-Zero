---
name: skill-gap-analyzer
description: Compare les besoins exprimés avec la banque existante (via l'inventaire), détecte les LACUNES, recommande réutiliser / améliorer / créer, et produit un plan priorisé.
role: Analyser l'écart entre le besoin et l'existant et proposer la bonne action (réutilisation > amélioration > création).
limites: Ne crée ni n'améliore lui-même (→ builder). Ne fait pas la recherche (→ researcher) ni la validation (→ validator). La décision finale est humaine.
tools: [ ]
family: meta
version: 0.1.0
---

# skill-gap-analyzer — procédure

## Objectif
Détecter les **lacunes** entre un besoin exprimé et la banque existante, et recommander la
**meilleure action** : réutiliser, améliorer, ou créer.

## Quand l'utiliser
Après `inventory`, dès qu'un besoin de compétence est formulé.

## Comment faire
1. Prendre l'**inventaire** (output de `inventory`) et le **besoin** exprimé.
2. **Comparer** : le besoin est-il couvert ? partiellement ? pas du tout ?
3. Identifier les **compétences connexes** (skills proches qui pourraient s'étoffer).
4. Rendre une **décision recommandée** en suivant la règle d'or :
   - Existe (complète) → **réutiliser**.
   - Existe (incomplète) → **améliorer**.
   - Partiellement couvert (plusieurs) → **consolider / référencer**.
   - Absent → **créer**.
   - Redondant → **signaler / archiver**.
   - Obsolète → **archiver / déprécier**.
5. Produire un **plan de développement priorisé** (quoi faire, dans quel ordre, par quel sous-skill).

## Règles
- **Priorité à la réutilisation** : jamais « créer » quand un skill existant suffit ou peut être étendu.
- Basé sur l'inventaire **réel** (pas d'à-priori).
- La décision reste **humaine** : on *recommande*, on n'impose pas.
- Documenter la **raison** de chaque recommandation (traçable).

## Vérifier (PASS = preuve)
- Chaque recommandation s'appuie sur l'inventaire réel (skill cité, raison).
- Le plan priorisé distingue `réutiliser / améliorer / créer` ; la décision finale est validée par l'humain.
