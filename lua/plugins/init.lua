return {
	-- Import grouped plugin specs. Keep plugin lists in their group files to avoid duplicates.
	{ import = "plugins.core" },
	{ import = "plugins.ui" },
	{ import = "plugins.languages" },
	{ import = "plugins.debug" },
	{ import = "plugins.rust" },
	{ import = "plugins.cpp" },
	{ import = "plugins.go" },
}
