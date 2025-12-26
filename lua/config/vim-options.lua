vim.opt.tabstop = 2 -- Number of spaces that a <Tab> in the file counts for.
vim.opt.shiftwidth = 2 -- Number of spaces to use for each step of (auto)indent.
vim.opt.expandtab = true -- In Insert mode: Use the appropriate number of spaces to insert a <Tab>.
vim.bo.softtabstop = 2
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Set to true if you have a Nerd Font installed and selected in the terminal
vim.g.have_nerd_font = false

-- Make line numbers and relative number default
vim.opt.number = true
vim.opt.relativenumber = true

-- Enable mouse mode, can be useful for resizing splits for example!
vim.opt.mouse = 'a'

-- Don't show the mode, since it's already in the status line
vim.opt.showmode = false


-- Navigate vim panes better
vim.keymap.set('n', '<c-k>', ':wincmd k<CR>', { silent = true })
vim.keymap.set('n', '<c-j>', ':wincmd j<CR>', { silent = true })
vim.keymap.set('n', '<c-h>', ':wincmd h<CR>', { silent = true })
vim.keymap.set('n', '<c-l>', ':wincmd l<CR>', { silent = true })

vim.keymap.set('n', '<leader>h', ':nohlsearch<CR>')

vim.opt.encoding = "utf-8" -- Sets the character encoding used inside Vim.
vim.opt.fileencoding = "utf-8" -- Sets the character encoding for the file of this buffer.
vim.scriptencoding = "utf-8"

-- -- Editor options
-- vim.opt.syntax = "on" -- When this option is set, the syntax with this name is loaded.
-- vim.opt.autoindent = true -- Copy indent from current line when starting a new line.
-- vim.opt.cursorline = true -- Highlight the screen line of the cursor with CursorLine.
-- vim.opt.ruler = true -- Show the line and column number of the cursor position, separated by a comma.
-- vim.opt.mouse = "a" -- Enable the use of the mouse. "a" you can use on all modes
-- vim.opt.title = true -- When on, the title of the window will be set to the value of 'titlestring'
-- vim.opt.hidden = true -- When on a buffer becomes hidden when it is |abandon|ed
-- vim.opt.ttimeoutlen = 0 -- The time in milliseconds that is waited for a key code or mapped key sequence to complete.
-- vim.opt.wildmenu = true -- When 'wildmenu' is on, command-line completion operates in an enhanced mode.
-- vim.opt.showcmd = true -- Show (partial) command in the last line of the screen. Set this option off if your terminal is slow.
-- vim.opt.showmatch = true -- When a bracket is inserted, briefly jump to the matching one.
-- vim.opt.inccommand = "split" -- When nonempty, shows the effects of :substitute, :smagic, :snomagic and user commands with the :command-preview flag as you type.
-- vim.opt.splitbelow = "splitright" -- When on, splitting a window will put the new window below the current one

-- checkhealth fixes
vim.g.loaded_python3_provider = 0
vim.g.loaded_perl_provider = 0

-- Set highlight on search
vim.o.hlsearch = false

-- Make relative line numbers default
vim.wo.number = true
vim.wo.relativenumber = true

-- Enable mouse mode
vim.o.mouse = 'a'

-- Sync clipboard between OS and Neovim.
--  Schedule the setting after `UiEnter` because it can increase startup-time.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
-- vim.schedule(function()
--   vim.opt.clipboard = 'unnamedplus'
-- end)

-- Enable break indent
vim.opt.breakindent = true

-- Save undo history
vim.opt.undofile = true

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Keep signcolumn on by default
vim.opt.signcolumn = 'yes'

-- Decrease update time
vim.opt.updatetime = 250

-- Decrease mapped sequence wait time
vim.opt.timeoutlen = 500 -- or 500 (Default: 1000)

-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Preview substitutions live, as you type!
vim.opt.inccommand = 'split'

-- Show which line your cursor is on
vim.opt.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 10

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect'

-- NOTE: You should make sure your terminal supports this
-- vim.o.termguicolors = true

-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- word wrap
vim.keymap.set('n', '<leader>w', ":set wrap!<CR>", { silent = true })

-- Diagnostic keymaps
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })

-- copy path and file into clipboard
vim.keymap.set('n', '<leader>cp', "n:let @+=expand('%:p')<CR>", { silent = true })

-- Keybinds to make split navigation easier.
--  Use ALT+<hjkl> to switch between windows
--  See `:help wincmd` for a list of all window commands
vim.keymap.set('n', '<A-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<A-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<A-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<A-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- Terminal execution for python
vim.keymap.set('n', '<C-r>', ':sp <CR> :term python % <CR>', { desc = 'Executes actual buffer with python' })
vim.keymap.set('n', '<C-w>', ':bd!<CR>', { desc = 'Close teminal' })

-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
-- See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- rainbow csv filetype
vim.cmd([[
  autocmd FileType csv setlocal expandtab
  autocmd BufNewFile,BufRead *.csv set filetype=csv_semicolon
]])

-- vim.loader.enable()

-- [[ Install `lazy.nvim` plugin manager ]]
--    See `:help lazy.nvim.txt` or https://github.com/folke/lazy.nvim for more info
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then
    error('Error cloning lazy.nvim:\n' .. out)
  end
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  spec = {
    -- add LazyVim and import its plugins
    -- { "LazyVim/LazyVim", import = "lazyvim.plugins" },
    -- import/override with your plugins
    { import = "plugins" },
  },
  defaults = {
    -- By default, only LazyVim plugins will be lazy-loaded. Your custom plugins will load during startup.
    -- If you know what you're doing, you can set this to `true` to have all your custom plugins lazy-loaded by default.
    lazy = false,
    -- It's recommended to leave version=false for now, since a lot the plugin that support versioning,
    -- have outdated releases, which may break your Neovim install.
    version = false, -- always use the latest git commit
    -- version = "*", -- try installing the latest stable version for plugins that support semver
  },
  -- install = { colorscheme = { "tokyonight", "habamax" } },
  checker = {
    enabled = true, -- check for plugin updates periodically
    notify = false, -- notify on update
  }, -- automatically check for plugin updates
  performance = {
    rtp = {
      -- disable some rtp plugins
      disabled_plugins = {
        "gzip",
        -- "matchit",
        -- "matchparen",
        -- "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})
