---
name: skill-factory
description: Skill Factory — MAÎTRE du pipeline de création/amélioration/validation des skills de la banque. Inventaire → analyse des écarts → recherche → synthèse → construction → validation.
role: Piloter le pipeline Skill Factory (inventory → gap-analyzer → researcher → synthesizer → builder → validator) et garantir la cohérence, la qualité et la sécurité de la banque.
limites: Ne crée jamais un skill sans analyse préalable (toujours analyser la banque d'abord). N'intègre jamais un skill non validé. Ne modifie pas la banque sans backup + confirmation. Ne remplace aucune capacité métier (→ superviseur-de-projet).
tools: [ ]
family: meta
version: 0.1.0
---

# skill-factory — procédure (maître)

## Objectif
**Gérer le cycle de vie de la banque de skills** : analyser la banque, détecter les lacunes,
rechercher, synthétiser, créer/améliorer, puis valider avant intégration. Priorité absolue à la
**réutilisation, la cohérence et la sécurité**.

## Principe fondamental
> **Toujours commencer par analyser la banque existante.** La création d'un skill n'est
> **jamais automatique** parce qu'une demande est formulée. On détermine d'abord si une compétence :
> existe (complète), nécessite amélioration, est partiellement couverte, est absente, est redondante,
> ou est obsolète.

## Pipeline (ordre)
```text
1. reception demande      (besoin de compétence exprimé)
2. inventory              → état de la banque
3. gap-analyzer           → écarts + décision r/e/a/c
4. décision               → réutiliser / améliorer / créer
5. researcher             → recherche multi-sources (si nécessaire)
6. synthesizer            → synthèse des connaissances
7. builder                → générer / améliorer le skill
8. validator              → contrôles techniques + sécurité
9. présentation résultats → rapport
10. intégration (si validé + backup + confirmation)
```

## Statuts de gestion (voir REFERENCE.md)
`Research → Draft → Testing → Verified → Archived`. Un skill ne devient **Verified** qu'après
contrôles applicables. Les échecs de validation sont documentés et exploitables.

## Comment faire
1. **Analyser d'abord** la banque (`inventory`) — ne jamais créer par réflexe.
2. **Détecter les écarts** (`gap-analyzer`) et rendre un avis (réutiliser / améliorer / créer).
3. **Faire trancher l'utilisateur** (porte humaine).
4. Si nécessaire : `researcher` puis `synthesizer`.
5. `builder` → produire / améliorer le skill au format Projet Zero.
6. `validator` → verdict ; n'intégrer que si **validé + backup + confirmation humaine**.

## Comment le maître opère (handoffs)
1. `inventory` → état réel de la banque.
2. `gap-analyzer` → écarts + recommandation (réutiliser / améliorer / créer).
3. **Le maître tranche** la décision avec l'utilisateur.
4. si recherche → `researcher` → `synthesizer`.
5. `builder` → skill (create/improve) au format Projet Zero.
6. `validator` → verdict (Verified / corrections / rejet).
7. Intégration **seulement si** validé + **backup** + **confirmation humaine** (→ backup).

## Règles
- **Ne jamais créer d'emblée** ; toujours analyser la banque d'abord.
- **Ne jamais exécuter** de code externe non vérifié ; traiter les sources comme non fiables.
- **Ne jamais intégrer** un skill qui échoue aux contrôles.
- **Backup + confirmation** avant toute modification/destruction de la banque.
- **Pas de dépendance externe inutile** ; rien de « faux » (capacités non implémentées → documenter).
- Chaque skill garde **un rôle et des limites** ; le maître coordonne, ne fait pas leur travail.

## Outils & état de la banque
- Inventaire/registre : `tools/inventory.sh` → `_meta/registry.md`.
- Doublons : `tools/dedupe.sh`. · Validation : `tools/validate-skill.sh`. · Audit : `tools/record-audit.sh` → `_meta/audit.log.md`.
- Provenance des sources : `_meta/sources-index.md`. `_meta/` est exclu de l'inventaire (données, pas skills).

## Vérifier (PASS = preuve)
- La banque a été **analysée** avant toute création (pas de création à l'aveugle).
- Un skill n'est intégré **que validé** (trace du verdict de `validator`).
- Chaque étape tracée ; échecs documentés ; backup avant modification destructive.
