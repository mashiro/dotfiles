return {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    opts = {
        flavour = "mocha",
        term_colors = true,
        transparent_background = true,
        integrations = {
            telescope = {
                enabled = true,
            },
        },
    },
    config = function(_, opts)
        require("catppuccin").setup(opts)
        vim.cmd([[colorscheme catppuccin]])
    end
}
