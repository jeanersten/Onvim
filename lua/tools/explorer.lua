local M = {}

local system = require('utils.system')

local state = {
  floating = {
    buffer = -1,
    window = -1
  },
  title               = 'Explorer',
  workspace_directory = vim.fn.getcwd(),
  current_directory   = vim.fn.getcwd(),
  header_row_height   = 3,
  items               = {}
}

local icons = {
  header_normal    = '󱧶',
  header_workspace = '󰉌',
  folder_parent    = '',
  folder_current   = '',
  folder_normal    = '󰉋',
  file_normal      = '󰈔',
  file_code        = '󰈮',
  file_config      = '󱁻',
  file_text        = '󱇧',
  file_image       = '󰈟',
  file_executable  = '󰲋'
}

local function open_floating_window(opts)
  opts = opts or {}

  local buffer = nil
  if vim.api.nvim_buf_is_valid(opts.buffer) then
    buffer = opts.buffer
  else
    buffer = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_set_option_value('bufhidden', 'wipe', {buf = buffer})
    vim.api.nvim_set_option_value('filetype', 'explorer', {buf = buffer})
  end

  local width  = math.floor(vim.o.columns / 2)
  local height = math.floor(vim.o.lines / 2)
  local row    = math.floor((vim.o.lines - height) / 2)
  local col    = math.floor((vim.o.columns - width) / 2)

  local config = {
    relative = 'editor',
    width    = width,
    height   = height,
    row      = row,
    col      = col,
    style    = 'minimal',
    border   = 'single',
    title    = (' ' .. state.title .. ' ')
  }

  local window = vim.api.nvim_open_win(buffer, true, config)
  vim.api.nvim_set_option_value('winfixbuf', true, {win = window})
  vim.api.nvim_set_option_value('winfixwidth', true, {win = window})
  vim.api.nvim_set_option_value('winfixheight', true, {win = window})
  vim.api.nvim_set_option_value('cursorline', true, {win = window})
  vim.api.nvim_set_hl(0, 'FloatBorder', {link = 'Normal'})
  vim.api.nvim_set_hl(0, 'NormalFloat', {link = 'Normal'})

  return {buffer = buffer, window = window}
end

local function hide_floating_window()
  local hidden = false
  if vim.api.nvim_win_is_valid(state.floating.window) then
    vim.api.nvim_win_hide(state.floating.window)
    state.floating.window = -1
    hidden = true
  end

  return hidden
end

local function is_floating_buffer(buffer)
  return buffer == state.floating.buffer
end

local function is_floating_window(window)
  return window == state.floating.window
end

local function get_item_icon(item)
  local extension_code_list       = {
    'c', 'cpp', 'h', 'hpp', 'lua',
    'py', 'rs', 'go', 'java', 'cs',
    'ts', 'tsx', 'js', 'jsx', 'sh',
    'bash', 'zsh', 'fish', 'rb', 'php',
    'swift', 'kt', 'm', 'mm'
  }

  local extension_config_list     = {
    'conf', 'json', 'jsonc', 'toml', 'yaml',
    'yml', 'ini', 'cfg', 'env', 'editorconfig'
  }

  local extension_text_list       = {
    'md', 'markdown', 'txt', 'log', 'rst',
    'org'
  }

  local extension_image_list      = {
    'bmp', 'gif', 'jpg', 'jpeg', 'png',
    'webp', 'svg', 'tiff', 'ico', 'heic'
  }

  local extension_executable_list = {
    'exe', 'bat', 'cmd', 'sh', 'bin',
    'run', 'msi', 'apk', 'app', 'elf'
  }

  if item.type == 'folder' then
    if item.name == '..' then
      return icons.folder_parent
    elseif item.name == '.' then
      return icons.folder_current
    else
      return icons.folder_normal
    end
  else
    local extension = item.name:match('%.([^%.]+)$')
    if extension then
      extension = extension:lower()
    else
      return icons.file_normal
    end

    if vim.tbl_contains(extension_code_list, extension) then
      return icons.file_code
    elseif vim.tbl_contains(extension_config_list, extension) then
      return icons.file_config
    elseif vim.tbl_contains(extension_text_list, extension) then
      return icons.file_text
    elseif vim.tbl_contains(extension_image_list, extension) then
      return icons.file_image
    elseif vim.tbl_contains(extension_executable_list, extension) then
      return icons.file_executable
    else
      return icons.file_normal
    end
  end
