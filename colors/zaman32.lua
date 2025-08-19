vim.cmd('highlight clear')
if vim.fn.exists('syntax_on') then
  vim.cmd('syntax reset')
end

vim.o.background  = "dark"
vim.g.colors_name = "zaman32"

local palette = {
  -- Background - Much darker than original Kanagawa
  bg0     = '#0d0c0e',  -- Deep dark background
  bg1     = '#16161d',  -- Main background
  bg2     = '#1f1f28',  -- Slightly lighter background
  bg3     = '#2a2a37',  -- Selection/highlight background
  bg4     = '#363646',  -- Lighter UI elements

  -- Foreground - Higher contrast
  fg0     = '#ddd8bb',  -- Main text (brighter cream)
  fg1     = '#c8c093',  -- Dimmed text
  fg2     = '#938056',  -- Comments, line numbers
  fg3     = '#54546d',  -- Very dim text

  -- Kanagawa-inspired palette with more contrast
  red     = '#ff5d62',  -- Brighter red
  orange  = '#ffa066',  -- Enhanced orange
  yellow  = '#e6c384',  -- Warmer yellow
  green   = '#98bb6c',  -- Vibrant green
  cyan    = '#7fb4ca',  -- Clear cyan
  blue    = '#7e9cd8',  -- Bright blue
  purple  = '#957fb8',  -- Enhanced purple
  magenta = '#d27e99',  -- Bright magenta

  -- Special colors
  accent  = '#658594',  -- Accent color
  warning = '#e98a00',  -- Orange warning
  error   = '#e82424',  -- Bright error red
  success = '#76946a',  -- Success green
}

vim.api.nvim_set_hl(0, 'Normal',      {fg = palette.fg0, bg = palette.bg1})
vim.api.nvim_set_hl(0, 'NormalFloat', {fg = palette.fg0, bg = palette.bg1})
vim.api.nvim_set_hl(0, 'FloatBorder', {fg = palette.fg3, bg = palette.bg1})
vim.api.nvim_set_hl(0, 'FloatTitle',  {fg = palette.fg1, bg = palette.bg1, bold = true})
vim.api.nvim_set_hl(0, 'NormalNC',    {fg = palette.fg0, bg = palette.bg1})
vim.api.nvim_set_hl(0, 'SignColumn',  {fg = palette.fg3, bg = palette.bg1})
vim.api.nvim_set_hl(0, 'EndOfBuffer', {fg = palette.bg3, bg = palette.bg1})

vim.api.nvim_set_hl(0, 'Cursor',       {fg = palette.bg1, bg = palette.fg0})
vim.api.nvim_set_hl(0, 'CursorLine',   {bg = palette.bg2})
vim.api.nvim_set_hl(0, 'CursorColumn', {bg = palette.bg2})
vim.api.nvim_set_hl(0, 'ColorColumn',  {bg = palette.bg2})
vim.api.nvim_set_hl(0, 'CursorLineNr', {fg = palette.accent, bold = true})
vim.api.nvim_set_hl(0, 'LineNr',       {fg = palette.fg3, bg = palette.bg})

vim.api.nvim_set_hl(0, 'Visual',    {bg = '#2d4f67'})
vim.api.nvim_set_hl(0, 'VisualNOS', {bg = '#2d4f67'})

vim.api.nvim_set_hl(0, 'Search',     {fg = palette.bg1, bg = '#c0a36e'})
vim.api.nvim_set_hl(0, 'IncSearch',  {fg = palette.bg1, bg = '#c0a36e'})
vim.api.nvim_set_hl(0, 'Substitute', {fg = palette.bg1, bg = '#e46876'})

vim.api.nvim_set_hl(0, 'ModeMsg',    {fg = palette.green, bold = true})
vim.api.nvim_set_hl(0, 'MoreMsg',    {fg = palette.cyan, bold = true})
vim.api.nvim_set_hl(0, 'Question',   {fg = palette.yellow, bold = true})
vim.api.nvim_set_hl(0, 'ErrorMsg',   {fg = palette.error, bold = true})
vim.api.nvim_set_hl(0, 'WarningMsg', {fg = palette.warning, bold = true})

vim.api.nvim_set_hl(0, 'Pmenu',      {fg = palette.fg1, bg = palette.bg3})
vim.api.nvim_set_hl(0, 'PmenuSel',   {fg = palette.bg1, bg = palette.accent, bold = true})
vim.api.nvim_set_hl(0, 'PmenuSbar',  {bg = palette.bg4})
vim.api.nvim_set_hl(0, 'PmenuThumb', {bg = palette.fg3})

vim.api.nvim_set_hl(0, 'StatusLine',   {fg = palette.fg0, bg = '#363646', bold = true})
vim.api.nvim_set_hl(0, 'StatusLineNC', {fg = palette.fg2, bg = '#2a2a37'})

vim.api.nvim_set_hl(0, 'TabLine',     {fg = palette.fg1, bg = '#2a2a37'})
vim.api.nvim_set_hl(0, 'TabLineSel',  {fg = palette.fg0, bg = '#2a2a37', bold = true})
vim.api.nvim_set_hl(0, 'TabLineFill', {fg = palette.fg3, bg = '#2a2a37'})

