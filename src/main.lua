local RunService = game:GetService("RunService")
local PlayersService = game:GetService("Players")
local LocalPlayer = PlayersService.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local LoggerModule = require("../lib/logger")
local SendNotification = require("../lib/notify")
local Constants = require("./constants")
if game.PlaceId ~= Constants.PlaceId then
	return SendNotification("Zła gra", "Wejdz do polish car driving")
end
local Metadata = require("../lib/metadata")
local platoboost = require("../lib/platoboost")
local getFlag = platoboost.getFlag

if getthreadidentity() < 8 then
	setclipboard(Metadata.discord)
	return SendNotification("Za słaby executor! - " .. identifyexecutor(), "Użyj executorów podanych w #tutorial")
end
local AntiCheatDisable = require("./anti_cheat_disabler")
require("../lib")
local ConfigManager = require("../lib/config_manager")
local PlayersService = game:GetService("Players")
local LocalPlayer = PlayersService.LocalPlayer
local IsServerSupported = table.find(Constants.SupportedPlaceVersion, game.PlaceVersion) ~= nil
local Utils = require("./utils")
if getFlag("KillSwitch") then
	setclipboard(Metadata.discord)
	return SendNotification("Skrypt został zatrzymany", "Sprawdź discorda (skopiowano link)")
end
if not IsServerSupported then
	SendNotification("Skrypt przestarzały", "Skrypt może nie działac albo możesz dostać bana")
end
local StateMachineLib = require("../lib/state")

local ByteUtilModules = require("./byteutil")
local Logger = LoggerModule:init({
	output = "pubmain.pcd.log",
	time = true,
	print = not not DEBUG,
})
AntiCheatDisable(Logger)
local AutoFarmMachine = StateMachineLib:new(Constants.States.Waiting, nil, Logger, "AutoFarm")

local Library =
	loadstring(game:HttpGet("https://raw.githubusercontent.com/pubmain/bin/refs/heads/main/xsx_fix_library.lua"))()
local Config = ConfigManager:new("pubmain.pcd.json", {
	InfFuel = false,
	ServerSortOrder = "Malejąca",
	TweenSpeed = 120,
	TweenHeight = 0,
	DisableAutoFarmOnStartup = true,
	Key = nil,
})

if Config.DisableAutoFarmOnStartup then
	Config.AutoFarm = false
end

local NotificationLib = Library:InitNotifications()

local function WrapCall(callback, name)
	return function(...)
		local success, err = pcall(callback, ...)
		if not success then
			Logger:log("Function", name, "stopped working", err)
			return NotificationLib:Notify("Funkcja " .. name .. " przestała działac! " .. tostring(err), 10, "error")
		end
	end
end

local function SkipLoadingScreen()
	local LoadingHandler = game:GetService("ReplicatedFirst").LoadingHandler
	if LoadingHandler.Enabled then
		getsenv(LoadingHandler)._G.LoadingCompleted = true
	end
	LoadingHandler.Enabled = false
	local LoadingScreen = LocalPlayer.PlayerGui:FindFirstChild("LoadingScreen")
	if LoadingScreen then
		LoadingScreen.Enabled = false
	end
	LocalPlayer.PlayerGui.InterfaceMain.Enabled = true
	game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.All, true)
	workspace.CurrentCamera.CameraType = Enum.CameraType.Custom
	NotificationLib:Notify("Usunięto ekran ładowania", 3, "success")
end

Library.title = "Pubmain PCD | v" .. tostring(Constants.ScriptVersion) .. " | " .. Metadata.discord
Library:Watermark(Library.title)
-- Library:Introduction()

local Window = Library:Init()

local MainTab = Window:NewTab("Main")
MainTab:Open()
MainTab:NewSection("Zmiany")

table.foreach(Constants.UpdateLog, function(_, value)
	MainTab:NewLabel(" - " .. value)
end)

MainTab:NewSection("")

MainTab:NewButton("Dołącz do naszego serwera " .. Metadata.discord, function()
	NotificationLib:Notify("Skopiowano link", 1, "success")
	setclipboard(Metadata.discord)
end)

MainTab:NewButton("Skipnij ładowanie", WrapCall(SkipLoadingScreen, "SkipLoadingScreen"))
-- MainTab:NewButton("Zoptymalizuj gre", function() end)

