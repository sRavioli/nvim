return {
  ---Git integration for buffers
  "lewis6991/gitsigns.nvim",
  event = { "BufReadPre", "BufNewFile" },
  init = function()
    ---load gitsigns only when a git file is opened
    vim.api.nvim_create_autocmd({ "BufRead" }, {
      group = vim.api.nvim_create_augroup("GitSignsLazyLoad", { clear = true }),
      callback = function()
        vim.fn.system("git -C " .. '"' .. vim.fn.expand "%:p:h" .. '"' .. " rev-parse")
        if vim.v.shell_error == 0 then
          vim.api.nvim_del_augroup_by_name "GitSignsLazyLoad"
          vim.schedule(
            function() require("lazy").load { plugins = { "gitsigns.nvim" } } end
          )
        end
      end,
    })
  end,

  opts = {
    signs = {
      add = { text = "│" },
      change = { text = "│" },
      delete = { text = "󰍵" },
      topdelete = { text = "‾" },
      changedelete = { text = "~" },
      untracked = { text = "│" },
    },
    preview_config = {
      border = require("srv.preferences").border,
    },
    on_attach = function(bufnr)
      require("srv.utils.fn").mappings.load("gitsigns", { buffer = bufnr })
    end,
  },
}
