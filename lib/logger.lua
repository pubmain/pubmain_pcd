local module = {}
module.__index = module

local function floord(num, digits)
	return math.floor(num * 10 ^ digits) / 10 ^ digits
end

local function gettime()
	return floord(time(), 2)
end

function module:init(settings)
	writefile(settings.output, "[LOG INIT] Initialized logger " .. gettime())
	return setmetatable({ settings = settings }, module)
end

function module:log(...)
	local out = "[LOG] "
	if self.settings.time then
		out = gettime() .. " - " .. out
	end
	for _, value in pairs({ ... }) do
		if type(value) ~= "string" then
			value = dump(value)
		end
		out = out .. value .. " "
	end
	if self.settings.print then
		print(out)
	end
	appendfile(self.settings.output, out .. "\n")
end

return module

-- local LOG_FILE_OUTPUT = "pubmain.pcd.log"
-- local PRINT_LOGS = true
-- local LOG_TIME = true
-- writefile(LOG_FILE_OUTPUT, "[LOG INIT] Initialized logger " .. gettime())

-- local function Log(text)
--     local out = "[LOG] " .. text
--     if LOG_TIME then
--         out = gettime() .. " " .. out
--     end
--     if PRINT_LOGS then print(out) end
--     appendfile(LOG_FILE_OUTPUT, "\n" .. out)
-- end
