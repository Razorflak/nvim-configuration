return {
	{
		"mfussenegger/nvim-dap",
		recommended = true,
		desc = "Debugging support. Requires language specific adapters to be configured. (see lang extras)",

		dependencies = {
			"rcarriga/nvim-dap-ui",
			-- virtual text for the debugger
			{
				"theHamsta/nvim-dap-virtual-text",
				opts = {},
			},
		},

  -- stylua: ignore
  keys = {
    { "<leader>jB", function() require("dap").set_breakpoint(vim.fn.input('Breakpoint condition: ')) end, desc = "Breakpoint Condition" },
    { "<leader>jb", function() require("dap").toggle_breakpoint() end, desc = "Toggle Breakpoint" },
    { "<leader>jc", function() require("dap").continue() end, desc = "Run/Continue" },
    { "<leader>ja", function() require("dap").continue({ before = get_args }) end, desc = "Run with Args" },
    { "<leader>jC", function() require("dap").run_to_cursor() end, desc = "Run to Cursor" },
    { "<leader>jg", function() require("dap").goto_() end, desc = "Go to Line (No Execute)" },
    { "<leader>ji", function() require("dap").step_into() end, desc = "Step Into" },
    { "<leader>jj", function() require("dap").down() end, desc = "Down" },
    { "<leader>jk", function() require("dap").up() end, desc = "Up" },
    { "<leader>jl", function() require("dap").run_last() end, desc = "Run Last" },
    { "<leader>jo", function() require("dap").step_out() end, desc = "Step Out" },
    { "<leader>jO", function() require("dap").step_over() end, desc = "Step Over" },
    { "<leader>jP", function() require("dap").pause() end, desc = "Pause" },
    { "<leader>jr", function() require("dap").repl.toggle() end, desc = "Toggle REPL" },
    { "<leader>js", function() require("dap").session() end, desc = "Session" },
    { "<leader>jt", function() require("dap").terminate() end, desc = "Terminate" },
    { "<leader>jw", function() require("dap.ui.widgets").hover() end, desc = "Widgets" },
  },

		config = function()
			-- load mason-nvim-dap here, after all adapters have been setup
			if LazyVim.has("mason-nvim-dap.nvim") then
				require("mason-nvim-dap").setup(LazyVim.opts("mason-nvim-dap.nvim"))
			end

			vim.api.nvim_set_hl(0, "DapStoppedLine", { default = true, link = "Visual" })

			for name, sign in pairs(LazyVim.config.icons.dap) do
				sign = type(sign) == "table" and sign or { sign }
				vim.fn.sign_define(
					"Dap" .. name,
					{ text = sign[1], texthl = sign[2] or "DiagnosticInfo", linehl = sign[3], numhl = sign[3] }
				)
			end

			-- setup dap config by VsCode launch.json file
			local vscode = require("dap.ext.vscode")
			local json = require("plenary.json")
			vscode.json_decode = function(str)
				return vim.json.decode(json.json_strip_comments(str))
			end
		end,
	},
	{
		"rcarriga/nvim-dap-ui",
		-- virtual text for the debugger
		{
			"theHamsta/nvim-dap-virtual-text",
			opts = {},
		},
	},
	{
		"theHamsta/nvim-dap-virtual-text",
		opts = {},
	},
	{
		"rcarriga/nvim-dap-ui",
		dependencies = { "nvim-neotest/nvim-nio" },
  -- stylua: ignore
  keys = {
    { "<leader>ju", function() require("dapui").toggle({ }) end, desc = "Dap UI" },
    { "<leader>je", function() require("dapui").eval() end, desc = "Eval", mode = {"n", "v"} },
  },
		opts = {},
		config = function(_, opts)
			local dap = require("dap")
			local dapui = require("dapui")
			dapui.setup(opts)
			dap.listeners.after.event_initialized["dapui_config"] = function()
				dapui.open({})
			end
			dap.listeners.before.event_terminated["dapui_config"] = function()
				dapui.close({})
			end
			dap.listeners.before.event_exited["dapui_config"] = function()
				dapui.close({})
			end
			-- TRUC CHELOU LazyVim
			--
			if not dap.adapters["pwa-node"] then
				require("dap").adapters["pwa-node"] = {
					type = "server",
					host = "localhost",
					port = "${port}",
					executable = {
						command = "node",
						-- 💀 Make sure to update this path to point to your installation
						args = {
							vim.fn.stdpath("data") .. "/mason/packages/js-debug-adapter/js-debug/src/dapDebugServer.js",
							"${port}",
						},
					},
				}
			end
			if not dap.adapters["node"] then
				dap.adapters["node"] = function(cb, config)
					if config.type == "node" then
						config.type = "pwa-node"
					end
					local nativeAdapter = dap.adapters["pwa-node"]
					if type(nativeAdapter) == "function" then
						nativeAdapter(cb, config)
					else
						cb(nativeAdapter)
					end
				end
			end

			local js_filetypes = { "typescript", "javascript", "typescriptreact", "javascriptreact" }

			local vscode = require("dap.ext.vscode")
			vscode.type_to_filetypes["node"] = js_filetypes
			vscode.type_to_filetypes["pwa-node"] = js_filetypes

			for _, language in ipairs(js_filetypes) do
				if not dap.configurations[language] then
					dap.configurations[language] = {
						{
							type = "pwa-node",
							request = "launch",
							name = "Launch file",
							program = "${file}",
							cwd = "${workspaceFolder}",
						},
						{
							type = "pwa-node",
							request = "attach",
							name = "Attach",
							processId = require("dap.utils").pick_process,
							cwd = "${workspaceFolder}",
						},
					}
				end
			end
		end,
	},
	{ "nvim-neotest/nvim-nio" },
}
