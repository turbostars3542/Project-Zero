# Rules (règles) — document de référence

> Gabarit **générique** des règles de conduite d'un projet, adapté à **tout type de projet**.
> Chaque règle porte un **ID unique** dont le **préfixe = la catégorie** : `RUL-<CATÉGORIE>-<NNNN>`
> (numéro unique **par catégorie**, chaque catégorie repart à `0001`).

## Règles

### RUL-PROJ — Respect du projet
- **RUL-PROJ-0001** : respecter les objectifs, exigences et contraintes des documents du projet.

### RUL-CHANGE — Changements
- **RUL-CHANGE-0001** : comprendre avant de modifier ; ne pas inventer ; préserver l'existant ;
  changements limités à la tâche.

### RUL-STRUC — Structure
- **RUL-STRUC-0001** : respecter `ARCHITECTURE.md` ; signaler tout changement structurel important.

### RUL-VAL — Validation
- **RUL-VAL-0001** : tout résultat doit être vérifié sur preuve (via meta/validation · meta/testing).

### RUL-SEC — Sécurité
- **RUL-SEC-0001** : pas de secret ; valider les entrées (voir `SECURITY.md`).

### RUL-DOC — Documentation
- **RUL-DOC-0001** : mettre à jour la doc et le changelog quand le comportement change.

---

> **Convention** : préfixe `RUL-` + code de catégorie + numéro unique **dans la catégorie**
> (chaque catégorie repart à `0001`). **Aucun plafond** : la largeur s'élargit naturellement.
> Nouvelles catégories ajoutables (`RUL-REVIEW-`, `RUL-COMM-`…) sans repartir de zéro.
