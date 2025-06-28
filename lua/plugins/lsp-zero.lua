local function getBiomeConfiguration()
	local ok, util = pcall(require, "lspconfig.util")
	if not ok then
		vim.notify("lspconfig.util could not be loaded")
		return {}
	end

	vim.notify("jta biome")
	return {
		root_dir = util.root_pattern("biome.jsonc"),
		single_file_support = false,
	}
end

local function getEslintConfiguration()
	local ok, util = pcall(require, "lspconfig.util")
	if not ok then
		vim.notify("lspconfig.util could not be loaded")
		return {}
	end

	return {
		root_dir = util.root_pattern(
			".eslintrc.js",
			".eslintrc.cjs",
			".eslintrc.yaml",
			".eslintrc.yml",
			".eslintrc.json"
		),
		single_file_support = false,
	}
end

return {
	{
		"williamboman/mason.nvim",
		lazy = false,
		config = function()
			require("mason").setup()
		end,
	},
	{
		"neovim/nvim-lspconfig",
		lazy = false,
		config = function()
			local capabilities = vim.lsp.protocol.make_client_capabilities()

			local lspconfig = require("lspconfig")

			-- Config Biome
			lspconfig.biome.setup(getBiomeConfiguration())

			-- Config ESLint
			lspconfig.eslint.setup(getEslintConfiguration())

			-- Config TS Server (typescript-language-server dans Mason)
			lspconfig.ts_ls.setup({
				capabilities = capabilities,
				on_attach = function(client, bufnr)
					vim.notify("tsserver attached")
					local function goto_source_definition()
						local params = vim.lsp.util.make_position_params()
						vim.lsp.buf.execute_command({
							command = "_typescript.goToSourceDefinition",
							arguments = { vim.api.nvim_buf_get_name(0), params.position },
						})
					end
					vim.keymap.set("n", "gds", goto_source_definition, { buffer = bufnr })
				end,
				handlers = {
					["workspace/executeCommand"] = function(err, result, ctx)
						if ctx.params.command ~= "_typescript.goToSourceDefinition" then
							return
						end
						if result and #result > 0 then
							vim.lsp.util.jump_to_location(result[1], "utf-8")
						end
					end,
				},
			})

			-- Config Lua LS
			lspconfig.lua_ls.setup({
				capabilities = capabilities,
			})

			lspconfig.tailwindcss.setup({
				capabilities = capabilities,
			})

			-- Config Rust Analyzer
			lspconfig.rust_analyzer.setup({
				capabilities = capabilities,
			})

			-- Config Svelte LS
			lspconfig.svelte.setup({
				capabilities = capabilities,
				on_attach = function(client, bufnr)
					vim.notify("Svelte LSP attached")
					-- Ajoutez vos keymaps ou autres configurations spécifiques ici
				end,
			})

			-- Keymaps
			vim.keymap.set("n", "gD", vim.lsp.buf.type_definition, {})
			vim.keymap.set("n", "gd", function()
				vim.lsp.buf.definition()
				vim.defer_fn(function()
					vim.api.nvim_input("zz")
				end, 100)
			end, {})
			vim.keymap.set("n", "gdd", function()
				vim.lsp.buf.definition()
				vim.defer_fn(function()
					vim.api.nvim_input("zz")
				end, 100)
			end, {})
			vim.keymap.set("n", "gdv", function()
				vim.cmd("vsplit")
				vim.cmd("wincmd l")
				vim.lsp.buf.definition()
				vim.defer_fn(function()
					vim.api.nvim_input("zz")
				end, 100)
			end, {})

			-- Hover
			vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })
			vim.lsp.handlers["textDocument/signatureHelp"] =
				vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" })

			-- Diagnostics et code actions
			vim.keymap.set("n", "<leader>vws", vim.lsp.buf.workspace_symbol, {})
			vim.keymap.set("n", "<leader>vd", vim.diagnostic.open_float, {})
			vim.keymap.set("n", "<leader>ee", vim.diagnostic.goto_next, {})
			vim.keymap.set("n", "<leader>ez", vim.diagnostic.goto_prev, {})
			vim.keymap.set("n", "<leader>vca", vim.lsp.buf.code_action, {})
			vim.keymap.set("n", "<leader>vrn", vim.lsp.buf.rename, {})
			vim.keymap.set("i", "<C-h>", vim.lsp.buf.signature_help, {})
			vim.keymap.set("n", "<leader>f", vim.lsp.buf.format)

			-- Diagnostics
			vim.diagnostic.config({ virtual_text = { current_line = true } })

			-- Commande pour redémarrer LSP
			vim.api.nvim_create_user_command("LspStopStart", function()
				vim.cmd("LspStop")
				vim.defer_fn(function()
					vim.cmd("LspStart")
				end, 500)
			end, {})
		end,
	},
}
