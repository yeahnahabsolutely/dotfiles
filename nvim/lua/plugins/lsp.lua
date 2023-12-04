return {
    -- lspconfig
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            'williamboman/mason.nvim', -- Automatically install LSPs to stdpath for neovim
            'williamboman/mason-lspconfig.nvim', -- ibid
            'folke/neodev.nvim', -- Lua language server configuration for nvim
            { 
                -- Autocompletion
                'hrsh7th/nvim-cmp',
                dependencies = { 'hrsh7th/cmp-nvim-lsp', 'L3MON4D3/LuaSnip', 'saadparwaiz1/cmp_luasnip' },
            },
        },
        opts = {
            -- options for vim.diagnostic.config()
            diagnostics = {
                underline = true,
                update_in_insert = false,
                virtual_text = {
                    spacing = 4,
                    source = "if_many",
                    prefix = "●",
                    -- this will set set the prefix to a function that returns the diagnostics icon based on the severity
                    -- this only works on a recent 0.10.0 build. Will be set to "●" when not supported
                    -- prefix = "icons",
                },
                severity_sort = true,
            },
            -- add any global capabilities here
            capabilities = {},
            -- Automatically format on save
            autoformat = true,
            -- options for vim.lsp.buf.format
            -- `bufnr` and `filter` is handled by the LazyVim formatter,
            -- but can be also overridden when specified
            format = {
                formatting_options = nil,
                timeout_ms = nil,
            },
            -- LSP Server Settings
            ---@type lspconfig.options
            servers = {
                jsonls = {},
                lua_ls = {
                    -- mason = false, -- set to false if you don't want this server to be installed with mason
                    settings = {
                        Lua = {
                            workspace = {
                                checkThirdParty = false,
                            },
                            completion = {
                                callSnippet = "Replace",
                            },
                        },
                    },
                },
            },
            -- you can do any additional lsp server setup here
            -- return true if you don't want this server to be setup with lspconfig
            ---@type table<string, fun(server:string, opts:_.lspconfig.options):boolean?>
            setup = {
                -- example to setup with typescript.nvim
                -- tsserver = function(_, opts)
                    --   require("typescript").setup({ server = opts })
                    --   return true
                    -- end,
                    -- Specify * to use this function as a fallback for any server
                    -- ["*"] = function(server, opts) end,
                },
            },
            config = function()
                -- LSP settings
                require('mason').setup {}
                require('mason-lspconfig').setup()

                -- Add nvim-lspconfig plugin
                local lspconfig = require 'lspconfig'
                local on_attach = function(_, bufnr)
                    local attach_opts = { silent = true, buffer = bufnr }
                    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, attach_opts)
                    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, attach_opts)
                    vim.keymap.set('n', 'K', vim.lsp.buf.hover, attach_opts)
                    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, attach_opts)
                    vim.keymap.set('n', '<C-s>', vim.lsp.buf.signature_help, attach_opts)
                    vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, attach_opts)
                    vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, attach_opts)
                    vim.keymap.set('n', '<leader>wl', function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end, attach_opts)
                    vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, attach_opts)
                    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, attach_opts)
                    vim.keymap.set('n', 'so', require('telescope.builtin').lsp_references, attach_opts)
                end

                -- nvim-cmp supports additional completion capabilities
                local capabilities = vim.lsp.protocol.make_client_capabilities()
                capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

                -- Enable the following language servers
                local servers = { 'clangd', 'tsserver', 'denols' }

                lspconfig.denols.setup {
                    on_attach = on_attach,
                    root_dir = lspconfig.util.root_pattern("deno.json", "deno.jsonc"),
                }

                lspconfig.tsserver.setup {
                    on_attach = on_attach,
                    root_dir = lspconfig.util.root_pattern("package.json"),
                    single_file_support = false,
                    filetypes = {
                        "javascript",
                        "javascriptreact",
                        "javascript.jsx",
                        "typescript.tsx",
                        "typescript",
                        "typescriptreact"
                    },
                    capabilities = capabilities
                }

                lspconfig.clangd.setup{
                    capabilities = capabilities
                }

                local cmp = require('cmp')
                cmp.setup {
                    mapping = cmp.mapping.preset.insert {
                        ['<Tab>'] = cmp.mapping(function(fallback)
                            if cmp.visible() then
                                cmp.select_next_item()
                            else
                                fallback()
                            end
                        end, { 'i', 's' }),
                        ['<S-Tab>'] = cmp.mapping(function(fallback)
                            if cmp.visible() then
                                cmp.select_prev_item()
                            elseif luasnip.jumpable(-1) then
                                luasnip.jump(-1)
                            else
                                fallback()
                            end
                        end, { 'i', 's' }),
                    },
                    sources = {
                        { name = 'nvim_lsp' },
                    },
                }
            end
            }
        }
