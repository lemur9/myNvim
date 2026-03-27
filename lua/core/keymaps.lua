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

-- lsp 快捷键设置
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspConfig", { clear = true }),
  callback = function(ev)
    vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

    local opts = { buffer = ev.buf }
    -- 查看文档（hover）
    keymap("n", "K", vim.lsp.buf.hover, opts)
    -- 跳转定义
    keymap("n", "<space>gd", vim.lsp.buf.definition, opts)
    -- 跳转声明
    keymap('n', 'gD', vim.lsp.buf.declaration, opts)
    -- 查找引用
    keymap('n', 'gr', function()
      local params = vim.lsp.util.make_position_params()
      params.context = { includeDeclaration = false }
      vim.lsp.buf_request(ev.buf, 'textDocument/references', params, function(err, result)
        if err then
          vim.notify("LSP references request failed: " .. (err.message or "unknown error"), vim.log.levels.WARN)
          return
        end

        if not result or vim.tbl_isempty(result) then
          vim.notify("No references found", vim.log.levels.INFO)
          return
        end

        local items = {}
        for _, v in ipairs(result) do
          table.insert(items, {
            filename = vim.uri_to_fname(v.uri),
            lnum = v.range.start.line + 1,
            col = v.range.start.character + 1,
            text = "reference",
          })
        end
        vim.fn.setqflist({}, ' ', { title = 'LSP References', items = items })
        vim.cmd('copen')
      end)
    end, opts)
    -- 跳转实现
    -- 重命名
    keymap("n", "<space>rn", vim.lsp.buf.rename, opts)
    -- 代码操作
    keymap({ "n", "v" }, "<space>ca", vim.lsp.buf.code_action, opts)

    -- 诊断快捷键
    vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
    vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
    vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
  end,
})

-- fzf-lua 快捷键 (全部迁移)
local picker = require("plugins.fzf.picker")

-- 文件查找
keymap("n", "<leader>ff", function() picker.safe_pick_call("files") end, { desc = "Find Files (Root Dir)" })
keymap("n", "<leader>fF", function() picker.safe_pick_call("files", { root = false }) end, { desc = "Find Files (cwd)" })
keymap("n", "<leader>fg", "<cmd>FzfLua git_files<cr>", { desc = "Find Files (git-files)" })
keymap("n", "<leader>fb", function() picker.safe_pick_call("buffers", { sort_mru=true, sort_lastused=true }) end, { desc = "Buffers" })
keymap("n", "<leader>fB", "<cmd>FzfLua buffers<cr>", { desc = "Buffers (all)" })
keymap("n", "<leader>fr", "<cmd>FzfLua oldfiles<cr>", { desc = "Recent" })
keymap("n", "<leader>fR", function() picker.safe_pick_call("oldfiles", { cwd = vim.uv.cwd() }) end, { desc = "Recent (cwd)" })
keymap("n", "<leader>fc", function() 
  if _G.LemurVim and LemurVim.pick and LemurVim.pick.config_files then
    local pick_func = LemurVim.pick.config_files()
    if pick_func then pick_func() end
  else
    picker.safe_pick_call("files", { cwd = vim.fn.stdpath("config") })
  end
end, { desc = "Find Config File" })

-- Git 操作
keymap("n", "<leader>gc", "<cmd>FzfLua git_commits<CR>", { desc = "Commits" })
keymap("n", "<leader>gd", "<cmd>FzfLua git_diff<cr>", { desc = "Git Diff (hunks)" })
keymap("n", "<leader>gl", "<cmd>FzfLua git_commits<CR>", { desc = "Commits" })
keymap("n", "<leader>gs", "<cmd>FzfLua git_status<CR>", { desc = "Status" })
keymap("n", "<leader>gS", "<cmd>FzfLua git_stash<cr>", { desc = "Git Stash" })

-- 搜索
keymap("n", "<leader>/", function() picker.safe_pick_call("live_grep") end, { desc = "Grep (Root Dir)" })
keymap("n", "<leader>sg", function() picker.safe_pick_call("live_grep") end, { desc = "Grep (Root Dir)" })
keymap("n", "<leader>sG", function() picker.safe_pick_call("live_grep", { root = false }) end, { desc = "Grep (cwd)" })
keymap("n", "<leader>sw", function() picker.safe_pick_call("grep_cword") end, { desc = "Word (Root Dir)" })
keymap("n", "<leader>sW", function() picker.safe_pick_call("grep_cword", { root = false }) end, { desc = "Word (cwd)" })
keymap("x", "<leader>sw", function() picker.safe_pick_call("grep_visual") end, { desc = "Selection (Root Dir)" })
keymap("x", "<leader>sW", function() picker.safe_pick_call("grep_visual", { root = false }) end, { desc = "Selection (cwd)" })

-- 符号搜索
keymap("n", "<leader>ss", function()
  require("fzf-lua").lsp_document_symbols({
    regex_filter = picker.symbols_filter,
  })
end, { desc = "Goto Symbol" })
keymap("n", "<leader>sS", function()
  require("fzf-lua").lsp_live_workspace_symbols({
    regex_filter = picker.symbols_filter,
  })
end, { desc = "Goto Symbol (Workspace)" })

