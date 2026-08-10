return {
	"saghen/blink.cmp",
	version = "1.*",
	dependencies = { "rafamadriz/friendly-snippets" },
	opts = {
		keymap = {
			preset = "enter",
			["<Tab>"] = {
				function()
					local ok, suggestion = pcall(require, "copilot.suggestion")
					if ok and suggestion.is_visible() then
						suggestion.accept()
						return true
					end
				end,
				"snippet_forward",
				"fallback",
			},
		},
		appearance = { nerd_font_variant = "mono" },
		completion = {
			menu = { border = "rounded" },
			documentation = {
				auto_show = true,
				auto_show_delay_ms = 300,
				window = { border = "rounded" },
			},
		},
		signature = {
			enabled = true,
			window = { border = "rounded" },
		},
		sources = {
			default = { "lsp", "path", "snippets", "buffer" },
			per_filetype = {
				markdown = { inherit_defaults = true },
			},
		},
		fuzzy = { implementation = "prefer_rust_with_warning" },
	},
	opts_extend = { "sources.default" },
}
