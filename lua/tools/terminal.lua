local M = {}

local state = {
  floating = {
    buffer = -1,
    window = -1
  },
  title = 'Terminal',
}

local function open_floating_window(opts)
  opts = opts or {}

  local buffer = nil
  if vim.api.nvim_buf_is_valid(opts.buffer) then
    buffer = opts.buffer
  else
    buffer = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_set_option_value('bufhidden', 'wipe', {buf = buffer})
    vim.api.nvim_set_option_value('filetype', 'terminal', {buf = buffer})
  end

  local width  = math.floor(vim.o.columns / 2)
  local height = math.floor(vim.o.lines / 2)
  local row    = math.floor((vim.o.lines - height) / 2)
  local column = math.floor((vim.o.columns - width) / 2)

  local config = {
    relative = 'editor',
    width    = width,
    height   = height,
    row      = row,
    col      = column,
    style    = 'minimal',
    border   = 'single',
    title    = (' ' .. state.title .. ' ')
  }

  local window = vim.api.nvim_open_win(buffer, true, config)
  vim.api.nvim_set_option_value('winfixbuf', true, {win = window})
  vim.api.nvim_set_option_value('winfixwidth', true, {win = window})
  vim.api.nvim_set_option_value('winfixheight', true, {win = window})

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

local function start_terminal()
  local buffer = state.floating.buffer
  if vim.b[buffer].terminal_job_id then return end

  vim.fn.termopen(vim.o.shell)
end

local function stop_terminal()
  if vim.api.nvim_buf_is_valid(state.floating.buffer) then
    local job_id = vim.b[state.floating.buffer].terminal_job_id
    if job_id then
      vim.fn.jobstop(job_id)
    end
  end
end

local function enable_keymaps()
  local opts = {buffer = state.floating.buffer, silent = true}

  vim.keymap.set('n', '<Esc>', hide_floating_window, opts)

  vim.keymap.set('n', 'q', hide_floating_window, opts)
end

local function attach_autocmd()
  vim.api.nvim_create_augroup('ZTerminalProtect', {clear = true})

  vim.api.nvim_create_autocmd('QuitPre', {
    callback = function()
      stop_terminal()
    end
  })

  vim.api.nvim_create_autocmd('VimResized', {
    group = 'ZTerminalProtect',
    callback = function()
      vim.schedule(function()
        hide_floating_window()
      end)
    end
  })

  vim.api.nvim_create_autocmd({'WinEnter', 'WinNew'}, {
    group = 'ZTerminalProtect',
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
    group = 'ZTerminalProtect',
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
end

function M.toggle()
  local hidden = hide_floating_window()
  if not hidden then
    state.floating = open_floating_window({buffer = state.floating.buffer})
    start_terminal()
    enable_keymaps()
    attach_autocmd()
  end
end

function M.setup()
  vim.api.nvim_create_user_command('ZTerminal', M.toggle, {})
  vim.keymap.set('n', '<M-t>', M.toggle, {desc = 'Toggle Terminal'})
end

return M
