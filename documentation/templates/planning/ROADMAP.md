# ROADMAP — Phases, jalons et micro-étapes

> **Le projet n'est pas construit d'un seul coup.** Il est construit progressivement, par **petites
> capacités fonctionnelles indépendantes**. Chaque capacité doit fonctionner, être utilisée, testée,
> documentée, sauvegardée et validée avant d'ajouter la suivante.

---

## 1. Principes de construction

### 1.1 Construction progressive
- Ne pas créer à l'avance les fichiers futurs.
- Ne pas créer une architecture uniquement parce qu'elle pourrait être utile plus tard.
- Chaque fichier doit avoir une **raison réelle d'exister** au moment où il est créé.
- Les fonctionnalités futures restent **planifiées** dans cette roadmap, pas créées d'avance.
- Éviter toute complexité qui n'apporte pas encore de valeur.

### 1.2 Micro-étapes
Chaque fonctionnalité est divisée en **petites étapes indépendantes et ordonnées** :

```text
<Fonctionnalité 1>
    ↓
<Étape 1.1>
    ↓
<Étape 1.2>
    ↓
<Étape 1.3>
    ↓
<Validation>
```

Une fonctionnalité constitue une étape distincte ; on n'avance qu'une micro-étape à la fois.

### 1.3 Cycle obligatoire
Chaque micro-étape suit le cycle :

```text
PLANIFIER
↓
MODIFIER
↓
TESTER
↓
DOCUMENTER CE QUI A ÉTÉ FAIT
↓
BACKUP IMMÉDIAT
↓
VÉRIFIER
↓
VALIDER
↓
PASSER À L'ÉTAPE SUIVANTE
```

### 1.4 Backup obligatoire
Après chaque modification :
1. Effectuer immédiatement un backup.
2. Enregistrer ce qui a été modifié.
3. Identifier les fichiers touchés.
4. Enregistrer le résultat des tests.
5. Conserver les problèmes connus.
6. Vérifier que le backup est récupérable.

### 1.5 Contrôle humain
L'IA peut aider à : analyser · proposer · planifier · exécuter · tester · corriger · documenter.
Mais les **décisions importantes restent sous contrôle humain** :

```text
IA propose
↓
Humain décide
↓
IA exécute
↓
Tests
↓
Backup
↓
Humain valide
```

### 1.6 Pas d'autonomie prématurée
L'autonomie doit être **gagnée progressivement**. Ne jamais donner une capacité à l'IA simplement
parce qu'elle pourrait être utile plus tard.

---

## 2. Mission
- <l'objectif global>

---

## 3. Phases et sous-étapes ordonnées

### 3.1 Phases
| Phase | Objectif | Jalons / livrables | Statut |
|---|---|---|---|
| P1 | <objectif> | J1.1 · J1.2 | Proposé |
| P2 | <objectif> | J2.1 | Proposé |

### 3.2 Sous-étapes (ordre d'exécution)
Chaque phase est découpée en **sous-étapes numérotées dans l'ordre** (`P1.1`, `P1.2`, `P2.1`…).
On avance **une sous-étape à la fois, dans l'ordre, sans sauter**.

| Sous-étape | Phase | Description | Résultat attendu | Dépend de | Statut |
|---|---|---|---|---|---|
| P1.1 | P1 | <description> | <résultat> | — | Proposé |
| P1.2 | P1 | <description> | <résultat> | P1.1 | Confirmé |
| P2.1 | P2 | <description> | <résultat> | P1.2 | Inconnu |

---

## 4. Critère de validation par étape
Chaque fonctionnalité / phase définit un **critère de validation** mesurable :

- <ce qui doit être vrai quand l'étape est terminée (état final, pas la solution)>

---

## 5. Critère de fin d'une micro-étape
Une micro-étape est terminée **uniquement** si :
- fonctionnelle · testée · vérifiée · documentée
- backup effectué · modification enregistrée · problème connu consigné
- stable · compréhensible · compatible avec l'architecture actuelle

Ensuite seulement :

```text
→ MICRO-ÉTAPE SUIVANTE
```

---

## 6. Règle anti-overengineering
À chaque création, demander : **« Pourquoi avons-nous besoin de ceci maintenant ? »**
- Si la réponse est *« parce qu'on en aura probablement besoin plus tard »* → **NE PAS CRÉER**.
- Si la réponse est *« l'étape actuelle en dépend réellement »* → **CRÉER** (création minimale).

> Un fichier est créé lorsqu'une étape actuelle ou une dépendance immédiate **justifie réellement**
> son existence. La roadmap peut prévoir des documents futurs ; ils ne sont pas créés d'avance.

---

## 7. Réévaluation de la roadmap
À chaque grande capacité terminée :
- vérifier si la suite est toujours pertinente ; vérifier les contraintes, technologies et besoins réels ;
- supprimer les étapes devenues inutiles ; ajouter / réorganiser les étapes nécessaires ;
- une idée future ne devient pas automatiquement une priorité.

---

## 8. Priorité de construction

```text
FONCTIONNER
↓
UTILISER
↓
AMÉLIORER
↓
TESTER
↓
SÉCURISER
↓
AUTOMATISER
↓
ÉTENDRE
```

---

## 9. Avancement
- <phase / sous-étape en cours> — <progression> — Validé / En cours / Bloquant

---

## 10. Règle finale
> **Ne jamais construire aujourd'hui ce dont nous n'avons pas encore besoin.**
> **Prévoir l'avenir dans la roadmap, mais construire uniquement le présent.**
> **Chaque nouvelle capacité doit être petite, fonctionnelle, testée, documentée, sauvegardée et validée avant de continuer.**
>
> Le projet devient puissant par **accumulation de petites capacités fiables**, et non par une
> architecture gigantesque construite trop tôt.
