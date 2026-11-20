---
name: monitoring
description: Module Monitoring/observabilité — métriques, logs, traces, alertes, dashboards. Alertes centrées symptômes (RED/USE/SLO), seuils avec pending, pas de secret. Sources : Grafana, Prometheus, SRE/Google, Microsoft Well-Architected.
family: technology
status: Verified
version: 0.2.0
role: Assurer l'observabilité (métriques/logs/traces) et des alertes actionnables : collecter, stocker, visualiser, alerter — sans fuite de secret.
limites: Ne gère pas les secrets (→ vault). Ne fait pas la rétention/traitement lourd (→ storage). Les alertes restent humaines/actionnables (pas d'automatisme destructif sans porte).
tools: [ ]
---

# monitoring — procédure (observabilité)

## Objectif
Assurer l'**observabilité** (métriques, logs, traces) et des **alertes actionnables**, pour diagnostiquer
rapidement, sans exposer de secret.

## Modèle d'observabilité (concepts distincts)
> Garder **distincts** ces quatre concepts ; ne pas les fusionner sans raison (principe §1) :
| Concept | Définition | Exemple |
|---|---|---|
| **Log** | enregistrement d'une information | `msg="auth ok" user=abc` |
| **Événement** | quelque chose qui s'est produit | `user.created`, `task.state=Running` |
| **Alerte** | événement nécessitant potentiellement une intervention | `disque > 90 %` |
| **Action** | réponse effectuée par le système/l'admin | `rollback`, `restart`, notification |

- Un **log** n'est pas forcément un événement ; un **événement** peut déclencher une **alerte** ; une
  **action** est une réponse (pas un signal). Les modéliser séparément évite les dépendances circulaires.

## Quand l'utiliser
Module **optionnel** (Monitoring) — dès qu'un système doit être observable et produire des alertes fiables.

## Comment faire
### 1. Télémétrie structurée
- Capturer **métriques** (tendances: latence, erreurs, charge), **logs** (diagnostic) et **traces**
  (transactions) de façon **structurée** (JSON/MessagePack) et cohérente (schéma + corrélation IDs).
- **Instrumenter tout** (Prometheus : au moins quelques métriques par service).

### 2. Collecte
- Modèle **pull** (scraping local) et/ou **push** (émission d'événements) ; consolider dans un dépôt central ;
  formater de façon cohérente.

### 3. Dashboards (USE / RED)
- **USE** (matériel) : Utilisation, Saturation, Erreurs.
- **RED** (services/expérience) : Rate, Erreurs, Duration.
- Alertes sur **symptômes** (RED) ; dashboards lisibles et paramétrés.

### 4. Alertes
- Alerter sur **symptômes utilisateur** d'abord ; infra = support (canal non-pageant).
- **Seuils lissés** (window) : `avg_over_time` plutôt que valeur brute ; **pending period** pour éviter le flapping.
- **Percentiles** (p95) pour latence ; regrouper les cascades ; **keep_firing_for**.
- Chaque alerte : **propriétaire**, pourquoi/quoi/comment investiguer, lien runbook.

### 5. Sécurité
- **Aucun secret** dans métriques/logs/traces/dashboards ; valider avant publication.
- Alerte = indicateur, pas automatisme destructif sans porte humaine.

## Règles
- **Télémétrie structurée** + cohérente ; corrélation (request/trace IDs).
- **Alertes = symptômes**, actionnables, propriétaires, sans flapping (pending/window).
- **Pas de secret** ; verbosité ajustable (détaillée en dev, réduite en prod).

## Vérifier (PASS = preuve)
- Métriques/logs/traces capturés et consultables ; dashboards USE/RED utiles.
- Alertes actionnables, propriétaires, sans secret, avec pending pour éviter le flapping.
- Aucun secret exposé dans la télémétrie.