MainTab:NewButton(
	"Zamknij skrypt",
	WrapCall(function()
		Window:Remove()
		Config:save()
		Config.AutoFarm = false
	end, "CloseScript")
)

MainTab:NewKeybind(
	"Interfejs toggle",
	Enum.KeyCode.RightAlt,
	WrapCall(function()
		Library:UpdateKeybind(Enum.KeyCode[key])
	end, "ChangeKeybind")
)

local AutoFarmTab = Window:NewTab("Auto farm")

local StateLabel = AutoFarmTab:NewLabel("Stan auto farmy: " .. AutoFarmMachine.CurrentState)
AutoFarmMachine.onChange = function(state)
	StateLabel:Text("Stan auto farmy: " .. state)
end

local OwnedCars = {}
-- note: rewrite this
local function UpdateCars()
	for _, option in OwnedCars do
		AutoFarmSelectCar:RemoveOption(option)
	end
	OwnedCars = {}
	for _, instance in LocalPlayer.Cars:GetChildren() do
		table.insert(OwnedCars, instance.Name)
		-- AutoFarmSelectCaron(instance.Name)
	end
	-- AutoFarmSelectCar:Text(OwnedCars[1] or "Nie masz aut 🤯")
end

LocalPlayer.Cars.ChildAdded:Connect(UpdateCars)
UpdateCars()

-- note: register all auto farm states
do
	local Nodes = workspace.PCDMap.Roads:GetChildren()
	AutoFarmMachine:registerState(Constants.States.TPDestination, function()
		local Vehicle = Utils.GetPlayerVehicle()
		if not Vehicle then
			return AutoFarmMachine:updateState(Constants.States.SpawningCar)
		end
		if not Utils.PlayerInsideHisOwnVehicle() then
			return AutoFarmMachine:updateState(Constants.States.EnteringCar)
		end
		local Destination = Utils.GetCurrentDestination()
		if not Destination then
			return AutoFarmMachine:updateState(Constants.States.Waiting)
		end

		local Tween = Utils.ModelTween(
			Vehicle,
			Vehicle:GetPivot() + Vector3.new(0, Config.TweenHeight, 0),
			TweenInfo.new(1),
			nil,
			nil
		)
		Tween.Completed:Wait()

		-- Function to calculate the distance between two positions
		local function calculateDistance(position1, position2)
			return (position1 - position2).Magnitude
		end

		-- Function to find the closest node to the current position
		local function findClosestNode(currentPosition, targetPosition, nodes)
			local closestNode = nil
			local shortestDistance = math.huge

			for _, node in ipairs(nodes) do
				-- Calculate distance from current position to the node
				local distanceToNode = calculateDistance(currentPosition, node.Position)
				-- Calculate distance from the node to the target
				local distanceToTarget = calculateDistance(node.Position, targetPosition)

				-- Ensure the node is closer to the target than the current position
				if distanceToTarget < calculateDistance(currentPosition, targetPosition) then
					-- Check if this node is the closest so far
					if distanceToNode < shortestDistance and distanceToNode > 20 then
						closestNode = node
						shortestDistance = distanceToNode
					end
				end
			end

			return closestNode
		end

		Vehicle:PivotTo(Vehicle:GetPivot() + Vector3.new(0, Config.TweenHeight, 0))
		while calculateDistance(Vehicle.PrimaryPart.Position, Destination.Position) > 5 do
			-- Find the closest node
			local closestNode = findClosestNode(Vehicle.PrimaryPart.Position, Destination.Position, Nodes)
				or Destination
			local IsCompleted = false
			local Tween, Heartbeat, Completed
			Tween, Heartbeat, Completed = Utils.ModelTween(
				Vehicle,
				closestNode.CFrame + Vector3.new(0, Config.TweenHeight, 0),
				TweenInfo.new(
					(closestNode.Position - Vehicle.PrimaryPart.Position).Magnitude / Config.TweenSpeed,
					Enum.EasingStyle.Linear,
					Enum.EasingDirection.Out
				),
				function()
					if not Vehicle.PrimaryPart then
						Heartbeat:Disconnect()
						Completed:Disconnect()
						return Tween:Cancel()
					end
					Vehicle.PrimaryPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
					Vehicle.PrimaryPart.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
				end,
				function()
					IsCompleted = true
				end
			)
			repeat
				if not Utils.PlayerInsideHisOwnVehicle() then
					return error("Gracz wyszedł z auta")
				end
				task.wait(0)
			until IsCompleted
				or not Config.AutoFarm
				or Tween.PlaybackState == Enum.PlaybackState.Cancelled
				or not Utils.GetCurrentDestination()
			Heartbeat:Disconnect()
			Completed:Disconnect()
			if not IsCompleted then
				return
			end
			if closestNode == Destination then
				break
			end
		end

		local Tween = Utils.ModelTween(Vehicle, Destination.CFrame, TweenInfo.new(1), nil, nil)
		Tween.Completed:Wait()
		task.wait(0.5)
		local Root = LocalPlayer.Character.HumanoidRootPart
		firetouchinterest(Root, Destination, 0)
		task.wait(0.5)
		firetouchinterest(Root, Destination, 1)
	end)

	AutoFarmMachine:registerState(Constants.States.SpawningCar, function()
		local Vehicle = Utils.GetPlayerVehicle()
		if Vehicle then
			return AutoFarmMachine:updateState(Constants.States.Waiting)
		end
		ReplicatedStorage.spawn_car:FireServer(
			OwnedCars[1],
			Utils.NoiseifyColor(Config.CarColor or Utils.GenerateColor())
		)
		task.wait(1)
		AutoFarmMachine:updateState(Constants.States.EnteringCar)
		-- ReplicatedStorage.spawn_car:FireServer("Maluch", Utils.NoiseifyColor(Color3.new()))
	end)

	AutoFarmMachine:registerState(Constants.States.EnteringCar, function()
		local Character = LocalPlayer.Character
		if not Character then
			return AutoFarmMachine:updateState(Constants.States.WaitingRespawn)
		end
		local Vehicle = Utils.GetPlayerVehicle()
		if not Vehicle then
			return AutoFarmMachine:updateState(Constants.States.SpawningCar)
		end
		if Utils.PlayerInsideHisOwnVehicle() then
			return AutoFarmMachine:updateState(Constants.States.Waiting)
		end
		fireproximityprompt(Vehicle.DriveSeat.DPX)
		task.wait(0.5)
		AutoFarmMachine:updateState(Constants.States.Waiting)
	end)

	AutoFarmMachine:registerState(Constants.States.Waiting, function()
		local Character = LocalPlayer.Character
		if not Character then
			return AutoFarmMachine:updateState(Constants.States.WaitingRespawn)
		end
		if Utils.GetCurrentDestination() then
			return AutoFarmMachine:updateState(Constants.States.TPDestination)
		else
			return
		end
	end)

	AutoFarmMachine:registerState(Constants.States.WaitingRespawn, function()
		local Character = LocalPlayer.Character
		if Character then
			return AutoFarmMachine:updateState(Constants.States.Waiting)
		end
		LocalPlayer.CharacterAdded:Wait()
	end)
