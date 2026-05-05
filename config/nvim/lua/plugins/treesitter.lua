return 
{
    'nvim-treesitter/nvim-treesitter',
    lazy = false,
    build = ':TSUpdate',
    config = function()
        require'nvim-treesitter'.setup {
            -- Directory to install parsers and queries to (prepended to `runtimepath` to have priority)
            install_dir = vim.fn.stdpath('data') .. '/site'
        }
        require'nvim-treesitter'.install { 'c', 'cpp', 'lua', 'json'}

        vim.filetype.add({
            pattern = { [".*/hypr/.*%.conf"] = "hyprlang" },
        })

        -- Hyprlang LSP
        vim.api.nvim_create_autocmd({'BufEnter', 'BufWinEnter'}, {
            pattern = {"*.hl", "hypr*.conf"},
            callback = function(event)
                print(string.format("starting hyprls for %s", vim.inspect(event)))
                vim.lsp.start {
                    name = "hyprlang",
                    cmd = {"hyprls"},
                    root_dir = vim.fn.getcwd(),
                    settings = {
                        hyprls = {
                            preferIgnoreFile = true, -- set to false to prefer `hyprls.ignore`
                            ignore = {"hyprlock.conf", "hypridle.conf"}
                        }
                    }
                }
            end
        })
    end
}
