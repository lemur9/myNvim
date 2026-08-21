vim.g.mapleader = " "

local keymap = vim.keymap.set

-- ==================== 插入模式 ====================
keymap({ "i" }, "jk", "<ESC>", { silent = true, desc = "退出插入模式" })

-- ==================== 视觉模式 ====================
keymap({ "v" }, "J", ":m '>+1<CR>gv=gv", { silent = true, desc = "向下移动选中行" })
keymap({ "v" }, "K", ":m '>-2<CR>gv=gv", { silent = true, desc = "向上移动选中行" })

-- ==================== 正常模式 ====================
-- 窗口分割
keymap({ "n" }, "<leader>sv", "<C-w>v", { silent = true, desc = "垂直分割窗口" })
keymap({ "n" }, "<leader>sh", "<C-w>s", { silent = true, desc = "水平分割窗口" })
keymap({ "n" }, "<C-s>", "<Cmd>w<CR>", { silent = true, desc = "保存文件" })

-- ==================== 多模式 ====================
keymap({ "n", "v" }, "<C-k>", "5k", { silent = true, desc = "向上移动 5 行" })
keymap({ "n", "v" }, "<C-j>", "5j", { silent = true, desc = "向下移动 5 行" })
keymap({ "n", "i" }, "<C-z>", "<Cmd>undo<CR>", { silent = true, desc = "撤销" })

-- 取消搜索高亮
keymap("n", "<leader>nh", ":nohl<CR>", { silent = true, desc = "取消搜索高亮" })

-- ==================== 插件 ====================
-- 缓冲区切换
keymap("n", "<A-Left>", "<Cmd>BufferLineCyclePrev<CR>", { silent = true, desc = "上一个缓冲区" })
keymap("n", "<A-Right>", "<Cmd>BufferLineCycleNext<CR>", { silent = true, desc = "下一个缓冲区" })

-- Live Server
keymap("n", "<leader>lt", ":LiveServerToggle<CR>", { silent = true, desc = "切换 Live Server" })

-- 切换主题
keymap("n", "<leader>uC", function()
  LemurVim.colorscheme.select()
end, { silent = true, desc = "切换主题" })