end

local AutoFarmToggle
AutoFarmToggle = AutoFarmTab:NewToggle(
	"Auto farm",
	false,
	WrapCall(function(value)
		if #OwnedCars == 0 and value then
			AutoFarmToggle:Set(false)
			return NotificationLib:Notify("Nie masz żadnego auta!", 3, "error")
		end
		Config.AutoFarm = value
		while Config.AutoFarm do
			local succeded, err = pcall(AutoFarmMachine.handle, AutoFarmMachine)
			if not succeded then
				Config.AutoFarm = false
				NotificationLib:Notify("Auto farma sie zepsula! " .. err, 10, "error")
				AutoFarmToggle:Set(false)
				return
			end
			task.wait(0.5)
		end
	end, "AutoFarmToggle")
)

-- note: PhoneHandler.c signal to DeliveryEvent
-- note: PhoneHandler:b() fires remote DeliveryEvent
-- note: reason why u need to use PhoneHandler because it obfuscates the location of DeliveryEvent
ByteUtilModules.PhoneHandler.c:Connect(WrapCall(function(delivery_type, info)
	if DEBUG then
		Logger:log("Received Delivery update", delivery_type, info)
	end
	if not Config.AutoFarm then
		return
	end
	-- note: type=2 - uber eats, type=3 - taxi
	if delivery_type ~= 2 and delivery_type ~= 3 then
		return --Logger:log("Returned from DeliveryClient (type ~= 2 and 3)")
	end
	task.wait(math.random() / 2)
	ByteUtilModules.PhoneHandler:b(1)
	Logger:log("Accepted delivery", delivery_type)
end, "DeliveryClient"))

