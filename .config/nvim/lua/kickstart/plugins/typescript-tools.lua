return {
  {
    'pmizio/typescript-tools.nvim',
    dependencies = { 'nvim-lua/plenary.nvim', 'neovim/nvim-lspconfig' },
    opts = {
      settings = {
        tsserver_file_preferences = {
          includeInlayParameterNameHints = 'all',
          includeInlayParameterNameHintsWhenArgumentMatchesName = true,
          includeInlayFunctionParameterTypeHints = true,
          includeInlayVariableTypeHints = true,
          includeInlayPropertyDeclarationTypeHints = true,
          includeInlayFunctionLikeReturnTypeHints = true,
          includeInlayEnumMemberValueHints = true,
        },
      },
      on_attach = function(client, bufnr)
        -- Helper function to execute code actions sequentially
        local function execute_code_action(actions, index)
          if index > #actions then
            return
          end
          vim.lsp.buf.code_action {
            apply = true,
            context = {
              only = { actions[index] },
              diagnostics = {},
            },
            callback = function()
              -- Execute the next action after the current one completes
              execute_code_action(actions, index + 1)
            end,
          }
        end

        -- Autocommand to run code actions sequentially on save
        vim.api.nvim_create_autocmd('BufWritePre', {
          pattern = { '*.ts', '*.tsx', '*.js', '*.jsx' },
          callback = function()
            local actions = { 'source.addMissingImports.ts', 'source.removeUnused.ts', 'source.organizeImports' }
            execute_code_action(actions, 1)
          end,
        })

        -- Keybindings for LSP features and individual code actions
        local bufopts = { noremap = true, silent = true, buffer = bufnr }
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
        vim.keymap.set('n', '<leader>ai', function()
          vim.lsp.buf.code_action { apply = true, context = { only = { 'source.addMissingImports.ts' }, diagnostics = {} } }
        end, vim.tbl_extend('force', bufopts, { desc = 'Add missing imports' }))
        vim.keymap.set('n', '<leader>ru', function()
          vim.lsp.buf.code_action { apply = true, context = { only = { 'source.removeUnused.ts' }, diagnostics = {} } }
        end, vim.tbl_extend('force', bufopts, { desc = 'Remove unused imports' }))
        vim.keymap.set('n', '<leader>oi', function()
          vim.lsp.buf.code_action { apply = true, context = { only = { 'source.organizeImports' }, diagnostics = {} } }
        end, vim.tbl_extend('force', bufopts, { desc = 'Organize imports' }))
      end,
      filetypes = { 'typescript', 'typescriptreact', 'javascript', 'javascriptreact' },
    },
  },
}