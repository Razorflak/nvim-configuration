return {
    'VonHeikemen/lsp-zero.nvim',
    branch = 'v2.x',
    dependencies = {
        -- LSP Support
        { 'neovim/nvim-lspconfig' },
        { 'williamboman/mason.nvim' },
        { 'williamboman/mason-lspconfig.nvim' },

        -- Autocompletion
        { 'hrsh7th/nvim-cmp' },
        { 'hrsh7th/cmp-buffer' },
        { 'hrsh7th/cmp-path' },
        { 'saadparwaiz1/cmp_luasnip' },
        { 'hrsh7th/cmp-nvim-lsp' },
        { 'hrsh7th/cmp-nvim-lua' },

        -- Snippets
        { 'L3MON4D3/LuaSnip' },
        { 'rafamadriz/friendly-snippets' },
    },
    config = function()
        local lsp = require("lsp-zero")
        lsp.preset("recommended")
        lsp.ensure_installed({
            'tsserver',
        })
        -- Fix Undefined global 'vim'
        lsp.nvim_workspace()

        local cmp = require('cmp')
        local cmp_select = { behavior = cmp.SelectBehavior.Select }
        local cmp_mappings = lsp.defaults.cmp_mappings({
            ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
            ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
            ['<CR>'] = cmp.mapping.confirm({ select = true }),
            ["<C-Space>"] = cmp.mapping.complete(),
        })

        cmp_mappings['<Tab>'] = nil
        cmp_mappings['<S-Tab>'] = nil

        lsp.setup_nvim_cmp({
            mapping = cmp_mappings
        })

        lsp.set_sign_icons({
            error = '✘',
            warn = '▲',
            hint = '⚑',
            info = '»'
        })

        lsp.on_attach(function(client, bufnr)
            -- Navbuddy attach
            local navbuddy = require("nvim-navbuddy")
            if client.name ~= "eslint" then
                navbuddy.attach(client, bufnr)
            end
            --
            -- Remap for goto definition
            local opts = { buffer = bufnr, remap = false }
            vim.keymap.set("n", "gd", function()
                vim.lsp.buf.definition()
                vim.defer_fn(function()
                    vim.api.nvim_input("zz")
                end, 100)
            end, opts)
            vim.keymap.set("n", "gdd", function()
                vim.lsp.buf.definition()
                vim.defer_fn(function()
                    vim.api.nvim_input("zz")
                end, 100)
            end, opts)
            vim.keymap.set("n", "gdv", function()
                vim.cmd("vsplit")
                vim.cmd("wincmd l")
                vim.lsp.buf.definition()
                vim.defer_fn(function()
                    vim.api.nvim_input("zz")
                end, 100)
            end, opts)
            --
            -- Remap for lsp acitons
            vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
            vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
            vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
            vim.keymap.set("n", "<leader>ee", function() vim.diagnostic.goto_next() end, opts)
            vim.keymap.set("n", "<leader>ez", function() vim.diagnostic.goto_prev() end, opts)
            vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)
            vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts)
            vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
            vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
        end)

        lsp.setup()

        vim.diagnostic.config({
            virtual_text = true
        })
    end
}
