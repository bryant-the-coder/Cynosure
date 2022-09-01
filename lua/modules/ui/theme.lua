local base16 = require "base16"

-- Theme that I like:
-- A) onedark
-- B) kanagawa
-- C) everforest
-- D) mocha

_G.theme = "doom_one"

local theme = _G.theme

return base16(base16.themes(theme))
