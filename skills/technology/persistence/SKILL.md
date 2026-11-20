---
name: persistence
description: Persistance et abstraction de stockage — pattern Repository, SQLite via rusqlite (feature bundled), migrations versionnées, transactions, WAL, foreign_keys, fail-closed. Utilisé pour les cores de service.
family: technology
status: Verified
version: 0.1.0
role: Fournir une abstraction de persistance (Repository/SQLite) testable en mémoire, avec migrations, transactions et fail-closed, sans coupler les services au moteur concret.
limites: Ne rend pas de verdict de sécurité (→ security). Ne choisit pas seul le moteur (→ décision + DEPENDANCES). Ne fait pas la migration des données métier à la place des migrations versionnées.
tools: [ ]
---

# persistence — procédure

## Objectif
Ajouter une **persistance propre** à un core/service de manière **découplée** : les services parlent à
une **abstraction (trait Repository)**, le moteur concret (SQLite) reste derrière, donc testable en
mémoire et remplaçable. Sources de référence : rusqlite (crates.io), SQLite, rusqlite_migration.

## Quand l'utiliser
Dès qu'un service doit **stocker/recharger** de l'état (utilisateurs, rôles, sessions, tâches, config…)
et qu'on veut éviter de coupler la logique au moteur de base de données.

## Comment faire
1. Définir un **trait Repository** par domaine (ex. `UserRepository`, `RoleRepository`) dans les services.
2. Implémenter deux variantes : **InMemory** (tests / mode non persistant) et **SQLite** (persistant).
3. **SQLite (rusqlite)** : `rusqlite = { version = "…", features = ["bundled"] }` (compile SQLite embarqué,
   pas de dépendance système). Connexion dans un `Arc<Mutex<Connection>>` (send/sync partagé).
4. **PRAGMA à l'ouverture** : `journal_mode=WAL` (écritures ne bloquent pas les lectures), `foreign_keys=ON`,
   `busy_timeout` raisonnable (ex. 5000 ms). WAL est mémorisé dans le fichier mais on l'applique par défense.
5. **Migrations versionnées** : soit `rusqlite_migration` (utilise `user_version`), soit un vector de
   migrations avec table `schema_migrations`. Chaque migration s'applique **dans sa propre transaction** →
   un échec laisse l'état précédent committé et la migration est retentée au prochain démarrage.
6. **Transactions** : `Store::transaction` pour les opérations atomiques (ex. bootstrap, création Owner).
7. **Fail-closed** : si ouverture/vérification/migration échoue → **erreur**, **jamais** de basculement
   silencieux vers la mémoire. État `Failed`, pas de marche silencieuse.
8. Permissions fichier **sécurisées** (`0600` sur Unix).

## Exemple (SQLite + trait + migration)
```rust,ignore
trait UserRepository { fn find_by_id(&self, id: &UserId) -> Result<Option<User>, StoreError>; }
struct SqliteUserRepository { store: Store }   // impl UserRepository
struct InMemoryUserRepository;                  // impl UserRepository (tests)
// services reçoivent `&dyn UserRepository` — découplés du moteur

const MIGRATIONS: Migrations = Migrations::from_slice(&[
    M::up("CREATE TABLE users (id TEXT PRIMARY KEY, name TEXT NOT NULL);"),
    M::up("CREATE INDEX idx_users_name ON users(name);"),
]);
MIGRATIONS.to_latest(&mut conn)?;              // atomique
```

## Règles
- **Découplage** : les services ne connaissent pas le moteur, seulement les traits.
- **Migrations versionnées** obligatoires pour tout schéma en évolution ; jamais de `CREATE TABLE IF NOT EXISTS` en dur seul pour des évolutions.
- **Fail-closed** : jamais de bascule silencieuse vers la mémoire en cas d'échec.
- **Transactions** pour toute opération atomique/cohérente.
- **PRAGMA** : WAL + `foreign_keys=ON` + `busy_timeout` (défense en profondeur).
- **Sécurité** : permissions de fichier strictes ; pas de secret dans les logs.

## Vérifier (PASS = preuve)
- Tests en **InMemory** et **SQLite** passent ; migrations appliquées dans l'ordre (et test de validation
  `MIGRATIONS.validate()` si rusqlite_migration).
- Un échec de boot/migration → erreur (état `Failed`), **pas** de bascule silencieuse.
- Transactions atomiques testées (ex. bootstrap idempotent) ; WAL + foreign_keys actifs.
