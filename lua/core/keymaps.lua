vim.g.mapleader = " "

local keymap = vim.keymap.set

-- keymap( { "模式" }, "快捷键", "命令", { remap = true }, { silent = true })
-- remap 递归映射
-- silent 清空command line
-- ------------------- 插入模式 ------------------- ---
keymap({ "i" }, "jk", "<ESC>", { silent = true })

-- ------------------- 视觉模式 ------------------- ---
-- 单行或多行移动
keymap({ "v" }, "J", ":m '>+1<CR>gv=gv", { silent = true })
keymap({ "v" }, "K", ":m '>-2<CR>gv=gv", { silent = true })

-- ------------------- 正常模式 ------------------- ---
-- 窗口
keymap({ "n" }, "<leader>sv", "<C-w>v", { silent = true })
keymap({ "n" }, "<leader>sh", "<C-w>s", { silent = true })
keymap({ "n" }, "<C-s>", "<Cmd>w<CR>", { silent = true })

-- ------------------- 多模式 ------------------- ---
keymap({ "n", "v" }, "<C-k>", "5k", { silent = true })
keymap({ "n", "v" }, "<C-j>", "5j", { silent = true })
keymap({ "n", "i" }, "<C-z>", "<Cmd>undo<CR>", { silent = true })

-- 取消高亮
keymap("n", "<leader>nh", ":nohl<CR>", { silent = true })

-- ------------------- 插件 ------------------- ---
-- tab切换
keymap("n", "<A-Left>", "<Cmd>BufferLineCyclePrev<CR>", { silent = true })
keymap("n", "<A-Right>", "<Cmd>BufferLineCycleNext<CR>", { silent = true })

-- 开启live-server
keymap("n", "<leader>lt", ":LiveServerToggle<CR>", { silent = true })

-- telescope
keymap("n", "<leader>ff", "<Cmd>Telescope find_files<CR>", { silent = true })
keymap("n", "<leader>fh", "<Cmd>Telescope find_files search_dirs=~<CR>", { silent = true })
keymap("n", "<leader>fg", "<Cmd>Telescope git_files<CR>", { silent = true })
keymap("n", "<leader>fo", "<Cmd>Telescope oldfiles<CR>", { silent = true })
keymap("n", "<leader>fb", "<Cmd>Telescope buffers<CR>", { silent = true })
keymap("n", "<leader>fl", "<Cmd>Telescope live_grep<CR>", { silent = true })
keymap("n", "<leader>fd", "<Cmd>Telescope diagnostics<CR>", { silent = true })
keymap("n", "<leader>fp", "<Cmd>Telescope projects<CR>", { silent = true })
keymap("n", "<leader>ft", "<Cmd>TodoTelescope<CR>", { silent = true })
