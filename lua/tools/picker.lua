local M = {}

local state = {
  floating_prompt = {
    buffer = -1,
    window = -1
  },
  floating_list = {
    buffer = -1,
    window = -1
  },
  title          = 'Picker',
  files          = {},
  max_display    = 100,
  loading        = false,
  debounce_timer = nil,
  commentns      = vim.api.nvim_create_namespace('ZPickerHighlight')
}

local icons = {
  prompt_search   = '󰱼',
  file_normal     = '󰈔',
  file_code       = '󰈮',
  file_config     = '󱁻',
  file_text       = '󱇧',
  file_image      = '󰈟',
  file_executable = '󰲋'
}

local function open_floating_window(opts_prompt, opts_list)
  opts_prompt = opts_prompt or {}
  opts_list   = opts_list or {}

  local buffer_prompt = nil
  if vim.api.nvim_buf_is_valid(opts_prompt.buffer) then
    buffer_prompt = opts_prompt.buffer
  else
    buffer_prompt = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_set_option_value('bufhidden', 'wipe', {buf = buffer_prompt})
    vim.api.nvim_set_option_value('filetype', 'picker', {buf = buffer_prompt})
    vim.api.nvim_set_option_value('buftype', 'prompt', {buf = buffer_prompt})
    vim.fn.prompt_setprompt(buffer_prompt, ' ' .. icons.prompt_search .. ': ')
    vim.schedule(function()
      vim.cmd('startinsert')
      vim.defer_fn(function()
        vim.cmd('stopinsert')
      end, 5)
    end)
  end

  local buffer_list = nil
  if vim.api.nvim_buf_is_valid(opts_list.buffer) then
    buffer_list = opts_list.buffer
  else
    buffer_list = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_set_option_value('bufhidden', 'wipe', {buf = buffer_list})
    vim.api.nvim_set_option_value('filetype', 'picker', {buf = buffer_list})
  end

  local total_width  = math.floor(vim.o.columns / 2)
  local total_height = math.floor(vim.o.lines / 2)
  local start_row    = math.floor((vim.o.lines - total_height) / 2)
  local start_column = math.floor((vim.o.columns - total_width) / 2)

  local config_prompt = {
    relative = 'editor',
    width    = total_width,
    height   = 1,
    row      = start_row,
    col      = start_column,
    style    = 'minimal',
    border   = 'single',
    title    = (' ' .. state.title .. ' ')
  }

  local window_prompt = vim.api.nvim_open_win(buffer_prompt, true, config_prompt)
  vim.api.nvim_set_option_value('winfixbuf', true, {win = window_prompt})
  vim.api.nvim_set_option_value('winfixwidth', true, {win = window_prompt})
  vim.api.nvim_set_option_value('winfixheight', true, {win = window_prompt})
  vim.api.nvim_set_option_value('wrap', true, {win = window_prompt})
  vim.api.nvim_set_hl(0, 'FloatBorder', {link = 'Normal'})
  vim.api.nvim_set_hl(0, 'NormalFloat', {link = 'Normal'})

  local config_list = {
    relative  = 'editor',
    width     = total_width,
    height    = total_height - 3,
    row       = start_row + 3,
    col       = start_column,
    style     = 'minimal',
    border    = 'single',
    title     = ' Results ',
    title_pos = 'center'
  }

  local window_list = vim.api.nvim_open_win(buffer_list, false, config_list)
  vim.api.nvim_set_option_value('winfixbuf', true, {win = window_list})
  vim.api.nvim_set_option_value('winfixwidth', true, {win = window_list})
  vim.api.nvim_set_option_value('winfixheight', true, {win = window_list})
  vim.api.nvim_set_option_value('cursorline', true, {win = window_list})
  vim.api.nvim_set_hl(0, 'FloatBorder', {link = 'Normal'})
  vim.api.nvim_set_hl(0, 'NormalFloat', {link = 'Normal'})

  return {buffer = buffer_prompt, window = window_prompt},
         {buffer = buffer_list  , window = window_list}
end

local function hide_floating_window()
  local hidden = false
  if vim.api.nvim_win_is_valid(state.floating_prompt.window) then
    vim.api.nvim_win_close(state.floating_prompt.window, true)
    state.floating_prompt.window = -1
    hidden = true
  end
  if vim.api.nvim_win_is_valid(state.floating_list.window) then
    vim.api.nvim_win_close(state.floating_list.window, true)
    state.floating_list.window = -1
    hidden = true
  end

  return hidden
end

local function is_floating_buffer(buffer)
  return buffer == state.floating_prompt.buffer or buffer == state.floating_list.buffer
