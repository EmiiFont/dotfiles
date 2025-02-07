return {
  {
    'nvimdev/dashboard-nvim',
    event = 'VimEnter',
    config = function()
      require('dashboard').setup {
        theme = 'hyper', -- or 'doom'
        config = {
          shortcut = {
            {
              desc = '[  Emiifont]',
              group = '@constant.builtin',
            },
          },
          project = { enable = true, limit = 8 },
          header = {
            [[                                                                       ]],
            [[                                                                     ]],
            [[       ████ ██████           █████      ██                     ]],
            [[      ███████████             █████                             ]],
            [[      █████████ ███████████████████ ███   ███████████   ]],
            [[     █████████  ███    █████████████ █████ ██████████████   ]],
            [[    █████████ ██████████ █████████ █████ █████ ████ █████   ]],
            [[  ███████████ ███    ███ █████████ █████ █████ ████ █████  ]],
            [[ ██████  █████████████████████ ████ █████ █████ ████ ██████ ]],
            [[                                                                       ]],
          },
          center = {
            {
              icon = '  ',
              desc = 'Find File',
              action = 'Telescope find_files',
              shortcut = 'SPC f f',
            },
            {
              icon = '  ',
              desc = 'Recently opened files',
              action = 'Telescope oldfiles',
              shortcut = 'SPC f h',
            },
          },
          footer = {
            'Small changes make a big difference, like the tiny spark that starts a mighty flame.',
          },
        }, -- config
      }
    end,
    dependencies = { { 'nvim-tree/nvim-web-devicons' } },
  },
}
