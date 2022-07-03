local base16 = require "base16"

-- Theme that I like
-- A) everblush
-- B) onedark
-- C) UWU
-- D) everforest
-- E) rose_pine

_G.theme = "everblush"

local theme = _G.theme
local time = os.date "*t"

return base16(base16.themes(theme))
