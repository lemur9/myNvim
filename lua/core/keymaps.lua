vim.g.mapleader = " "

local keymap = vim.keymap.set

-- ------------------- 插入模式 ------------------- ---
keymap({ "i", "v" }, "jk", "<ESC>")

-- ------------------- 视觉模式 ------------------- ---
-- 单行或多行移动
keymap({ "v" }, "J", ":m '>+1<CR>gv=gv")
keymap({ "v" }, "K", ":m '>-2<CR>gv=gv")

-- ------------------- 正常模式 ------------------- ---
-- 窗口
keymap({ "n" }, "<leader>sv", "<C-w>v")
keymap({ "n" }, "<leader>sh", "<C-w>s")

keymap({ "n", "v" }, "<C-k>", "5k")
keymap({ "n", "v" }, "<C-j>", "5j")

-- 取消高亮
keymap("n", "<leader>nh", ":nohl<CR>")

-- ------------------- 插件 ------------------- ---
-- nvim-tree
keymap("n", "<leader>e", ":NvimTreeToggle<CR>")

-- tab切换
keymap("n", "<A-Left>", ":BufferLineCyclePrev<CR>")
keymap("n", "<A-Right>", ":BufferLineCycleNext<CR>")

-- 开启live-server
keymap("n", "<leader>lt",":LiveServerToggle<CR>")

-- telescope
keymap("n", "<leader>ff", "<Cmd>Telescope find_files<CR>")
keymap("n", "<leader>fh", "<Cmd>Telescope find_files search_dirs=~<CR>")
keymap("n", "<leader>fg", "<Cmd>Telescope git_files<CR>")
keymap("n", "<leader>fo", "<Cmd>Telescope oldfiles<CR>")
keymap("n", "<leader>fb", "<Cmd>Telescope buffers<CR>")
keymap("n", "<leader>fl", "<Cmd>Telescope live_grep<CR>")
keymap("n", "<leader>fd", "<Cmd>Telescope diagnostics<CR>")
keymap("n", "<leader>fp", "<Cmd>Telescope projects<CR>")
keymap("n", "<leader>ft", "<Cmd>TodoTelescope<CR>")