end

local function is_floating_window(window)
  return window == state.floating_prompt.window or window == state.floating_list.window
end

local function get_file_icon(filename)
  local extension_code_list = {
    'c', 'cpp', 'h', 'hpp', 'lua', 'py', 'rs', 'go', 'java', 'cs',
    'ts', 'tsx', 'js', 'jsx', 'sh', 'bash', 'zsh', 'fish', 'rb', 'php',
    'swift', 'kt', 'm', 'mm'
  }
  local extension_config_list = {
    'conf', 'json', 'jsonc', 'toml', 'yaml', 'yml', 'ini', 'cfg', 'env', 'editorconfig'
  }
  local extension_text_list = {
    'md', 'markdown', 'txt', 'log', 'rst', 'org'
  }
  local extension_image_list = {
    'bmp', 'gif', 'jpg', 'jpeg', 'png', 'webp', 'svg', 'tiff', 'ico', 'heic'
  }
  local extension_executable_list = {
    'exe', 'bat', 'cmd', 'sh', 'bin', 'run', 'msi', 'apk', 'app', 'elf'
  }

  local extension = filename:match('%.([^%.]+)$')
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

local function render()
  local lines = {}

  if #state.files == 0 then
    lines = {string.format(' %s %s', icons.file_normal, 'Nothing to display over here..')}
  elseif state.loading == true then
    lines = {string.format(' %s %s', icons.file_normal, 'Loading..')}
  else
    for i, filename in ipairs(state.files) do
      lines[i] = string.format(' %s %s', get_file_icon(filename), filename)
    end
  end

  if vim.api.nvim_buf_is_valid(state.floating_list.buffer) then
    vim.api.nvim_set_option_value('modifiable', true, {buf = state.floating_list.buffer})
    vim.api.nvim_buf_set_lines(state.floating_list.buffer, 0, -1, false, lines)
    vim.api.nvim_set_option_value('modifiable', false, {buf = state.floating_list.buffer})
    vim.api.nvim_buf_clear_namespace(state.floating_list.buffer, state.commentns, 0, -1)
  end

  if #state.files == 0 or state.loading == true then
    vim.api.nvim_buf_add_highlight(state.floating_list.buffer, state.commentns, 'Comment', 0, 0, -1)
  end
end

