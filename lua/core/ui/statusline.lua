local function get_mode_name()
  local mode        = vim.fn.mode()
  local mode_name = {
    n       = ' NRML ',
    i       = ' INST ',
    v       = ' VSAL ',
    V       = ' VLNE ',
    ['\22'] = ' VBLK ',
    s       = ' SLCT ',
    S       = ' SLNE ',
    ['\19'] = ' SBLK ',
    c       = ' CMND ',
    R       = ' RPLC ',
    r       = ' RPLC ',
    ['!']   = ' SHLL ',
    t       = ' TRML '
  }

  return mode_name[mode] or '????'
end

local function get_file_name()
  local file_name  = ''
  if vim.bo.filetype == 'explorer' then
    file_name = 'Explorer'
  elseif vim.bo.filetype == 'picker' then
    file_name = 'Picker'
  elseif vim.bo.filetype == 'terminal' then
    file_name = 'Terminal'
  else
    file_name = vim.fn.expand('%:t')
  end

  file_name = file_name ~= '' and file_name or 'No Name'
  file_name = ' ' .. file_name .. ' '
  file_name = file_name

  return file_name
end

function _G.setup_statusline()
  local mode_name       = get_mode_name()
  local file_name       = get_file_name()
  local cursor_position = '%l:%c:%p%%'
  local separator       = '│'

  local format = {
    '%#StatusLine#',
    ' ',
    mode_name,
    ' ',
    separator,
    ' ',
    file_name,
    ' ',
    separator,
    '%=',
    separator,
    ' ',
    cursor_position,
    ' ',
    '%#StatusLine#'
  }

  return table.concat(format)
end