AutoFarmTab:NewSection("Ustawienia")

AutoFarmTab:NewSlider(
	"Szybkość teleportacji",
	" u/s",
	true,
	"/",
	{ min = 20, max = 220, default = Config.TweenSpeed },
	Config:createHandler("TweenSpeed")
)

AutoFarmTab:NewSlider(
	"Wysokość teleportacji",
	" units",
	false,
	"/",
	{ min = -30, max = 100, default = Config.TweenHeight },
	Config:createHandler("TweenHeight")
)

-- AutoFarmTab:NewSelector("Typy zadań do zaakceptowania", "Blisko", { "Blisko", "Daleko", "Wszystkie" }, Config:createHandler("AutoFarmJobType"))

local MiscTab = Window:NewTab("Misc")
-- note: to nie działa 😭 sprawdzaja na serwerze kto jest włascicielem 🤯
-- MiscTab:NewButton("Radio spawn", function()
--     if LocalPlayer.Backpack:FindFirstChild("Radio") or LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Radio") then
--         return NotificationLib:Notify("Już masz radio!", 3, "information")
--     end
--     for _, player in PlayersService:GetPlayers() do
--         local RadioTool = player.Backpack:FindFirstChild("Radio")
--         if RadioTool then
--             RadioTool:Clone().Parent = LocalPlayer.Backpack
--             NotificationLib:Notify("Udało sie zespawnować radio!", 3, "success")
--             return
--         end
--     end
--     NotificationLib:Notify("Nie udało sie zespawnować radia!", 3, "error")
-- end)

MiscTab:NewSlider(
	"Zmień swoją kase kase",
	"",
	false,
	"/",
	{ min = 500, max = 10 ^ 7, default = 1000 },
	function(value)
		-- fireconnection(workspace.TheW.TheMN.OnClientEvent, value)
		LocalPlayer.leaderstats.Money.Value = value
	end
)

-- note: velocity hookmetamethod is bugged

MiscTab:NewButton(
	"Napraw interfejs aut",
	WrapCall(function()
		for _, ui in LocalPlayer.PlayerGui:GetChildren() do
			if ui.Name == "A-Chassis Interface" then
				local CarValue = ui.Car.Value
				if CarValue == nil or CarValue.Parent ~= workspace.Cars then
					ui:Destroy()
				end
			end
		end
	end, "FixVehicleInterface")
)

-- note: nie czaje api tego gówna
-- MiscTab:NewSection("ESP")
-- MiscTab:NewToggle("ESP włączone", Config:create("Esp"))
-- MiscTab:NewToggle("Vehicle ESP", Config:create("VehicleESP"))
-- MiscTab:NewToggle("Player ESP", Config:create("PlayerESP"))
-- MiscTab:NewButton("Load ESP", function()
-- 	-- loadstring(game:HttpGet("https://raw.githubusercontent.com/Exunys/Exunys-ESP/main/src/ESP.lua"))()
-- 	-- ExunysDeveloperESP.Load()
-- end)

local GameplayTab = Window:NewTab("Gameplay")
GameplayTab:NewToggle("Nieskończone paliwo", Config:create("InfFuel"))

-- note: gra każdego Heartbeat (chyba) wysyła request do FuelEvent (jest w nil instances) i ile trzeba paliwa zabrac
local fuelHook
fuelHook = hookmetamethod(game, "__namecall", function(self, ...)
	local args = { ... }
	local method = getnamecallmethod()
	WrapCall(function()
		if self.Name:lower():find("fuel") and method == "FireServer" then
			if Config.InfFuel then
				args[1] = 1e-9 * math.random()
			end
		end
	end, "InfFuelHook")()

	return fuelHook(self, table.unpack(args))
end)

GameplayTab:NewButton(
	"Wyłącz wszystkie radary",
	WrapCall(function()
		-- note: jeśli zrobisz Part:Destroy() masz bana dlatego przesuwam
		for _, v in workspace:FindFirstChild("radary"):GetDescendants() do
			if v:IsA("BasePart") then
				v.CFrame = CFrame.new()
			end
		end
		NotificationLib:Notify("Wyłączono wszystkie radary", 3, "success")
	end, "DisableRadars")
)

