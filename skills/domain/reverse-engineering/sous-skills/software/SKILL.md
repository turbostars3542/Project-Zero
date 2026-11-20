---
name: reverse-engineering-software
description: Sous-skill de rétro-ingénierie — type LOGICIEL INFORMATIQUE : analyser une application/binaire existant(e) (architecture, formats de fichiers, protocoles, interfaces) de façon reproductible et autorisée. Voir aussi le maître reverse-engineering (méthodologie générale) et reverse-engineering-plc.
family: domain
status: Verified
version: 0.1.0
role: Analyser des artefacts logiciels (binaires, apps, fichiers, protocoles) via le workflow 7 étapes : cadrer, préserver, trier, observer, modéliser, vérifier, rapporter.
limites: Ne modifie pas le système analysé. Autorisation requise (possédé/licence). Ne produit pas l'implémentation (→ builder). C'est un sous-skill spécialisé — suivre la méthodologie générale du maître reverse-engineering.
tools: [ ]
---

# reverse-engineering — sous-skill logiciel informatique

> Suivre d'abord le **maître `reverse-engineering`** (workflow 7 étapes, règles, cadre légal). Ce sous-skill
> fournit les **particularités applicables au logiciel informatique** (binaire, app, fichier, protocole).

## Objectif
Analyser un **logiciel / artefact numérique** (binaire, application, fichier, protocole) pour en comprendre
le **fonctionnement, l'architecture, les formats de fichiers, les protocoles et les interfaces**, de façon
**reproductible et vérifiable**, dans un **cadre autorisé**.

Un bon résultat permet à une **deuxième personne de reproduire un comportement observé** depuis le **même
artefact autorisé** + les **preuves**.

## Comment faire
1. Lire le **maître** `reverse-engineering` (règles communes + cadre légal) si ce n'est pas fait.
2. Appliquer le **workflow** ci-dessous pour une cible *logiciel informatique*.

## Workflow (7 étapes, spécifique logiciel)
```text
1. Cadrer → 2. Préserver → 3. Trier → 4. Observer → 5. Modéliser → 6. Vérifier → 7. Rapporter
```
1. **Cadrer** : cible, propriétaire/autorisation, but, questions. *(sortie : page de cadrage)*
2. **Préserver** : copie lecture seule + **sha256** + date. *(sortie : ID artefact + hash)*
3. **Trier** : `file` (≠ extension), `strings`, **Detect-It-Easy** (format/compilateur/obfuscation), PE-bear/LIEF (PE/ELF/Mach-O). *(sortie : tableau d'inventaire)*
4. **Observer** : tests permis **une variable à la fois** — `xxd`/hex, **Ghidra** (désassemblage/décompilation/headless), `objdump`, débogueur (labo isolé), Wireshark (protocoles). *(sortie : journal entrées-sorties/captures)*
5. **Modéliser** : fonctions, états, messages, données. *(sortie : call-graph, diagrammes, table protocole)*
6. **Vérifier** : prédire → changer **un** paramètre → comparer (ex. tester 0 et 255 pour confirmer un champ). *(sortie : tests pass/fail)*
7. **Rapporter** : **faits / inférences / inconnus** + étapes reproductibles. *(sortie : rapport lié aux preuves)*

## Analyse statique vs dynamique
- **Statique** : sans exécution (désassemblage, décompilation, lecture de format) — large vue, imprécise sur pointeurs/chargement dynamique.
- **Dynamique** : sur l'exécution (traces, débogage) — concrète mais **incomplète**.
- **Combiner** les deux : statique (vue large) + dynamique (vérification ciblée).

## Outils par type de cible logicielle
| Cible | Outils | Ce qu'on capture |
|---|---|---|
| Binaire/librairie | `file`, `strings`, `sha256sum`, `objdump`, **Ghidra**, débogueur isolé | format, archi, imports, fonctions, call-graph, I/O |
| Fichier format inconnu | `xxd`, hex, `python struct`, échantillons connus | offsets, taille, endianness, valeurs, parser |
| Protocole | captures contrôlées, Wireshark | table des champs |
| App mobile (autorisée) | Android emulator, adb, JADX, OWASP MASTG | métadonnées, permissions, endpoints |

## Règles (logiciel)
- **Autorisation** (possédé / droit / licence) ; vérifier licences avant réutilisation/réimplémentation.
- **Pas de contournement** de protection sans droit ; **labo isolé** pour tout binaire non fiable.
- **Préserver l'original** + hash ; ne pas altérer la seule copie.
- **capable ≠ autorisé** : analyser ≠ pouvoir reproduire/distribuer.

## Vérifier (PASS = preuve)
- Artefact **préservé** (hash) et **autorisé** ; chaque observation a une **preuve**.
- Chaque fait confirmé par un **test reproductible** ; hypothèses non prouvées → `inférence`/`inconnu`.
- Rapport **faits / inférences / inconnus** + étapes reproductibles ; aucune modification de l'original.
