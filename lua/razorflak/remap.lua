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
