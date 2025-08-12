local opts = {noremap = true, silent = true}

vim.keymap.set('i', 'df', '<ESC>', opts)       -- d then f to go back to normal mode from insert mode
vim.keymap.set('t', 'df', '<C-\\><C-n>', opts) -- d then f to go back to normal mode from terminal mode

vim.keymap.set('n', '<M-k>', '<CMD> wincmd k <CR>', opts) -- alt+k to move window context up
vim.keymap.set('n', '<M-j>', '<CMD> wincmd j <CR>', opts) -- alt+j to move window context down
vim.keymap.set('n', '<M-l>', '<CMD> wincmd l <CR>', opts) -- alt+l to move window context left
vim.keymap.set('n', '<M-h>', '<CMD> wincmd h <CR>', opts) -- alt+h to move window context right
vim.keymap.set('n', '<M-Up>',    '<CMD> horizontal resize +1 | set cmdheight=1 <CR>', opts) -- alt+up to resize window bigger horizontally
vim.keymap.set('n', '<M-Down>',  '<CMD> horizontal resize -1 | set cmdheight=1 <CR>', opts) -- alt+up to resize window smaller horizontally
vim.keymap.set('n', '<M-Right>', '<CMD> vertical resize +1 | set cmdheight=1 <CR>', opts)   -- alt+up to resize window vertically
vim.keymap.set('n', '<M-Left>',  '<CMD> vertical resize -1 | set cmdheight=1 <CR>', opts)   -- alt+up to resize window smaller vertically

vim.keymap.set('n', '<Tab>',   '<CMD> tabnext <CR>', opts)     -- tab to go to next tab
vim.keymap.set('n', '<S-Tab>', '<CMD> tabprevious <CR>', opts) -- tab to go to previous tab
vim.keymap.set('n', '<M-s>',   '<CMD> bnext <CR>', opts)       -- alt+s to go to next buffer
vim.keymap.set('n', '<M-a>',   '<CMD> bprevious <CR>', opts)   -- alt+a to go to previous buffer

vim.keymap.set('n', '<M-c>', '<CMD> nohl <CR>', opts) -- alt+c to clear highlight

vim.keymap.set({'n', 'v'}, '<Space>', '<Nop>', opts) -- make space do nothing
vim.keymap.set('n', '<C-u>', '<C-u>zz', opts)        -- center when scrolling up
vim.keymap.set('n', '<C-d>', '<C-d>zz', opts)        -- center when scrolling down