local ServersTab = Window:NewTab("Serwery")
local ServersFound = {}
local ServerLabelList = {}

ServersTab:NewButton(
	"Dołącz do tego samego serwera",
	WrapCall(function()
		game:GetService("TeleportService"):Teleport(game.PlaceId, LocalPlayer)
	end, "RejoinServer")
)

local OrderMap = {
	["Malejąca"] = "Desc",
	["Rosnąca"] = "Asc",
}

ServersTab:NewSelector(
	"Kolejność serwerów",
	Config.ServerSortOrder,
	{ "Malejąca", "Rosnąca" },
	Config:createHandler("ServerSortOrder")
)

-- note: zeskidowane z iy
ServersTab:NewButton(
	"Skanuj serwery",
	WrapCall(function()
		NotificationLib:Notify("Skanuje serwery...", 3, "notification")
		local Response = request({
			Url = string.format(
				"https://games.roblox.com/v1/games/%d/servers/Public?sortOrder=%s&limit=100&excludeFullGames=true",
				game.PlaceId,
				OrderMap[Config.ServerSortOrder]
			),
		})
		local Body = HttpService:JSONDecode(Response.Body)

		if Body and Body.data then
			local j = 0
			for i, v in next, Body.data do
				if
					type(v) == "table"
					and tonumber(v.playing)
					and tonumber(v.maxPlayers)
					and v.playing < v.maxPlayers
					and v.id ~= JobId
				then
					j = j + 1
					-- table.insert(ServersFound, 1, v.id)
					ServersFound[j] = v.id
					if ServerLabelList[j] ~= nil then
						ServerLabelList[j]:Text(
							string.format("Dołącz do serwera %d/%d osób", v.playing, v.maxPlayers)
						)
					-- ServerLabelList[j]:Text(string.format("Dołącz %d/%d osób", v.playing, v.maxPlayers))
					else
						table.insert(
							ServerLabelList,
							1,
							ServersTab:NewButton(
								string.format("Dołącz do serwera %d/%d osób", v.playing, v.maxPlayers),
								function()
									queue_on_teleport("loadfile('pcd.bundle.lua')()")
									game:GetService("TeleportService")
										:TeleportToPlaceInstance(game.PlaceId, ServersFound[i], LocalPlayer)
								end
							)
						)
					end
				end
			end
		else
			return NotificationLib:Notify("Nie udało sie znależć serwerów", 3, "error")
		end

		NotificationLib:Notify("Zaktualizowano liste serwerów", 3, "notification")
	end, "ScanServers")
)

ServersTab:NewSection("Znalezione serwery")

local TrollTab = Window:NewTab("Trollowanie")
local PlayerTextbox = TrollTab:NewTextbox(
	"Nazwa graczka",
	"",
	Config.TrollSelectedPlayer,
	"all",
	"small",
	true,
	false,
	Config:createHandler("TrollSelectedPlayer")
)

TrollTab:NewButton(
	"Znajdź najbliższego gracza",
	WrapCall(function()
		local LowestDistance = math.huge
		local CurrPlayer = nil
		for _, player in PlayersService:GetPlayers() do
			if player.Character and player ~= LocalPlayer then
				local Distance = (player.Character.PrimaryPart.Position - LocalPlayer.Character.PrimaryPart.Position).Magnitude
				if Distance < LowestDistance then
					CurrPlayer = player
					LowestDistance = Distance
				end
			end
		end
		if not CurrPlayer then
			return NotificationLib:Notify("Jesteś sam na tym serwerze!", 3, "notification")
		end
		PlayerTextbox:Input(CurrPlayer.DisplayName)
		NotificationLib:Notify("Znaleziono " .. CurrPlayer.DisplayName, 3, "notification")
		-- PlayerTextbox:Input(CurrPlayer.DisplayName)
		-- PlayerTextbox:Fire(CurrPlayer.DisplayName)
	end, "FindNearestPlayer")
)

