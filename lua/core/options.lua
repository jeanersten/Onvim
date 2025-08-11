vim.opt.completeopt = 'menuone,popup,noselect' -- better completion
vim.opt.showfulltag = true                     -- full tag in completion

vim.opt.number        = true        -- enable line numbers
vim.opt.cursorline    = true        -- enable highlight line
vim.opt.cursorcolumn  = true        -- enable highlight column
vim.opt.cursorlineopt = 'line'      -- set highlight only line
vim.opt.laststatus    = 3           -- set global statusline
vim.opt.showtabline   = 2           -- set always show tabline
vim.opt.signcolumn    = 'yes'       -- set always show signcolumn
vim.opt.wrap          = false       -- disable line wrap
vim.opt.fillchars     = {eob = ' '} -- change '~' to ' ' at eof
vim.opt.winborder     = 'single'    -- default floating window border

vim.opt.expandtab   = true    -- enable tabs convertion to spaces
vim.opt.shiftwidth  = 2       -- set indent width
vim.opt.softtabstop = 2       -- set soft tab width
vim.opt.tabstop     = 2       -- set real tab width
vim.opt.smartindent = true    -- enable smart indent
vim.opt.smartcase   = true    -- enable smart case search
vim.opt.virtualedit = 'block' -- set free cursor in block mode

vim.opt.swapfile    = false -- disable swapfile
vim.opt.undofile    = true  -- enable undo history
vim.opt.writebackup = false -- disable write backup

vim.opt.confirm   = true -- enable confirm on quit
vim.opt.mouse     = 'a'  -- set mouse
vim.opt.scrolloff = 8    -- set scroll margin

vim.opt.showmode   = false                        -- disable showinng mode in command line
vim.opt.statusline = '%!v:lua.setup_statusline()' -- set lua statusline from function
vim.opt.tabline    = '%!v:lua.setup_tabline()'    -- set lua tabline from function