-- 其他搜索
keymap("n", '<leader>s"', "<cmd>FzfLua registers<cr>", { desc = "Registers" })
keymap("n", "<leader>s/", "<cmd>FzfLua search_history<cr>", { desc = "Search History" })
keymap("n", "<leader>sa", "<cmd>FzfLua autocmds<cr>", { desc = "Auto Commands" })
keymap("n", "<leader>sb", "<cmd>FzfLua lines<cr>", { desc = "Buffer Lines" })
keymap("n", "<leader>sc", "<cmd>FzfLua command_history<cr>", { desc = "Command History" })
keymap("n", "<leader>sC", "<cmd>FzfLua commands<cr>", { desc = "Commands" })
keymap("n", "<leader>sd", "<cmd>FzfLua diagnostics_workspace<cr>", { desc = "Diagnostics" })
keymap("n", "<leader>sD", "<cmd>FzfLua diagnostics_document<cr>", { desc = "Buffer Diagnostics" })
keymap("n", "<leader>sh", "<cmd>FzfLua help_tags<cr>", { desc = "Help Pages" })
keymap("n", "<leader>sH", "<cmd>FzfLua highlights<cr>", { desc = "Search Highlight Groups" })
keymap("n", "<leader>sj", "<cmd>FzfLua jumps<cr>", { desc = "Jumplist" })
keymap("n", "<leader>sk", "<cmd>FzfLua keymaps<cr>", { desc = "Key Maps" })
keymap("n", "<leader>sl", "<cmd>FzfLua loclist<cr>", { desc = "Location List" })
keymap("n", "<leader>sM", "<cmd>FzfLua man_pages<cr>", { desc = "Man Pages" })
keymap("n", "<leader>sm", "<cmd>FzfLua marks<cr>", { desc = "Jump to Mark" })
keymap("n", "<leader>sR", "<cmd>FzfLua resume<cr>", { desc = "Resume" })
keymap("n", "<leader>sq", "<cmd>FzfLua quickfix<cr>", { desc = "Quickfix List" })

-- 其他快捷键
keymap("n", "<leader><space>", function() picker.safe_pick_call("files") end, { desc = "Find Files (Root Dir)" })
keymap("n", "<leader>,", function() picker.safe_pick_call("buffers", { sort_mru=true, sort_lastused=true }) end, { desc = "Switch Buffer" })
keymap("n", "<leader>:", "<cmd>FzfLua command_history<cr>", { desc = "Command History" })
keymap("n", "<leader>uC", function() picker.safe_pick_call("colorschemes") end, { desc = "Colorscheme with Preview" })

-- fzf 模式专用快捷键
keymap("t", "<c-j>", "<c-j>", { ft = "fzf", nowait = true })
keymap("t", "<c-k>", "<c-k>", { ft = "fzf", nowait = true })

-- todo-comments 快捷键
keymap("n", "<leader>st", function() require("todo-comments.fzf").todo() end, { desc = "Todo" })
keymap("n", "<leader>sT", function () require("todo-comments.fzf").todo({ keywords = { "TODO", "FIX", "FIXME" } }) end, { desc = "Todo/Fix/Fixme" })

-- markdown 快捷键
keymap("n", "<leader>mk", "<cmd>MarkdownPreviewToggle<cr>", { desc = "Toggle Markdown Preview" })

-- snacks 快捷键
keymap("n", "<leader>ca", function() require("snacks").lsp.code_actions() end, { desc = "Code Actions" })
keymap("n", "<leader>nf", function() require("snacks").picker.files() end, { desc = "Find Files" })
keymap("n", "<leader>nh", function() require("snacks").notifier.show_history() end, { desc = "Notification History" })

-- trans 快捷键
keymap({ "n", "x" }, "mm", "<Cmd>Translate<CR>", { desc = "󰊿 Translate" })
keymap({ "n", "x" }, "mk", "<Cmd>TransPlay<CR>", { desc = " Auto Play" })
keymap("n", "mi", "<Cmd>TranslateInput<CR>", { desc = "󰊿 Translate From Input" })

-- neo-tree 快捷键
keymap("n", "<leader>fe", function()
  local root_dir = vim.uv.cwd()
  if _G.LemurVim and LemurVim.root then
    pcall(function()
      root_dir = LemurVim.root()
    end)
  end
  require("neo-tree.command").execute({ toggle = true, dir = root_dir })
end, { desc = "Explorer NeoTree (Root Dir)" })
keymap("n", "<leader>fE", function()
  require("neo-tree.command").execute({ toggle = true, dir = vim.uv.cwd() })
end, { desc = "Explorer NeoTree (cwd)" })
keymap("n", "<leader>e", "<leader>fe", { desc = "Explorer NeoTree (Root Dir)", remap = true })
keymap("n", "<leader>E", "<leader>fE", { desc = "Explorer NeoTree (cwd)", remap = true })
keymap("n", "<leader>ge", function()
  require("neo-tree.command").execute({ source = "git_status", toggle = true })
end, { desc = "Git Explorer" })
keymap("n", "<leader>be", function()
  require("neo-tree.command").execute({ source = "buffers", toggle = true })
end, { desc = "Buffer Explorer" })
keymap("n", "<leader>ee", function()
  require("neo-tree.command").execute({
    source = "filesystem",
    toggle = false,
    reveal = true,
  })
end, { desc = "Jump to Tree (filesystem)" })

-- gitsigns 快捷键 (在插件配置中定义，但为完整性列出)
-- 注意：这些快捷键在 gitsigns.lua 的 on_attach 中定义，使用 buffer-local 映射
-- 主要快捷键包括：
-- ]h/[h - 下一个/上一个变更块
-- <leader>ghs - 暂存当前块
-- <leader>ghr - 重置当前块
-- <leader>ghS - 暂存整个缓冲区
-- <leader>ghu - 撤销暂存块
-- <leader>ghR - 重置整个缓冲区
-- <leader>ghp - 行内预览块
-- <leader>ghb - 显示当前行作者信息
-- <leader>ghB - 显示缓冲区作者信息
-- <leader>ghd - 与索引比较
-- <leader>ghD - 与上一个提交比较
-- ih - 选择变更块
