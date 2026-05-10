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
vim.opt.number = true
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
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
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
--- [Mason Setup] --------
require("mason").setup({
  ui = { border = "rounded" },
})

require("mason-lspconfig").setup({
  -- Add/remove servers here. Mason will auto-install them.
  ensure_installed = { "lua_ls", "pyright", "ts_ls" },
  automatic_installation = true,
})
-------------------------
-------------------------


-------------------------
--- [Autocompletion] -----
local cmp = require("cmp")
local luasnip = require("luasnip")

cmp.setup({
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ["<C-Space>"] = cmp.mapping.complete(),         -- trigger completion
    ["<CR>"]      = cmp.mapping.confirm({ select = true }), -- confirm selection
    ["<Tab>"]     = cmp.mapping(function(fallback)  -- next item / expand snippet
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { "i", "s" }),
    ["<S-Tab>"]   = cmp.mapping(function(fallback)  -- previous item
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { "i", "s" }),
    ["<C-e>"]     = cmp.mapping.abort(),            -- close completion
    ["<C-d>"]     = cmp.mapping.scroll_docs(4),     -- scroll docs down
    ["<C-u>"]     = cmp.mapping.scroll_docs(-4),    -- scroll docs up
  }),
  sources = cmp.config.sources({
    { name = "nvim_lsp" }, -- LSP completions (highest priority)
    { name = "luasnip" },  -- snippet completions
    { name = "buffer" },   -- words from current buffer
    { name = "path" },     -- filesystem paths
  }),
  window = {
    completion    = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },
})
-------------------------
-------------------------

-------------------------
--- [LSP Setup] ----------
local lspconfig = require("lspconfig")
local capabilities = require("cmp_nvim_lsp").default_capabilities()

local servers = { "pyright", "stylua", "typescript-language-server", "lua-language-server", "bash-language-server" }


for _, server in ipairs(servers) do
  vim.lsp.config(server, {
    capabilities = capabilities,
    on_attach = on_attach,
  })

  vim.lsp.enable(server)
end


-- Shared on_attach: runs whenever an LSP attaches to a buffer
local on_attach = function(_, bufnr)
  local bopts = { noremap = true, silent = true, buffer = bufnr }
  vim.keymap.set("n", "gd",         vim.lsp.buf.definition,      bopts) -- go to definition
  vim.keymap.set("n", "gD",         vim.lsp.buf.declaration,     bopts) -- go to declaration
  vim.keymap.set("n", "gr",         vim.lsp.buf.references,      bopts) -- list references
  vim.keymap.set("n", "gi",         vim.lsp.buf.implementation,  bopts) -- go to implementation
  vim.keymap.set("n", "K",          vim.lsp.buf.hover,           bopts) -- hover docs
  vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename,          bopts) -- rename symbol
  vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action,     bopts) -- code actions
  vim.keymap.set("n", "<leader>f",  vim.lsp.buf.format,          bopts) -- format file
  vim.keymap.set("n", "[d",         vim.diagnostic.goto_prev,    bopts) -- previous diagnostic
  vim.keymap.set("n", "]d",         vim.diagnostic.goto_next,    bopts) -- next diagnostic
  vim.keymap.set("n", "<leader>e",  vim.diagnostic.open_float,   bopts) -- show diagnostic in float
end


-- Diagnostic display config
vim.diagnostic.config({
  virtual_text   = true,  -- show errors inline
  signs          = true,
  underline      = true,
  update_in_insert = false,
  float = { border = "rounded", source = "always" },
})
-------------------------
-------------------------
