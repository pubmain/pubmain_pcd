local module = {}
module.__index = module

function module:new(CurrentState, ErrorHandler, Logger, MachineName)
	return setmetatable({
		CurrentState = CurrentState,
		ErrorHandler = ErrorHandler,
		RegisteredStates = {},
		Logger = Logger,
		MachineName = MachineName,
		onChange = function() end,
	}, module)
end

function module:registerState(State, Handler)
	self.RegisteredStates[State] = Handler
	if DEBUG then
		self.Logger:log('Registered new state: "' .. tostring(State) .. '" with handler: ' .. tostring(Handler))
	end
end

function module:updateState(State)
	if not self.RegisteredStates[State] then
		return self:error('Tried to update the state to unknown, got: "' .. tostring(State) .. '"')
	end
	self.onChange(State)
	self.CurrentState = State
end

function module:handle()
	if not self.CurrentState then
		return self:error("CurrentState is not set")
	end
	local Handler = self.RegisteredStates[self.CurrentState]
	if not Handler then
		return self:error(self.CurrentState .. " is not registered")
	end
	Handler()
	-- local success, err = pcall(Handler)
	-- if not success then
	-- 	if not self.ErrorHandler then
	-- 		self:error(self.CurrentState .. " failed, reason is: " .. err)
	-- 	else
	-- 		self.ErrorHandler(err)
	-- 	end
	-- 	return false
	-- end
	-- return true
end

function module:error(Message)
	Message = "[" .. self.MachineName .. "] failed, reason is: " .. Message
	-- self.Logger:Log(Message)
	error(Message)
	return Message
end

return module
