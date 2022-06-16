-- HACK: Make this working again
require("dapui").setup()

local dap = require "dap"
dap.adapters.python = {
    type = "executable",
    command = "/Users/mater/.virtualenvs/debugpy/bin/python3.9",
    args = { "-m", "debugpy.adapter" },
}

dap.configurations.python = {
    {
        -- The first three options are required by nvim-dap
        type = "python", -- the type here established the link to the adapter definition: `dap.adapters.python`
        request = "launch",
        name = "Launch file",

        -- Options below are for debugpy, see https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings for supported options

        justMyCode = true,
        program = "${file}", -- This configuration will launch the current file if used.
        pythonPath = function()
            -- debugpy supports launching an application with a different interpreter then the one used to launch debugpy itself.
            -- The code below looks for a `venv` or `.venv` folder in the current directly and uses the python within.
            -- You could adapt this - to for example use the `VIRTUAL_ENV` environment variable.
            local cwd = vim.fn.getcwd()
            if vim.fn.executable(cwd .. "/env/bin/python") == 1 then
                return cwd .. "/env/bin/python"
            elseif vim.fn.executable(cwd .. "/.env/bin/python") == 1 then
                return cwd .. "/.env/bin/python"
            else
                return "/usr/bin/python3"
            end
        end,
    },
}

require("dap-python").setup "C:/Users/User/AppData/Local/Programs/Python/Python310/python.exe"

require("dap-python").test_runner = "pytest"

vim.keymap.set("n", "<leader>dn", function()
    require("dap-python").test_method()
end)
vim.keymap.set("n", "<leader>dn", function()
    require("dap-python").test_class()
end)

vim.keymap.set("n", "<leader>ds", function()
    require("dap-python").debug_selection()
end)
