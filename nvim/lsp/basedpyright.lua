return {
	capabilities = {
		-- 	workspace = {
		-- 		didChangeWatchedFiles = {
		-- 			dynamicRegistration = false,
		-- 		},
		-- 	},
		textDocument = {
			publishDiagnostics = {
				tagSupport = {
					valueSet = { 2 },
				},
			},
		},
	},
	settings = {
		basedpyright = {
			disableOrganizeImports = true, -- Use ruff
			autoImportCompletions = true,
		},
		python = {
			analysis = {
				autoImportCompletions = true,
				autoSearchPaths = true,
				diagnosticMode = "openFilesOnly",
				useLibraryCodeForTypes = true,
				typeCheckingMode = "strict",
			},
		},
	},
}
