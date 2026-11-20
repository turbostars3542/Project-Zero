---
name: language
description: Compétence multi-langages (Python, Rust, C++, Bash, Go, Web [HTML/CSS/PHP/SQL/JS], Java-Mod Minecraft) — sections séparées, chacune avec démarrage, structure, aide-mémoire et PIÈGES FRÉQUENTS pour faire le moins d'erreurs possible.
role: Produire du code correct et testé dans LE langage requis, en évitant les bugs courants.
limites: Ne décide pas des bibliothèques (→ DEPENDANCES.md du superviseur). N'installe rien sans --confirm. Pas de skill git (→ backup).
tools: [ check-env, deps, list-installed ]
family: language
status: Verified
version: 0.3.0
---

# language — procédure (toutes les langues)

## Objectif
Écrire du code **correct et testé** dans le langage demandé, en évitant les erreurs courantes grâce à une fiche dédiée par langage (démarrage, structure, aide-mémoire, pièges, porte de validation).

## Comment faire
1. Repérer la **langue requise** (`DEPENDANCES.md` / le superviseur). 
2. Aller à la **section** correspondante ci-dessous. 
3. Suivre **démarrage → structure → codage → pièges évités**. 
4. Passer la **porte de validation** (PASS = preuve). Les `tools/` sont communs et prennent la langue en paramètre.

