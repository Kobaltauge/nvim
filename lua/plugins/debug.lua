return {
  {
  "mfussenegger/nvim-dap",
    dependencies = {
      -- must be installed into virtual environment specified in "setup"
      -- debugpy/bin/python -m pip install debugpy
    "mfussenegger/nvim-dap-python",
      "leoluz/nvim-dap-go",
      "rcarriga/nvim-dap-ui",
      "nvim-neotest/nvim-nio",
    },
  config = function()
    require("dapui").setup()
    require("dap-go").setup()
    require("dap-python").setup('~/.virtualenvs/debugpy/bin/python')
    -- DAPUI
    local dap, dapui = require("dap"), require("dapui")

    dap.listeners.before.attach.dapui_config = function()
      dapui.open()
    end
    dap.listeners.before.launch.dapui_config = function()
      dapui.open()
    end
    dap.listeners.before.event_terminated.dapui_config = function()
      dapui.close()
    end
    dap.listeners.before.event_exited.dapui_config = function()
      dapui.close()
    end
      table.insert(dap.configurations.python, {
      type = 'python',
      request = 'launch',
      name = "Launch file",
      program = "${file}";
      pythonPath = function()
          local cwd = vim.fn.getcwd()
          if vim.fn.executable(cwd .. '/venv/bin/python') == 1 then
            return cwd .. '/venv/bin/python'
          elseif vim.fn.executable(cwd .. '/.venv/bin/python') == 1 then
            return cwd .. '/.venv/bin/python'
          else
            return '/usr/bin/python'
          end
        end;
      })
    -- Keybindngs
    vim.keymap.set("n", "<Leader>dt", ":DapToggleBreakpoint<CR>")
    vim.keymap.set("n", "<Leader>dc", ":DapContinue<CR>")
    vim.keymap.set("n", "<F5>", ":DapContinue<CR>")
    vim.keymap.set("n", "<Leader>dx", ":DapTerminate<CR>")
    vim.keymap.set("n", "<F10>", ":DapStepOver<CR>")
  end,
},
}
