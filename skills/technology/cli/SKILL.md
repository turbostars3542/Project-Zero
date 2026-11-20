---
name: cli
description: Interface en ligne de commande sur les capacités d'un core — couche mince sur les services, clap, sous-commandes, stdout/stderr, exit codes, secrets via stdin/prompt non-écho. Sources : clig.dev, NCSC, clap.
family: technology
status: Verified
version: 0.1.0
role: Construire une CLI comme couche mince : parser d'arguments (clap), sous-commandes, prompt non-écho pour secrets, aucun accès direct à la base ni logique métier.
limites: Ne contient pas la logique métier (→ core/services). N'accède pas directement à la base (→ persistence). Ne gère pas l'auth complète (→ security/auth).
tools: [ ]
---

# cli — procédure

## Objectif
Fournir une **interface en ligne de commande** qui expose les capacités d'un core via des
**sous-commandes**, en restant une **couche mince** (parser + appels services), sans logique métier
ni accès direct à la base de données.

## Quand l'utiliser
Dès qu'un core a des capacités (auth, users, roles, tasks…) et qu'on veut une **interface utilisateur
locale** (ex. `mon-app status|init|login|whoami|user …`).

## Comment faire
1. **Parser d'arguments** : `clap` (derive) — sous-commandes via un enum, arguments typés (le compilateur
   garantit la validité), `--help`/`--version`.
2. **Couche mince** : chaque sous-commande → appel aux **services** du core (jamais de logique métier inline).
3. **Streams typés** : le **résultat/la donnée → stdout**, les logs/erreurs/prompts → **stderr**
   (piping propre et parsable).
4. **Exit codes** : `0` succès, non-zéro échec ; définir et documenter les codes (ex. `2` usage invalide,
   `3` auth/permission, `4` ressource introuvable).
5. **Secrets** (règle clig.dev/NCSC — ici explication, pas de secret réel) : **jamais en argument/flag**
   (ex. `--auth-file` plutôt qu'un flag portant la valeur ; car tout argument fuit dans `ps`/history) ni en
   **variable d'environnement** ; accepter via **stdin** ou fichier (chemin) ou **prompt non-écho**
   (désactiver l'écho ; activer seulement si stdin est un **TTY**). Fournir un équivalent non-interactif.
6. **Prompt/confirmation** : **seulement** si stdin est un TTY ; sinon échouer proprement et indiquer le flag.
   Actions destructives → confirmation (`--yes` / `--force` non-interactif).
7. **Aucun accès direct à la DB** : la CLI passe par les services/repositories (voir `persistence`).
8. **Erreurs claires** : 1 phrase lisible en haut, détails/internes sous `--verbose` ; pas de fuite de secret
   ni de chemin interne.

## Règles
- **Couche mince** : aucune logique métier ; pas de ré-implémentation de l'auth/RBAC/DB.
- **stdout = donnée, stderr = tout le reste.**
- **Secrets** jamais en argument, flag, ou env var ; via stdin/fichier/prompt non-écho (TTY).
- **Non-interactif possible** (scripts/CI/agents) : chaque prompt a un équivalent en flag.
- **capable ≠ autorisé** : exécuter via la chaîne de décision (policy/risk), pas de court-circuit.
- **Documenter** les commandes et les exit codes.

## Vérifier (PASS = preuve)
- Sous-commandes parsées et mappées aux services ; tests succès + erreurs + autorisation.
- Aucun secret en argument/log ; pas d'accès direct à la DB depuis la CLI.
- stdout vs stderr corrects ; exit codes cohérents (0 succès / 2 usage / 3 auth).
- Prompt désactivé hors TTY (+ `--no-input`/`--yes`) ; aide claire.