vim.api.nvim_set_hl(0, 'WinSeparator', {fg = palette.bg4})
vim.api.nvim_set_hl(0, 'VertSplit',    {fg = palette.bg4})

vim.api.nvim_set_hl(0, 'Folded',     {fg = palette.fg2, bg = palette.bg2})
vim.api.nvim_set_hl(0, 'FoldColumn', {fg = palette.fg3, bg = palette.bg1})

vim.api.nvim_set_hl(0, 'DiffAdd',    {fg = palette.green, bg = palette.bg2})
vim.api.nvim_set_hl(0, 'DiffChange', {fg = palette.yellow, bg = palette.bg2})
vim.api.nvim_set_hl(0, 'DiffDelete', {fg = palette.red, bg = palette.bg2})
vim.api.nvim_set_hl(0, 'DiffText',   {fg = palette.orange, bg = palette.bg3, bold = true})

vim.api.nvim_set_hl(0, 'SpellBad',   {fg = palette.error, undercurl = true})
vim.api.nvim_set_hl(0, 'SpellCap',   {fg = palette.warning, undercurl = true})
vim.api.nvim_set_hl(0, 'SpellLocal', {fg = palette.cyan, undercurl = true})
vim.api.nvim_set_hl(0, 'SpellRare',  {fg = palette.purple, undercurl = true})

vim.api.nvim_set_hl(0, 'Comment', {fg = palette.fg2, italic = true})
vim.api.nvim_set_hl(0, 'Todo',    {fg = palette.warning, bg = palette.bg2, bold = true})
vim.api.nvim_set_hl(0, 'Error',   {fg = palette.error, bold = true})

vim.api.nvim_set_hl(0, 'Constant',  {fg = palette.orange})
vim.api.nvim_set_hl(0, 'String',    {fg = palette.green})
vim.api.nvim_set_hl(0, 'Character', {fg = palette.green})
vim.api.nvim_set_hl(0, 'Number',    {fg = palette.magenta})
vim.api.nvim_set_hl(0, 'Boolean',   {fg = palette.magenta})
vim.api.nvim_set_hl(0, 'Float',     {fg = palette.magenta})

vim.api.nvim_set_hl(0, 'Identifier', {fg = palette.cyan})
vim.api.nvim_set_hl(0, 'Function',   {fg = palette.blue})

vim.api.nvim_set_hl(0, 'Statement',   {fg = palette.purple})
vim.api.nvim_set_hl(0, 'Conditional', {fg = palette.purple})
vim.api.nvim_set_hl(0, 'Repeat',      {fg = palette.purple})
vim.api.nvim_set_hl(0, 'Label',       {fg = palette.purple})
vim.api.nvim_set_hl(0, 'Operator',    {fg = palette.red})
vim.api.nvim_set_hl(0, 'Keyword',     {fg = palette.purple})
vim.api.nvim_set_hl(0, 'Exception',   {fg = palette.purple})

vim.api.nvim_set_hl(0, 'PreProc',   {fg = palette.red})
vim.api.nvim_set_hl(0, 'Include',   {fg = palette.red})
vim.api.nvim_set_hl(0, 'Define',    {fg = palette.red})
vim.api.nvim_set_hl(0, 'Macro',     {fg = palette.red})
vim.api.nvim_set_hl(0, 'PreCondit', {fg = palette.red})

vim.api.nvim_set_hl(0, 'Type',         {fg = palette.cyan})
vim.api.nvim_set_hl(0, 'StorageClass', {fg = palette.cyan})
vim.api.nvim_set_hl(0, 'Structure',    {fg = palette.cyan})
vim.api.nvim_set_hl(0, 'Typedef',      {fg = palette.cyan})

vim.api.nvim_set_hl(0, 'Special',        {fg = palette.yellow})
vim.api.nvim_set_hl(0, 'SpecialChar',    {fg = palette.yellow})
vim.api.nvim_set_hl(0, 'Tag',            {fg = palette.yellow})
vim.api.nvim_set_hl(0, 'Delimiter',      {fg = palette.fg1})
vim.api.nvim_set_hl(0, 'SpecialComment', {fg = palette.fg2, italic = true})
vim.api.nvim_set_hl(0, 'Debug',          {fg = palette.warning})

vim.api.nvim_set_hl(0, 'Underlined', {fg = palette.blue, underline = true})
vim.api.nvim_set_hl(0, 'Ignore',     {fg = palette.fg3})
vim.api.nvim_set_hl(0, 'Bold',       {bold = true})
vim.api.nvim_set_hl(0, 'Italic',     {italic = true})

vim.api.nvim_set_hl(0, '@variable',           {fg = palette.fg0})
vim.api.nvim_set_hl(0, '@variable.builtin',   {fg = palette.red})
vim.api.nvim_set_hl(0, '@variable.parameter', {fg = palette.yellow})
vim.api.nvim_set_hl(0, '@variable.member',    {fg = palette.cyan})