end

local function render()
  local lines = {}

  local header_icon = ''
  if (state.current_directory:match(state.workspace_directory)) then
    header_icon = icons.header_workspace
  else
    header_icon = icons.header_normal
  end

  table.insert(lines, '')
  table.insert(lines, ' ' .. header_icon .. ' ' .. state.current_directory)
  table.insert(lines, '')

  for _, item in ipairs(state.items) do
    local line = string.format(' %s %s', get_item_icon(item), item.name)
    if item.type == 'folder' then
      line = line .. system.get_separator()
    end

    table.insert(lines, line)
  end

  if vim.api.nvim_buf_is_valid(state.floating.buffer) then
    vim.api.nvim_set_option_value('modifiable', true, {buf = state.floating.buffer})
    vim.api.nvim_buf_set_lines(state.floating.buffer, 0, -1, false, lines)
    vim.api.nvim_set_option_value('modifiable', false, {buf = state.floating.buffer})
  end
end

local function update_items()
  state.items = {}

  local handle = vim.uv.fs_scandir(state.current_directory)
  if not handle then return {} end

  if not system.is_root(state.current_directory) then
    table.insert(state.items, {
      name = '..',
      path = vim.fn.fnamemodify(state.current_directory, ':h'),
      type = 'folder'
    })
  end

  table.insert(state.items, {
    name = '.',
    path = state.current_directory,
    type = 'folder'
  })

  local folders = {}
  local files   = {}
  while true do
    local name, type = vim.uv.fs_scandir_next(handle)
    if not name then break end

    local path = ''
    if state.current_directory:sub(-1) == system.get_separator() then
      path = state.current_directory .. name
    else
      path = state.current_directory .. system.get_separator() .. name
    end

    if type == 'directory' then
      local item = {
        name = name,
        path = path,
        type = 'folder'
      }
      table.insert(folders, item)
    else
      local item = {
        name = name,
        path = path,
        type = 'file'
      }
      table.insert(files, item)
    end
  end

  for _, folder in ipairs(folders) do
    table.insert(state.items, folder)
  end

  for _, file in ipairs(files) do
    table.insert(state.items, file)
  end

  table.sort(state.items, function(a, b)
    if a.name == '..' and b.name ~= '..' then return true end
    if b.name == '..' and a.name ~= '..' then return false end

    if a.name == '.' and b.name ~= '.' then return true end
    if b.name == '.' and a.name ~= '.' then return false end

    if a.type ~= b.type then
      return a.type == 'folder'
    end

    return a.name < b.name
  end)

  render()
end

local function get_current_item()
  local line_index = vim.api.nvim_win_get_cursor(state.floating.window)[1]
  local item_index = line_index - state.header_row_height
  if line_index <= state.header_row_height or item_index > #state.items then
    return nil
  end

  return state.items[item_index]
end

local function handle_item_select()
  local item = get_current_item()
  if not item then
    return
  end

  if item.type == 'folder' then
    state.current_directory = item.path
    update_items()
    vim.api.nvim_win_set_cursor(state.floating.window, {state.header_row_height + 1, 0})
  else
    hide_floating_window()
    vim.cmd('edit ' .. vim.fn.fnameescape(item.path))
  end
end

local function handle_item_open_in_system()
  local item = get_current_item()
  if not item then
    return
  end

  local command = string.format('%s %s', system.get_open_command(), item.path)
  vim.fn.system(command)
