return {
	{
		"mfussenegger/nvim-jdtls",
		ft = "java",
		dependencies = { "neovim/nvim-lspconfig", "mfussenegger/nvim-dap" },
		config = function()
			local jdtls = require("jdtls")
			local mason = vim.fn.stdpath("data") .. "/mason"
			local bundles = { mason .. "/share/java-debug-adapter/com.microsoft.java.debug.plugin.jar" }

			vim.lsp.config("jdtls", {
				cmd = function(dispatchers, config)
					local root = config.root_dir or vim.fn.getcwd()
					-- Le hash évite de partager l'index entre deux projets de même nom.
					local workspace = vim.fn.stdpath("cache") .. "/jdtls/" .. vim.fn.sha256(root)
					return vim.lsp.rpc.start({
						"jdtls",
						"-data",
						workspace,
						"-configuration",
						workspace .. "/config",
						"--jvm-arg=-javaagent:" .. mason .. "/share/jdtls/lombok.jar",
					}, dispatchers, { cwd = root })
				end,
				init_options = {
					bundles = bundles,
					extendedClientCapabilities = jdtls.extendedClientCapabilities,
				},
				on_attach = function(_, bufnr)
					jdtls.setup_dap({ hotcodereplace = "auto" })
					vim.keymap.set("n", "<leader>co", jdtls.organize_imports, {
						buffer = bufnr,
						desc = "Organize Java imports",
					})
				end,
			})
			vim.lsp.enable("jdtls")
		end,
	},
}
