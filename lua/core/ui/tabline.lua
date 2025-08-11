local function get_file_name()
  local file_name = ''

  if vim.bo.filetype == 'explorer' then
    file_name = 'Explorer'
  elseif vim.bo.filetype == 'picker' then
    file_name = 'Picker'
  elseif vim.bo.buftype == 'terminal' then
    file_name = 'Terminal'
  else
    file_name = vim.fn.expand('%:p')
    if file_name == '' or vim.fn.isdirectory(file_name) == 1 then
      file_name = 'No Name'
    end
  end

  return file_name
end

function _G.setup_tabline()
  local statusline_hl = vim.api.nvim_get_hl(0, {name = 'StatusLine'})
  local banner     = 'Neovim!'
  local file_name  = get_file_name()
  local file_flags = '%h%m%r'
  local tabs       = ''

  file_name = (file_name ~= '' and file_name) or 'No Name'

  for i = 1, vim.fn.tabpagenr('$') do
    local tab_hl = i == vim.fn.tabpagenr() and '%#TabLineSel#' or '%#TabLine#'
    tabs = tabs .. tab_hl .. i .. ' %T'
  end

  vim.api.nvim_set_hl(0, 'TabLine', statusline_hl)
  vim.api.nvim_set_hl(0, 'TabLineFill', statusline_hl)
  vim.api.nvim_set_hl(0, 'TabLineSel', {fg = statusline_hl.fg, bg = statusline_hl.bg, bold = true})

  local format = {
    '%#TabLine#',
    ' ',
    banner,
    ' ',
    '|',
    '%=',
    file_name,
    ' ',
    file_flags,
    '%=',
    '|',
    ' ',
    tabs,
    ' ',
    '%#TabLine#'
  }

  return table.concat(format)
end
