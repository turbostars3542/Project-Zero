---
name: skill-validator
description: Valide les skills — structure, métadonnées, cohérence, doublons, dépendances, tests, sécurité, compatibilité moteur — et rend un verdict (Verified / corrections / rejet). Refuse les non conformes.
role: Vérifier sur preuves un skill avant intégration et produire un rapport de validation exploitables.
limites: Ne corrige pas le skill (→ builder, après rapport). La décision finale d'intégration reste humaine (avec backup + confirmation). Ne valide jamais sans preuve.
tools: [ ]
family: meta
version: 0.1.0
---

# skill-validator — procédure

## Objectif
Vérifier un skill **sur preuves** et rendre un verdict clair : **Verified** (intégrable),
**corrections requises**, ou **rejet** (non conforme). Produire un **rapport de validation**.

## Quand l'utiliser
Après `builder` (et à la revalidation d'un skill de la banque).

## Comment faire (contrôles — voir REFERENCE §6)
1. **Structure** : `SKILL.md` présent ; dossier conforme v2 ; pas de fichier parasite.
2. **Métadonnées** : frontmatter valide (name/description/role/limites/family/tools).
3. **Cohérence des instructions** : procédure claire, règles cohérentes, PASS vérifiable.
4. **Doublons / conflits** (via inventaire) : pas de chevauchement non signalé.
5. **Dépendances** : `requires`/`tools` référencés existent dans la banque.
6. **Tests** : le skill est-il testable ? tests adaptés exécutés et probants.
7. **Sécurité** : capable≠autorisé, anti-traversal, pas de secret, exclusions, sources sûres.
8. **Compatibilité moteur** : conforme au contrat Projet Zero (v2) ; aucun outil/capacité « faux ».
9. Écrire le **rapport** : chaque contrôle → OK / problème / bloquant, avec preuve ; verdict final.

## Outils (automatisés)
- `../tools/validate-skill.sh <skill>` : contrôle local structure + métadonnées (lecture seule) → PASS / NON VÉRIFIÉ.
- `../tools/record-audit.sh` : consigne le verdict dans `_meta/audit.log.md` (append-only, avec confirmation).

## Décision
- **Verified** : tous les contrôles applicables OK (preuves) → peut être intégré.
- **Corrections** : problèmes corrigeables → rapport exploitable pour `builder`.
- **Rejet** : incohérence bloquante ou sécurité → **refus d'intégration**, expliqué.

## Règles
- **PASS = preuve** : jamais Verified sur simple inspection si un contrôle est exécutable.
- **REFUS des non conformes** : aucun skill invalide ne rentre dans la banque automatiquement.
- Un **échec** est documenté (quoi, pourquoi, comment corriger) et exploitable.
- Ne pas modifier le skill ; seulement vérifier et rapporter.

## Vérifier (PASS = preuve)
- Rapport de validation produit (contrôles + preuves + verdict) ; aucun skill non conforme intégré.
- Statut mis à jour cohéremment (→ Verified ou retour Draft/Testing pour correction).
