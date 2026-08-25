# 🦊 LemurVim

> 一套基于 [lazy.nvim](https://github.com/folke/lazy.nvim) 构建的现代化 Neovim 配置，开箱即用、全中文提示、开箱即用的 LSP / 补全 / 文件树 / 模糊查找 / Git / Markdown 工作流。

![Neovim](https://img.shields.io/badge/Neovim-0.10+-57A143?logo=neovim&logoColor=fff)
![Lua](https://img.shields.io/badge/Lua-5.1-2C2D72?logo=lua&logoColor=fff)
![Platform](https://img.shields.io/badge/platform-Linux%20%7C%20macOS-0078D4)
![Version](https://img.shields.io/badge/version-1.0.0-orange)

---

## ✨ 特性

- ⚡ **极速启动**：lazy.nvim 按需懒加载，禁用了一堆内置无用插件
- 🧩 **模块化结构**：核心配置与插件配置分离，每个插件一个文件
- 🈶 **全中文体验**：which-key、gitsigns、dashboard、LSP 诊断等全部中文化
- 🎨 **6 套主题一键切换**：tokyonight（默认）、catppuccin、nightfox、kanagawa、onedark、rose-pine，选择自动记忆
- 🧠 **开箱即用的 LSP**：Mason 自动安装，支持 Java（含 Lombok）、Lua、TS/Vue、Python 风格的前端全家桶等
- 💡 **智能补全**：blink.cmp + LuaSnip + friendly-snippets + Codeium AI
- 🔍 **模糊查找**：fzf-lua 接管文件、Grep、LSP、Git、诊断、TODO 等所有搜索
- 🌳 **文件树**：neo-tree 浮动居中显示，跟随当前文件
- 🪴 **Markdown 一流支持**：预览、待办勾选、截止日期高亮、表格、图片粘贴、日期片段
- 🔀 **Git 集成**：gitsigns 行内变更标记 + hunk 操作 + fzf 提交/状态/差异
- 🪶 **IDE 手感**：自动配对、智能注释、环绕编辑、flash 快速跳转、nvim-ufo 智能折叠
- 🌐 **翻译 & 朗读**：Trans.nvim，选中即译
- 🏠 **启动页**：dashboard-nvim，常用入口一键直达

---

## 📦 环境要求

| 依赖 | 版本 / 说明 |
|------|-------------|
| [Neovim](https://neovim.io/) | **≥ 0.10**（推荐 0.11+，部分 LSP 配置使用新 API） |
| [Git](https://git-scm.com/) | 用于拉取 lazy.nvim 与各插件 |
| [Nerd Font](https://www.nerdfonts.com/) | 显示文件图标与 UI 符号（建议 Nerd Font Mono） |
| [ripgrep](https://github.com/BurntSushi/ripgrep) | fzf-lua 的 grep 搜索后端 |
| [fd](https://github.com/sharkdp/fd) | 更快的文件查找（可选） |
| Node.js / npm | 部分 LSP（ts_ls、vue、html、css、json、tailwind）需要 |
| Python 3 | `g:python3_host_prog` 指向的解释器，供 pynvim 使用 |
| JDK 17+ | 使用 `jdtls`（Java LSP）时需要 |
| C 工具链 | blink.cmp 从 main 分支构建时需要 Rust/C 工具链；使用 release tag 可跳过 |
| SQLite | Trans.nvim 依赖（`libsqlite3`） |

> 终端建议启用真彩色（`termguicolors` 已默认开启）。

---

## 🚀 安装

```bash
# 1. 备份你现有的配置（如有）
mv ~/.config/nvim ~/.config/nvim.bak

# 2. 克隆本仓库
git clone https://github.com/lemur9/myNvim.git ~/.config/nvim

# 3. 启动 Neovim，lazy.nvim 会自动引导安装所有插件
nvim
```

首次启动会自动：

1. 克隆 [lazy.nvim](https://github.com/folke/lazy.nvim) 到 `~/.local/share/nvim/lazy/`
2. 安装 `lua/plugins/` 下声明的全部插件
3. 通过 Mason 自动安装 `lua/plugins/lsp.lua` 中 `ensure_installed` 的 LSP 服务器

安装完成后重启一次即可。

> 💡 设置 Python 主机程序路径（可选）：启动前 `export PYTHON=$(which python3)`，配置会读取该变量写入 `g:python3_host_prog`。

---

## 🧭 快速上手

**Leader 键是空格 `<space>`**。记住这几个最高频的按键就能开工：

| 按键 | 作用 |
|------|------|
| `<space><space>` / `<leader>ff` | 查找文件 |
| `<leader>fg` | 查找 Git 跟踪的文件 |
| `<leader>fr` | 最近打开的文件 |
| `<leader>,` | 切换缓冲区 |
| `<leader>/` / `<leader>sg` | 实时 Grep 搜索 |
| `<leader>sw` | 搜索光标下的词 |
| `<leader>e` | 打开/关闭浮动文件树 |
| `<C-e>` | 在编辑器和文件树之间切换焦点 |
| `<leader>ss` | 当前文档符号跳转 |
| `<leader>sS` | 工作区符号跳转 |
| `gd` / `gr` / `gI` / `gy` | 定义 / 引用 / 实现 / 类型定义 |
| `<space>rn` | 重命名符号 |
| `<space>ca` | 代码操作 |
| `]d` / `[d` | 下一个 / 上一个诊断 |
| `]h` / `[h` | 下一个 / 上一个 Git 变更块 |
| `<leader>ghs` / `<leader>ghr` | 暂存 / 重置当前 hunk |
| `<leader>uC` | 切换主题 |
| `<leader>mk` | Markdown 预览 |
| `mm` / `mk` | 翻译 / 朗读（选中或光标下词） |
| `jk` | 插入模式下快速退出到普通模式 |
| `<C-s>` | 保存（保存时自动用 LSP 格式化） |

完整键位清单请看 👉 [keymaps.md](./keymaps.md)，它和代码一一对应，持续更新。

---

## 🧱 插件列表

> 配置文件位于 [`lua/plugins/`](./lua/plugins)。下方只列关键插件，完整依赖见 [lazy-lock.json](./lazy-lock.json)。

### 核心

| 插件 | 作用 |
|------|------|
| [folke/lazy.nvim](https://github.com/folke/lazy.nvim) | 插件管理器（自动引导） |
| [nvim-lua/plenary.nvim](https://github.com/nvim-lua/plenary.nvim) | Lua 工具函数库 |
| [MunifTanjim/nui.nvim](https://github.com/MunifTanjim/nui.nvim) | UI 组件库 |
| [nvim-tree/nvim-web-devicons](https://github.com/nvim-tree/nvim-web-devicons) | 图标 |

### 编辑 & 导航

| 插件 | 作用 |
|------|------|
| [nvim-neo-tree/neo-tree.nvim](https://github.com/nvim-neo-tree/neo-tree.nvim) | 浮动文件树 |
| [ibhagwan/fzf-lua](https://github.com/ibhagwan/fzf-lua) | 模糊查找（文件/Grep/LSP/Git/诊断…） |
| [folke/flash.nvim](https://github.com/folke/flash.nvim) | 两字符快速跳转 |
| [lukas-reineke/indent-blankline.nvim](https://github.com/lukas-reineke/indent-blankline.nvim) | 缩进竖线 |
| [kevinhwang91/nvim-ufo](https://github.com/kevinhwang91/nvim-ufo) | 基于 treesitter 的智能折叠 |

### LSP & 补全

| 插件 | 作用 |
|------|------|
| [neovim/nvim-lspconfig](https://github.com/neovim/nvim-lspconfig) | LSP 基础配置 |
| [williamboman/mason.nvim](https://github.com/williamboman/mason.nvim) | LSP/工具自动安装 |
| [williamboman/mason-lspconfig.nvim](https://github.com/williamboman/mason-lspconfig.nvim) | mason × lspconfig 桥接 |
| [j-hui/fidget.nvim](https://github.com/j-hui/fidget.nvim) | LSP 进度通知 |
| [saghen/blink.cmp](https://github.com/saghen/blink.cmp) | 新一代补全引擎 |
| [L3MON4D3/LuaSnip](https://github.com/L3MON4D3/LuaSnip) | 代码片段引擎 |
| [rafamadriz/friendly-snippets](https://github.com/rafamadriz/friendly-snippets) | 多语言片段集合 |
| [Exafunction/codeium.nvim](https://github.com/Exafunction/codeium.nvim) | Codeium AI 补全源 |
| [nvim-treesitter/nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) | 语法高亮 / 文本对象 |

### IDE 体验

| 插件 | 作用 |
|------|------|
| [windwp/nvim-autopairs](https://github.com/windwp/nvim-autopairs) | 自动配对括号 |
| [folke/ts-comments.nvim](https://github.com/folke/ts-comments.nvim) | 智能注释 |
| [kylechui/nvim-surround](https://github.com/kylechui/nvim-surround) | 环绕编辑 |
| [lewis6991/gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim) | Git 行内变更标记 |
| [folke/which-key.nvim](https://github.com/folke/which-key.nvim) | 按键提示（全中文分组） |
| [folke/snacks.nvim](https://github.com/folke/snacks.nvim) | notifier / picker / rename 等工具集 |
| [akinsho/bufferline.nvim](https://github.com/akinsho/bufferline.nvim) | 顶部缓冲区标签栏 |
| [nvim-lualine/lualine.nvim](https://github.com/nvim-lualine/lualine.nvim) | 底部状态栏 |

### 语言 & 工具

| 插件 | 作用 |
|------|------|
| [JuanZoran/Trans.nvim](https://github.com/JuanZoran/Trans.nvim) | 翻译 & 朗读 |
| [iamcco/markdown-preview.nvim](https://github.com/iamcco/markdown-preview.nvim) | Markdown 浏览器预览 |
| [ferrine/md-img-paste.vim](https://github.com/ferrine/md-img-paste.vim) | 粘贴剪贴板图片到 Markdown |
| [dhruvasagar/vim-table-mode](https://github.com/dhruvasagar/vim-table-mode) | Markdown 表格实时对齐 |
| [folke/todo-comments.nvim](https://github.com/folke/todo-comments.nvim) | TODO/FIXME 高亮与检索 |
| [ngtuonghy/live-server-nvim](https://github.com/ngtuonghy/live-server-nvim) | 前端 Live Server |
| [nvimdev/dashboard-nvim](https://github.com/nvimdev/dashboard-nvim) | 启动页 |

### 主题

| 插件 | 风格 |
|------|------|
| [folke/tokyonight.nvim](https://github.com/folke/tokyonight.nvim) | 默认（moon） |
| [catppuccin/nvim](https://github.com/catppuccin/nvim) | mocha |
| [EdenEast/nightfox.nvim](https://github.com/EdenEast/nightfox.nvim) | nightfox |
| [rebelot/kanagawa.nvim](https://github.com/rebelot/kanagawa.nvim) | kanagawa |
| [navarasu/onedark.nvim](https://github.com/navarasu/onedark.nvim) | onedark |
| [rose-pine/neovim](https://github.com/rose-pine/neovim) | rose-pine |

---

## 📂 目录结构

```
myNvim/
├── init.lua                 # 入口：加载 core 和 plugins，启动 lazy.nvim
├── lazy-lock.json           # 插件版本锁定
├── keymaps.md               # 全部快捷键中文文档
├── lua/
│   ├── core/                # 核心配置
│   │   ├── init.lua         #   版本、图标、加载顺序
│   │   ├── options.lua      #   Neovim 选项（行号、缩进、折叠…）
│   │   ├── keymaps.lua      #   通用快捷键
│   │   └── autocmd.lua      #   自动命令（含 Markdown 待办高亮）
│   ├── plugins/             # 插件配置（每个文件一个模块）
│   │   ├── init.lua         #   插件列表汇总
│   │   ├── lsp.lua          #   LSP / Mason / jdtls
│   │   ├── blink.lua        #   补全
│   │   ├── fzf.lua          #   模糊查找
│   │   ├── neo-tree.lua     #   文件树
│   │   ├── gitsigns.lua     #   Git
│   │   ├── ide.lua          #   autopairs / surround / flash / ufo …
│   │   ├── theme.lua        #   主题（动态生成 lazy spec）
│   │   ├── markdown.lua     #   Markdown 预览 & 工具
│   │   ├── trans.lua        #   翻译
│   │   ├── which-key.lua    #   中文按键提示
│   │   └── …                #   其余插件
│   ├── snippets/            # 自定义 LuaSnip 片段
│   │   ├── all.lua          #   全局：date/time/deadline
│   │   ├── lua.lua          #   Lua：lfun/module/pcall…
│   │   ├── java.lua         #   Java：main/sout/fori/try…
│   │   └── markdown.lua     #   Markdown：todo/done/code…
│   └── util/                # 工具模块
│       ├── init.lua         #   LemurVim 全局对象
│       ├── lazy.lua         #   lazy.nvim 自举与性能配置
│       ├── colorscheme.lua  #   主题注册/切换/持久化
│       ├── icons.lua        #   图标
│       ├── root.lua         #   项目根目录检测
│       ├── pick.lua         #   fzf-lua 封装（支持根目录/当前目录）
│       ├── cmp.lua          #   补全辅助
│       └── G.lua            #   vim 全局 API 包装
```

---

## ⚙️ 自定义

### 切换主题

```vim
:LemurColorscheme         " 用 fzf 选择
```

或按 `<leader>uC`。选择结果会写入 `stdpath('data')/colorscheme`，重启后保持。

### 新增插件

在 `lua/plugins/` 下新建一个文件，把 lazy spec 挂到 `LemurVim.plugins` 表上即可：

```lua
-- lua/plugins/hello.lua
LemurVim.plugins.hello = {
  "author/hello.nvim",
  cmd = "Hello",
  opts = {},
}
```

`lua/plugins/init.lua` 里按顺序 `require` 一下即可被加载。

### 新增 LSP

在 `lua/plugins/lsp.lua` 的 `ensure_installed` 与 `servers` 表里加入服务器名；如需自定义配置，参照下面 `lua_ls` / `ts_ls` / `jdtls` 的写法。

### 新增代码片段

在 `lua/snippets/` 下新建文件，使用 LuaSnip 的 `s(...)` / `fmt(...)` 定义触发器，然后在该目录里的对应语言文件中 `require` 或直接追加。

### 自定义快捷键

通用按键写在 `lua/core/keymaps.lua`；插件相关按键写在对应插件文件里，并附上中文 `desc`，which-key 会自动收录。

---

## 🔧 常用命令

| 命令 | 说明 |
|------|------|
| `:Lazy` | 打开 lazy.nvim 插件管理面板 |
| `:Lazy sync` | 同步并更新所有插件 |
| `:Mason` | 打开 Mason，安装/更新 LSP、Formatter、Linter |
| `:LemurColorscheme` | 打开主题选择器 |
| `:LemurAbout` | 关于 LemurVim |
| `:Dashboard` | 打开启动页 |
| `:MarkdownPreviewToggle` | 切换 Markdown 预览 |
| `:TableModeToggle` | 切换 Markdown 表格模式 |
| `:PasteImg` | 在 Markdown 中粘贴剪贴板图片 |
| `:LiveServerToggle` | 切换前端 Live Server |
| `:Translate` / `:TransPlay` | 翻译 / 朗读 |

---

## 🐛 常见问题

**图标显示为方块或乱码？**
终端需要安装并启用一款 [Nerd Font](https://www.nerdfonts.com/)（推荐 Nerd Font Mono），并在终端设置里选中它。

**LSP 没有自动启动？**
1. 运行 `:Mason` 确认对应语言服务器已安装；
2. 确认当前目录被识别为项目根目录（有 `.git` / `pom.xml` / `package.json` 等标记）；
3. 执行 `:LspInfo` 查看客户端状态。

**Java (`jdtls`) 启动失败？**
需要 JDK 17+，并且首次启动会下载 jdtls 与 Lombok；`lua/plugins/lsp.lua` 中已配置好 `-javaagent:lombok.jar`。若工作区损坏，删除 `~/.local/share/nvim/mason/packages/jdtls/workspace/` 后重试。

**blink.cmp 安装慢？**
若使用 release tag（默认配置），会下载预编译产物，无需 Rust；如启用了 `main` 分支构建，请确保系统有 Rust 工具链。

**保存时没有自动格式化？**
当前缓冲区需要有支持 `documentFormattingProvider` 的 LSP。可以 `:LspInfo` 查看；也可在 autocmd `LspFormatOnSave`（`lua/plugins/lsp.lua`）中调整。

**左侧边栏出现数字？**
来自 `nvim-ufo` 的折叠列。在 `lua/plugins/ide.lua` 里把 `vim.o.foldcolumn = "1"` 改成 `"0"` 即可关闭（不影响折叠功能）。

---

## 🤝 贡献

欢迎提交 Issue 与 PR！

1. Fork 本仓库
2. 新建你的特性分支：`git checkout -b feat/awesome-feature`
3. 提交改动：`git commit -m 'feat: add awesome feature'`
4. 推送：`git push origin feat/awesome-feature`
5. 提 PR 🎉

代码请使用 [StyLua](https://github.com/JohnnyMorganz/StyLua) 格式化（仓库根目录已带 `.stylua.toml`，缩进 2 空格）。

---

## 📜 许可

[MIT License](./LICENSE)

---

<div align="center">

🦊 **LemurVim** · 用 Lua 写给自己的 Neovim，愿你写代码像狐猴一样灵巧。

<sub>Made with ❤️ using <a href="https://github.com/folke/lazy.nvim">lazy.nvim</a></sub>

</div>