end

local function handle_item_move()
  local item = get_current_item()
  if not item or item.name == '.' or item.name == '..' then
    return
  end

  local parent_directory = vim.fn.fnamemodify(item.path, ':h')

  vim.ui.input({
    prompt = string.format('Move item "%s" to: ', item.name),
    default = parent_directory .. system.get_separator(),
    completion = 'dir'
  }, function(input)
    if not input or input == '' then
      vim.notify('Item not moved', vim.log.levels.INFO)
      return
    end

    local old_path = vim.fn.fnamemodify(item.path, ':p')
    local new_path = vim.fn.fnamemodify(input, ':p')

    if input:sub(-1) == system.get_separator() then
      if not vim.fn.isdirectory(new_path) then
        local ok = vim.fn.mkdir(new_path, 'p')
        if ok == 0 then
          vim.notify(string.format('Failed to create target folder "%s"', new_path), vim.log.levels.ERROR)
          return
        end
      end

      new_path = vim.fs.joinpath(new_path, item.name)
    end

    local function exists_anywhere(p)
      if system.is_windows() then
        p = p:gsub('/', '\\')
      end

      local no_slash = p:gsub('[\\/]+$', '')

      return vim.fn.filereadable(no_slash) == 1 or vim.fn.isdirectory(no_slash) == 1
    end

    if system.is_windows() then
      old_path = old_path:gsub('/', '\\')
      new_path = new_path:gsub('/', '\\')
    end

    if new_path == old_path then
      vim.notify('Item target path is the same', vim.log.levels.WARN)
      return
    elseif exists_anywhere(new_path) then
      vim.notify('Item already exists', vim.log.levels.ERROR)
      return
    end

    local ok = vim.uv.fs_rename(old_path, new_path)
    if ok then
      state.current_directory = vim.fn.fnamemodify(new_path, ':h')
      update_items()
      if state.floating.window and vim.api.nvim_win_is_valid(state.floating.window) then
        local buffer = vim.api.nvim_win_get_buf(state.floating.window)
        local lines  = vim.api.nvim_buf_get_lines(buffer, 0, -1, false)

        local target_name = vim.fn.fnamemodify(new_path, ':t')
        for i, line in ipairs(lines) do
          local pattern = '%f[%w]' .. vim.pesc(target_name) .. '%f[%W]'
          if line:find(pattern) then
            vim.api.nvim_win_set_cursor(state.floating.window, {i, 0})
            break
          end
        end
      end

      vim.notify(string.format('Item "%s" moved to "%s"', item.name, new_path), vim.log.levels.INFO)
    else
      vim.notify(string.format('Failed to move item "%s"', new_path), vim.log.levels.ERROR)
    end
  end)
end

