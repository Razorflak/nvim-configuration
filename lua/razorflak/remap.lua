vim.g.mapleader = " "
-- vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)
vim.keymap.set("n", "<leader>pv", "<CMD>Oil<CR>", { desc = "Open parent directory" })
vim.keymap.set("x", "<leader>p", [["_dP]])

-- keymap pour pouvoir copié facilement de nvim dans le press papier
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])

-- supprime la sélection sans le garder dans le buffer
vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]])

-- En mode V, permet de déplacer la sélection vers le haut ou le bas
-- /!\ ca fait des trucs chelou ne fin ou début de fichier
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")

-- Remappage pour joindre la ligne actuelle avec la suivante et conserver le curseur à sa position
vim.keymap.set("n", "J", "mzJ`z")

-- Ajouter une ligne vide en mode normal
-- C'est con car ça va aussi vite de faire "O <Esc>" mais j'aime bien
vim.keymap.set("n", "<leader>o", "o<Esc>")
vim.keymap.set("n", "<leader>O", "O<Esc>")

-- Remappages pour défilement en maintenant le contenu précédent visible
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- Remappages pour gérer le copier-coller en mode visuel
vim.keymap.set("x", "<leader>p", [["_dP]])

-- Remappages pour copier du texte en mode normal et en mode visuel
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])

-- Remappage pour quitter le mode insertion avec <C-c>
vim.keymap.set("i", "<C-c>", "<Esc>")

-- Remappage pour désactiver la commande Q (sortir sans enregistrer)
vim.keymap.set("n", "Q", "<nop>")

-- Remappage pour exécuter une commande shell dans une nouvelle fenêtre tmux
vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")

-- Remappage pour effectuer un remplacement global avec la sélection en mode normal
vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
vim.keymap.set("v", "<leader>s", [[y:%s/<C-r>"//gI<Left><Left><Left>]])

-- Recherche sur la sélection visuel dans le fichier
vim.keymap.set("v", "<leader>vs", [[y/<C-r>"]])

-- ramapage pour les macros
vim.keymap.set("n", "<leader>q", "@q")

vim.api.nvim_set_keymap("n", "<C-l>", "", { noremap = true, silent = true })

-- Terminal remap

vim.keymap.set("t", "<C-h>", "<C-\\><C-N><C-w>h", t_opts)
vim.keymap.set("t", "<C-j>", "<C-\\><C-N><C-w>j", t_opts)
vim.keymap.set("t", "<C-k>", "<C-\\><C-N><C-w>k", t_opts)
vim.keymap.set("t", "<C-l>", "<C-\\><C-N><C-w>l", t_opts)
-- Redimensionner horizontalement
vim.keymap.set("n", "<A-l>", ":vertical resize +1<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<A-h>", ":vertical resize -1<CR>", { noremap = true, silent = true })

-- Redimensionner verticalement
vim.keymap.set("n", "<A-k>", ":resize +1<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<A-j>", ":resize -1<CR>", { noremap = true, silent = true })

-- Déactive la surbrillance de recherche quand on appuis sur Esc
vim.api.nvim_set_keymap("n", "<Esc>", ":noh<CR>", { noremap = true, silent = true })

-- Mappe <leader>y pour copier le chemin absolu du fichier courant dans le clipboard système
vim.api.nvim_set_keymap("n", "<leader>z", [[:let @+ = expand('%:p')<CR>]], { noremap = true, silent = true })

-- Obsidian
--
-- 📁 Répertoire principal de tes notes Obsidian
local obsidian_notes = "/Users/julien_tanguy2/Google Drive/Mon Drive/Obsidian-vault/work"

-- 🔍 Rechercher un fichier dans les notes
vim.keymap.set("n", "<leader>nfs", function()
	require("telescope.builtin").find_files({
		search_dirs = { obsidian_notes },
		default_text = "", -- tu peux mettre un mot-clé ici pour démarrer direct
		additional_args = function()
			return { "--no-ignore", "--hidden" }
		end,
		path_display = { "smart" },
	})
end)

-- 🔎 Faire une recherche texte dans les notes
vim.keymap.set("n", "<leader>nfg", function()
	require("telescope.builtin").live_grep({
		search_dirs = { obsidian_notes },
	})
end)
