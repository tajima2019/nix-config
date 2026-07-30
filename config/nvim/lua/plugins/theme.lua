-- TokyoNightのインストールと設定
-- return {
--   {
--     "folke/tokyonight.nvim",
--     lazy = false,
--     priority = 1000,
--     config = function()
--       require("tokyonight").setup({
--         transparent = true,
--         styles = {
--           sidebars = "transparent",
--           floats = "transparent",
--         },
--       })
--       vim.cmd([[colorscheme tokyonight]])
--     end,
--   },
-- }

-- Kanagawaのインストールと設定
return {
  {
    "rebelot/kanagawa.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("kanagawa").setup({
        compile = true,
        undercurl = true,
        commandStyle = { italic = true },
        keywordStyle = { italic = true },
        statementStyle = { bold = true },
        transparent = true,
      })
      vim.cmd("colorscheme kanagawa")
    end,
  },
}
