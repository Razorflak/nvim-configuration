return {
    -- Packer can manage itself
    {
        'nvim-lualine/lualine.nvim',
        dependencies = { 'nvim-tree/nvim-web-devicons', opt = true }
    },
    {
        'nvim-telescope/telescope.nvim', tag = '0.1.0',
        -- or                            , branch = '0.1.x',
        dependencies = { {'nvim-lua/plenary.nvim'} }
    },
    {
	    "kylechui/nvim-surround",
	    version = "*", -- Use for stability; omit to use `main` branch for the latest features
	    event = "VeryLazy",
	    config = function()
		    require("nvim-surround").setup({
			    -- Configuration here, or leave empty to use defaults
		    })
	    end
    },
    {
	    'rose-pine/neovim',
	    as = 'rose-pine',
	    config = function()
		    vim.cmd('colorscheme rose-pine')
	    end
    }, 

    {
        "folke/trouble.nvim",
        config = function()
            require("trouble").setup {
                icons = false,
                -- your configuration comes here
                -- or leave it empty to use the default settings
                -- refer to the configuration section below
            }
        end
    },

    {
        'nvim-treesitter/nvim-treesitter',
        build = function()
            local ts_update = require('nvim-treesitter.install').update({ with_sync = true })
            ts_update()
        end
        },

        "christoomey/vim-tmux-navigator",
        "ray-x/lsp_signature.nvim",
        "sindrets/diffview.nvim",
        "nvim-treesitter/playground",
        "theprimeagen/harpoon",
        "theprimeagen/refactoring.nvim",
        "mbbill/undotree",
        "tpope/vim-fugitive",
        "nvim-treesitter/nvim-treesitter-context",
        "dense-analysis/ale",
        "ggandor/leap.nvim",
        {
            'VonHeikemen/lsp-zero.nvim',
            branch = 'v2.x',
            dependencies = {
                -- LSP Support
                {'neovim/nvim-lspconfig'},
                {'williamboman/mason.nvim'},
                {'williamboman/mason-lspconfig.nvim'},

                -- Autocompletion
                {'hrsh7th/nvim-cmp'},
                {'hrsh7th/cmp-buffer'},
                {'hrsh7th/cmp-path'},
                {'saadparwaiz1/cmp_luasnip'},
                {'hrsh7th/cmp-nvim-lsp'},
                {'hrsh7th/cmp-nvim-lua'},

                -- Snippets
                {'L3MON4D3/LuaSnip'},
                {'rafamadriz/friendly-snippets'},
            }
        },
        {
            "SmiteshP/nvim-navbuddy",
            dependencies = {
                "neovim/nvim-lspconfig",
                "SmiteshP/nvim-navic",
                "MunifTanjim/nui.nvim",
                "numToStr/Comment.nvim",        -- Optional
                "nvim-telescope/telescope.nvim" -- Optional
            }
        }, 

        "folke/zen-mode.nvim",
        "eandrju/cellular-automaton.nvim",
        "laytan/cloak.nvim",
        "m4xshen/autoclose.nvim",
        {
            'Exafunction/codeium.vim',
            config = function ()
                -- Change '<C-g>' here to any keycode you like.
                vim.keymap.set('i', '<C-i>', function () return vim.fn['codeium#Accept']() end, { expr = true })
                vim.keymap.set('i', '<c-;>', function() return vim.fn['codeium#CycleCompletions'](1) end, { expr = true })
                vim.keymap.set('i', '<c-,>', function() return vim.fn['codeium#CycleCompletions'](-1) end, { expr = true })
                vim.keymap.set('i', '<c-x>', function() return vim.fn['codeium#Clear']() end, { expr = true })
            end
        },
    }