local function get_prompt_query()
  local line   = vim.api.nvim_buf_get_lines(state.floating_prompt.buffer, 0, 1, false)[1]
  local prompt = vim.fn.prompt_getprompt(state.floating_prompt.buffer)

  return line:sub(#prompt + 1)
end

local function update_files()
  if state.debounce_timer then
    vim.fn.timer_stop(state.debounce_timer)
  end

  state.debounce_timer = vim.fn.timer_start(200, function()
    local query = get_prompt_query()
    if not query or query == '' then
      state.files = {}
      render()

      return
    end

    state.loading = true
    render()

    local query_lower = query:lower()
    local results     = {}

    vim.schedule(function()
      vim.fn.jobstart('rg --files --color never --ignore-case --hidden', {
        stdout_buffered = true,
        on_stdout = function(_, data)
          if data then
            for _, path in ipairs(data) do
              if path ~= '' and #results < state.max_display then
                if path:lower():find(query_lower, 1, true)
                  and vim.fn.filereadable(path) == 1 then
                  results[#results + 1] = path
                end
              end
            end
          end
        end,
        on_exit = function()
          table.sort(results)
          state.files = results
          state.loading = false
          vim.schedule(function()
            render()
          end)
        end
      })
    end)
  end)
end

local function get_selected_file()
  local item_index = vim.api.nvim_win_get_cursor(state.floating_list.window)[1]
  if item_index > #state.files then
    return nil
  end

  return state.files[item_index]
end

local function handle_file_open()
  local file = get_selected_file()
  if not file then
    return
  end

  hide_floating_window()
  vim.cmd('edit ' .. vim.fn.fnameescape(file))
end

local function fix_cursor_position()
  local window = vim.api.nvim_get_current_win()
  local cursor = vim.api.nvim_win_get_cursor(window)
  local row    = cursor[1]
  local column = cursor[2]

  if (window == state.floating_prompt.window) then
    local prompt_text        = vim.fn.prompt_getprompt(state.floating_prompt.buffer)
    local prompt_text_length = string.len(prompt_text)

    if row == 1 and column < prompt_text_length then
      vim.api.nvim_win_set_cursor(0, {1, prompt_text_length})
    end
  elseif (window == state.floating_list.window) then
    vim.schedule(function()
      vim.api.nvim_set_current_win(state.floating_prompt.window)
    end)
  end
end

local function navigate_through(direction)
  local total_lines = vim.api.nvim_buf_line_count(state.floating_list.buffer)
  local cursor = vim.api.nvim_win_get_cursor(state.floating_list.window)
  local row    = cursor[1]

  local target_row = row + direction

  if target_row < 1 then
    target_row = total_lines
  elseif target_row > total_lines then
    target_row = 1
  end

  vim.api.nvim_win_set_cursor(state.floating_list.window, {target_row, 0})
end

local function enable_keymaps()
  local opts = {buffer = state.floating_prompt.buffer, silent = true}

  vim.keymap.set({'n', 'i'}, '<Tab>', function()
    navigate_through(1)
  end, opts)

  vim.keymap.set({'n', 'i'}, '<S-Tab>', function()
    navigate_through(-1)
  end, opts)

  vim.keymap.set({'n', 'i'}, '<CR>', handle_file_open, opts)

  vim.keymap.set({'n', 'i'}, '<2-LeftMouse>', handle_file_open, opts)

  vim.keymap.set('n', '<Esc>', hide_floating_window, opts)

  vim.keymap.set('n', 'q', hide_floating_window, opts)
end

local function attach_autocmd()
  vim.api.nvim_create_augroup('ZPickerProtect', {clear = true})

  vim.api.nvim_create_autocmd('VimResized', {
    group = 'ZPickerProtect',
    callback = function()
      vim.schedule(function()
        hide_floating_window()
      end)
    end
  })

  vim.api.nvim_create_autocmd('WinClosed', {
    group = 'ZPickerProtect',
    callback = function(args)
      vim.schedule(function()
        local window = tonumber(args.match)
        if is_floating_window(window) then
          hide_floating_window()
        end
      end)
    end
  })

  vim.api.nvim_create_autocmd({'WinEnter', 'WinNew'}, {
    group = 'ZPickerProtect',
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
    group = 'ZPickerProtect',
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

  vim.api.nvim_create_autocmd('BufModifiedSet', {
    group = 'ZPickerProtect',
    buffer = state.floating_prompt.buffer,
    callback = function()
      vim.api.nvim_set_option_value('modified', false, {buf = state.floating_prompt.buffer})
    end
  })

  vim.api.nvim_create_autocmd('ModeChanged', {
    group = 'ZPickerProtect',
    buffer = state.floating_prompt.buffer,
    callback = function()
      local mode = vim.api.nvim_get_mode().mode
      if mode == 'v' or mode == 'V' or mode == '\x16' then
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Esc>', true, false, true), 'n', false)
      end
    end
  })

  vim.api.nvim_create_autocmd('ModeChanged', {
    group = 'ZPickerProtect',
    buffer = state.floating_list.buffer,
    callback = function()
      local mode = vim.api.nvim_get_mode().mode
      if mode == 'v' or mode == 'V' or mode == '\x16' then
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Esc>', true, false, true), 'n', false)
      end
    end
  })

  vim.api.nvim_create_autocmd('TextChanged', {
    group = 'ZPickerProtect',
    buffer = state.floating_prompt.buffer,
    callback = function()
      local lines = vim.api.nvim_buf_get_lines(state.floating_prompt.buffer, 0, -1, false)
      local empty = true

      for _, line in ipairs(lines) do
        if line ~= '' then
          empty = false
          break
        end
      end

      if empty then
        vim.schedule(function()
          vim.cmd('startinsert')
          vim.defer_fn(function()
            vim.cmd('stopinsert')
          end, 5)
        end)
      end

      update_files()
    end
  })

  vim.api.nvim_create_autocmd('TextChangedI', {
    group = 'ZPickerProtect',
    buffer = state.floating_prompt.buffer,
    callback = function()
      update_files()
    end
  })

  vim.api.nvim_create_autocmd('CursorMoved', {
    group = 'ZPickerProtect',
    callback = function()
      fix_cursor_position()
    end
  })
end

function M.toggle()
  local hidden = hide_floating_window()
  if not hidden then
    state.floating_prompt, state.floating_list = open_floating_window({buffer = state.floating_prompt.buffer}, {buffer = state.floating_list.buffer})
    update_files()
    enable_keymaps()
    attach_autocmd()
  end
end

function M.setup()
  vim.api.nvim_create_user_command('ZPicker', M.toggle, {})
  vim.keymap.set('n', '<M-f>', M.toggle, {desc = 'Toggle Picker'})
end

return M
