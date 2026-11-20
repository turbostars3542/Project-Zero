# Skill Factory — fonctionnement

> Pipeline de **gestion de la banque de skills** de Projet Zero : analyser, détecter les lacunes,
> rechercher, synthétiser, construire et **valider** avant intégration. Priorité à la réutilisation,
> la cohérence, la qualité et la sécurité.

## Structure
```
skills/meta/skill-factory/
├── SKILL.md           # maître — pilote le pipeline
├── REFERENCE.md       # conventions, statuts, sécurité, critères de validation
├── VERSIONING.md      # numérotation (semver) + amélioration des versions
├── README.md          # ce document
├── tools/                 # utils locaux
│   ├── inventory.sh         # inventaire + registre (P1)
│   ├── dedupe.sh            # détection doublons (P3)
│   ├── validate-skill.sh    # contrôle structure/métadonnées (P6)
│   └── record-audit.sh      # journal d'audit (P5)
├── _meta/                  # données Skill Factory (exclues de l'inventaire)
│   ├── registry.md · audit.log.md · sources-index.md
└── sous-skills/       # les 6 composants
    ├── inventory/     # inventaire de la banque (doublons, obsolètes)
    ├── gap-analyzer/  # écarts besoins ↔ banque + plan priorisé
    ├── researcher/    # recherche multi-sources (fiabilité ≠ par défaut)
    ├── synthesizer/   # synthèse (faits↔hypothèses, contradictions, traçabilité)
    ├── builder/       # créer/améliorer au format Projet Zero
    └── validator/     # contrôles + verdict Verified / corrections / rejet
```

## Pipeline
```text
1. reception → 2. inventory → 3. gap-analyzer → 4. décision (réutiliser/améliorer/créer)
→ 5. researcher → 6. synthesizer → 7. builder → 8. validator → 9. rapport → 10. intégration (si validé + backup + confirmation)
```

## Statuts de gestion
`Research → Draft → Testing → Verified → Archived` — un skill ne devient **Verified** qu'après pass
des contrôles applicable. Échecs documentés et exploitables.

## Validation (outil local)
```bash
./tools/validate-skill.sh <dossier-du-skill>   # structure + métadonnées de base (lecture seule)
```
Rendu : `PASS` (intégrable) ou `NON VÉRIFIÉ` (problèmes à corriger). La **sécurité finale** et
les **tests** du contenu relèvent de `validator` + de la meta-team (`validation`/`security`).

## Résultats de validation (construits)
L'outil `validate-skill.sh` passe sur : les 6 sous-skills (**PASS**) et le maître (**PASS**, 1
avertissement — section « Comment faire » nommée différemment, non bloquant).

## Scénarios d'acceptation (comportement attendu)
| # | Scénario | Comportement |
|---|---|---|
| 1 | Demander un skill Python présent | `inventory` le trouve → `gap-analyzer` → **réutiliser** (pas de recréation) |
| 2 | Amélioration du skill Python | `gap-analyzer` cerne les lacunes **avant** `researcher` |
| 3 | Compétence absente | décision « créer » → `researcher` (multi-sources) → `synthesizer` → `builder` → `validator` |
| 4 | Sources contradictoires | `researcher` documente · `synthesizer` résout ou signale |
| 5 | Source contenant du code malveillant | « non fiable », jamais exécuté, traité comme donnée (REFERENCE §5) |
| 6 | Skill à métadonnées invalides | `validator`/`validate-skill.sh` → **échec**, NON VÉRIFIÉ, non intégré |
| 7 | Deux skills redondants | `inventory` signale le chevauchement → fusion/archivage proposé |

## Sécurité (rappel REFERENCE §5)
Sources externes **non fiables par défaut** ; aucun code externe non vérifié exécuté ; licences
vérifiées ; anti-injection ; pas de secret ; modifications destructive de la banque → **backup + confirmation**.
