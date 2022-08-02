local status_ok, color = pcall(require, "colorizer")
if not status_ok then
    return
end
require("colorizer").setup({
    "*",
}, {
    mode = "background",
    hsl_fn = true,
    RRGGBBAA = true,
    rgb_fn = true,
    css = true,
    css_fn = true,
})
