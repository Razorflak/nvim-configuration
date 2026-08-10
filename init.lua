-- Installation de lazy si besoin
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
	local output = vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
	if vim.v.shell_error ~= 0 then
		error("Impossible d'installer lazy.nvim:\n" .. output)
	end
end
vim.opt.rtp:prepend(lazypath)

_G.LocalConfig = {}
local local_path = vim.fn.stdpath("config") .. "/local.lua"
if vim.fn.filereadable(local_path) == 1 then
	_G.LocalConfig = dofile(local_path)
end

require("razorflak")
require("lazy").setup("plugins")
