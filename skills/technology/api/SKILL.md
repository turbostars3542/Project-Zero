---
name: api
description: Interface publique stable et versionnée (transport/contrats) pour CLI, Web UI, agents et modules — sans logique métier de domaine. Sources : Microsoft/OWASP/Home Office, NCSC. Ex.: API minimale d'un core.
family: technology
status: Verified
version: 0.1.0
role: Concevoir une API de transport/contrats (HTTP, versionnée, sécurisée) qui expose les capacités du core sans contenir de logique métier ni d'accès direct à la base de données.
limites: Ne contient pas la logique métier (→ core/services). N'accède pas directement à la base (→ persistence). Ne gère pas la sécurité d'accès seule (→ security).
tools: [ ]
---

# api — procédure

## Objectif
Exposer les capacités d'un core via une **API stable et versionnée**, servant de **transport/contrats** :
CLI, Web UI, agents et modules consomment cette surface, sans que l'API ne porte la logique métier.

## Quand l'utiliser
Quand on veut une **interface programme** sur un core (ex. M0.12 d'un service) — pour alimenter CLI/WebUI,
agents ou modules externes.

## Comment faire
1. **Modéliser la surface comme des contrats** : resources = **noms** (nouns), sous-commandes/actions =
   verbes HTTP. Ex. `GET /users`, `POST /users`, `GET /users/:id`.
2. **Versionner** la surface (`/v1/…`) : clients sélectionnent une **version majeure** ; un changement
   **cassant** → nouvelle version, on garde l'ancienne disponible. Stratégies : URI, header (`Api-Version`),
   query — choisir une et l'appliquer **partout**.
3. **Couche mince** : mapper `requête → service → réponse → type` ; aucune logique de domaine inline.
4. **Sécurité à la frontière** (chaque endpoint) : authentification + **autorisation** (moindre privilège,
   *deny by default*, valider les permissions à chaque requête). Jamais de logique d'auth côté client.
5. **Valider les entrées** en frontière (types, plages, content-type) ; **requêtes préparées** côté
   données (anti-injection SQL). Restreindre les méthodes HTTP à une **allowlist**.
6. **Aucun accès direct à la base** : toujours via les services/repositories (voir `persistence`).
7. **Stateless** : chaque requête porte ce qu'il faut (credentials, resource id, contexte). Cachability
   explicite (`Cache-Control`, `ETag`).
8. **Pas de secret** en réponse/erreur/logs.

## Règles
- **Transport ≠ métier** : l'API ne fait que transporter/appeler les services.
- **Versionnée et stable** ; les clients choisissent par **version majeure** seulement.
- **Aucun accès direct à la base** depuis l'API.
- **Sécurité par défaut** : auth + autorisation (deny by default, moindre privilège) + validation +
  pas de secret en clair. HTTPS obligatoire en transport.
- **Codes de statut corrects** (ex. 403 pour refus, 415 content-type, 405 méthode non autorisée).
- **Workflows** : valider les transitions d'état côté serveur (pas de dépendance au frontend).

## Vérifier (PASS = preuve)
- Contrats définis + versionnés ; endpoints testés (succès + erreurs + autorisation).
- Aucune logique métier dans la couche API ; aucun accès direct à la DB (traversée par les services).
- Authentification/authorisation vérifiées à chaque endpoint ; aucune fuite de secret en réponse/erreur.
- Méthodes HTTP restreintes ; entrées validées ; codes de statut corrects.
