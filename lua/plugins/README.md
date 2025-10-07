# lazy.nvim支持我们以更加优雅的方式编排插件：使用plugins目录统一编排插件。

具体做法为：
## 第一步：lazynvim-init.lua中的setup参数变为setup("plugins")，同时移除掉有关具体插件安装配置的代码；
## 第二步：在lazynvim-init.lua所在目录下创建一个名为"plugins"的目录；
## 第三步：在plugins目录中创建插件配置模块lua脚本。在这一步中，我们分别创建两个lua脚本来分别作为两个插件的配置模块.

这里有两个注意点：

    1）文件名可以随意；
    2）每一个脚本模块都将返回一个table，且table的每一项都是一个插件配置（这里每个文件只有一项插件配置），lazy会把这些table合并为一个插件配置的table进行加载（folke/lazy.nvim: 💤 A modern plugin manager for Neovim (github.com)）。

当然，你也可以只在plugins目录下创建一个lua脚本（譬如叫all-plugins.lua），然后里面return的table包含有上述两个插件的配置

~~~lua
-- all-plugins.lua
return {
    {
        'nvim-lualine/lualine.nvim',
        config = function()
            require('lualine').setup()
        end
    }
    {
        "nvim-tree/nvim-tree.lua",
        version = "*",
        dependencies = {"nvim-tree/nvim-web-devicons"},
        config = function()
            require("nvim-tree").setup {}
        end
    }
}
~~~
