return {
    "stevearc/conform.nvim",
    config = function()
        local conform = require("conform")
        conform.setup({
            formatters_by_ft = {
                javascript = { "biome", "prettier" },
                -- typescript = {"biome", "prettier"},
                javascriptreact = { "biome", "prettier" },
                typescriptreact = { "biome", "prettier" },
                typescript = function()
                    local root_dir = vim.fn.getcwd()
                    if vim.fn.filereadable(root_dir .. '/.prettierrc') == 1 or vim.fn.filereadable(root_dir .. '/.prettierrc.js') == 1 then
                        return { "prettier" }
                    else
                        return { "biome" }
                    end
                end,
                svelte = { "prettier" },
                css = { "prettier" },
                html = { "prettier" },
                json = { "prettier" },
                yaml = { "prettier" },
                markdown = { "prettier" },
                graphql = { "prettier" },
                lua = { "stylua" },
                python = { "isort", "black" },
            },
            format_on_save = {
                lsp_fallback = true,
                async = false,
                timeout_ms = 500,
            },
            notify_on_error = false,
        })

        vim.keymap.set({ "n", "v" }, "<leader>mp", function()
            conform.format({
                lsp_fallback = true,
                async = false,
                timeout_ms = 500,
            })
        end, { desc = "Format file or range (in visual mode)" })
    end,
}
