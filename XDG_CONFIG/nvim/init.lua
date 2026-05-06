-- [NVIM INIT.LUA FILE] --

-------------------------
-- [Default Options] ---
vim.o.mouse = "" -- disable mouse
vim.opt.ignorecase = true -- case insensitive search
vim.opt.titlestring = "%{$PWD}$ %f" -- title
vim.opt.clipboard = "unnamedplus"
vim.opt.spell = true -- enable spellcheck
vim.opt.undofile = true -- enable undofile
homedir = os.getenv("HOME")
-------------------------
-------------------------

-------------------------
-- [Visual Aids] --------
vim.opt.list = true -- symbols displayed during linewraps, tab, etc
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }
vim.opt.showbreak = "↪ "
vim.opt.inccommand = "split" -- show the pattern being searched in a separate split
vim.opt.cursorline = true	-- highlight the line where a search result is
vim.opt.hlsearch = true		-- highlight all matches to a search
vim.opt.signcolumn = "yes"      -- Reserves space for symbols, preventing text from shifting
-------------------------
-------------------------


-------------------------
-- [Split Behaviour] ----
vim.opt.splitright = true
vim.opt.splitbelow = true
-------------------------
-------------------------


-------------------------
-- [Keymaps] ------------
local opts = { noremap = true, silent = true }
local keymap = vim.api.nvim_set_keymap
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>") -- remove search highlights
keymap("n", "T", ":15split | :terminal<CR>", opts) -- open terminal
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })
keymap("n", "<C-Left>", ":vertical resize +3<CR>", opts)
keymap("n", "<C-Right>", ":vertical resize -3<CR>", opts)
keymap("n", "<C-Up>", ":resize +3<CR>", opts)
keymap("n", "<C-Down>", ":resize -3<CR>", opts)

keymap("n", "qr", "q", opts)
keymap("n", "q", "", opts)
keymap("n", "qa", ":qa!<CR>", opts)
keymap("n", "<C-t>", ":tabnew<CR>", opts)
keymap("n", "qq", ":bd<CR>", opts)
keymap("n", "wa", ":w<CR>", opts)
keymap("n", "wq", ":wq<CR>", opts)
keymap("n", "<S-Right>", ":bnext<CR>", opts)
keymap("n", "<S-Left>", ":bprevious<CR>", opts)
keymap("n", "w<Left>", "<C-w><Left>", opts)
keymap("n", "w<Right>", "<C-w><Right>", opts)
keymap("n", "w<Up>", "<C-w><Up>", opts)
keymap("n", "w<Down>", "<C-w><Down>", opts)

-------------------------
-------------------------
