-- https://raw.githubusercontent.com/danielcopper/nvim/refs/heads/main/lua/copper/plugins/lsp/lspconfig.lua

local icons = require("config.icons")

return {
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			"hrsh7th/cmp-nvim-lsp", -- Integration with nvim-cmp for LSP-based completions
			{ "antosha417/nvim-lsp-file-operations", config = true }, -- File operations through LSP
			{ "folke/neodev.nvim", opts = {} }, -- Enhanced support for Neovim development
			{ "williamboman/mason.nvim", cmd = "Mason" },
			"williamboman/mason-lspconfig.nvim",
			"WhoIsSethDaniel/mason-tool-installer.nvim",

			-- "Hoffs/omnisharp-extended-lsp.nvim",
			-- "iabdelkareem/csharp.nvim",
			-- "Tastyep/structlog.nvim", -- Optional, but highly recommended for debugging
			-- "mfussenegger/nvim-dap",

			-- "pmizio/typescript-tools.nvim",
			"joeveiga/ng.nvim",

			"b0o/schemastore.nvim",
		},
		config = function()
			-- neodev setup must be done before lspconfig to enhance Lua dev experience
			require("neodev").setup()

			local lspconfig = require("lspconfig")
			local mason = require("mason")
			local mason_lspconfig = require("mason-lspconfig")

			-- SECTION: UI
			-- Handlers in LSP are functions that determine how certain types of server responses
			-- (like hover, signature help, etc.) are displayed or processed in Neovim.
			-- This function sets up customized behavior for these responses, like defining borders
			-- or other UI enhancements.
			local handlers = {
				["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { }),
				["textDocument/signatureHelp"] = vim.lsp.with(
					vim.lsp.handlers.signature_help,
					{ }
				),
			}

			-- TODO: maybe move to options.lua
			for name, icon in pairs(icons.diagnostics) do
				name = "DiagnosticSign" .. name
				vim.fn.sign_define(name, { text = icon, texthl = name, numhl = "" })
			end

			-- SECTION: Functionalities
			-- The default neovim supported client capabilities
			local capabilities = vim.lsp.protocol.make_client_capabilities()
			-- Additional completion capabilities for lsps enabled by nvim-cmp
			capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)
			-- Enables text folding range capabilities in the LSP (nvim ufo)
			capabilities.textDocument.foldingRange = { dynamicRegistration = false, lineFoldingOnly = true }
			-- Enable (broadcasting) snippet capability for completion
			capabilities.textDocument.completion.completionItem.snippetSupport = true

			local markdown_oxide_capabilities = capabilities
			markdown_oxide_capabilities.workspace = {
				didChangeWatchedFiles = {
					dynamicRegistration = true,
				},
			}

			vim.diagnostic.config({
				-- Enable or disable updating diagnostics in insert mode
				update_in_insert = false,
				underline = false,
				-- Configure the floating window for diagnostics
				float = {
					source = "always", -- Show the source of the diagnostic
				},
			})

			-- local on_attach = function(_, bufnr)
			--   local set = vim.keymap.set
			--   local keybind = function(keys, func, desc)
			--     set("n", keys, func, { buffer = bufnr, desc = desc, noremap = true, silent = true })
			--   end
			--
			--   keybind("<leader>cl", "<cmd>LspInfo<cr>", "Lsp Info")
			--   keybind("<leader>cf", function() vim.lsp.buf.format({ async = true }) end, "Quick format the open buffer")
			--   keybind("gd", require("telescope.builtin").lsp_definitions, "Show LSP definitions")
			--   keybind("gD", vim.lsp.buf.declaration, "Go to declaration")
			--   keybind("gr", require("telescope.builtin").lsp_references, "Show LSP references")
			--   keybind("gi", require("telescope.builtin").lsp_implementations, "Show LSP implementations")
			--   keybind("gt", require("telescope.builtin").lsp_type_definitions, "Show LSP type definitions")
			--   keybind("<leader>rn", vim.lsp.buf.rename, "Smart rename")
			--   keybind("<leader>vd", function() vim.diagnostic.open_float(nil, { border = vim.copper_config.borders }) end,
			--     "Show line diagnostics")
			--   keybind("[d", vim.diagnostic.goto_prev, "Go to previous diagnostic")
			--   keybind("]d", vim.diagnostic.goto_next, "Go to next diagnostic")
			--   keybind("K", vim.lsp.buf.hover, "Show documentation for what is under the cursor")
			--   keybind("<leader>rs", ":LspRestart<CR>", "Restart LSP")
			--   set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action,
			--     { buffer = bufnr, noremap = true, silent = true, desc = "See available code actions" })
			--   set("n", "<leader>vD", "<cmd>Telescope diagnostics bufnr=0<CR>",
			--     { buffer = bufnr, noremap = true, silent = true, desc = "Show buffer diagnostics" })
			--
			--   keybind("<space>wa", vim.lsp.buf.add_workspace_folder, "")
			--   keybind("<space>wr", vim.lsp.buf.remove_workspace_folder, "")
			--   keybind("<space>wl", function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end, "")
			--
			--   -- Taken from markdown oxide
			--   -- refresh codelens on TextChanged and InsertLeave as well
			--   -- TODO: error on 0.10
			--   -- vim.api.nvim_create_autocmd({ 'TextChanged', 'InsertLeave', 'CursorHold', 'LspAttach' }, {
			--   --   buffer = bufnr,
			--   --   callback = vim.lsp.codelens.refresh,
			--   -- })
			--
			--   -- trigger codelens refresh
			--   -- vim.api.nvim_exec_autocmds('User', { pattern = 'LspAttached' })
			--
			--   -- TODO: gives error currently on 0.10
			--   -- local ng_opts = { noremap = true, silent = true }
			--   -- local ng = require("ng");
			--   -- vim.keymap.set("n", "<leader>at", ng.goto_template_for_component({ reuse_window = true }), ng_opts)
			--   -- vim.keymap.set("n", "<leader>ac", ng.goto_component_with_template_file({ reuse_window = true }), ng_opts)
			--   -- vim.keymap.set("n", "<leader>aT", ng.get_template_tcb, ng_opts)
			-- end

			-- autocommand becuase the local function did break roslyn functionality.
			-- TODO: rework nvim config files. this is evolving into the opposite of simple and efficient
			-- Create a group for the autocommand
			vim.api.nvim_create_augroup("DefaultLspAttach", { clear = true })
			-- Define the autocommand for LspAttach
			vim.api.nvim_create_autocmd("LspAttach", {
				group = "DefaultLspAttach",
				callback = function(args)
					local bufnr = args.buf -- Get the buffer number for the attached LSP
					local set = vim.keymap.set -- Alias for key mapping

					-- Helper function for creating buffer-local keymaps
					local keymap = function(mode, lhs, rhs, opts)
						opts = vim.tbl_extend("force", { buffer = bufnr, silent = true, noremap = true }, opts or {})
						set(mode, lhs, rhs, opts)
					end

					keymap("n", "<leader>cl", "<cmd>LspInfo<cr>", { desc = "Lsp Info" })
          keymap("n", "<leader>cf", function() vim.lsp.buf.format({ async = true }) end,
            { desc = "Quick format the open buffer" })
					keymap("n", "gd", function()
						require("telescope.builtin").lsp_definitions()
					end, { desc = "Show LSP definitions" })
					keymap("n", "gD", function()
						vim.lsp.buf.declaration()
					end, { desc = "Go to declaration" })
					keymap("n", "gr", function()
						require("telescope.builtin").lsp_references()
					end, { desc = "Show LSP references" })
					keymap("n", "gi", function()
						require("telescope.builtin").lsp_implementations()
					end, { desc = "Show LSP implementations" })
					keymap("n", "gt", function()
						require("telescope.builtin").lsp_type_definitions()
					end, { desc = "Show LSP type definitions" })
					keymap("n", "<leader>rn", function()
						vim.lsp.buf.rename()
					end, { desc = "Smart rename" })
					keymap("n", "<leader>vd", function()
						vim.diagnostic.open_float(nil, { })
					end, { desc = "Show line diagnostics" })
					keymap("n", "[d", function()
						vim.diagnostic.goto_prev()
					end, { desc = "Go to previous diagnostic" })
					keymap("n", "]d", function()
						vim.diagnostic.goto_next()
					end, { desc = "Go to next diagnostic" })
					keymap("n", "K", function()
						vim.lsp.buf.hover()
					end, { desc = "Show documentation for what is under the cursor" })
					keymap("n", "<leader>rs", "<cmd>LspRestart<CR>", { desc = "Restart LSP" })
					keymap({ "n", "v" }, "<leader>ca", function()
						vim.lsp.buf.code_action()
					end, { desc = "See available code actions" })
					keymap("n", "<leader>vD", "<cmd>Telescope diagnostics bufnr=0<CR>", { desc = "Show buffer diagnostics" })

					-- vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
					-- vim.keymap.set("n", "<leader>gd", vim.lsp.buf.definition, {})
					-- vim.keymap.set("n", "<leader>gr", vim.lsp.buf.references, {})
					-- vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, {})

					keymap("n", "<space>wa", function()
						vim.lsp.buf.add_workspace_folder()
					end, { desc = "Add workspace folder" })
					keymap("n", "<space>wr", function()
						vim.lsp.buf.remove_workspace_folder()
					end, { desc = "Remove workspace folder" })
					keymap("n", "<space>wl", function()
						print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
					end, { desc = "List workspace folders" })

					-- TODO: needs fixing
					-- Refresh codelens (if supported)
					-- local client = vim.lsp.get_client_by_id(args.data.client_id)
					-- if client and client.server_capabilities.codeLensProvider then
					--   vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
					--     group = vim.api.nvim_create_augroup("LspCodelensRefresh", { clear = true }),
					--     buffer = bufnr,
					--     callback = vim.lsp.codelens.refresh,
					--   })
					-- end
				end,
			})

			-- SECTION: Server Setups
			mason.setup({
				ui = {
					icons = {
						package_installed = icons.ui.CheckAlt,
						package_pending = icons.ui.Arrow,
						package_uninstalled = icons.ui.ErrorAlt,
					},
				},
			})

			mason_lspconfig.setup({
				ensure_installed = {
					"bashls",
					"dockerls",
					"docker_compose_language_service",
					"emmet_language_server",
					"eslint",
					"jsonls",
					"lemminx",
					"lua_ls",
					"markdown_oxide",
					-- fow now use:
					-- :MasonInstall --target=win_x86 markdown-oxide
					"marksman",
					-- "omnisharp",
					"powershell_es",
					-- "sqlls",
					"ts_ls",
					"yamlls",
				},
			})

			mason_lspconfig.setup_handlers({
				-- The first entry (without a key) will be the default handler
				-- and will be called for each installed server that doesn't have
				-- a dedicated handler.
				function(server_name) -- default handler (optional)
          lspconfig[server_name].setup {
						capabilities = capabilities,
						handlers = handlers,
          }
        end,

        ["azure_pipelines_ls"] = function()
          lspconfig.azure_pipelines_ls.setup {
            capabilities = capabilities,
            handlers = handlers,
            root_dir = function(fname)
              return lspconfig.util.root_pattern(
                '.azure*',               -- Matches any file starting with '.azure'
                'azure-pipeline*.y*l',   -- Matches any file starting with 'azure-pipeline' and having an extension like .yaml or .yml
                'Azure-Pipelines/*.y*l', -- Matches any .yaml or .yml file in the 'Azure-Pipelines' directory
                'Pipelines/*.y*l',       -- Matches any .yaml or .yml file in the 'Pipelines' directory
                '.git',                  -- Matches the .git directory
                'Pipelines/**/*.y*l',    -- Matches any .yaml or .yml file in 'Pipelines' and any of its subdirectories
                'pipelines/**/*.y*l'     -- Matches any .yaml or .yml file in 'pipelines' and any of its subdirectories
              )(fname) or vim.fn.getcwd()
            end,
            settings = {
              yaml = {
                schemas = {
                  ["https://raw.githubusercontent.com/microsoft/azure-pipelines-vscode/master/service-schema.json"] = {
                    ".azure*",               -- Matches any file starting with '.azure'
                    "azure-pipeline*.y*l",   -- Matches any file starting with 'azure-pipeline' and having an extension like .yaml or .yml
                    "Azure-Pipelines/*.y*l", -- Matches any .yaml or .yml file in the 'Azure-Pipelines' directory
                    "Pipelines/*.y*l",       -- Matches any .yaml or .yml file in the 'Pipelines' directory
                    "Pipelines/**/*.y*l",    -- Matches any .yaml or .yml file in 'Pipelines' and any of its subdirectories
                    "pipelines/**/*.y*l"     -- Matches any .yaml or .yml file in 'pipelines' and any of its subdirectories
                  },
                },
              },
            },
          }
				end,

				["eslint"] = function()
					lspconfig.eslint.setup({
						capabilities = capabilities,
						on_new_config = function(config, new_root_dir)
							config.settings.workspaceFolder = {
								uri = vim.uri_from_fname(new_root_dir),
                name = vim.fn.fnamemodify(new_root_dir, ':t')
							}
						end,
					})
				end,

				["jsonls"] = function()
					lspconfig.jsonls.setup({
						capabilities = capabilities,
						handlers = handlers,
						settings = {
							json = {
								schemas = require("schemastore").json.schemas(),
								validate = { enable = true },
							},
						},
					})
				end,

				-- Next, you can provide a dedicated handler for specific servers.
				["lua_ls"] = function()
					lspconfig.lua_ls.setup({
						capabilities = capabilities,
						handlers = handlers,
						settings = {
							Lua = {
								diagnostics = {
                  globals = { "vim" }
								},
								codelens = true,
								doc = {
									privateName = { "^_" },
								},
								format = {
									defaultConfig = {
										indent_style = "space",
                    indent_size = 2
                  }
								},
								hint = { enable = true },
								telemetry = { enable = false },
								workspace = {
									library = {
										[vim.fn.expand("$VIMRUNTIME/lua")] = true,
										[vim.fn.stdpath("config") .. "/lua"] = true,
									},
								},
							},
						},
					})
				end,

				["markdown_oxide"] = function()
					lspconfig.markdown_oxide.setup({
						capabilities = markdown_oxide_capabilities, -- ensure that capabilities.workspace.didChangeWatchedFiles.dynamicRegistration = true
						handlers = handlers,
						root_dir = lspconfig.util.root_pattern(".git", vim.fn.getcwd()), -- this is a temp fix for an error in the lspconfig for this LS
					})
				end,

				["powershell_es"] = function()
					lspconfig.powershell_es.setup({
						capabilities = capabilities,
						handlers = handlers,
						bundle_path = vim.fn.stdpath("data") .. "/mason/packages/powershell-editor-services",
						init_options = {
							enableProfileLoading = false,
            }
					})
				end,

				-- ["sqlls"] = function()
				--   lspconfig.sqlls.setup({
				--     cmd = { "sql-language-server", "up", "--method", "stdio" },
				--     capabilities = capabilities,
				--     on_attach = on_attach,
				--     handlers = handlers,
				--     filetypes = { "sql", "mysql", "mdx" },
				--     root_dir = lspconfig.util.root_pattern('.git', vim.fn.getcwd()), -- this is a temp fix for an error in the lspconfig for this LS
				--   })
				-- end,

				["yamlls"] = function()
					local schemas = require("schemastore").yaml.schemas()
					-- schemas["https://raw.githubusercontent.com/microsoft/azure-pipelines-vscode/master/service-schema.json"] = {
					--   "*.azure*",
					--   "azure-pipeline*.y*l",
					--   "Azure-Pipelines/**/*.y*l",
					--   "Pipelines/**/*.y*l",
					--   "pipelines/**/*.y*l",
					-- }

					require("lspconfig").yamlls.setup({
						capabilities = capabilities,
						handlers = handlers,
						settings = {
							yaml = {
								format = {
									enable = true,
								},
								schemas = schemas,
							}
						},
					})
				end,

			})
		end,
	},
}
