local base16 = require "base16"

-- Theme that I like
-- A) everblush
-- B) onedark
-- C) UWU
-- D) everforest
-- E) rose_pine

_G.theme = "gruvbox"

local theme = _G.theme
local time = os.date "*t"

-- When its 7am or is equal or more than 9pm = onedark
-- if time.hour < 7 or time.hour >= 21 then
--     theme = "onedark"
-- else
--     theme = "everblush"
-- end

return base16(base16.themes(theme))
