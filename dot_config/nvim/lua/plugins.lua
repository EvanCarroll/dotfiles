vim.cmd [[packadd packer.nvim]]
vim.lsp.set_log_level("debug")


-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
	local opts = { noremap=true, silent=true }
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<Leader>f',  '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gD',         '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gd',         '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K',          '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gi',         '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<C-k>',      '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<Leader>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<Leader>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<Leader>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<Leader>D',  '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<Leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<Leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gr',         '<cmd>lua vim.lsp.buf.references()<CR>', opts)
end


require'lspconfig'.perlnavigator.setup{}


return require('packer').startup(function()
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

	use 'neovim/nvim-lsp'
	use {
		'neovim/nvim-lspconfig',
		config = function ()
			local opts = { noremap=true, silent=true }
			vim.api.nvim_set_keymap('n', '<space>e', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
			vim.api.nvim_set_keymap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
			vim.api.nvim_set_keymap('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
			vim.api.nvim_set_keymap('n', '<space>q', '<cmd>lua vim.diagnostic.setloclist()<CR>', opts)
			-- Use a loop to conveniently call 'setup' on multiple servers and
			-- map buffer local keybindings when the language server attaches
			local servers = { 'pyright', 'tsserver' }
			local nvim_lsp = require'lspconfig'

			for _, lsp in pairs(servers) do
				nvim_lsp[lsp].setup {
					on_attach = on_attach,
					flags = {
						-- This will be the default in neovim 0.7+
						debounce_text_changes = 150,
					}
				}
			end
			nvim_lsp["rust_analyzer"].setup {
				settings = {
					["rust-analyzer"] = {
						trace = {
							server = "verbose"
						},
            cargo = {
            	allFeatures = true
            },
					}
				},
				on_attach = on_attach,
				flags = {
					-- This will be the default in neovim 0.7+
					debounce_text_changes = 150,
				}
			}
		end
	}
	use 'liuchengxu/vista.vim'
	use 'vim-scripts/vis'
	use 'tpope/vim-fugitive'
	use 'tpope/vim-surround'
	use 'takac/vim-hardtime'
	use 'junegunn/vim-easy-align'
	use 'ervandew/supertab'

	use {
		'phaazon/hop.nvim',
		config = function()
			-- you can configure Hop the way you like here; see :h hop-config
			vim.api.nvim_set_keymap('n', 'f', "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.AFTER_CURSOR, current_line_only = true })<cr>", {})
			vim.api.nvim_set_keymap('n', 'F', "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.BEFORE_CURSOR, current_line_only = true })<cr>", {})
			vim.api.nvim_set_keymap('o', 'f', "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.AFTER_CURSOR, current_line_only = true, inclusive_jump = true })<cr>", {})
			vim.api.nvim_set_keymap('o', 'F', "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.BEFORE_CURSOR, current_line_only = true, inclusive_jump = true })<cr>", {})
			-- vim.api.nvim_set_keymap('',  't', "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.AFTER_CURSOR, current_line_only = true })<cr>", {})
			-- vim.api.nvim_set_keymap('',  'T', "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.BEFORE_CURSOR, current_line_only = true })<cr>", {})
			vim.api.nvim_set_keymap('',  '<Leader>hl', "<cmd>lua require'hop'.hint_lines_skip_whitespace()<cr>", {})
			vim.api.nvim_set_keymap('',  '<Leader>h/', "<cmd>lua require'hop'.hint_patterns()<cr>", {})
			vim.api.nvim_set_keymap('',  '<Leader>ha', "<cmd>lua require'hop'.hint_anywhere()<cr>", {})
			require'hop'.setup({})
		end
	}
	use {
		'simrat39/rust-tools.nvim',
		after = "nvim-lspconfig",
		requires = {
			{'nvim-lua/plenary.nvim', opt = true},
			{'mfussenegger/nvim-dap', opt = true},
			{'neovim/nvim-lspconfig'}
		},
		ft = { 'rust' },
		config = function ()
			local opts = { noremap=true, silent=true }
			require('rust-tools').setup({})
  		vim.api.nvim_set_keymap('n', '<Leader>t',  "<cmd>lua require('rust-tools.inlay_hints').toggle_inlay_hints()<CR>", opts)
		end
	}


	-- no longer support Shougo is now using dino plugins
	-- use 'Shougo/deoplete.nvim', {['do'] = ':UpdateRemotePlugins'}
	-- use 'Shougo/deoplete-lsp'
end)


-- Currently requires 0.7
-- Plug('nvim-lua/plenary.nvim')          -- plenary is required for telescope
-- Plug('nvim-telescope/telescope.nvim' ) -- fuzzy finder
-- nmap('<Leader>ff', "<cmd>lua require('telescope.builtin').find_files()<cr>")
-- nmap('<Leader>fg', "<cmd>lua require('telescope.builtin').live_grep()<cr>")
-- nmap('<Leader>fb', "<cmd>lua require('telescope.builtin').buffers()<cr>")
-- nmap('<Leader>fh', "<cmd>lua require('telescope.builtin').help_tags()<cr>")


-- vim.cmd([[
-- augroup packer_user_config
--   autocmd!
--   autocmd BufWritePost plugins.lua source <afile> | PackerCompile
-- augroup end
-- ]])

