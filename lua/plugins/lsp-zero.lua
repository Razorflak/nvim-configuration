local function getLspConfiguration(configFiles)
	local ok, util = pcall(require, "lspconfig.util")
	if not ok then
		vim.notify("lspconfig.util could not be loaded")
		return {}
	end

	return {
		root_dir = util.root_pattern(unpack(configFiles)),
		--Eslint9
		experimental = {
			useFlatConfig = true,
		},
		workingDirectory = { mode = "auto" },
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
		"mfussenegger/nvim-dap",
		lazy = false,
		config = function()
			require("mason-nvim-dap").setup()
		end,
	},
	{
		"neovim/nvim-lspconfig",
		lazy = false,
		config = function()
			local capabilities = vim.lsp.protocol.make_client_capabilities()

			local lspconfig = require("lspconfig")

			-- Liste des serveurs LSP à configurer
			local servers = {
				"lua_ls", -- Lua Language Server
				"tailwindcss", -- Tailwind CSS
				"rust_analyzer", -- Rust Analyzer
				"svelte", -- Svelte Language Server
			}

			-- Configuration commune pour tous les serveurs
			for _, server in ipairs(servers) do
				lspconfig[server].setup({
					capabilities = capabilities,
				})
			end

			-- Config Biome
			lspconfig.biome.setup(getLspConfiguration({ "biome.jsonc" }))

			-- Config ESLint
			lspconfig.eslint.setup(getLspConfiguration({
				".eslintrc.js",
				".eslintrc.cjs",
				".eslintrc.yaml",
				".eslintrc.yml",
				"eslint.config.mjs",
				".eslintrc.json",
			}))

			-- Config TS Server (typescript-language-server dans Mason)
			lspconfig.ts_ls.setup({
				capabilities = capabilities,
				on_attach = function(client, bufnr)
					local function goto_source_definition()
						local params = vim.lsp.util.make_position_params()
						vim.lsp.buf.execute_command({
							command = "_typescript.goToSourceDefinition",
							arguments = { vim.api.nvim_buf_get_name(0), params.position },
						})
					end
					vim.keymap.set("n", "gds", goto_source_definition, { buffer = bufnr })

					local lsp_signature = require("lsp_signature")
					lsp_signature.on_attach({
						bind = true,
						handler_opts = {
							border = "rounded",
						},
					}, bufnr)
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
