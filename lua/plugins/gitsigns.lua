LemurVim.plugins.gitsigns = {
  "lewis6991/gitsigns.nvim",
  -- event = "LazyFile",
  opts = {
    signs = {
      add = { text = "▎" },
      change = { text = "▎" },
      delete = { text = "" },
      topdelete = { text = "" },
      changedelete = { text = "▎" },
      untracked = { text = "▎" },
    },
    signs_staged = {
      add = { text = "▎" },
      change = { text = "▎" },
      delete = { text = "" },
      topdelete = { text = "" },
      changedelete = { text = "▎" },
    },
    on_attach = function(buffer)
      local gs = package.loaded.gitsigns

      -- stylua: ignore start
      LemurVim.G.map("n", "]h", function()
        if vim.wo.diff then
          vim.cmd.normal({ "]c", bang = true })
        else
          gs.nav_hunk("next")
        end
      end, { buffer = buffer, desc = "下一个变更块", silent = true })

      LemurVim.G.map("n", "[h", function()
        if vim.wo.diff then
          vim.cmd.normal({ "[c", bang = true })
        else
          gs.nav_hunk("prev")
        end
      end,  { buffer = buffer, desc = "上一个变更块", silent = true })

      LemurVim.G.map("n", "]H", function() gs.nav_hunk("last") end, { buffer = buffer, desc = "最后一个变更块", silent = true })
      LemurVim.G.map("n", "[H", function() gs.nav_hunk("first") end, { buffer = buffer, desc = "第一个变更块", silent = true })

      LemurVim.G.map({ "n", "v" }, "<leader>ghs", ":Gitsigns stage_hunk<CR>",  { buffer = buffer, desc = "暂存当前块", silent = true })
      LemurVim.G.map({ "n", "v" }, "<leader>ghr", ":Gitsigns reset_hunk<CR>",  { buffer = buffer, desc = "重置当前块", silent = true })
      LemurVim.G.map("n", "<leader>ghS", gs.stage_buffer,  { buffer = buffer, desc = "暂存整个缓冲区", silent = true })
      LemurVim.G.map("n", "<leader>ghu", gs.undo_stage_hunk,  { buffer = buffer, desc = "撤销暂存块", silent = true })
      LemurVim.G.map("n", "<leader>ghR", gs.reset_buffer,  { buffer = buffer, desc = "重置整个缓冲区", silent = true })
      LemurVim.G.map("n", "<leader>ghp", gs.preview_hunk_inline,  { buffer = buffer, desc = "行内预览块", silent = true })
      LemurVim.G.map("n", "<leader>ghb", function() gs.blame_line({ full = true }) end,  { buffer = buffer, desc = "显示当前行作者信息", silent = true })
      LemurVim.G.map("n", "<leader>ghB", function() gs.blame() end,  { buffer = buffer, desc = "显示缓冲区作者信息", silent = true })
      LemurVim.G.map("n", "<leader>ghd", gs.diffthis,  { buffer = buffer, desc = "与索引比较", silent = true })
      LemurVim.G.map("n", "<leader>ghD", function() gs.diffthis("~") end,  { buffer = buffer, desc = "与上一个提交比较", silent = true })
      LemurVim.G.map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>",  { buffer = buffer, desc = "选择变更块", silent = true })
    end,
  }
}
