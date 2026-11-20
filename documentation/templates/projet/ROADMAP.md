# ROADMAP — {{N}}

> **Le projet ne se construit pas d'un seul coup.** Il est construit par **micro-étapes** :
> chaque capacité fonctionne → est testée → documentée → sauvegardée → validée avant la suivante.
> Cycle obligatoire : `PLANIFIER → MODIFIER → TESTER → DOCUMENTER → BACKUP → VÉRIFIER → VALIDER → ÉTAPE SUIVANTE`.

---

## 0. Principes de construction
- **Construction progressive** : ne pas créer un fichier/capacité à l'avance sans raison réelle.
- **Micro-étapes** : petites capacités fonctionnelles indépendantes, chacune vérifiable avant la suite.
- **Pas d'autonomie prématurée** : on ajoute une capacité quand le besoin devient réel, jamais en avance.
- **Contrôle humain** : `AI propose → Humain décide → AI exécute → Tests → Backup → Humain valide`.

---

## 1. Vision du projet
```text
<FONCTIONNALITÉ 1>
    ↓ <FONCTIONNALITÉ 2>
    ↓ <FONCTIONNALITÉ 3>
    ↓ <…>
```
La complexité n'apparaît que lorsque le besoin devient réel.

---

## 2. État actuel

| Phase / capacité | Statut | Preuve |
|---|---|---|
| <P1 — première capacité> | En cours | <test / sortie réelle> |
| <…> | Proposé | — |

---

## 3. Prochaine micro-étape (en cours)
### Objectif de l'étape
<ce que doit faire la micro-étape>

### Décomposition
```text
<capacité visée>
    ↓ <micro-étape 1>
    ↓ <micro-étape 2>
    ↓ <micro-étape 3>
    ↓ <validation>
```

### Cycle à respecter
```text
PLANIFIER → MODIFIER → TESTER → DOCUMENTER → BACKUP → VÉRIFIER → VALIDER
```

---

## 4. Vérifier (PASS = preuve)
- Chaque micro-étape terminée a une **preuve** enregistrée ; sinon → `NON VÉRIFIÉ`.
- Aucune capacité ajoutée « à l'avance » sans besoin confirmé.
- L'état (§2) est mis à jour à chaque étape validée.
