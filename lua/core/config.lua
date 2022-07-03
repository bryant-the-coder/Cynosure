local config = {}

config.plugins = {
    -- WARN: Dont disable this
    plenary = false,
    icons = false,
    base16 = false,
    nui = false,

    -----------------------------------
    --           Completion          --
    -----------------------------------
    cmp = false,
    cmp_luasnip = false,
    cmp_lsp = false,
    cmp_buffer = false,
    cmp_path = false,
    luasnip = false,
    friendly_snippets = false,
    autopairs = false,

    -----------------------------------
    --             Editor            --
    -----------------------------------
    impatient = false,
    comment = false,
    commentstring = false,
    neorg = false,
    neorg_kaban = false,
    neorg_telescope = false,

    -----------------------------------
    --              Files            --
    -----------------------------------
    nvim_tree = true,
    neotree = false,
    harpoon = false,
    telescope = false,
    telescope_fzf_native = false,
    telescope_file_browser = false,
    formatter = true,
    neogen = false,
    null = false,
    treesitter = false,
    ts_rainbow = false,
    autotag = true,
    playground = false,
    ts_context = false,
    trouble = false,
    lsp = false,
    lsp_installer = false,
    lua_dev = false,
    clangd_ext = true,
    lsp_signature = false,
    lspsaga = true,

    -----------------------------------
    --             Tools             --
    -----------------------------------
    colorizer = false,
    colortils = false,
    fidget = false,
    toggleterm = true,
    gitsigns = false,
    paperplanes = false,
    lightspeed = false,
    todo_comments = false,
    nvim_surround = true,

    -----------------------------------
    --               UI              --
    -----------------------------------
    bufferline = false,
    indent_blankline = false,
    notify = false,
    satellite = false,
}

return config
