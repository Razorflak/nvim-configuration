return {
	"nvim-neotest/neotest",
	dependencies = {
		"nvim-neotest/nvim-nio",
		"nvim-lua/plenary.nvim",
		"antoinemadec/FixCursorHold.nvim",
		"nvim-treesitter/nvim-treesitter",
		"nvim-neotest/neotest-jest",
		"marilari88/neotest-vitest",
	},
	cwd = function(path)
		print(path, "CWD Global")
		if string.find(path, "/packages/") then
			return string.match(path, "(.-/[^/]+/)src")
		end
		return vim.fn.getcwd()
	end,
	config = function()
		local adapters = {
			require("neotest-vitest")({
				vitestCommand = function()
					return "pnpx vitest@3.0.0 run"
				end,
				vitestConfigFile = function(file)
					if string.find(file, "/packages/") then
						return string.match(file, "(.-/[^/]+/)src") .. "vitest.config.ts"
					end

					return vim.fn.getcwd() .. "/vitest.config.ts"
				end,
				cwd = function(path)
					if string.find(path, "/packages/") then
						return string.match(path, "(.-/[^/]+/)src")
					end
					return vim.fn.getcwd()
				end,
			}),
			--[[ require("neotest-jest")({
				jestCommand = "pnpx jest ", -- Adapt this command if needed
				jestConfigFile = function(file)
					if string.find(file, "/packages/") then
						return string.match(file, "(.-/[^/]+/)src") .. "jest.config.ts"
					end

					return vim.fn.getcwd() .. "/jest.config.ts"
				end,
				cwd = function(path)
					print(path, "CWD Jest")
					if string.find(path, "/packages/") then
						return string.match(path, "(.-/[^/]+/)src")
					end
					return vim.fn.getcwd()
				end,
			}), ]]
			--Sticky back
			--[[ require("neotest-jest")({
				jestCommand = "pnpx jest ", -- Adapt this command if needed
				jestConfigFile = function(file)
					print("init jest", file)
					if string.find(file, "/endpoints/") then
						print("jestfile", string.match(file, "(.-/[^/]+/)src") .. "jest.config.js")
						return string.match(file, "(.-/[^/]+/)src") .. "jest.config.js"
					end
					print("pas trouvé", vim.fn.getcwd() .. "/jest.config.js")
					return vim.fn.getcwd() .. "/jest.config.js"
				end,
				cwd = function(path)
					print(path, "CWD Jest")
					if string.find(path, "/endpoints/") then
						return string.match(path, "(.-/[^/]+/)src")
					end
					return vim.fn.getcwd()
				end,
			}), ]]
		}
		require("neotest").setup({
			output_panel = {
				--		open = "botright vsplit | vertical resize 200",
				open = "botright vsplit | vertical resize " .. math.floor(vim.o.columns * 0.5),
			},
			adapters = adapters,
		})
	end,

	event = "VeryLazy",
	keys = {
		{
			"<leader>tt",
			function()
				require("neotest").run.run(vim.fn.expand("%"))
			end,
			desc = "Run Test File",
		},
		{
			"<leader>tT",
			function()
				require("neotest").run.run(vim.loop.cwd())
			end,
			desc = "Run All Test Files",
		},
		{
			"<leader>tr",
			function()
				require("neotest").run.run()
			end,
			desc = "Run Nearest Test",
		},
		{
			"<leader>ts",
			function()
				require("neotest").summary.toggle()
			end,
			desc = "Toggle Test Summary",
		},
		{
			"<leader>to",
			function()
				require("neotest").output.open({ enter = true, auto_close = true })
			end,
			desc = "Show Test Output",
		},
		{
			"<leader>tO",
			function()
				require("neotest").output_panel.toggle()
			end,
			desc = "Toggle Output Panel",
		},
		{
			"<leader>tS",
			function()
				require("neotest").run.stop()
			end,
			desc = "Stop Running Test",
		},
		{
			"<leader>tw",
			function()
				require("neotest").watch.watch(vim.fn.expand("%"))
			end,
			desc = "Running Test File in watch mode",
		},
	},
}
