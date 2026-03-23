return {
    -- We still keep the plugin for the "collection" of default configs,
    -- but we change how we activate them.
    "neovim/nvim-lspconfig",
    dependencies = {
        "stevearc/conform.nvim",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "hrsh7th/nvim-cmp",
        "L3MON4D3/LuaSnip",
        "saadparwaiz1/cmp_luasnip",
        "j-hui/fidget.nvim",
    },

    config = function()
        local cmp = require('cmp')
        local cmp_lsp = require("cmp_nvim_lsp")

        require("fidget").setup({})
        require("conform").setup({ formatters_by_ft = {} })

        -- 1. Setup Capabilities
        local capabilities = vim.tbl_deep_extend(
            "force",
            {},
            vim.lsp.protocol.make_client_capabilities(),
            cmp_lsp.default_capabilities()
        )

        -- 2. Define/Customize Configs using vim.lsp.config
        -- This replaces the old lspconfig.lua_ls.setup({})
        vim.lsp.config('lua_ls', {
            caps = capabilities, -- 'caps' is the new shorthand for capabilities in 0.11
            settings = {
                Lua = {
                    runtime = { version = 'LuaJIT' },
                    diagnostics = { globals = { 'vim' } },
                    workspace = {
                        library = vim.api.nvim_get_runtime_file("", true),
                        checkThirdParty = false,
                    },
                }
            }
        })

        -- 3. Enable the servers
        -- This tells Neovim to actually start these servers for their filetypes
        vim.lsp.enable('lua_ls')
        vim.lsp.enable('rust_analyzer')
        vim.lsp.enable('tailwindcss')
        vim.lsp.enable('pyright')
        vim.lsp.enable('tinymist')

        -- 4. Completion Setup (Standard nvim-cmp)
        local cmp_select = { behavior = cmp.SelectBehavior.Select }
        cmp.setup({
            snippet = {
                expand = function(args) require('luasnip').lsp_expand(args.body) end,
            },
            mapping = cmp.mapping.preset.insert({
                ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
                ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
                ['<C-y>'] = cmp.mapping.confirm({ select = true }),
                ["<C-Space>"] = cmp.mapping.complete(),
            }),
            sources = cmp.config.sources({
                { name = 'nvim_lsp' },
                { name = 'luasnip' },
            }, {
                { name = 'buffer' },
            })
        })
    end
}
