---@diagnostic disable: undefined-global
local module = [[
local M = {}

${1:code}

return M
]]

local mappings = [[
map("$1", "$2", "<cmd>$0<CR>")
]]

local status = [[
local status_ok, ${1:module_var_name} = pcall(require, "${2:module_name}")
if not status_ok then
    return
end
]]

return {
    parse({ trig = "M" }, module),
    parse({ trig = "map" }, mappings),
    parse({ trig = "status" }, status),
}
