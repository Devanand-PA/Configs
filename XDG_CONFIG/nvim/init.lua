--- [NVIM INIT.LUA FILE] --

-------------------------
--- [Default Options] ---
vim.o.mouse = "" -- disable mouse
vim.opt.ignorecase = true -- case insensitive search
vim.opt.title = true
vim.opt.titlestring = "%{$PWD}$ %f" -- title
vim.opt.clipboard = "unnamedplus"
vim.opt.spell = true -- enable spellcheck
vim.opt.undofile = true -- enable undofile
homedir = os.getenv("HOME")
-------------------------
-------------------------

-------------------------
--- [Visual Aids] --------
--- vim.opt.number = true
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
--- [Split Behaviour] ----
vim.opt.splitright = true
vim.opt.splitbelow = true
-------------------------
-------------------------


-------------------------
--- [Keymaps] ------------
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

-------------------------
-----[Autocomplete] -----
-- Completion sources (current buffer + other buffers)
vim.opt.complete = { ".", "b" }

-- Make popup behave like autocomplete
vim.opt.completeopt = { "menuone", "noinsert", "noselect" }

-- Auto-trigger completion while typing
vim.api.nvim_create_autocmd("TextChangedI", {
  callback = function()
    -- Don't trigger inside completion already
    if vim.fn.pumvisible() == 0 then
      -- Get current line and cursor position
      local col = vim.fn.col(".") - 1
      if col > 0 then
        local line = vim.fn.getline(".")
        local char_before = line:sub(col, col)

        -- Trigger only if previous character is part of a word
        if char_before:match("%w") then
          vim.api.nvim_feedkeys(
            vim.api.nvim_replace_termcodes("<C-n>", true, false, true),
            "n",
            true
          )
        end
      end
    end
  end,
})
-------------------------
-------------------------
