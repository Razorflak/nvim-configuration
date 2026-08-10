vim.g.mapleader = " "
require("razorflak.set")

vim.keymap.set("n", "<leader>pv", vim.cmd.Ex, { desc = "Open file explorer" })
