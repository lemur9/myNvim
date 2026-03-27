local M = {}

--- 获取 jdtls 配置
function M.get_config()
  local mason_data = vim.fn.stdpath("data")
  local jdtls_dir = vim.fs.joinpath(mason_data, "mason", "packages", "jdtls")
  local jdtls_plugins_dir = vim.fs.joinpath(jdtls_dir, "plugins")
  local lombok_jar = vim.fs.joinpath(jdtls_dir, "lombok.jar")
  local config_name = (LemurVim.is_win() and "config_win")
    or (LemurVim.is_mac() and "config_mac")
    or "config_linux"
  local jdtls_config_dir = vim.fs.joinpath(jdtls_dir, config_name)
  local root_marker = vim.fs.find({ ".git", "pom.xml", "build.gradle" }, { upward = true })[1]
  local jdtls_root = root_marker and vim.fs.dirname(root_marker) or vim.uv.cwd()
  local project_name = vim.fs.basename(jdtls_root)
  local workspace_dir = vim.fs.joinpath(jdtls_dir, "workspace", project_name)

  local launcher_jars = vim.fn.globpath(jdtls_plugins_dir, "org.eclipse.equinox.launcher_*.jar", false, true)
  table.sort(launcher_jars)
  local launcher_jar = launcher_jars[#launcher_jars]

  if not launcher_jar then
    vim.notify(
      "[lsp] jdtls launcher jar not found under Mason path, keeping default jdtls config",
      vim.log.levels.WARN
    )
    return nil
  end

  return {
    cmd = {
      "java",
      "-Declipse.application=org.eclipse.jdt.ls.core.id1",
      "-Dosgi.bundles.defaultStartLevel=4",
      "-Declipse.product=org.eclipse.jdt.ls.core.product",
      "-Dlog.protocol=true",
      "-Dlog.level=ALL",
      "-Xms1g",
      "--add-modules=ALL-SYSTEM",
      "--add-opens",
      "java.base/java.util=ALL-UNNAMED",
      "--add-opens",
      "java.base/java.lang=ALL-UNNAMED",
      -- 增加 lombok 插件支持
      "-javaagent:" .. lombok_jar,
      "-Xbootclasspath/a:" .. lombok_jar,
      "-jar",
      launcher_jar,
      "-configuration",
      jdtls_config_dir,
      "-data",
      workspace_dir,
    },
    root_dir = jdtls_root,
    init_options = {
      bundles = {},
    },
    settings = {
      java = {
        configuration = {
          annotationProcessing = {
            enabled = true,
          },
        },
      },
    },
  }
end

return M