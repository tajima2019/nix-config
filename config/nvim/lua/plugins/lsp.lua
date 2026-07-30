-- LSPの設定
return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
    },
    config = function()
      -- Mason(インストーラー) の設定
      require("mason").setup()
      require("mason-lspconfig").setup({
        ensure_installed = { "gopls", "lua_ls", "ts_ls", "pyright", "yamlls", "cssls" }, -- 自動で入れたいものを書く
        automatic_enable = true,
      })

      -- Go言語の個別設定
      vim.lsp.config("gopls", {
        settings = {
          gopls = {
            analyses = { unusedparams = true },
            staticcheck = true,
          },
        },
      })

      -- Luaの個別設定
      vim.lsp.config("lua_ls", {
        settings = {
          Lua = { diagnostics = { globals = { "vim" } } },
        },
      })

      -- JS/TS用の設定
      vim.lsp.config("ts_ls", {})

      -- CSS用の設定
      vim.lsp.config("cssls", {
        settings = {
          css = { validate = true },
          scss = { validate = true },
          less = { validate = true },
        },
      })

      -- Python用の設定
      vim.lsp.config("pyright", {
        settings = {
          python = {
            analysis = {
              typeCheckingMode = "off",
            },
          },
        },
      })

      -- yaml用の設定
      vim.lsp.config("yamlls", {
        settings = {
          yaml = {
            -- スキーマの自動ダウンロードを有効化
            schemaStore = {
              enable = true,
              url = "https://www.schemastore.org/api/json/catalog.json",
            },
            -- フォーマットの設定
            format = {
              enable = true,
            },
            validate = true,
            completion = true,
            hover = true,
          },
        },
      })

      -- matlab用の設定
      vim.lsp.config("matlab_ls", {
        cmd = { "matlab-language-server", "--stdio" },
        filetypes = { "matlab" },
        settings = {
          MATLAB = {
            installPath = "/Applications/MATLAB_R2025b.app", -- MATLABのインストールパスを指定
            indexWorkspace = true,
            matlabConnectionTiming = "onStart",
            telemetry = false,
          },
        },
      })
      vim.lsp.enable("matlab_ls")

      -- キーバインド設定
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspConfig", {}),
        callback = function(ev)
          local opts = { buffer = ev.buf }
          -- 定義ジャンプ(Go Definition) -> gd
          vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
          -- 情報表示(Hover) -> K
          vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
          -- リネーム(変数名変更) -> <Space>rn
          vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, opts)
          -- コードアクション(修正提案) -> <Space>ca
          vim.keymap.set("n", "<space>ca", vim.lsp.buf.code_action, opts)
          -- 参照先一覧 -> gr
          vim.keymap.set("n", "gr", require("telescope.builtin").lsp_references, opts)
        end,
      })
    end,
  },
}