vim.api.nvim_set_hl(0, '@constant',         {fg = palette.orange})
vim.api.nvim_set_hl(0, '@constant.builtin', {fg = palette.magenta})
vim.api.nvim_set_hl(0, '@constant.macro',   {fg = palette.red})

vim.api.nvim_set_hl(0, '@module', {fg = palette.red})
vim.api.nvim_set_hl(0, '@label',  {fg = palette.purple})

vim.api.nvim_set_hl(0, '@string',        {fg = palette.green})
vim.api.nvim_set_hl(0, '@string.regex',  {fg = palette.orange})
vim.api.nvim_set_hl(0, '@string.escape', {fg = palette.red})

vim.api.nvim_set_hl(0, '@character',         {fg = palette.green})
vim.api.nvim_set_hl(0, '@character.special', {fg = palette.red})

vim.api.nvim_set_hl(0, '@number',  {fg = palette.magenta})
vim.api.nvim_set_hl(0, '@boolean', {fg = palette.magenta})
vim.api.nvim_set_hl(0, '@float',   {fg = palette.magenta})

vim.api.nvim_set_hl(0, '@function',         {fg = palette.blue})
vim.api.nvim_set_hl(0, '@function.builtin', {fg = palette.red})
vim.api.nvim_set_hl(0, '@function.macro',   {fg = palette.red})
vim.api.nvim_set_hl(0, '@function.method',  {fg = palette.blue})

vim.api.nvim_set_hl(0, '@constructor', {fg = palette.cyan})
vim.api.nvim_set_hl(0, '@operator',    {fg = palette.red})

vim.api.nvim_set_hl(0, '@keyword',          {fg = palette.purple})
vim.api.nvim_set_hl(0, '@keyword.function', {fg = palette.purple})
vim.api.nvim_set_hl(0, '@keyword.return',   {fg = palette.purple})
vim.api.nvim_set_hl(0, '@keyword.operator', {fg = palette.red})

vim.api.nvim_set_hl(0, '@conditional', {fg = palette.purple})
vim.api.nvim_set_hl(0, '@repeat',      {fg = palette.purple})
vim.api.nvim_set_hl(0, '@exception',   {fg = palette.purple})

vim.api.nvim_set_hl(0, '@type',            {fg = palette.cyan})
vim.api.nvim_set_hl(0, '@type.builtin',    {fg = palette.red})
vim.api.nvim_set_hl(0, '@type.definition', {fg = palette.cyan})

vim.api.nvim_set_hl(0, '@attribute', {fg = palette.red})
vim.api.nvim_set_hl(0, '@property',  {fg = palette.cyan})

vim.api.nvim_set_hl(0, '@comment',         {fg = palette.fg2, italic = true})
vim.api.nvim_set_hl(0, '@comment.todo',    {fg = palette.warning, bg = palette.bg2, bold = true})
vim.api.nvim_set_hl(0, '@comment.note',    {fg = palette.cyan, bg = palette.bg2, bold = true})
vim.api.nvim_set_hl(0, '@comment.warning', {fg = palette.warning, bg = palette.bg2, bold = true})
vim.api.nvim_set_hl(0, '@comment.error',   {fg = palette.error, bg = palette.bg2, bold = true})

vim.api.nvim_set_hl(0, '@markup.heading',       {fg = palette.orange, bold = true})
vim.api.nvim_set_hl(0, '@markup.raw',           {fg = palette.green})
vim.api.nvim_set_hl(0, '@markup.link',          {fg = palette.blue})
vim.api.nvim_set_hl(0, '@markup.link.url',      {fg = palette.blue, underline = true})
vim.api.nvim_set_hl(0, '@markup.link.label',    {fg = palette.cyan})
vim.api.nvim_set_hl(0, '@markup.list',          {fg = palette.red})
vim.api.nvim_set_hl(0, '@markup.strong',        {fg = palette.fg0, bold = true})
vim.api.nvim_set_hl(0, '@markup.italic',        {fg = palette.fg0, italic = true})
vim.api.nvim_set_hl(0, '@markup.strikethrough', {fg = palette.fg2, strikethrough = true})

vim.api.nvim_set_hl(0, 'DiagnosticError',{fg = palette.error})
vim.api.nvim_set_hl(0, 'DiagnosticWarn', {fg = palette.warning})
vim.api.nvim_set_hl(0, 'DiagnosticInfo', {fg = palette.cyan})
vim.api.nvim_set_hl(0, 'DiagnosticHint', {fg = palette.fg2})

vim.api.nvim_set_hl(0, 'DiagnosticUnderlineError', {undercurl = true, sp = palette.error})
vim.api.nvim_set_hl(0, 'DiagnosticUnderlineWarn',  {undercurl = true, sp = palette.warning})
vim.api.nvim_set_hl(0, 'DiagnosticUnderlineInfo',  {undercurl = true, sp = palette.cyan})
vim.api.nvim_set_hl(0, 'DiagnosticUnderlineHint',  {undercurl = true, sp = palette.fg2})
