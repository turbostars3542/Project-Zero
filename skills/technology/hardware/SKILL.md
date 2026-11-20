---
name: hardware
description: Module Hardware — supervision et gestion du matériel (CPU, RAM, disques, température, capteurs) : inventaire, seuils, alertes, santé. Aucun secret, moindre accès.
family: technology
status: Verified
version: 0.1.0
role: Superviser et inventorier le matériel (CPU/RAM/disques/température) : santé, seuils, alertes, moindre accès.
limites: Ne fait pas le monitoring global (→ monitoring). Ne gère pas le réseau (→ network). Pas d'accès matériel destructif sans confirmation.
tools: [ ]
---

# hardware — procédure (module domaine)

## Objectif
**Superviser et inventorier le matériel** (CPU, RAM, disques, température, capteurs) : connaître la **santé**,
déclencher des **alertes sur seuils**, avec **moindre accès** et **aucun secret**.

## Quand l'utiliser
Module **optionnel** (Hardware) — pour surveiller l'état physique d'une machine.

## Comment faire
1. **Inventaire** : CPU, RAM, disques, interfaces, capteurs ; état de santé de base.
2. **Collecte** : métriques matériel (utilisation, saturation, température, SMART disques) → alimenter `monitoring`.
3. **Seuils/alertes** : alerter sur **santé** (température, espace, SMART) — avec pending pour éviter le flapping.
4. **Moindre accès** : lecture des capteurs sans privilège inutile ; pas d'opération destructive sur le matériel.
5. **Aucun secret** dans la télémétrie matériel.
6. Action sensible (redémarrage, éjecter un disque) → **confirmation**.

## Règles
- **Inventaire + santé** matériel ; **seuils** actionnables (pas de bruit).
- **Moindre accès** : lire sans privilège excessif ; pas de secret.
- Action matérielle destructive/réversible → confirmation.

## Vérifier (PASS = preuve)
- Inventaire matériel (CPU/RAM/disques/capteurs) disponible et à jour.
- Métriques envoyées à monitoring avec seuils + pending ; pas de secret.
- Aucune opération destructive faite sans confirmation.
