local M = {}

--- 设置诊断显示配置
function M.setup_diagnostics()
  local icons = LemurVim.config.icons.diagnostics
  vim.diagnostic.config({
    -- 错误信息提示
    virtual_text = true,
    -- 在输入模式下也更新提示，设置为 true 也许会影响性能
    update_in_insert = true,
    float = { border = 'rounded' },
    signs = {
      text = {
        [vim.diagnostic.severity.ERROR] = icons.Error,
        [vim.diagnostic.severity.WARN]  = icons.Warn,
        [vim.diagnostic.severity.INFO]  = icons.Info,
        [vim.diagnostic.severity.HINT]  = icons.Hint,
      },
      numhl = {
        [vim.diagnostic.severity.ERROR] = "DiagnosticSignError",
        [vim.diagnostic.severity.WARN]  = "DiagnosticSignWarn",
        [vim.diagnostic.severity.INFO]  = "DiagnosticSignInfo",
        [vim.diagnostic.severity.HINT]  = "DiagnosticSignHint",
      },
    },
  })
end

--- 获取 LSP 处理函数
function M.get_handlers()
   -- 浮动窗口边框
  require('lspconfig.ui.windows').default_options.border = 'rounded'
  return {
    ['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, { border = 'rounded' }),
    ['textDocument/signatureHelp'] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = 'rounded' }),
  }
end

--- 获取 LSP 能力配置（支持 blink.cmp）
function M.get_capabilities()
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  local ok_blink, blink = pcall(require, "blink.cmp")
  if ok_blink and blink.get_lsp_capabilities then
    capabilities = blink.get_lsp_capabilities(capabilities)
  end
  return capabilities
end

--- 获取 LSP 附件处理函数
function M.get_on_attach()
  return function(client, bufnr)
     -- 高亮光标下的符号
    if client.server_capabilities.documentHighlightProvider then
      vim.api.nvim_create_augroup('lsp_document_highlight', {
        clear = false,
      })
      vim.api.nvim_clear_autocmds({
        buffer = bufnr,
        group = 'lsp_document_highlight',
      })
      vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
        group = 'lsp_document_highlight',
        buffer = bufnr,
        callback = function()
          vim.lsp.buf.document_highlight()
        end,
      })
      vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
        group = 'lsp_document_highlight',
        buffer = bufnr,
        callback = function()
          vim.lsp.buf.clear_references()
        end,
      })
    end
  end
end

return M