return {
    'nvim-telescope/telescope.nvim', version = '*',
    dependencies = {
        'nvim-lua/plenary.nvim',
        -- optional but recommended
        { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
    },

    config = function()
        require('telescope').setup({})

        local utils = require('telescope.utils')
        local builtin = require('telescope.builtin')
        
        local default_action = function()
            local _, ret, _ = utils.get_os_command_output({ 'git', 'rev-parse', '--is-inside-work-tree' }) 
            if ret == 0 then 
                builtin.git_files() 
            else 
                builtin.find_files() 
            end 
        end

        vim.keymap.set('n', '<leader><leader>', default_action, {})
        vim.keymap.set('n', '<leader>f', function()
            builtin.grep_string({ search = vim.fn.input("Grep > ") })
        end)
        vim.keymap.set('n', '<leader><h>', builtin.help_tags, {})
    end
}

