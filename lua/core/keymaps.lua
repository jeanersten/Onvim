vim.keymap.set('i', 'df', '<ESC>', {})               -- d then f to go back to normal mode from insert mode
vim.keymap.set('t', 'df', '<C-\\><C-n>', {})         -- d then f to go back to normal mode from terminal mode
vim.keymap.set('n', '<C-c>', '<CMD> close <CR>', {}) -- ctrl+c to close

vim.keymap.set('n', '<M-k>', '<CMD> wincmd k <CR>', {}) -- alt+k to move window context up
vim.keymap.set('n', '<M-j>', '<CMD> wincmd j <CR>', {}) -- alt+j to move window context down
vim.keymap.set('n', '<M-l>', '<CMD> wincmd l <CR>', {}) -- alt+l to move window context left
vim.keymap.set('n', '<M-h>', '<CMD> wincmd h <CR>', {}) -- alt+h to move window context right
vim.keymap.set('n', '<M-Up>',    '<CMD> horizontal resize +1 | set cmdheight=1 <CR>', {}) -- alt+up to resize window bigger horizontally
vim.keymap.set('n', '<M-Down>',  '<CMD> horizontal resize -1 | set cmdheight=1 <CR>', {}) -- alt+up to resize window smaller horizontally
vim.keymap.set('n', '<M-Right>', '<CMD> vertical resize +1 | set cmdheight=1 <CR>', {})   -- alt+up to resize window vertically
vim.keymap.set('n', '<M-Left>',  '<CMD> vertical resize -1 | set cmdheight=1 <CR>', {})   -- alt+up to resize window smaller vertically
