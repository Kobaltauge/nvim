if (vim.g.vscode) then
	-- VSCode extension
	require("vim-options-vsc")
else
  require("vim-options")


	-- [[ Install `lazy.nvim` plugin manager ]]
	--    https://github.com/folke/lazy.nvim
	--    `:help lazy.nvim.txt` for more info
	local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
	if not vim.loop.fs_stat(lazypath) then
	  vim.fn.system({
	    'git',
	    'clone',
	    '--filter=blob:none',
	    'https://github.com/folke/lazy.nvim.git',
	    '--branch=stable', -- latest stable release
	    lazypath,
	  })
	end
	vim.opt.rtp:prepend(lazypath)
	require("lazy").setup("plugins")

  local launch_ahklsp = function()
	  local autocmd
    local config = {
    name = 'ahk-lsp',
    cmd = { "AutoHotkey64.exe", "c:/git/ahk-lsp/ahk-lsp.ahk"},
    -- cmd = { "C:/Daten/programmier/AutoHotkey_2/AutoHotkey64.exe", "C:/Daten/programmier/ahk-lsp/main.ahk"},
    -- cmd = { "C:/Daten/programmier/ahk-lsp/main.exe"},
    -- cmd = { 'c:\\tools\\ahk-lsp.exe' },
    -- root_dir = { "C:/Daten/programmier/ahk-lsp" }
    root_dir = vim.fs.dirname(vim.fs.find({'main.ahk'}, { upward = true })[1]),
    capabilities = vim.lsp.protocol.make_client_capabilities(),
    }

    config.on_init = function(client, results)
	    local buf_attach = function()
		    vim.lsp.buf_attach_client(0, client.id)
      end

      autocmd = vim.api.nvim_create_autocmd({'BufRead', 'BufNewFile'}, {
        pattern = 'D:/Programmier/autohotkey/*.ahk',
        callback = buf_attach
      })
      buf_attach()
    end

    vim.lsp.start_client(config)
  end

  vim.api.nvim_create_autocmd({'BufRead', 'BufNewFile'}, {
    pattern = 'D:/Programmier/autohotkey/*.ahk',
    callback = launch_ahklsp
  })

	-- vim.keymap.set('n', 'F12', '!cmd D:\\portable\\Autohotkey2\\Compiler\\Ahk2Exe.exe /in d:\\git\\ahk-lsp\\main.ahk /out c:\\tools\\ahk-lsp.exe', { expr = true, silent = true })
	-- vim.keymap.set('n', "<F12>", ":silent ! d:/git/ahk-lsp/build.cmd > output.log 2>&1<CR>", { silent = true })

	-- Set highlight on search
	vim.o.hlsearch = false

	-- Make line numbers default
	vim.wo.number = true

	-- Enable mouse mode
	vim.o.mouse = 'a'

	-- Sync clipboard between OS and Neovim.
	--  Remove this option if you want your OS clipboard to remain independent.
	--  See `:help 'clipboard'`
	vim.o.clipboard = 'unnamedplus'

	-- Enable break indent
	vim.o.breakindent = true

	-- Save undo history
	vim.o.undofile = true

	-- Case-insensitive searching UNLESS \C or capital in search
	vim.o.ignorecase = true
	vim.o.smartcase = true

	-- Keep signcolumn on by default
	vim.wo.signcolumn = 'yes'

	-- Decrease update time
	vim.o.updatetime = 250
	vim.o.timeoutlen = 300

	-- Set completeopt to have a better completion experience
	vim.o.completeopt = 'menuone,noselect'

	-- NOTE: You should make sure your terminal supports this
	vim.o.termguicolors = true

	-- [[ Basic Keymaps ]]

	-- Keymaps for better default experience
	-- See `:help vim.keymap.set()`
	vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

  -- word wrap
  vim.keymap.set('n', '<leader>w', ":set wrap!<CR>", { silent = true })

	-- Remap for dealing with word wrap
	vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
	vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

	-- Diagnostic keymaps
	vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
	vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
	vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
	vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })

	-- [[ Highlight on yank ]]
	-- See `:help vim.highlight.on_yank()`
	local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
	vim.api.nvim_create_autocmd('TextYankPost', {
	  callback = function()
	    vim.highlight.on_yank()
	  end,
	  group = highlight_group,
	  pattern = '*',
	})
end
