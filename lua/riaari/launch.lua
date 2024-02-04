LAZY_PLUGIN_SPEC = {}

-- Global function from chris@machine used to add individual plugin specs to Lazy spec
function spec(plugin_spec)
	table.insert(LAZY_PLUGIN_SPEC, { import = plugin_spec })
end