TrollTab:NewButton(
	"Znajdź najbliższego gracza w aucie",
	WrapCall(function()
		local LowestDistance = math.huge
		local CurrPlayer = nil
		for _, player in PlayersService:GetPlayers() do
			if player.Character and player ~= LocalPlayer then
				local Distance = (player.Character.PrimaryPart.Position - LocalPlayer.Character.PrimaryPart.Position).Magnitude
				if Distance < LowestDistance and player.Character.Humanoid.Sit then
					CurrPlayer = player
					LowestDistance = Distance
				end
			end
		end
		if not CurrPlayer then
			return NotificationLib:Notify("Jesteś sam na tym serwerze!", 3, "notification")
		end
		PlayerTextbox:Input(CurrPlayer.DisplayName)
		-- Config.TrollSelectedPlayer = CurrPlayer.DisplayName
		NotificationLib:Notify("Znaleziono " .. CurrPlayer.DisplayName, 3, "notification")
		-- PlayerTextbox:Fire(CurrPlayer.DisplayName)
	end, "FindNearestPlayerInVehicle")
)

local IsViewingPlayer = false
local ConnectionDied
TrollTab:NewButton(
	"Zmień kamere na gracza",
	WrapCall(function()
		local CurrentCamera = workspace.CurrentCamera
		IsViewingPlayer = not IsViewingPlayer
		if IsViewingPlayer == false then
			CurrentCamera.CameraSubject = LocalPlayer.Character.Humanoid
			if ConnectionDied then
				ConnectionDied:Disconnect()
			end
			return
		end
		local TargetName = Config.TrollSelectedPlayer:lower()
		if not TargetName then
			return NotificationLib:Notify("Nie wpisałeś nicku gracza", 3, "error")
		end
		local Target = nil
		for _, value in PlayersService:GetPlayers() do
			if value.Name:lower():find(TargetName) ~= nil or value.DisplayName:lower():find(TargetName) ~= nil then
				Target = value
				break
			end
		end
		if not Target then
			return NotificationLib:Notify("Taki gracz nie istnieje", 3, "error")
		end
		if not Target.Character then
			return NotificationLib:Notify("Ten gracz nie zyje", 3, "error")
		end
		CurrentCamera.CameraSubject = Target.Character.Humanoid
		ConnectionDied = Target.Character.Humanoid.Died:Connect(function()
			CurrentCamera.CameraSubject = LocalPlayer.Character.Humanoid
			ConnectionDied:Disconnect()
		end)
	end, "ChangeCamera")
)

TrollTab:NewSection("Trollowanie")

-- note: nie działa
-- TrollTab:NewButton("Wywal auto gracza", SafeCall(function()
--     local TargetName = Config.TrollSelectedPlayer
--     if not TargetName then
--         return NotificationLib:Notify("Nie wpisałeś nicku gracza", 3, "error")
--     end
--     TargetName = TargetName:lower()
--     local Target = nil
--     for _, value in PlayersService:GetPlayers() do
--         if value.Name:lower():find(TargetName) ~= nil or value.DisplayName:lower():find(TargetName) ~= nil then
--             Target = value
--             break
--         end
--     end
--     if not Target then
--         return NotificationLib:Notify("Taki gracz nie istnieje", 3, "error")
--     end
--     if not Target.Character then
--         return NotificationLib:Notify("Ten gracz nie zyje", 3, "error")
--     end
--     local TargetVehicle = workspace.Cars:FindFirstChild(Target.Name)
--     if not TargetVehicle then
--         return NotificationLib:Notify(Target.DisplayName .. " nie ma auta", 3, "error")
--     end
--     local PlayerVehicle = workspace.Cars:FindFirstChild(LocalPlayer.Name)
--     if not PlayerVehicle then
--         NotificationLib:Notify("Respie auto...", 3, "notification")
--         ReplicatedStorage.spawn_car:FireServer("Maluch", Color3.new(math.random(), math.random(), math.random()))
--         task.wait(2.5)
--         PlayerVehicle = workspace.Cars:FindFirstChild(LocalPlayer.Name)
--         if not PlayerVehicle then
--             return NotificationLib:Notify("Nie udało sie zrespawnować malucha!", 3, "error")
--         end
--         fireproximityprompt(PlayerVehicle.DriveSeat.DPX)
--         task.wait(0.5)
--     end
--     if not LocalPlayer.Character.Humanoid.Sit then
--         fireproximityprompt(PlayerVehicle.DriveSeat.DPX)
--         task.wait(0.5)
--     end
--     NotificationLib:Notify("Wypierdalanie auta gracza " .. Target.Name, 3, "notification")
--     local OriginalPivot = PlayerVehicle:GetPivot()
--     local RunService = game:GetService("RunService")
--     local humanoid = LocalPlayer.Character:FindFirstChildWhichIsA("Humanoid")
--     local flinging = true
--     if humanoid then
--         humanoid.Died:Connect(function()
--             flinging = false
--         end)
--     end

--     -- for _, part in PlayerVehicle:GetDescendants() do
--     --     if part:IsA("BasePart") then
--     --         part.CanCollide = false
--     --     end
--     -- end

--     repeat
--         RunService.Heartbeat:Wait()
--         PlayerVehicle:PivotTo(TargetVehicle:GetPivot() -
--             Vector3.new(6 * (math.random() - 0.5), 6 * (math.random() - 0.5), 6 * (math.random() - 0.5)))
--         local character = LocalPlayer.Character
--         if not humanoid.Sit then
--             flinging = false
--             break
--         end
--         local root = character.HumanoidRootPart
--         local vel, movel = nil, 0.1

--         while not (character and character.Parent and root and root.Parent) do
--             RunService.Heartbeat:Wait()
--             character = LocalPlayer.Character
--             root = character.HumanoidRootPart
--         end

--         vel = root.Velocity
--         root.Velocity = vel * 10000 + Vector3.new(0, 10000, 0)

--         RunService.RenderStepped:Wait()
--         if character and character.Parent and root and root.Parent then
--             root.Velocity = vel
--         end

--         RunService.Stepped:Wait()
--         if character and character.Parent and root and root.Parent then
--             root.Velocity = vel + Vector3.new(0, movel, 0)
--             movel = movel * -1
--         end
--     until flinging == false

--     PlayerVehicle:PivotTo(OriginalPivot)
--     -- task.wait(0.5)
--     -- PlayerVehicle:PivotTo(LocalPlayer.Character:GetPivot())
-- end, "Wywal auto gracza"))

