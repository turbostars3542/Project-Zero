# DEPENDANCES — {{N}}

> **Déterminé par le superviseur-de-projet** : il y écrit **quels skills** le projet a besoin
> et **quelles bibliothèques** ces skills utiliseront. Les skills s'**activent** ; les bibliothèques
> s'**installent** (après confirmation, `deps.sh install --confirm`).
> Format : `<nom> : <raison>` (une par ligne). Lignes `#...` ou vides ignorées.

## Skills requis (quels skills activer)
```text
# <skill> : <pourquoi il est nécessaire>
meta/superviseur-de-projet      : supervision (toujours actif)
language                       : développement (Python, Rust, C++, Bash)
```

## Bibliothèques autorisées (à installer, par skill)
```text
# <paquet> : <raison>   (pour le skill concerné)
requests   : requêtes HTTP          (skill: language)
tokio      : async runtime          (skill: language)
```

## Règles
- Le superviseur décide **quels skills** et **quelles bibliothèques** ; les skills ne les modifient pas seuls.
- Une bibliothèque doit être **déclarée ici avant** d'être utilisée (`pyproject.toml` à jour).
- Toute installation passe la **porte humaine** (`deps.sh install --confirm`) + `Policy → Risk`.
