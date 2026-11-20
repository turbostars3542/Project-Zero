---
name: network
description: Module Network — gestion et supervision du réseau : pare-feu default-deny, ports/exposition, services internes, VPN/tunnels, IPv4/IPv6. Bonnes pratiques de segmentation et moindre exposition.
family: technology
status: Verified
version: 0.1.0
role: Administrer et sécuriser le réseau : pare-feu, exposition minimale, services internes, tunnels — avec moindre privilège et défense en profondeur.
limites: Ne gère pas les secrets de tunnels (→ vault). Ne fait pas le monitoring de trafic (→ monitoring). Action disruptive → confirmation.
tools: [ ]
---

# network — procédure (module domaine)

## Objectif
Gérer le **réseau** de façon **sécurisée et minimaliste** : pare-feu **default-deny**, ne garder que les
ports/services nécessaires, exposer le moins possible, utiliser des tunnels pour l'accès distant.

## Quand l'utiliser
Module **optionnel** (Network) — quand un système expose des services ou accède à d'autres machines.

## Comment faire
1. **Pare-feu default-deny** : n'ouvrir que le nécessaire, et seulement aux sources nécessaires
   (IPv4 + IPv6). 
2. **Services internes** : écouter sur `127.0.0.1` ou le réseau privé (pas d'exposition publique inutile).
3. **Inventaire** : `ss -tlnp` → savoir ce qui écoute ; désactiver ce qui ne sert pas.
4. **Accès distant** : via tunnels/filaires (ex. Tailscale/ZeroTier/WireGuard) proposés **sans imposer**.
5. **Segmentation** : séparer les zones (si pertinent) ; **moindre exposition** par défaut.
6. **Sécurité** : clés de tunnel protégées (→ vault) ; pas de secret réseau en clair.
7. Action disruptive (changement de pare-feu, restart réseau) → **confirmation** (risque de coupure).

## Règles
- **Default-deny** : rien d'ouvert sans besoin réel ; sources restreintes.
- **Exposition minimale** : services internes non publics.
- **Tunnels** proposés proprement ; secrets protégés.
- **Réversibilité** : tout changement peut être annulé ; confirmation pour les coupsures potentielles.

## Vérifier (PASS = preuve)
- Pare-feu default-deny appliqué (IPv4+IPv6) ; seuls les ports nécessaires sont ouverts.
- Services internes non exposés publiquement ; inventaire des listeners.
- Aucun secret de réseau en clair ; accès distant via tunnel sécurisé.
