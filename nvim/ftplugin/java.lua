local workspace_dir = "C:/Users/26254/.cache/jdtls-workspace"
local config = {
  cmd = {
    'D:/LANG/jdtls-1.45.0/bin/jdtls.bat',
    '-data', workspace_dir,
  },
  -- root_dir = vim.fs.root(0, {'pom.xml'}),
  root_dir = "D:\\A8File\\IntelliJ IDEA\\SpringBoot"
}
require('jdtls').start_or_attach(config)
