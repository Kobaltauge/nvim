if vim.g.nvy then
  vim.o.guifont = "Cousine Nerd Font:h10"
  vim.cmd("cd %:p:h")
end

if vim.g.neovide then
  vim.o.guifont = "Cousine Nerd Font:h10"
  vim.cmd("cd %:p:h")
  -- vim.keymap.set('n', '<D-s>', ':w<CR>') -- Save
  -- vim.keymap.set('v', '<D-c>', '"+y') -- Copy
  -- vim.keymap.set('n', '<D-v>', '"+P') -- Paste normal mode
  -- vim.keymap.set('v', '<D-v>', '"+P') -- Paste visual mode
  -- vim.keymap.set('c', '<D-v>', '<C-R>+') -- Paste command mode
  -- vim.keymap.set('i', '<D-v>', '<ESC>l"+Pli') -- Paste insert mode
end

-- Allow clipboard copy paste in neovim
vim.api.nvim_set_keymap('', '<D-v>', '+p<CR>', { noremap = true, silent = true})
vim.api.nvim_set_keymap('!', '<D-v>', '<C-R>+', { noremap = true, silent = true})
vim.api.nvim_set_keymap('t', '<D-v>', '<C-R>+', { noremap = true, silent = true})
vim.api.nvim_set_keymap('v', '<D-v>', '<C-R>+', { noremap = true, silent = true})

if vim.fn.has("unix") == 1 and string.match(vim.fn.system("uname"), "Linux") then
  vim.o.shell = "/bin/bash"
end

if (vim.g.vscode) then
  -- VSCode extension
  require("config.vim-options-vsc")
else
  require("config.vim-options")
end


