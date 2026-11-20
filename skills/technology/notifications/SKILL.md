---
name: notifications
description: Module Notifications — émission de notifications externes (email, webhook, messagerie) de façon contrôlée : canaux, format, fréquence, secrets de canal, sans spam ni fuite.
family: technology
status: Verified
version: 0.1.0
role: Envoyer des notifications externes (alertes, rapports) via des canaux contrôlés, de façon fiable et sans secret ni sur-notification.
limites: Ne génère pas les alertes (→ monitoring/audit). Ne gère pas les secrets de canal (→ vault). Ne décide pas seul des destinataires (→ policy/risk).
tools: [ ]
---

# notifications — procédure (module domaine)

## Objectif
Envoyer des **notifications externes** (alertes, rapports, événements) via des **canaux contrôlés**
(email, webhook, messagerie), de façon **fiable, actionnable et sans fuite de secret**.

## Quand l'utiliser
Module **optionnel** (Notifications) — quand un système doit prévenir des humains/services externes.

## Comment faire
1. **Définir les canaux** autorisés (email, webhook, Slack/Teams, etc.) selon la politique (→ policy/risk).
2. **Contenu limité** : ne notifier que ce qui est actionnable ; éviter le spam ; grouper les notifications.
3. **Pas de secret** dans le contenu (token, mot de passe, lien compromettant) — jamais.
4. **Secrets de canal** (clé webhook, SMTP) via `vault` (→ vault), pas en dur.
5. **Fiabilité** : retry, délai, et éviter les notifications redondantes (regrouper, `keep_firing_for`).
6. **Destinataires** : les plus restrictifs nécessaires ; préférence canal non perturbant pour l'infra.
7. **Traçabilité** : log d'envoi (sans secret) pour audit.

## Règles
- **Actionnable** ; **sans spam** ; **grouper** les notifications redondantes.
- **Aucun secret** dans le contenu ni dans les logs d'envoi.
- **Secrets de canal** via `vault` ; destinataires moindre privilège.
- **Retry/fiabilité** maîtrisés ; pas d'envoi non contrôlé sans porte.

## Vérifier (PASS = preuve)
- Canaux autorisés + destinataires minimaux ; contenu actionnable, sans spam.
- Aucun secret dans les notifications ni logs ; clés via vault.
- Tests d'envoi (succès + échec + retry) ; pas de notification redondante inutile.
