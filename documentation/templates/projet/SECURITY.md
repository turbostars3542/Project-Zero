# Sécurité — {{N}}
> Politique de sécurité. Dernière mise à jour : {{DATE}}.

## 1. Principe fondamental
**capable ≠ autorisé** (et **tools ≠ permissions**) : déclarer un outil/capacité ne donne pas le droit de l'exécuter.
Autres principes : moindre privilège, défense en profondeur, **par défaut le refus** (fail-closed).

## 2. Modèle de décision
| Statut | Signification | Exécution |
|---|---|---|
| ALLOW | permission accordée | autorisée |
| NEED_CONFIRM | permission demandée / action humaine requise | **aucune exécution** sans confirmation |
| DENY | capacité non déclarée ou refusée | **jamais exécutée** |

## 3. Niveaux d'un outil
- read_only → lecture / diagnostic.
- mutate → écriture → **jamais auto**, confirmation.
- destructive → irréversible → **jamais auto + validation humaine**.

## 4. Mode par défaut
- **dry-run** par défaut (actions planifiées, non lancées) ; execute sous permission.
- Toute action destructive exige --confirm / confirmation humaine.
- **PASS = preuve** : un résultat non prouvé = NON VÉRIFIÉ.

## 5. Règles de sécurité (IDs)
Chaque règle porte un ID SEC-<CATÉGORIE>-<NNNN> (numéro par catégorie, repart à 0001).
### SEC-POL — Principes
- **SEC-POL-0001** : capable ≠ autorisé ; tools ≠ permissions.
- **SEC-POL-0002** : moindre privilège ; fail-closed (refus par défaut).
### SEC-ENV — Environnement
- **SEC-ENV-0001** : aucun secret en clair ; valider les entrées.
### SEC-EXE — Exécution
- **SEC-EXE-0001** : dry-run par défaut ; execute sous permission.
- **SEC-EXE-0002** : toute action destructive → confirmation humaine.