TrollTab:NewButton(
	"Jumpscare",
	WrapCall(function()
		local TargetName = Config.TrollSelectedPlayer
		if not TargetName then
			return NotificationLib:Notify("Nie wpisałeś nicku gracza", 3, "error")
		end
		TargetName = TargetName:lower()
		local Target = nil
		for _, value in PlayersService:GetPlayers() do
			if value.Name:lower():find(TargetName) ~= nil or value.DisplayName:lower():find(TargetName) ~= nil then
				Target = value
				break
			end
		end
		if not Target then
			return NotificationLib:Notify("Taki gracz nie istnieje", 3, "error")
		end
		if not Target.Character then
			return NotificationLib:Notify("Ten gracz nie zyje", 3, "error")
		end
		local PlayerVehicle = workspace.Cars:FindFirstChild(LocalPlayer.Name)
		if not PlayerVehicle then
			NotificationLib:Notify("Respie auto...", 3, "notification")
			ReplicatedStorage.spawn_car:FireServer("Maluch", Color3.new(math.random(), math.random(), math.random()))
			task.wait(2.5)
			PlayerVehicle = workspace.Cars:FindFirstChild(LocalPlayer.Name)
			if not PlayerVehicle then
				return NotificationLib:Notify("Nie udało sie zrespawnować malucha!", 3, "error")
			end
			fireproximityprompt(PlayerVehicle.DriveSeat.DPX)
		end
		if not LocalPlayer.Character.Humanoid.Sit then
			fireproximityprompt(PlayerVehicle.DriveSeat.DPX)
			task.wait(0.1)
		end
		NotificationLib:Notify("Jumpscaruje gracza " .. Target.DisplayName, 3, "notification")
		if not LocalPlayer.Character.Humanoid.Sit then
			fireproximityprompt(PlayerVehicle.DriveSeat.DPX)
			task.wait(0.1)
		end
		local OriginalPivot = PlayerVehicle:GetPivot()
		PlayerVehicle:PivotTo(Target.Character:GetPivot())
		-- PlayerVehicle:PivotTo(CFrame.lookAt(
		--     (Target.Character:GetPivot() - Target.Character:GetPivot().LookVector * 5).Position,
		--     Target.Character:GetPivot()))
		task.wait(2)
		if PlayerVehicle.Parent == nil then
			NotificationLib:Notify("Twój pojazd został usunięty!", 3, "notification")
			LocalPlayer.Character:PivotTo(OriginalPivot)
		else
			PlayerVehicle:PivotTo(OriginalPivot)
		end
	end, "JumpscarePlayer")
)
