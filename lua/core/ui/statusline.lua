local function get_mode_strig()
  local mode        = vim.fn.mode()
  local mode_string = {
    n       = 'NRML',
    i       = 'INST',
    v       = 'VSAL',
    V       = 'VLNE',
    ['\22'] = 'VBLK',
    s       = 'SLCT',
    S       = 'SLNE',
    ['\19'] = 'SBLK',
    c       = 'CMND',
    R       = 'RPLC',
    r       = 'RPLC',
    ['!']   = 'SHLL',
    t       = 'TRML'
  }

  return mode_string[mode] or '????'
end

local function get_file_name()
  local file_name = ''

  if vim.bo.filetype == 'explorer' then
    file_name = 'Explorer'
  elseif vim.bo.filetype == 'picker' then
    file_name = 'Picker'
  elseif vim.bo.buftype == 'terminal' then
    file_name = 'Terminal'
  else
    file_name = vim.fn.expand('%:t')
    file_name = (file_name ~= '' and file_name) or 'No Name'
  end

  return file_name
end

function _G.setup_statusline()
  local file_name       = get_file_name()
  local mode_string     = get_mode_strig()
  local cursor_position = '%l:%c:%p%%'

  local format = {
    '%#StatusLine#',
    ' ',
    mode_string,
    ' ',
    '|',
    ' ',
    file_name,
    ' ',
    '|',
    '%=',
    '|',
    ' ',
    cursor_position,
    ' ',
    '%#StatusLine#'
  }

  return table.concat(format)
end
