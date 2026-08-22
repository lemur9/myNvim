# LemurVim 快捷键中文导航

> 本文档按模块整理当前 Neovim 配置的全部快捷键，与 `lua/` 下的配置一一对应。
> **Leader 键为空格（`<space>`）**，下文 `<leader>` 均表示空格。表中「模式」列：n=正常、i=插入、v=可视（字符）、x=可视（行/块）、t=终端。

## 目录

- [〇、前缀速查](#〇前缀速查)
- [一、核心快捷键](#一核心快捷键)
- [二、模糊查找 fzf-lua](#二模糊查找-fzf-lua)
- [三、文件树 neo-tree](#三文件树-neo-tree)
- [四、LSP 语言服务](#四lsp-语言服务)
- [五、代码补全 blink.cmp](#五代码补全-blinkcmp)
- [六、Git gitsigns](#六git-gitsigns)
- [七、Markdown 与待办系统](#七markdown-与待办系统)
- [八、翻译 Trans.nvim](#八翻译-transnvim)
- [九、主题切换](#九主题切换)
- [十、IDE 舒适度插件](#十ide-舒适度插件)
- [十一、其他工具](#十一其他工具)
- [十二、代码片段触发器](#十二代码片段触发器)
- [十三、Neovim 默认快捷键](#十三neovim-默认快捷键)

---

## 〇、前缀速查

| 前缀 | 功能 | 示例 |
|------|------|------|
| `<leader>f` | 文件 / 缓冲区查找 | `ff` 查找文件 |
| `<leader>g` | Git（fzf-lua） | `gs` Git 状态 |
| `<leader>s` | 搜索 / 符号 | `sg` Grep 搜索 |
| `<leader>gh` | Git 变更块（gitsigns） | `ghs` 暂存当前块 |
| `<leader>e` / `<leader>E` | 文件树 | `e` 文件树（根目录） |
| `<space>g` | LSP 跳转 | `<space>gd` 跳转到定义 |
| `<leader>u` | 工具 | `uC` 切换主题 |

---

## 一、核心快捷键

来源：`lua/core/keymaps.lua`

### 插入模式

| 按键 | 模式 | 说明 |
|------|------|------|
| `jk` | i | 退出插入模式 |

### 可视模式

| 按键 | 模式 | 说明 |
|------|------|------|
| `J` | v | 向下移动选中行 |
| `K` | v | 向上移动选中行 |

### 正常模式

| 按键 | 模式 | 说明 |
|------|------|------|
| `<leader>sv` | n | 垂直分割窗口 |
| `<leader>sh` | n | 水平分割窗口 |
| `<C-s>` | n | 保存文件 |
| `<leader>nh` | n | 取消搜索高亮 |
| `<A-Left>` | n | 上一个缓冲区 |
| `<A-Right>` | n | 下一个缓冲区 |
| `<leader>lt` | n | 切换 Live Server |
| `<leader>uC` | n | 切换主题 |

### 多模式

| 按键 | 模式 | 说明 |
|------|------|------|
| `<C-k>` | n, v | 向上移动 5 行 |
| `<C-j>` | n, v | 向下移动 5 行 |
| `<C-z>` | n, i | 撤销 |

---

## 二、模糊查找 fzf-lua

来源：`lua/plugins/fzf.lua`。`<leader><space>` 是最常用的「查找文件」。

### 文件 / 缓冲区

| 按键 | 模式 | 说明 |
|------|------|------|
| `<leader><space>` | n | 查找文件（根目录） |
| `<leader>ff` | n | 查找文件（根目录） |
| `<leader>fF` | n | 查找文件（当前目录） |
| `<leader>fg` | n | 查找文件（Git 跟踪） |
| `<leader>fr` | n | 最近文件 |
| `<leader>fR` | n | 最近文件（当前目录） |
| `<leader>fc` | n | 查找配置文件 |
| `<leader>,` | n | 切换缓冲区 |
| `<leader>fb` | n | 缓冲区 |
| `<leader>fB` | n | 缓冲区（全部） |

### Git

| 按键 | 模式 | 说明 |
|------|------|------|
| `<leader>gc` | n | Git 提交 |
| `<leader>gl` | n | Git 提交 |
| `<leader>gd` | n | Git 差异 |
| `<leader>gs` | n | Git 状态 |
| `<leader>gS` | n | Git 储藏 |

### 搜索

| 按键 | 模式 | 说明 |
|------|------|------|
| `<leader>/` | n | Grep 搜索（根目录） |
| `<leader>sg` | n | Grep 搜索（根目录） |
| `<leader>sG` | n | Grep 搜索（当前目录） |
| `<leader>sw` | n | 搜索当前词（根目录） |
| `<leader>sW` | n | 搜索当前词（当前目录） |
| `<leader>sw` | x | 搜索选中内容（根目录） |
| `<leader>sW` | x | 搜索选中内容（当前目录） |
| `<leader>s/` | n | 搜索历史 |

### 符号 / 跳转

| 按键 | 模式 | 说明 |
|------|------|------|
| `<leader>ss` | n | 跳转符号（当前文档） |
| `<leader>sS` | n | 跳转符号（工作区） |
| `<leader>sj` | n | 跳转列表 |
| `<leader>sl` | n | 位置列表 |
| `<leader>sm` | n | 跳转到标记 |
| `<leader>sk` | n | 键位映射 |
| `<leader>sh` | n | 帮助文档 |
| `<leader>sH` | n | 高亮组 |
| `<leader>sM` | n | 手册页 |

### 诊断 / 其他

| 按键 | 模式 | 说明 |
|------|------|------|
| `<leader>sd` | n | 工作区诊断 |
| `<leader>sD` | n | 缓冲区诊断 |
| `<leader>sq` | n | 快速修复列表 |
| `<leader>sR` | n | 恢复上次搜索 |
| `<leader>sc` | n | 命令历史 |
| `<leader>sC` | n | 命令 |
| `<leader>sa` | n | 自动命令 |
| `<leader>sb` | n | 缓冲区行 |
| `<leader>s"` | n | 寄存器 |
| `<leader>st` | n | TODO 注释 |
| `<leader>sT` | n | TODO / FIX / FIXME |
| `<leader>:` | n | 命令历史 |

### fzf-lua 覆盖的 LSP 跳转

| 按键 | 模式 | 说明 |
|------|------|------|
| `gd` | n | 跳转到定义 |
| `gr` | n | 引用 |
| `gI` | n | 跳转到实现 |
| `gy` | n | 跳转到类型定义 |

### fzf 窗口内键位

| 按键 | 说明 |
|------|------|
| `ctrl-q` | 全选并接受 |
| `ctrl-u` / `ctrl-d` | 上半页 / 下半页 |
| `ctrl-f` / `ctrl-b` | 预览页向下 / 向上 |
| `ctrl-x` | 跳转 |
| `ctrl-r` / `alt-c` | 切换根目录 / 当前目录 |
| `alt-i` | 忽略文件开关 |
| `alt-h` | 隐藏文件开关 |
| `ctrl-t` | 在 Trouble 中打开（若已安装） |

---

## 三、文件树 neo-tree

来源：`lua/plugins/neo-tree.lua`

| 按键 | 模式 | 说明 |
|------|------|------|
| `<leader>e` | n | 文件树（根目录） |
| `<leader>E` | n | 文件树（当前目录） |
| `<C-e>` | n | 编辑器 / 文件树焦点切换 |
| `<leader>ge` | n | Git 文件树 |
| `<leader>be` | n | 缓冲区列表 |

### 文件树窗口内

| 按键 | 说明 |
|------|------|
| `l` | 打开节点 |
| `h` | 关闭节点 |
| `<space>` | 禁用（无操作） |
| `Y` | 复制路径到剪贴板 |
| `O` | 用系统应用打开 |
| `P` | 预览开关 |

---

## 四、LSP 语言服务

来源：`lua/plugins/lsp.lua`（LspAttach 时对当前缓冲区生效）

| 按键 | 模式 | 说明 |
|------|------|------|
| `<space>gh` | n | 悬停文档 |
| `<space>gd` | n | 跳转到定义 |
| `<space>gr` | n | 查询引用 |
| `<space>rn` | n | 重命名符号 |
| `<space>ca` | n, v | 代码操作 |
| `]d` | n | 下一个诊断（错误/警告） |
| `[d` | n | 上一个诊断 |

> 注：`gd` / `gr` / `gI` / `gy` 在 fzf-lua 的映射下走模糊查找，见上节。
> 保存文件时（`<C-s>` 或 `:w`）会自动用 LSP 格式化，无需手动调用 `:Format`。

---

## 五、代码补全 blink.cmp

来源：`lua/plugins/blink.lua`

| 按键 | 模式 | 说明 |
|------|------|------|
| `<C-y>` | i | 选择并接受 |
| `<Tab>` | i | 片段占位符跳转 / AI 补全接受 |
| `<CR>` | i | 确认选择（preset = enter） |

> 补全源：lsp、path、snippets、buffer、codeium（🤖）。

---

## 六、Git gitsigns

来源：`lua/plugins/gitsigns.lua`

| 按键 | 模式 | 说明 |
|------|------|------|
| `]h` | n | 下一个变更块 |
| `[h` | n | 上一个变更块 |
| `]H` | n | 最后一个变更块 |
| `[H` | n | 第一个变更块 |
| `<leader>ghs` | n, v | 暂存当前块 |
| `<leader>ghr` | n, v | 重置当前块 |
| `<leader>ghS` | n | 暂存整个缓冲区 |
| `<leader>ghu` | n | 撤销暂存块 |
| `<leader>ghR` | n | 重置整个缓冲区 |
| `<leader>ghp` | n | 行内预览块 |
| `<leader>ghb` | n | 显示当前行作者信息 |
| `<leader>ghB` | n | 显示缓冲区作者信息 |
| `<leader>ghd` | n | 与索引比较 |
| `<leader>ghD` | n | 与上一个提交比较 |
| `ih` | o, x | 选择变更块 |

---

## 七、Markdown 与待办系统

来源：`lua/core/autocmd.lua` + `lua/plugins/markdown.lua`

| 按键 | 模式 | 说明 |
|------|------|------|
| `<cr>` | n | 切换任务状态（`[ ]` ↔ `[x]`） |
| `<2-LeftMouse>` | n | 双击切换任务状态 |
| `<leader>mk` | n | Markdown 预览 |

日期格式（自动高亮）：`D:YYYY-MM-DD` 截止日期（红色）、`S:YYYY-MM-DD` 开始日期。

相关命令：

| 命令 | 说明 |
|------|------|
| `:MarkdownPreviewToggle` | 预览开关 |
| `:TableModeToggle` | 表格模式开关（vim-table-mode） |
| `:PasteImg` | 粘贴剪贴板图片（md-img-paste） |

---

## 八、翻译 Trans.nvim

来源：`lua/plugins/trans.lua`

| 按键 | 模式 | 说明 |
|------|------|------|
| `mm` | n, x | 翻译 |
| `mk` | n, x | 自动朗读 |
| `mi` | n | 输入翻译 |

---

## 九、主题切换

来源：`lua/plugins/theme.lua` + `lua/util/colorscheme.lua`

| 按键 / 命令 | 说明 |
|------|------|
| `<leader>uC` | 切换主题（fzf-lua 选择） |
| `:LemurColorscheme` | 打开主题选择 |

可用主题：tokyonight（默认）、catppuccin、nightfox、kanagawa、onedark、rose-pine。选择结果自动记忆，重启后保持。

---

## 十、IDE 舒适度插件

来源：`lua/plugins/ide.lua`

### 自动配对 nvim-autopairs

| 按键 | 模式 | 说明 |
|------|------|------|
| `(`, `[`, `{`, `"`, `'` | i | 自动补全右半部分（结合 treesitter，字符串/注释内不配对） |

### 注释 ts-comments

| 按键 | 模式 | 说明 |
|------|------|------|
| `gcc` | n | 注释/取消注释当前行 |
| `gc` | n, v | 注释/取消注释选中区域 |
| `gbc` | n | 行块注释 |
| `gb` | n, v | 选中区域块注释 |

### 环绕 nvim-surround

| 按键 | 模式 | 说明 |
|------|------|------|
| `ys<textobj>` | n | 给对象加环绕，如 `ysiw"` 给当前词加双引号 |
| `yS<textobj>` | n | 同上但环绕内容换行 |
| `cs<旧><新>` | n | 替换环绕，如 `cs"'` 双引号改单引号 |
| `ds<环绕>` | n | 删除环绕，如 `ds"` 删除双引号 |
| `S<环绕>` | v | 环绕选中文本 |
| `gS<环绕>` | v | 环绕选中文本（换行） |

### 快速跳转 flash.nvim

| 按键 | 模式 | 说明 |
|------|------|------|
| `s` | n, v, o | 输入两个字符跳到屏幕内任意位置 |
| `S` | n, v, o | 按 Treesitter 节点跳转 |

### 智能折叠 nvim-ufo

| 按键 | 模式 | 说明 |
|------|------|------|
| `zc` / `zo` | n | 折叠 / 展开当前块 |
| `za` | n | 切换折叠 |
| `zM` / `zR` | n | 全部折叠 / 全部展开 |

> 折叠优先使用 treesitter，其次回退到缩进折叠；折叠列显示在行号左侧。

---

## 十一、其他工具

### snacks.nvim（来源：`lua/plugins/snacks.lua`）

| 按键 | 说明 |
|------|------|
| `<leader>ca` | 代码操作 |
| `<leader>nf` | 查找文件 |
| `<leader>nh` | 通知历史 |

### dashboard-nvim（启动页）

| 命令 / 项 | 说明 |
|------|------|
| `:Dashboard` | 打开启动页 |
| `Lazy 性能分析` | 打开 Lazy profile |
| `编辑配置` | 编辑 `init.lua` |
| `Mason 管理` | 打开 Mason |
| `关于 LemurVim` | 关于页 |

---

## 十二、代码片段触发器

来源：`lua/snippets/`（LuaSnip）。输入触发器后按 `<Tab>` 展开，`<Tab>` 在占位符间跳转。

### 全局（all.lua）

| 触发器 | 展开结果 |
|--------|----------|
| `date` | 当前日期 `YYYY-MM-DD` |
| `time` | 当前时间 `HH:MM:SS` |
| `deadline` | `D:YYYY-MM-DD`（截止日期） |
| `startdate` | `S:YYYY-MM-DD`（开始日期） |

### Lua（lua.lua）

| 触发器 | 展开结果 |
|--------|----------|
| `lfun` | 局部函数模板 |
| `pdb` | `print(...)` 调试 |
| `pcall` | pcall 保护调用模板 |
| `module` | 模块模板（`local M = {}` … `return M`） |

### Java（java.lua）

| 触发器 | 展开结果 |
|--------|----------|
| `main` | main 方法 |
| `sout` | `System.out.println` |
| `fori` | 普通 for 循环 |
| `foreach` | 增强 for 循环 |
| `try` | try-catch 模板 |

### Markdown（markdown.lua）

| 触发器 | 展开结果 |
|--------|----------|
| `todo` | `- [ ] ` 待办 |
| `done` | `- [x] ` 已完成 |
| `todod` | 待办 + 截止日期 |
| `code` | 代码块 |

> 另外 friendly-snippets 提供了海量现成片段（各类语言通用模板），开箱即用。

---

## 十三、Neovim 默认快捷键

以下为 Neovim 自带、配置未覆盖的常用键位。

### 移动

| 按键 | 说明 |
|------|------|
| `h` / `j` / `k` / `l` | 左 / 下 / 上 / 右 |
| `w` / `b` / `e` | 下一个词首 / 上一个词首 / 词尾 |
| `0` / `^` / `$` | 行首 / 行首非空 / 行尾 |
| `gg` / `G` | 文件开头 / 末尾 |
| `<C-d>` / `<C-u>` | 向下 / 向上半页 |
| `<C-f>` / `<C-b>` | 向下 / 向上翻页 |
| `%` | 跳转匹配括号 |

### 编辑

| 按键 | 说明 |
|------|------|
| `i` / `a` / `I` / `A` | 插入（光标前 / 后 / 行首 / 行尾） |
| `o` / `O` | 下方 / 上方新行 |
| `x` / `dd` / `yy` | 删字符 / 删行 / 复制行 |
| `p` / `P` | 粘贴（后 / 前） |
| `u` / `<C-r>` | 撤销 / 重做 |
| `.` | 重复上次编辑 |

### 选择

| 按键 | 说明 |
|------|------|
| `v` | 字符可视模式 |
| `V` | 行可视模式 |
| `<C-v>` | 块可视模式 |

### 搜索替换

| 按键 | 说明 |
|------|------|
| `/` / `?` | 向前 / 向后搜索 |
| `n` / `N` | 下一个 / 上一个匹配 |
| `*` / `#` | 搜索当前词（向前 / 向后） |
| `:%s/old/new/g` | 全局替换 |

### 窗口管理

| 按键 | 说明 |
|------|------|
| `<C-w>h/j/k/l` | 切到左 / 下 / 上 / 右窗口 |
| `<C-w>s` / `<C-w>v` | 水平 / 垂直分割 |
| `<C-w>c` / `<C-w>=` | 关闭窗口 / 均衡大小 |

### 标签页

| 按键 | 说明 |
|------|------|
| `gt` / `gT` | 下一个 / 上一个标签页 |
| `{i}gt` | 切到第 i 个标签页 |
| `:tabnew` | 新建标签页 |

---

## 查看按键的几种方式

```vim
:WhichKey     " which-key 图形化提示（中文说明）
:map          " 列出所有键位映射
:Telescope    " 非本配置；本配置用 <leader>sk 查键位映射
```

> 提示：本配置所有自定义按键的 `desc` 均为中文，配合 which-key 可直接看到中文说明；部分插件（如 fzf-lua、gitsigns）内部按键以其插件文档为准。配置变更后以 `:map` 实际结果为准。

**最后更新**: 2026-08-21
