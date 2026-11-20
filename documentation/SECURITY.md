# SECURITY — règles de sécurité pour créer un skill

> Référence unique des règles de sécurité à appliquer à **chaque skill** et **gabarit**.
> Un skill bien conçu est sécurisé **dès la conception**, pas après coup.

---

## 1. Capable ≠ autorisé
- Un skill peut **savoir faire** une chose, mais cela ne signifie pas qu'il a le **droit** de la faire.
- Une **action destructive** ne s'exécute **jamais automatiquement** : elle exige une **confirmation humaine** explicite.
- Le code/script peut contenir l'action, mais il **bloque** tant que la confirmation n'est pas donnée.

## 2. Actions par niveau de risque
| Niveau | Exemple | Règle |
|---|---|---|
| **Lecture seule** (`list`, `read`) | lister des snapshots | ✅ auto |
| **Écriture** (`create`, `write`) | créer un snapshot | ⚠️ fait le job ; confirmation selon le contexte |
| **Destructif** (`delete`, `restore`, `write` irréversible) | restaurer, supprimer | 🛑 **JAMAIS auto** : exige `--confirm` / validation humaine |

## 3. Anti-traversal (chemins)
- Tout chemin construit à partir d'une **entrée utilisateur/IA** doit être **confiné**.
- Refuser les chemins contenant `..` ou qui sortent d'un dossier dédié (ex. `.backups/`).
- Ne jamais écrire/lire **hors du périmètre** déclaré du skill.

## 4. Pas de secret dans le skill
- **Aucun mot de passe, jeton, clé** ne doit être écrit dans `SKILL.md`, les scripts ni les docs.
- Les secrets (`.env`, config) restent **hors du skill** et ne sont jamais logués.

## 5. Vérification = preuve (PASS)
- Un résultat n'est déclaré **réussi que sur preuve réelle** (ex. hash, sortie d'exécution), jamais sur inspection visuelle.
- Séparer **PROUVÉ** de **NON VÉRIFIÉ** ; signaler la limite si un contrôle ne peut pas être exécuté.

## 6. Validation humaine pour les actions sensibles
- Toute action **destructive** ou **hors périmètre** s'arrête et **demande la confirmation humaine** avant d'agir.
- Ne jamais **contourner** le mécanisme d'autorisation pour « finir plus vite ».

## 7. Permissions minimales
- Un skill ne demande/monte que le **nécessaire** à son rôle.
- Pas d'outil, de script ou d'accès inutile « au cas où ».

## 8. Exclusions d'exécution
- Ne pas traiter/copier les caches et artefactes inutiles : `__pycache__`, `.venv`, `venv`, `node_modules`, `.git`, `.backups/` (dans un copy), etc.

---

## Résumé à appliquer à chaque skill
- [ ] Lecture = auto ; écriture = contrôlée ; destruction = **confirmation obligatoire**.
- [ ] `capable ≠ autorisé` : le script sait faire mais **bloque** sans confirmation.
- [ ] **Anti-traversal** : chemins confinés, `..` refusé.
- [ ] **Aucun secret** présent dans le skill.
- [ ] **PASS = preuve** réelle (hash / sortie), sinon NON VÉRIFIÉ.
- [ ] **Validation humaine** pour toute action sensible.
- [ ] **Permissions minimales** (que le nécessaire).
- [ ] **Exclusions** respectées (caches, etc.).

> Référence : ce fichier est le modèle de sécurité hérité du Projet Zero. À référencer dans `SKILL_TEMPLATE.md` et à appliquer à chaque skill créé.
