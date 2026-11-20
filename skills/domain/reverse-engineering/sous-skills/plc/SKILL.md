---
name: reverse-engineering-plc
description: Sous-skill de rétro-ingénierie — type INDUSTRIEL (PLC/automates) : analyser, reconstruire et moderniser des programmes d'automates multimarques (Siemens, Rockwell, Schneider, CODESYS…), langages IEC 61131-3, formats projets, migration, simulation et validation. Suivre le maître reverse-engineering.
family: domain
status: Verified
version: 0.1.0
role: Analyser et reconstruire des programmes PLC : formats projets constructeurs, langages IEC 61131-3, logique de commande, dépendances/incohérences, migration, simulation et validation avant mise en service.
limites: Ne modifie pas le système industriel réel sans procédure. Autorisation de l'opérateur requise. Ne contourne pas les protections. Sécurité OT = priorité absolue. Suivre la méthodologie générale du maître reverse-engineering.
tools: [ ]
---

# reverse-engineering — sous-skill industriel (PLC / automates)

> Suivre d'abord le **maître `reverse-engineering`** (workflow 7 étapes, règles, cadre légal). Ce sous-skill
> couvre les **particularités industrielles** (PLC multimarque, IEC 61131-3, migration, simulation).

## Objectif
Analyser, **reconstruire et moderniser** des **programmes d'automates industriels (PLC)** de différents
constructeurs : reconstruire la logique de commande, détecter dépendances/incohérences, préparer des
**migrations**, générer des livrables (programmes, rapports, listes I/O, documentation), et **simuler/valider**
avant toute mise en service. **Sécurité industrielle (OT)** en priorité.

## Quand l'utiliser
Pour tout travail de rétro-ingénierie / migration / modernisation d'automates (axe D de la vision) :
analyse de projets existants, reconstruction de logique, préparation de migration, validation.

## Comment faire
### 1. Cadrer & autoriser
- Confirmer **l'autorisation de l'opérateur** ; identifier **constructeur, matériel, versions, langages**, et le **périmètre** (migration ? analyse seule ?).

### 2. Récupérer / préserver le projet
- Obtenir une **copie du projet / export** (et les docs, schémas, I/O) ; ne **jamais modifier l'original** ; hasher + sauvegarder.
- Formats courants par constructeur :
  - **Rockwell** : `.L5X` (export) / `.ACD` (propriétaire, partiel).
  - **Siemens** : TIA Portal **Openness / SimaticML** (`.xml`), Step 7 `.awl`/`.scl` (STL/SCL) ; `.apXX` (propriétaire, export requis).
  - **CODESYS / Beckhoff / autres PLCopen** : **PLCopen XML** (TC6), export requis.
  - **Schneider** : EcoStruxure Control Engineering (conversion via langage neutre).
> Les formats **propriétaires non documentés** → demander l'**export** dans un format lisible (PLCopen XML, SimaticML, L5X), ne pas tenter de les parser à l'aveugle.

### 3. Trier / identifier
- Déterminer : **constructeur/IDE**, **langages utilisés**, version firmware, structure (tasks, POU, tags, I/O).
- Outils : **plcinfo** (analyse + diff de projets PLC : Rockwell, Siemens, CODESYS/Bechhoff) ; Detect-It-Easy pour binaires ; comparateurs de version.
- Sortie : **inventaire** des blocs/POU/tags/tasks/IO + preuves.

### 4. Reconstruire la logique de commande
- Langages **IEC 61131-3** (Edition actuelle) :
  - **LD** (Schéma à contacts) — logique booléenne/relais ;
  - **ST** (Texte structuré) — logique impérative/modernes ;
  - **FBD** (Blocs fonction) — contrôle d'équipement ;
  - **SFC** (Grafcet) — contrôle de **séquences/états**.
  - *(IL obsolète — retiré de l'édition 2025, surtout maintenance legacy.)*
- Modéliser : **mémoire/org** (variables, points, registres), **types** (simples, structures, enum, FB), **bibliothèques système**, **structure applicative** (tasks, POU), entrées-sorties & interlocks.
- **Détecter** : dépendances, variables non documentées, incohérences, chemins non couverts.

### 5. Migration / modernisation
- 3 approches : **garder tel quel** / **réécrire à neuf** / **migrer le code existant** vers la cible.
- Convertir via un **langage neutre / plateforme-indépendant** quand possible (ex. approche Schneider GLIPS, Siemens Migration Studio) ; **manuellement ajuster** là où l'outil l'indique.
- Préserver les **schémas, noms, structure** pour la familiarité ; gérer différences de librairies/timing.

### 6. Simuler & valider AVANT mise en service
- **Simulation** du nouveau programme ; comparer comportement attendu (logique source) ↔ cible.
- **Vérification indépendante** (voir `verification-after-action`), critères de validation, **test** (voir `testing`/`validation`).
- Séquences d'entrées-sorties, délais, interlocks, états de démarrage/arrêt.
- **Aucune mise en service** sans validation réussie + protection OT.

## Règles (sécurité industrielle / OT)
- **Autorisation opérateur** ; ne toucher au **système réel** que via procédure validée.
- **Sécurité OT renforcée** : pas d'accès LLM direct au PLC ; **dry-run** ; tout changement → confirmation.
- **Ne contourner** ni protège-matériel, ni verrou, ni secret ; respecter les licences et la propriété intellectuelle.
- **Formats propriétaires** : utiliser les **exports** documentés, pas de reverse-engineering du format à l'aveugle sans besoin.
- **Validation avant mise en service** : simulation + tests + preuve.

## Vérifier (PASS = preuve)
- Projet **récupéré + préservé** (hash) ; autorisation **explicite** de l'opérateur.
- Logique reconstruite (modèle) + **dépendances/incohérences détectées** documentées.
- Migration préparée (langage neutre ou export documenté) ; **simulation** reproduit le comportement attendu.
- Aucune mise en service sans **validation réussie** + sécurités OT respectées.