local function handle_item_create()
  local item = get_current_item()
  if not item then
    return
  end

  local base_path = item.type == 'folder' and item.path or vim.fn.fnamemodify(item.path, ':h')

  vim.ui.input({
    prompt = string.format('Create new item: %s', base_path) .. system.get_separator(),
  }, function(input)
    if not input or input == '' then
      vim.notify('Item not created', vim.log.levels.INFO)
      return
    end

    local path             = vim.fs.joinpath(base_path, input)
    local parent_directory = vim.fn.fnamemodify(path, ':h')

    local function exists_anywhere(p)
      if system.is_windows() then
        p = p:gsub('/', '\\')
      end
      local no_slash = p:gsub('[\\/]+$', '')
      return vim.fn.filereadable(no_slash) == 1 or vim.fn.isdirectory(no_slash) == 1
    end

    if system.is_windows() then
      path = path:gsub('/', '\\')
      parent_directory = parent_directory:gsub('/', '\\')
    end

    path = path:gsub("[/\\]$", "")

    if exists_anywhere(path) then
      vim.notify('Item already exists', vim.log.levels.ERROR)
      return
    end

    local is_folder = input:match('[/\\]$') ~= nil
    if is_folder then
      vim.fn.mkdir(path, 'p')
      vim.notify(string.format('Item "%s" created (folder)', path), vim.log.levels.INFO)
    else
      vim.fn.mkdir(parent_directory, 'p')
      local file = io.open(path, 'w')
      if file then
        file:close()
        vim.notify(string.format('Item "%s" created (file)', path), vim.log.levels.INFO)
      else
        vim.notify(string.format('Failed to create item "%s"', path), vim.log.levels.ERROR)
        return
      end
    end

    state.current_directory = parent_directory
    update_items()
    if vim.api.nvim_win_is_valid(state.floating.window) then
      local buffer = vim.api.nvim_win_get_buf(state.floating.window)
      local lines  = vim.api.nvim_buf_get_lines(buffer, 0, -1, false)

      local target_name = vim.fn.fnamemodify(path, ':t')
      for i, line in ipairs(lines) do
        local pattern = '%f[%w]' .. vim.pesc(target_name) .. '%f[%W]'
        if line:find(pattern) then
          vim.api.nvim_win_set_cursor(state.floating.window, {i, 0})
          break
        end
      end
    end
  end)
end

local function handle_item_delete()
  local item = get_current_item()
  if not item or item.name == '.' or item.name == '..' then return end

  if vim.fn.filereadable(item.path) == 0 and vim.fn.isdirectory(item.path) == 0 then
    vim.notify(string.format('Path "%s" no longer exists', item.path), vim.log.levels.ERROR)
    return
  end

  vim.ui.input({
    prompt = string.format('Delete "%s"? (y/n): ', item.path)
  }, function(input)
    if not input or input == '' or input:lower() == 'n' then
      vim.notify('Item not deleted', vim.log.levels.INFO)
      return
    elseif input and input:lower() ~= 'y' then
      vim.notify('Invalid input', vim.log.levels.WARN)
      return
    end

    local function do_delete()
      local ok = vim.fn.delete(item.path, 'rf') == 0
      if ok then
        update_items()
        vim.notify(string.format('Item "%s" deleted', item.name), vim.log.levels.INFO)
      else
        vim.notify(string.format('Failed to delete item "%s"', item.name), vim.log.levels.ERROR)
      end
    end

    if item.type == 'folder' then
      local result = vim.fn.systemlist(system.get_item_count_command(item.path))
      local file_count = tonumber(result[1]) or 0

      if file_count > 0 then
        vim.ui.input({
          prompt = string.format('Folder contains %d items. Delete anyway? (y/n): ', file_count)
        }, function(confirm)
          if not confirm or confirm == '' or confirm:lower() == 'n' then
            vim.notify('Item not deleted', vim.log.levels.INFO)
            return
          elseif confirm and confirm:lower() ~= 'y' then
            vim.notify('Invalid input', vim.log.levels.WARN)
            return
          end

          do_delete()
        end)
      else

        do_delete()
      end
    else

      do_delete()
    end
  end)
end

local function constrain_cursor_position()
  if not state.floating.window or not vim.api.nvim_win_is_valid(state.floating.window) then
    return
  end

  local cursor = vim.api.nvim_win_get_cursor(state.floating.window)
  local row    = cursor[1]
  local column = cursor[2]

  if row < state.header_row_height + 1 then
    vim.api.nvim_win_set_cursor(state.floating.window, {state.header_row_height + 1, 0})
    return
  end

  if column ~= 0 then
    vim.api.nvim_win_set_cursor(state.floating.window, {row, 0})
    return
  end
end

local function navigate_through(direction)
  local total_lines = vim.api.nvim_buf_line_count(state.floating.buffer)
  local cursor = vim.api.nvim_win_get_cursor(state.floating.window)
  local row    = cursor[1]

  local target_row = row + direction
  if target_row >= 1 and target_row <= total_lines then
    vim.api.nvim_win_set_cursor(state.floating.window, {target_row, 0})
  end
