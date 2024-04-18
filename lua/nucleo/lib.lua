local uv = vim.uv or vim.loop

local target_shared_lib =
  string.format('target/release/libnucleo_nvim.%s', uv.os_uname().sysname == 'Darwin' and 'dylib' or 'so')

local function get_path()
  local bin = vim.api.nvim_get_runtime_file(target_shared_lib, false)[1]
  if bin then
    return bin
  end
  vim.notify_once('nucleo.nvim: only debug build found')
  return (assert(vim.api.nvim_get_runtime_file(target_shared_lib, false)[1], 'lib not found'))
end
return package.loadlib(get_path(), 'luaopen_nucleo_nvim')()