> Chaque langue a sa **section séparée** (retrouve-la via l'index ci-dessous).
> Dans chaque section : **démarrage** → **structure** → **aide-mémoire** → **pièges à éviter** → **porte de validation**.
> Les `tools/` prennent une **langue** : `check-env.sh <langue>`, `deps.sh … <langue> <projet>`,
> `list-installed.sh <projet>`.

## Index (pour trouver vite)
1. **Python** → uv/Ruff/mypy/pytest
2. **Rust** → cargo/clippy/rustfmt
3. **C++** (dont **Unreal Engine 5**) → g++/clang++/cmake
4. **Bash / automatisation** → bash + shellcheck
5. **Go** → go mod / gofmt / go vet / go test
6. **Web** → HTML + CSS + PHP (Composer/PDO) + SQL + JavaScript/TypeScript
7. **Java — Mod Minecraft** → Gradle / Fabric / NeoForge

## Règles communes (toutes langues)
- **Bibliothèques = le superviseur** : installer depuis `DEPENDANCES.md` (`deps.sh … --confirm`), jamais en vrac.
- **capable ≠ autorisé** : toute écriture/exécution → `Permissions → Policy → Risk` ; mutation → confirmation humaine.
- **PASS = preuve** : on n'a pas fini tant que lint + types + tests ne passent pas **sans avertissement**.
- **Micro-étapes** : petites briques, chacune testée et validée avant la suivante.
- Pas de skill **git** : la préservation des versions se fait par **`backup`**.

---

# 🐍 1. Python

## Démarrage (projet neuf)
```bash
uv init monprojet          # crée un projet (sans --package pour un script simple)
cd monprojet
uv add <bibliotheques>     # déclare ET verrouille (uv.lock)
uv add --dev pytest ruff mypy coverage   # outils de dev
```
> Toujours `uv run <commande>` — jamais activer le venv à la main.

## Structure type
```
src/monpak/
├── __init__.py
└── mon_module.py          # code, avec types annoncés
tests/
└── test_mon_module.py
pyproject.toml · uv.lock
```

## Aide-mémoire (commande → effet)
| Commande | Effet |
|---|---|
| `uv add pkg` | ajouter une dépendance |
| `uv add --dev pkg` | ajouter un outil de dev |
| `uv run python -m …` | exécuter dans le projet |
| `uv run ruff check .` | vérifier le style / erreurs |
| `uv run ruff format .` | formater |
| `uv run mypy src tests` | vérifier les types |
| `uv run pytest --cov` | lancer les tests + couverture |

## Pièges à éviter (importants)
- **Dépendance non déclarée** → toujours `uv add` (jamais de `pip install` direct) sinon `pyproject.toml`/`uv.lock` désynchronisés.
- **Argument mutable par défaut** : `def f(x=[])` = bug ⇒ écrire `def f(x=None)` puis `x = x or []`.
- **Imports circulaires** (A↔B) ⇒ restructurer, ou importer dans la fonction.
- **Code sans types** → échoue à `mypy strict` ⇒ typer les fonctions publiques.
- **Comparer des flottants** (`==`) ⇒ préférer une tolérance (`abs(a-b) < 1e-9`) ou `decimal`.

## Porte de validation (PASS)
`uv run ruff check .` · `uv run mypy src tests` → `Success` · `uv run pytest --cov` → `passed`. **Zéro avertissement.**

---

# 🦀 2. Rust

## Démarrage (projet neuf)
```bash
cargo new monprojet        # crée le projet (--lib si bibliothèque)
cd monprojet
cargo add <crate>          # ajoute une dépendance (met à jour Cargo.toml)
```

## Structure type
```
src/
├── main.rs                # (ou lib.rs pour une bibliothèque)
└── lib.rs · mod.rs …
Cargo.toml · Cargo.lock
tests/  (fichiers de test)
```

## Aide-mémoire (commande → effet)
| Commande | Effet |
|---|---|
| `cargo add pkg` | ajouter une dépendance |
| `cargo build` | compiler |
| `cargo run` | lancer |
| `cargo fmt --check` | vérifier le format |
| `cargo clippy -- -D warnings` | détecter les problèmes (sévère) |
| `cargo test` | lancer les tests |

## Pièges à éviter (importants)
- **Emprunt/ownership** : ne pas prêter une valeur qu'on a déjà déplacée ⇒ suivre les messages du *borrow checker*.
- **`unwrap()` partout** → peut planter à l'exécution ; préférer `?` et `Result/Option`.
- **`&str` vs `String`** : deux types différents, ne pas les confondre.
- **Ignorer les warnings de clippy** ⇒ imposer `-D warnings` pour qu'ils deviennent des erreurs.
- **Boucle infinie / grand `Vec`** → borner et vérifier la mémoire.

## Porte de validation (PASS)
`cargo fmt --check` · `cargo clippy -- -D warnings` → propre · `cargo test` → `passed`. **Zéro avertissement.**

### Rust avancé — Core système (core de service)
Pour un **core de service** (runtime, config, events, auth/RBAC, logs, persistence, tasks, scheduler, API/CLI) :

| Notion | Bonne pratique |
|---|---|
| **Structure** | `src/lib.rs` (bibliothèque) + `src/main.rs` (fin) ; noyau testable en `lib` |
| **Modules** | un `mod` par domaine (`auth/`, `log/`, `event/`, …), ré-exports publics via `lib.rs` |
| **Async** | `tokio` pour les tâches/temps réel (scheduler, workers) |
| **CLI** | `clap` (parser d'arguments), prompt **non-écho** pour secrets |
| **Persistence** | `rusqlite` (feature `bundled`) ; repository derrière un **trait** (testable en mémoire) |
| **Secrets** | `argon2` (mots de passe) ; jamais de secret dans logs/erreurs ; permissions fichier `0600` |
| **Events/Logs** | EventBus + Logger ; exclure les secrets du contexte |
| **Erreurs** | `?` et types d'erreur dédiés (`thiserror`) — jamais `unwrap()` dans le code de prod |

## Pièges (Core système — supplémentaires)
- **Séparer logique et transport** : le core ne doit pas connaître l'implémentation réseau/UI (contrats).
- **`unwrap()`/`expect()` en prod** ⇒ crash ; tout passer par `Result` (`?`) + erreurs typées.
- **Dépendances auto-téléchargées** sans validation ⇒ exiger un `Cargo.toml` contrôlé (aucune dep non validée).
- **Secret dans les logs** (mot de passe, token) ⇒ interdire ; purger si présent.
- **Tests** : `cargo test --all-targets` (lib + intégration) ; `-D warnings` pour fiabiliser.

## Porte de validation (PASS, Core système)
`cargo fmt --check` · `cargo clippy -- -D warnings` · `cargo test --all-targets` → `passed` · `cargo run` OK. **Zéro warning, aucun secret en clair.**

---

# 🖥️ 3. C++ (dont Unreal Engine 5)

## Démarrage (projet CMake)
```bash
cmake -S . -B build        # prépare le build
cmake --build build        # compile
ctest --test-dir build     # lance les tests
```
> UE5 : code dans `Source/<Projet>/`, compilation via l'éditeur / `Build.bat` (pas de CMake manuel).

## Structure type (CMake)
```
CMakeLists.txt
src/ (ou Source/<Projet>/ pour UE5)
tests/
```

## Aide-mémoire (commande → effet)
| Commande | Effet |
|---|---|
| `cmake -S . -B build` | préparer |
| `cmake --build build` | compiler |
| `ctest` | tests |
| *(UE5)* Build.bat | compiler le module UE5 |

## Pièges à éviter (importants)
- **Fuite mémoire** / pointeur brut ⇒ utiliser `std::unique_ptr` (pas de `new/delete` à la main).
- **Importer avant d'avoir déclaré** : `#include` et ordre de définition fautifs.
- **Comportement indéfini (UB)** : accéder hors d'un tableau, variable non initialisée ⇒ activer les **sanitizers** en dev.
- **UE5** : ne pas modifier les fichiers générés ; respecter la structure de `Source/`.
- **Libriries** : déclarer dans `CMakeLists.txt`/`vcpkg`/`Conan` (pas d'install automatique).

## Porte de validation (PASS)
Build **sans erreur ni warning** · `ctest` → `passed` · mémoire/UB contrôlés.

---

# 🐚 4. Bash / automatisation

## Démarrage (script)
```bash
#!/usr/bin/env bash
set -euo pipefail          # arrêt sur erreur + variables vides refusées
# <but du script>          # décrire en 1 ligne
```
> Tester à l'isole dans l'**environnement de test fermé** du superviseur (`test-env.sh`).

## Aide-mémoire (pratique)
| Motif | Effet / à éviter |
|---|---|
| `"$var"` entre guillemets | éviter la casse des espaces (toujours quoter) |
| `set -euo pipefail` | arrêt dès qu'une commande échoue |
| `if command -v x` … | vérifier qu'un outil existe avant de s'en servir |
| `shellcheck script.sh` | détecter les erreurs de script |

## Pièges à éviter (importants)
- **Oublier les guillemets** autour des variables → cassé si un chemin contient un espace.
- **Ignorer les échecs** → `set -e` arrête le script sinon il continue après une erreur.
- **`rm` / commandes destructives sans garde** → confinement + confirmation (voir `test-env.sh`).
- **Globbing surprise** (`*` sur des fichiers) → vérifier avant de traiter.

## Porte de validation (PASS)
`shellcheck script.sh` → `No issues found` · exécuté **dans un environnement de test fermé** avec le résultat attendu. **Zéro avertissement.**

---

# 〽️ 5. Go

## Démarrage (projet neuf)
```bash
go mod init <module>       # crée le module (module path = dépôt si publié, ex. github.com/user/monproj)
# écrire le code (main.go), puis…
go run .                   # compiler + lancer
```
> Contrairement à Node/Python : **pas besoin d'installer avant d'écrire le code**. On importe, et `go build` / `go run` résout la dépendance.

## Structure type (idiomatique)
- **Petit projet** : tout à la racine (`main.go`, `go.mod`, `go.sum`). Pas de `src/`.
- **Avec packages internes** : `internal/<pkg>/` (non importable hors module).
- **Multi-binaires** : `cmd/<app>/main.go` + `internal/<pkg>/` + assets à la racine.
- Préférer une hiérarchie **plate** (1-2 niveaux) et par **domaine** (ex. `internal/user/`, `internal/payement/`), pas par couche technique (`handlers/services/repos`).

## Aide-mémoire (commande → effet)
| Commande | Effet |
|---|---|
| `go mod init <path>` | initialiser le module (crée `go.mod`) |
| `go get <module>@version` | (dé)référencer une dépendance |
| `go mod tidy` | **nettoyer** `go.mod` (+ `go.sum`) — à faire avant de valider |
| `go build` / `go run .` | compiler / lancer |
| `go test ./...` | lancer les tests |
| `gofmt -l .` | lister les fichiers mal formatés |
| `go vet ./...` | détecter les erreurs de code suspectes |
| `go install <cmd>@latest` | installer un **outil** CLI (pas une dépendance) |

## Pièges à éviter (importants)
- **Surstructurer d'avance** (Java-itis) : en Go on commence **plat** (juste `main.go`) et on crée des packages quand le besoin est réel.
- **`go get` vs `go install`** : `go get` gère les dépendances du module (modifie `go.mod`/`go.sum`), `go install` installe un exécutable CLI. Ne pas les confondre.
- **Oublier `go mod tidy`** avant de valider → `go.mod`/`go.sum` désynchronisés du code.
- **Ignorer `go.sum`** : le **garder** (checksums d'intégrité), ne pas l'ajouter à `.gitignore`.
- **Imports circulaires** entre packages ⇒ définir une interface dans le package consommateur.
- **Trop de petits packages** ⇒ complexité + imports circulaires ; rester pragmatique.

## Porte de validation (PASS)
`gofmt -l .` → vide · `go vet ./...` → propre · `go test ./...` → `ok`. **Zéro avertissement.**

---

# 🌐 6. Web (HTML + CSS + PHP + SQL + JS/TS)

> Ces 5 vont **ensemble** pour un site complet. Les deux « pôles » : **frontend** (structure/style/JS) et **backend** (PHP + SQL).

## Démarrage (projet PHP moderne)
```bash
composer init             # crée composer.json
composer require <pkg>    # ajoute une dépendance
# code + PSR-4 autoload → public/index.php, et…
composer dump-autoload -o # optimise l'autoload (production)
```
> PHP moderne = **Composer** + **PDO** (requêtes préparées) + **PSR-4**. Pas de `require` écrits à la main.

## Structure type
```
public/            # fichiers accessibles (index.php)
app/ ou src/       # logique (MVC : Models/Controllers/Views)
config/ · routes/ · storage/
vendor/            # dépendances Composer (ne pas versionner à la main, généré)
composer.json · composer.lock
```

## Aide-mémoire (commande → effet)
| Commande / motif | Effet |
|---|---|
| `composer require pkg` | ajouter une dépendance |
| `composer install --no-dev --optimize-autoloader` | installer **en prod** depuis le lock |
| `$stmt = $pdo->prepare(...)` ; `$stmt->execute([...])` | requête **préparée** (anti-injection SQL) |
| `htmlspecialchars($x, ENT_QUOTES, 'UTF-8')` | échapper en sortie (anti-XSS) |
| `password_hash()` / `password_verify()` | hacher / vérifier les secrets de connexion (fonctions PHP — pas de secret réel en dur) |
| SQL `SELECT/INSERT/UPDATE/DELETE` | requêtes — toujours via placeholders |

## Pièges à éviter (importants)
- **Injections SQL** : **jamais** concaténer des entrées dans une requête. Toujours **requêtes préparées PDO** (placeholders `:x` / `?`). Configurer `PDO::ATTR_EMULATE_PREPARES=false`.
- **XSS** : ne pas jeter de l'entrée utilisateur directement dans le HTML ; **échapper en sortie** (`htmlspecialchars`), pas à l'entrée.
- **Secrets de connexion en clair / MD5/SHA-1** : toujours `password_hash()` / `password_verify()` — pas de secret réel ici, ce sont les fonctions PHP à utiliser.
- **`composer update` en production** : jamais — casserait la reproductibilité ; utiliser `composer install`.
- **Ne pas versionner `vendor/`** : c'est généré depuis `composer.json` + `composer.lock`.
- **HTML** : utiliser les **éléments sémantiques** (`header/main/section/article/nav/footer`…) pour la structure (accessibilité).
- **CSS** : rendre responsive ; éviter les styles globaux qui cassent le layout.
- **JS/TS** : valider les entrées ; échapper avant d'injecter dans le DOM (anti-XSS côté client).

## Porte de validation (PASS)
- PHP : `composer validate` OK · `composer install` → `lock` cohérent · `php -l` sur les fichiers · requêtes **préparées** uniquement (pas de concaténation SQL).
- Vérif. de sécurité : aucune injection SQL directe, aucun secret de connexion en clair, échappement HTML en sortie. **Zéro avertissement.**

---

# ⛏️ 7. Java — Mod Minecraft (Fabric / NeoForge)

> Modding Minecraft Java : deux loaders principaux — **Fabric** (léger, communautaire) et **NeoForge** (historique, riche en API). Les deux reposent sur **Gradle**.

## Démarrage (projet de mod)
```bash
# 1) Générer le projet via le générateur officiel (Fabric Template Generator / NeoForge Mod Generator)
#    (renseigner mod name, mod id, package, version Minecraft)
# 2) ouvrir le projet Gradle dans un IDE (IntelliJ + plugin Minecraft Development recommandé)
./gradlew build            # compiler le mod → build/libs/<monmod>-<version>.jar
./gradlew runClient        # lancer Minecraft avec le mod (tests)
```
> Toujours utiliser le **générateur** officiel (versions coordonnées). Ne pas tout écrire à la main.

## Structure type
```
src/main/java/<com.example.monmod>/   # code Java (package unique au mod)
src/main/resources/fabric.mod.json     # (Fabric) métadonnées du mod (id, version, entrypoints)
  ou src/main/resources/META-INF/neoforge.mods.toml   # (NeoForge)
build.gradle · gradle.properties · settings.gradle
```

## Aide-mémoire (commande → effet)
| Commande / notion | Effet |
|---|---|
| `./gradlew build` | compiler le mod → JAR dans `build/libs/` |
| `./gradlew runClient` | lancer le client de test |
| `fabric.mod.json` (`id`, `version`, `entrypoints`, `environment`) | décrire le mod (Fabric) |
| **DeferredRegister** (NeoForge) / registres | enregistrer blocks/items/entities (unique par nom) |
| **Mappings** (Mojang / Yarn / Parchment) | noms lisibles du code obfusqué du jeu |
| **Events** | réagir aux événements du jeu |

## Pièges à éviter (importants)
- **Package top-level non unique** → risque de crash au chargement. Utiliser un package **que tu possèdes** (ex. `com.github.toi.monmod`), qui matche ton group id.
- **Mod id et package partout** (`example-mod`) non remplacés → remplacer dans tous les chemins/fichiers (assets, `entrypoints`).
- **Ne pas enregistrer (registries)** un block/item/entity → le jeu « ne sait pas » qu'il existe (crash/comportement inexpliqué). Utiliser `DeferredRegister`.
- **Consulter un registre pendant son enregistrement** → pas sûr ; n'interroger qu'après.
- **Ne pas modifier les fichiers générés** par l'outillage ; respecter la structure `src/main/java` + `resources`.
- Pour du **multi-loader** (Fabric + NeoForge), envisager **Architectury API** (common + loader-spécifique), sinon dupliquer le code.

## Porte de validation (PASS)
`./gradlew build` → **SUCCESS** sans erreur · JAR produit dans `build/libs/` · le mod **se charge** au lancement (`runClient`) sans crash · registres cohérents. **Zéro avertissement.**

---

## Vérifier (général)
- La langue utilisée correspond à celle requise (via `DEPENDANCES.md` / le superviseur).
- Sa **porte de validation** est passée (zéro avertissement) → `PASS = preuve`.
- Toute installation tracée (`pyproject.toml`/`Cargo.lock`…) ; testé à l'isole si mutation.
