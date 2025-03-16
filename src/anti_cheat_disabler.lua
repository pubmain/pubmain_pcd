local Logger
local function isrbxclosure(func)
	local source = debug.info(func, "s")
	if source and source:sub(1, 7) == "CoreGui" then
		return true
	end
	return iscclosure(func)
end

-- note: atlantis czy jakis inny executor sa uposledzone i tak
local function disableconn(conn)
	pcall(conn.Disable, conn)
	pcall(conn.Disconnect, conn)
end
local function BlockAntiCheatRequests()
	-- note: nwm wsm po co to jest jak oni nie wiedza o while true do end 💀
	game["Script Context"]:SetTimeout(0)

	-- note: to jest stary anticheat, nowy jest obfuscowany xDD
	-- https://github.com/pubmain/bin/blob/993c7134c8a06ec94d157b3a1dbb819276b99f7e/pcd_anti_cheat.lua

	-- note: Ban Remotey sa w ReplicatedStorage.StreamingAssets (chyba juz nie) i w Workspace.Expansions
	local function isBlocked(remote)
		if remote:IsDescendantOf(game:GetService("ReplicatedStorage").StreamingAssets) then
			return true
		end
		if remote:IsDescendantOf(workspace.Expansions) then
			return true
		end
		return remote.Name == "DeItaRemote"
	end

	-- note: Obfuscowany anticheat musi callowac ta funkcje bo inaczej latwiej by sie szukalo w codzie namecalla
	-- note: Remote.FireServer(Remote, "blah") -> Calluje FireServer zamiast namecalla
	local origFireServer
	origFireServer = hookfunction(
		Instance.new("RemoteEvent").FireServer,
		newcclosure(function(self, ...)
			local argv = { ... }
			if typeof(self) == "Instance" and isBlocked(self) and self.ClassName == "RemoteEvent" then
				if not (#argv == 1 and argv[1] == 1) then
					Logger:log("Blocked remote", self, "from firing", ...)
					return task.wait(9e9)
				end
				-- print("blocked", self:GetFullName(), ...)
				-- self = Instance.new("RemoteEvent")
			end
			return origFireServer(self, ...)
		end)
	)
	local __namecall
	-- note: core gui detection bypass
	local origPreloadAsync
	local ContentProvider = game:GetService("ContentProvider")
	origPreloadAsync = hookfunction(
		ContentProvider.PreloadAsync,
		newcclosure(function(...)
			if DEBUG then
				Logger:log(".PreloadAsync was called", ...)
				return error()
			end
			return origPreloadAsync(...)
			-- error()
		end)
	)
	__namecall = hookmetamethod(game, "__namecall", function(self, ...)
		local method = getnamecallmethod()
		if self == ContentProvider and method == "PreloadAsync" and not checkcaller() then
			if DEBUG then
				Logger:log("redirecting :PreloadAsync to .PreloadAsync", getcallingscript():GetFullName())
			end
			return ContentProvider.PreloadAsync(self, ...)
		end
		-- note: mega rozpierdolone
		-- if method == "FireServer" and self.ClassName == "RemoteEvent" and isBlocked(self) and not checkcaller() then
		-- 	if DEBUG then
		-- 		Logger:log("Blocked event", self, "from firing", getcallingscript():GetFullName(), ...)
		-- 	end
		-- 	return
		-- end
		-- note: bypass dla F3X
		-- note: też można zrobic dla WalkSpeeda czyli hooknac __index i returnac walkSpeed 17 i tak dalej
		if method == "FindFirstChild" and not checkcaller() then
			local name, recursive = ...
			if name == "F3X" then
				-- note: too spammy
				-- if DEBUG then
				-- 	Logger:log("Bypassed check for F3X", getcallingscript():GetFullName())
				-- end
				return nil
			end
		end
		return __namecall(self, ...)
	end)
	if DEBUG then
		Logger:log("Disabling LogService.MessageOut")
	end
	-- note: nwm czy oni dalej monitoruja na string xeno xd
	for _, conn in getconnections(game:GetService("LogService").MessageOut) do
		if conn.Function and not isrbxclosure(conn.Function) then
			disableconn(conn)
		end
	end
	if DEBUG then
		Logger:log("Disabling ScriptContext.Error")
	end
	-- note: oni nie wiedza o tym ale i tak wylaczam
	for _, conn in getconnections(game:GetService("ScriptContext").Error) do
		if conn.Function and not isrbxclosure(conn.Function) then
			disableconn(conn)
		end
	end
	-- Logger:log("Disabled client anti cheat")
end

local function UnprotectAll()
	-- note: w leaku ac uzywaja AncestryChanged zeby sprawdzic czy .Parent sie zmienia wiec wylaczam wszystko poprostu

	-- https://github.com/pubmain/bin/blob/993c7134c8a06ec94d157b3a1dbb819276b99f7e/pcd_anti_cheat.lua
	-- note: unprotects every protected instance protected by a nil script (Check getnilinstances() for scripts that use ContextProvider service)

	local function Unprotect(part)
		if true then
			return
		end
		-- if not part:IsA("BasePart") then return end
		local connection_array = getconnections(part.AncestryChanged)
		if #connection_array == 0 then
			return warn(part:GetFullName(), "isnt protected")
		end
		-- note: for some reason getconnections doesnt work
		for _, conn in connection_array do
			disableconn(conn)
			-- printdump(debug.getinfo(conn.Function))
			-- conn:Disconnect()
		end
		-- Logger:log(part:GetFullName(), "has been unprotected")
		-- print(part:GetFullName(), "has been unprotected")
	end
	for _, v in workspace.Railway.Crossings:GetDescendants() do
		Unprotect(v)
	end
	local Radars = workspace.radary
	Unprotect(Radars.Malechowo.Sensor)
	Unprotect(Radars.Rzyszczewo.Sensor)
	Unprotect(Radars["S\196\153czkowo"].Sensor)
	Unprotect(Radars["S\197\130awno"].Sensor)
	if DEBUG then
		Logger:log("Unprotected all protected instances")
	end
end

return function(logger)
	Logger = logger
	if DEBUG then
		Logger:log("Disabling anticheat")
	end
	BlockAntiCheatRequests()
	pcall(UnprotectAll)
end
