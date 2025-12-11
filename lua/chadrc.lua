-- This file needs to have same structure as nvconfig.lua 
-- https://github.com/NvChad/ui/blob/v3.0/lua/nvconfig.lua
-- Please read that file to know all available options :( 

---@type ChadrcConfig
local M = {}

M.base46 = {
	theme = "oxocarbon",
}

-- M.plugins = {
--   ["nvim-telescope/telescope.nvim"] = {
--     override_options = {
--       defaults = {
--         vimgrep_arguments = {
--           'rg',
--           '--color=never',
--           '--no-heading',
--           '--with-filename',
--           '--line-number',
--           '--column',
--           '--smart-case',
--           '--hidden',
--           '--glob=!.git/*',
--           '--glob=!node_modules/*',
--         },
--       },
--     },
--   },
-- }

return M
