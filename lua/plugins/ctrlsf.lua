return {
	"dyng/ctrlsf.vim",
	lazy = true, -- Active le chargement différé
	cmd = { "CtrlSFOpen", "CtrlSFToggle" }, -- Charge le plugin uniquement lorsque ces commandes sont utilisées
	config = function()
		vim.g.ctrlsf_mapping = {
			close = "Q",
		}
	end,
}
