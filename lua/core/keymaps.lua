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
