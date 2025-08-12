local function get_version()
  local version = string.format('Neovim %s.%s.%s',
                                vim.version().major,
                                vim.version().minor,
                                vim.version().patch)

  return version
end

local function get_file_name()
  local file_name  = ''
  local file_flags = '%h%m%r'
  if vim.bo.filetype == 'explorer' then
    file_name = 'Explorer'
    file_flags = '*'
  elseif vim.bo.filetype == 'picker' then
    file_name = 'Picker'
    file_flags = '*'
  elseif vim.bo.filetype == 'terminal' then
    file_name = 'Terminal'
    file_flags = '*'
  else
    file_name = vim.fn.expand('%:.\'')
  end

  file_name = file_name ~= '' and file_name or 'No Name'
  file_name = ' ' .. file_name .. ' '
  file_name = file_name .. file_flags

  return file_name
end

local function get_tabs_number()
  local tab_number = ''
  for i = 1, vim.fn.tabpagenr('$') do
    local tabline_hl = i == vim.fn.tabpagenr() and '%#TabLineSel#' or '%#TabLine#'
    tab_number = tab_number .. tabline_hl .. ' ' .. i .. ' ' .. '%#TabLineSel#' .. '%#TabLine#'
  end

  return tab_number
end

function _G.setup_tabline()
  local version     = get_version()
  local file_name   = get_file_name()
  local tabs_number = get_tabs_number()
  local separator   = '│'

  local format = {
    '%#TabLine#',
    ' ',
    version,
    ' ',
    separator,
    '%=',
    file_name,
    '%=',
    separator,
    ' ',
    tabs_number,
    ' ',
    '%#TabLine#'
  }

  return table.concat(format)
end
