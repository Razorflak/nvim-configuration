vim.g.mapleader = " "
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)
vim.keymap.set("x", "<leader>p", [["_dP]])

-- Remap pour pouvoir copié facilement de nvim dans le press papier
vim.keymap.set({"n", "v"}, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])

-- supprime la sélection sans le garder dans le buffer
vim.keymap.set({"n", "v"}, "<leader>d", [["_d]])

-- En mode V, permet de déplacer la sélection vers le haut ou le bas
-- /!\ ca fait des trucs chelou ne fin ou début de fichier
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")

-- Remappage pour joindre la ligne actuelle avec la suivante et conserver le curseur à sa position
vim.keymap.set("n", "J", "mzJ`z")

-- Ajouter une ligne vide en mode normal
vim.keymap.set("n","<leader>o", "o<Esc>")
vim.keymap.set("n","<leader>O", "O<Esc>")

-- Remappages pour défilement en maintenant le contenu précédent visible
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- Remappages pour gérer le copier-coller en mode visuel
vim.keymap.set("x", "<leader>p", [["_dP]])

-- Remappages pour copier du texte en mode normal et en mode visuel
vim.keymap.set({"n", "v"}, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])

-- Remappage pour quitter le mode insertion avec <C-c>
vim.keymap.set("i", "<C-c>", "<Esc>")

-- Remappage pour désactiver la commande Q (sortir sans enregistrer)
vim.keymap.set("n", "Q", "<nop>")

-- Remappage pour exécuter une commande shell dans une nouvelle fenêtre tmux
vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")

-- Remappage pour formater le code en utilisant le langage server protocol (LSP)
vim.keymap.set("n", "<leader>f", vim.lsp.buf.format)

-- Remappages pour naviguer entre les erreurs et les avertissements du LSP
vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")
vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")

-- Remappage pour effectuer un remplacement global avec la sélection en mode normal
vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

-- ramapage pour les macros
vim.keymap.set("n", "<leader>q", "@q")
