# Java

La configuration principale charge `nvim-jdtls` à l'ouverture d'un fichier Java.
Mason installe `jdtls` et `java-debug-adapter`. Treesitter installe
le parser Java. Chaque projet a son propre index dans le cache Neovim.

Le JDK nécessaire au serveur dépend de la version JDT LS installée. Le JDK du
projet peut être différent ; il se règle avec `java.configuration.runtimes`
dans les paramètres JDT LS ou avec `:JdtSetRuntime`.

- Navigation, renommage et actions : raccourcis LSP habituels.
- Formatage : `<leader>f` et à la sauvegarde via JDT LS.
- Imports : `<leader>co`.
- Debug : `<leader>jb` pour un breakpoint, `<leader>jc` pour lancer/continuer,
  puis les raccourcis DAP habituels. Les classes principales sont détectées
  au lancement du debug.
- Tests JUnit : lancer `:NeotestJava setup` une fois pour installer le lanceur,
  puis `<leader>tt` (fichier), `<leader>tr` (test proche), `<leader>td` (debug),
  `<leader>ts` (panneau). Maven/Gradle et les dépendances restent ceux du projet.

Après la première installation des outils Mason, rouvrir Neovim si un fichier
Java était déjà ouvert. Le premier import du projet peut prendre du temps.
Diagnostic : `:checkhealth vim.lsp`, `:checkhealth neotest-java`, `:JdtShowLogs`.

Vérification de la configuration : `nvim --clean -l tests/java.lua` depuis ce dossier.
