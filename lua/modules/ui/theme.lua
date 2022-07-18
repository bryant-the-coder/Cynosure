local base16 = require "base16"

-- Theme that I like
-- A) everblush
-- B) everforest
-- C) mocha

_G.theme = "onedark"

local theme = _G.theme

return base16(base16.themes(theme))
