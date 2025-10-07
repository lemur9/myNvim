local G = require('core.G')

-- 以下是for不同文件类型的相关配置

local function _markdown()
    -- 自定义语法高亮组
    G.hi({
        -- 待办日期 (深蓝)
        ["MDTodoDate"] = {
            fg = "#5c4aff",
            bold = true,
            italic = false
        },
        -- 完成日期 (浅蓝)
        ["MDDoneDate"] = {
            fg = "#c0caf5",
            italic = true,
            strikethrough = true
        },
        -- 待办文本 (浅蓝)
        ["MDTodoText"] = {
            fg = "#c0caf5",
            italic = false
        },
        -- 完成文本 (浅绿) 
        ["MDDoneText"] = {
            fg = "#9ece6a",
            italic = true,
            strikethrough = true
        },
        -- 截止日期 (大红)
        ["MDDeadline"] = {
            fg = "#fa2828",
            bold = true,
            underline = true
        },
        -- 临近日期 (粉红)
        ["MDNearline"] = {
            fg = "#fa6e6e",
            bold = true
        }
    })
    -- 匹配并高亮截止日期和临近日期
    G.command([[
        call matchadd('MDDeadline', 'D:'.strftime("%Y-%m-%d"))
        call matchadd('MDNearline', 'D:'.strftime("%Y-%m-%d", localtime() + 3600 * 24))
        call matchadd('MDNearline', 'D:'.strftime("%Y-%m-%d", localtime() + 3600 * 48))
    ]])
    -- 键位映射
    G.map({
        { "n", "<cr>", ":call v:lua.G_markdown_toggleCheck(0)<cr><cr>", { noremap = true, silent = true, buffer = true } },
        { "n", "<2-LeftMouse>", ":call v:lua.G_markdown_toggleCheck(1)<cr><2-LeftMouse>", { noremap = true, silent = true, buffer = true } },
    })
    -- 延迟加载语法规则
    G.command("call timer_start(0, 'v:lua.G_markdown_loadafter')")
end

local map = {
    markdown = _markdown,
}

for filetype, func in pairs(map) do
    G.api.nvim_create_autocmd({ "FileType" }, {
        pattern = { filetype },
        callback = function ()
            if G.b.loaded == 1 then return end; G.b.loaded = 1
            func()
        end
    })
end

-- 部分需要暴露到全局的函数
function G_markdown_loadafter()
    G.command([[syn match markdownError "\w\@<=\w\@="]])
    G.command([[syn match MDDoneDate /[SD]:\d\{4\}\([\/-]\d\d\)\{2\}/ contained]])      -- 完成事项的日期匹配
    G.command([[syn match MDTodoDate /[SD]:\d\{4\}\([\/-]\d\d\)\{2\}/ contained]])      -- 待办事项的日期匹配
    G.command([[syn match MDDoneText /- \[x\] \zs.*/ contains=MDDoneDate contained]])   -- 已完成任务的文本匹配
    G.command([[syn match MDTodoText /- \[ \] \zs.*/ contains=MDTodoDate contained]])   -- 未完成任务的文本匹配
    G.command([[syn match MDTask /- \[\(x\| \)\] .*/ contains=MDDoneText,MDTodoText]])  -- 通用任务行匹配
    G.command([[
        let b:md_block = '```'
        setlocal shiftwidth=2
        setlocal softtabstop=2
        setlocal tabstop=2
    ]])
end

function G_markdown_toggleCheck(needsave)
    local line = G.fn.getline('.')
    if line:match('^%s*- %[ %]') then line = line:gsub('%[ %]', '[x]')
    elseif line:match('^%s*- %[x%]') then line = line:gsub('%[x%]', '[ ]')
    else return end
    G.fn.setline('.', line)
    if needsave then G.command('w') end
end
