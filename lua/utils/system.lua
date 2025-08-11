local U = {}

function U.is_windows()
  return vim.uv.os_uname().sysname == 'Windows_NT'
      or vim.fn.has('win32') == 1
end

function U.is_linux()
U.is_linux   = vim.uv.os_uname().sysname == 'Linux'
end

function U.is_macos()
U.is_macos   = vim.uv.os_uname().sysname == 'Darwin'
end

function U.is_root(directory)
  if U.is_windows and directory:match('^[A-Za-z]:[\\/]?$') then
    return true
  elseif not U.is_windows and directory == '/' then
    return true
  end

  return false
end

function U.get_separator()
  return U.is_windows and '\\' or '/'
end

function U.get_open_command()
  if U.is_windows() then
    return 'explorer'
  elseif U.is_macos() == 'Darwin' then
    return 'open'
  elseif U.is_linux() == 'Linux' then
    return 'xdg-open'
  end
end

function U.get_item_count_command(path)
  if U.is_windows() then
    return string.format('dir /b "%s" | find /c /v ""', path)
  else
    return string.format('find "%s" -mindepth 1 | wc -l', path)
  end
end

return U
