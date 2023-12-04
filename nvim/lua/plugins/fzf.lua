return {
    "ibhagwan/fzf-lua",
    name = "fzf-lua",
    config = function ()
        vim.keymap.set('n', '<leader>ff', "<cmd>lua require('fzf-lua').files()<CR>", { silent = true })
        vim.keymap.set('n', '<leader>qf', "<cmd>lua require('fzf-lua').quickfix()<CR>", { silent = true })
        vim.keymap.set('n', '<leader>bf', "<cmd>lua require('fzf-lua').buffers()<CR>", { silent = true })

        vim.keymap.set('n', '<leader>gs', "<cmd>lua require('fzf-lua').git_status()<CR>", { silent = true })

        vim.keymap.set('n', '<leader>ps', "<cmd>lua require('fzf-lua').grep()<CR>", { silent = true })
        vim.keymap.set('n', '<leader>lg', "<cmd>lua require('fzf-lua').live_grep()<CR>", { silent = true })
        vim.keymap.set('n', '<leader>gv', "<cmd>lua require('fzf-lua').grep_visual()<CR>", { silent = true })
    end
}

