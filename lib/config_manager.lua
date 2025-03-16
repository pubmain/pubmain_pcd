local module = {}
module.__index = module

local HttpService = game:GetService("HttpService")

local function validate_table(input_table, default_table)
	-- Check if the input_table is nil or not a table
	if type(input_table) ~= "table" then
		return default_table
	end

	-- Iterate over the default_table to check for matching types and fields
	for key, default_value in pairs(default_table) do
		local input_value = input_table[key]

		-- If the key is not present in the input_table or the types don't match, set it to the default value
		if input_value == nil or type(input_value) ~= type(default_value) then
			input_table[key] = default_value
		elseif type(default_value) == "table" then
			-- If the value is a table, recursively validate it
			validate_table(input_value, default_value)
		end
	end

	-- Return the validated input_table
	return input_table
end

local config = {}
config.__index = config
function module:new(name, default_cfg, onMessage)
	name = tostring(name)
	onMessage = onMessage or print
	local exists = isfile(name)
	local parsed
	if not exists then
		print("nie znaleziono pliku configuracyjnego", name)
		writefile(name, HttpService:JSONEncode(default_cfg))
		parsed = default_cfg
	else
		local contents = readfile(name)
		local success
		success, parsed = pcall(HttpService.JSONDecode, HttpService, contents)
		if not success then
			return onMessage('Failed to load config "' .. name .. '", reason: ' .. parsed)
		end
	end
	local validated = validate_table(parsed, default_cfg)
	validated.__CFG_NAME = name
	writefile(name, HttpService:JSONEncode(default_cfg))
	return setmetatable(validated, config)
end

function config:save()
	writefile(self.__CFG_NAME, HttpService:JSONEncode(self))
end

function config:createHandler(field)
	return function(value)
		self[field] = value
		pcall(self.save, self)
	end
end

function config:create(field)
	return self[field], self:createHandler(field)
end

return module
