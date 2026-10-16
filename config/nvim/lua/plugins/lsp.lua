-- LSPの設定
return {
	{
		"neovim/nvim-lspconfig",
		config = function()
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

			-- 自動有効化から外すサーバー名
			local exclude = {}

			-- nvim-lspconfigに含まれるサーバーを候補にする
			local function candidates()
				local names = {}
				for _, file in ipairs(vim.api.nvim_get_runtime_file("lsp/*.lua", true)) do
					table.insert(names, vim.fn.fnamemodify(file, ":t:r"))
				end
				return names
			end

			-- 実行ファイルがPATHにあるサーバーだけ有効化する
			local function installed_servers()
				local enable = {}
				for _, name in ipairs(candidates()) do
					local cmd = vim.lsp.config[name].cmd
					if
						not vim.tbl_contains(exclude, name)
						and type(cmd) == "table"
						and type(cmd[1]) == "string"
						and vim.fn.executable(cmd[1]) == 1
					then
						table.insert(enable, name)
					end
				end
				return enable
			end

			vim.lsp.enable(installed_servers())

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
