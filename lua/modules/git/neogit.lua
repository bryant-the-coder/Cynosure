local status_ok, neogit = pcall(require, "neogit")
if not status_ok then
    return
end

neogit.setup {
    disable_signs = false,
    disable_context_highlighting = false,
    disable_commit_confirmation = false, -- nah i like this
    disable_hint = false,
    auto_refresh = true,
    disable_builtin_notifications = true,
    use_magit_keybindings = true,
    disable_insert_on_commit = false,
    signs = {
        section = { "", "" }, -- "", ""
        item = { "▸", "▾" },
        hunk = { "樂", "" },
    },
    integrations = {
        diffview = true,
    },
    -- override/add mappings
    mappings = {
        -- modify status buffer mappings
        status = {
            -- adds a mapping with "b" as key that does the "branchpopup" command
            ["b"] = "branchpopup",
            -- removes the default mapping of "s"
        },
    },
}
