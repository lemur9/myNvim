LemurVim.plugins["trans"] = {
  {
    "JuanZoran/Trans.nvim",
    build = function () require'Trans'.install() end,

    dependencies = { 'kkharji/sqlite.lua', },
    opts = {
      -- your configuration there
    }
  }
}
