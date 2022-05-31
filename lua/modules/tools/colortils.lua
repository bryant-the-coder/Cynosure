local present, color = pcall(require, "colortils")
if not present then
    return
end

color.setup({
    register = "+", -- register in which color codes will be copied: any register
    color_display = "block", -- how to display the color: "block" or "hex"
})
