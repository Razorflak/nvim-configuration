-- Installation de lazy si besoin
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

local local_path = vim.fn.stdpath("config") .. "/local.lua"
if vim.fn.filereadable(local_path) == 1 then
	_G.LocalConfig = dofile(local_path)
end

require("razorflak")
require("lazy").setup("plugins")