end

local function enable_keymaps()
  local opts = {buffer = state.floating.buffer, silent = true}

  vim.keymap.set('n', '<Tab>', function()
    navigate_through(1)
  end, opts)

  vim.keymap.set('n', '<S-Tab>', function()
    navigate_through(-1)
  end, opts)

  vim.keymap.set('n', '<CR>', handle_item_select, opts)

  vim.keymap.set('n', '<2-LeftMouse>', handle_item_select, opts)

  vim.keymap.set('n', 'a', handle_item_create, opts)

  vim.keymap.set('n', 'd', handle_item_delete, opts)

  vim.keymap.set('n', 'm', handle_item_move, opts)

  vim.keymap.set('n', 'o', handle_item_open_in_system, opts)

  vim.keymap.set('n', 'y', function()
    update_items()
  end, opts)

  vim.keymap.set('n', '~', function()
    state.current_directory = vim.fn.expand('~')
    update_items()
    vim.api.nvim_win_set_cursor(state.floating.window, {state.header_row_height + 1, 0})
  end, opts)

  vim.keymap.set('n', 'w', function()
    state.current_directory = state.workspace_directory
    update_items()
    vim.api.nvim_win_set_cursor(state.floating.window, {state.header_row_height + 1, 0})
  end, opts)

  vim.keymap.set('n', '<Esc>', function()
    hide_floating_window()
  end, opts)

  vim.keymap.set('n', 'q', function()
    hide_floating_window()
  end, opts)
end

local function attach_autocmd()
  vim.api.nvim_create_augroup('ZExplorerProtect', {clear = true})

  vim.api.nvim_create_autocmd('VimResized', {
    group = 'ZExplorerProtect',
    callback = function()
      vim.schedule(function()
        hide_floating_window()
      end)
    end
  })

  vim.api.nvim_create_autocmd({'WinEnter', 'WinNew'}, {
    group = 'ZExplorerProtect',
    callback = function()
      vim.schedule(function()
        local window = vim.api.nvim_get_current_win()
        local buffer = vim.api.nvim_win_get_buf(window)
        if not is_floating_window(window) then
          hide_floating_window()
          if is_floating_buffer(buffer) then
            vim.api.nvim_win_close(window, true)
          end
        end
      end)
    end
  })

  vim.api.nvim_create_autocmd({'BufEnter','BufNew'}, {
    group = 'ZExplorerProtect',
    callback = function()
      vim.schedule(function()
        local window = vim.api.nvim_get_current_win()
        local buffer = vim.api.nvim_win_get_buf(window)
        if is_floating_window(window)
        and not is_floating_buffer(buffer) then
          hide_floating_window()
          vim.schedule(function()
            vim.api.nvim_set_current_buf(buffer)
          end)
        end
      end)
    end
  })

  vim.api.nvim_create_autocmd('ModeChanged', {
    group = 'ZExplorerProtect',
    buffer = state.floating.buffer,
    callback = function()
      local mode = vim.api.nvim_get_mode().mode
      if mode == 'v' or mode == 'V' or mode == '\x16' then
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Esc>', true, false, true), 'n', false)
      end
    end
  })

  vim.api.nvim_create_autocmd('CursorMoved', {
    group = 'ZExplorerProtect',
    buffer = state.floating.buffer,
    callback = function()
      constrain_cursor_position()
    end
  })
end

function M.toggle()
  local hidden = hide_floating_window()
  if not hidden then
    state.floating = open_floating_window({buffer = state.floating.buffer})
    update_items()
    enable_keymaps()
    attach_autocmd()
  end
end

function M.setup()
  vim.api.nvim_create_user_command('ZExplorer', M.toggle, {})
  vim.keymap.set('n', '<M-e>', M.toggle, {desc = 'Toggle Explorer'})
end

return M
