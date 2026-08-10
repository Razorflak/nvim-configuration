local function javascript_adapter_path()
	return vim.fn.stdpath("data") .. "/mason/packages/js-debug-adapter/js-debug/src/dapDebugServer.js"
end

local function configure_javascript(dap)
	local adapter = javascript_adapter_path()
	if vim.fn.filereadable(adapter) == 0 then
		return
	end

	dap.adapters["pwa-node"] = {
		type = "server",
		host = "127.0.0.1",
		port = "${port}",
		executable = {
			command = "node",
			args = { adapter, "${port}" },
		},
	}

	local filetypes = { "typescript", "javascript", "typescriptreact", "javascriptreact" }
	local vscode = require("dap.ext.vscode")
	vscode.type_to_filetypes["pwa-node"] = filetypes
	vscode.type_to_filetypes.node = filetypes

	for _, filetype in ipairs(filetypes) do
		dap.configurations[filetype] = dap.configurations[filetype]
			or {
				{
					type = "pwa-node",
					request = "launch",
					name = "Launch current file",
					program = "${file}",
					cwd = "${workspaceFolder}",
					sourceMaps = true,
				},
				{
					type = "pwa-node",
					request = "attach",
					name = "Attach to process",
					processId = require("dap.utils").pick_process,
					cwd = "${workspaceFolder}",
					sourceMaps = true,
				},
			}
	end
end

return {
	{
		"mfussenegger/nvim-dap",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"williamboman/mason.nvim",
			{
				"jay-babu/mason-nvim-dap.nvim",
			},
			{
				"rcarriga/nvim-dap-ui",
				dependencies = { "nvim-neotest/nvim-nio" },
			},
			{
				"theHamsta/nvim-dap-virtual-text",
			},
		},
		keys = {
			{
				"<leader>jB",
				function()
					require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
				end,
				desc = "Breakpoint condition",
			},
			{
				"<leader>jb",
				function()
					require("dap").toggle_breakpoint()
				end,
				desc = "Toggle breakpoint",
			},
			{
				"<leader>jc",
				function()
					require("dap").continue()
				end,
				desc = "Run/continue",
			},
			{
				"<leader>jC",
				function()
					require("dap").run_to_cursor()
				end,
				desc = "Run to cursor",
			},
			{
				"<leader>jg",
				function()
					require("dap").goto_()
				end,
				desc = "Go to line",
			},
			{
				"<leader>ji",
				function()
					require("dap").step_into()
				end,
				desc = "Step into",
			},
			{
				"<leader>jj",
				function()
					require("dap").down()
				end,
				desc = "Down stack frame",
			},
			{
				"<leader>jk",
				function()
					require("dap").up()
				end,
				desc = "Up stack frame",
			},
			{
				"<leader>jl",
				function()
					require("dap").run_last()
				end,
				desc = "Run last",
			},
			{
				"<leader>jo",
				function()
					require("dap").step_out()
				end,
				desc = "Step out",
			},
			{
				"<leader>jO",
				function()
					require("dap").step_over()
				end,
				desc = "Step over",
			},
			{
				"<leader>jP",
				function()
					require("dap").pause()
				end,
				desc = "Pause",
			},
			{
				"<leader>jr",
				function()
					require("dap").repl.toggle()
				end,
				desc = "Toggle REPL",
			},
			{
				"<leader>js",
				function()
					require("dap").session()
				end,
				desc = "Session",
			},
			{
				"<leader>jt",
				function()
					require("dap").terminate()
				end,
				desc = "Terminate",
			},
			{
				"<leader>jw",
				function()
					require("dap.ui.widgets").hover()
				end,
				desc = "Widgets",
			},
			{
				"<leader>ju",
				function()
					require("dapui").toggle()
				end,
				desc = "Toggle DAP UI",
			},
			{
				"<leader>je",
				function()
					require("dapui").eval()
				end,
				mode = { "n", "v" },
				desc = "Evaluate expression",
			},
		},
		config = function()
			local dap = require("dap")
			local dapui = require("dapui")

			require("mason-nvim-dap").setup({
				ensure_installed = { "js" },
				automatic_installation = true,
			})
			require("nvim-dap-virtual-text").setup()
			dapui.setup()

			vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DiagnosticError" })
			vim.fn.sign_define("DapBreakpointCondition", { text = "◆", texthl = "DiagnosticWarn" })
			vim.fn.sign_define("DapStopped", { text = "▶", texthl = "DiagnosticInfo", linehl = "Visual" })

			configure_javascript(dap)

			local vscode = require("dap.ext.vscode")
			local json = require("plenary.json")
			vscode.json_decode = function(content)
				return vim.json.decode(json.json_strip_comments(content))
			end

			dap.listeners.after.event_initialized.dapui = function()
				dapui.open()
			end
			dap.listeners.before.event_terminated.dapui = function()
				dapui.close()
			end
			dap.listeners.before.event_exited.dapui = function()
				dapui.close()
			end
		end,
	},
}
