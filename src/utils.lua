local Utils = {}
local LocalPlayer = game.Players.LocalPlayer

function Utils.GetPlayerVehicle(player)
	player = player or LocalPlayer
	return workspace.Cars:FindFirstChild(player.Name)
end

function Utils.PlayerHasVehicle(player)
	player = player or LocalPlayer
	return workspace.Cars:FindFirstChild(player.Name) ~= nil
end

function Utils.PlayerInsideVehicle(player)
	player = player or LocalPlayer
	if not player.Character then
		return false
	end
	if not player.Character.Humanoid.SeatPart then
		return false
	end
	return player.Character.Humanoid.SeatPart:IsDescendantOf(workspace.Cars)
end

function Utils.PlayerInsideHisOwnVehicle(player)
	player = player or LocalPlayer
	if not player.Character then
		return false
	end
	local Vehicle = Utils.GetPlayerVehicle(player)
	if not Vehicle then
		return false
	end
	if not player.Character.Humanoid.SeatPart then
		return false
	end
	return player.Character.Humanoid.SeatPart:IsDescendantOf(Vehicle)
end

function Utils.GetCurrentDestination()
	local Character = LocalPlayer.Character
	if not Character or not Character.PrimaryPart then
		return
	end
	local DirectionBeam = Character.HumanoidRootPart.DirectionAttachment:FindFirstChild("DirectionBeam")
	if not DirectionBeam or not DirectionBeam.Enabled then
		return
	end
	local Attachment1 = DirectionBeam.Attachment1
	if not Attachment1 then
		return
	end
	return Attachment1.Parent
end

function Utils.GenerateColor()
	return Color3.new(math.random(), math.random(), math.random())
end

-- note: miało być do customowego koloru auta zeby nie bylo detectowane
-- note: nwm wsm czemu sie tyle wysilalem jak oni napewno nie beda robic checkow do tego
function Utils.NoiseifyColor(color, mod)
	mod = 1 / 100
	return Color3.new(color.R + math.random() * mod, color.G + math.random() * mod, color.B + math.random() * mod)
end

function Utils.ModelTween(model, targetCFrame, tweenInfo, handler, completed)
	handler = handler or function() end
	completed = completed or function() end
	local pivotCFrameValue = Instance.new("CFrameValue")
	pivotCFrameValue.Value = model:GetPivot()
	local tween = game:GetService("TweenService"):Create(pivotCFrameValue, tweenInfo, { Value = targetCFrame })
	local Heartbeat
	local Completed = tween.Completed:Connect(function()
		Heartbeat:Disconnect()
		model:PivotTo(targetCFrame)
		completed()
	end)
	Heartbeat = game:GetService("RunService").Heartbeat:Connect(function(dt)
		if tween.PlaybackState == Enum.PlaybackState.Cancelled then
			Heartbeat:Disconnect()
			Completed:Disconnect()
			return
		end
		model:PivotTo(pivotCFrameValue.Value)
		handler(dt)
	end)
	tween:Play()
	return tween, Heartbeat, Completed
end
-- note: to powinnienem usunac chyba
function Utils.CreateInvertedBox(pos)
	local size = Vector3.new(100, 100, 100)
	local thickness = 2
	local Parent = Instance.new("Model", workspace)

	-- Function to create a wall
	local function createWall(position, rotation, wallSize)
		local wall = Instance.new("Part", Parent)
		wall.Size = wallSize
		wall.Position = position
		wall.Rotation = rotation
		wall.Anchored = true
		wall.Transparency = 1
		return wall
	end

	createWall(pos + Vector3.new(0, size.Y / 2, 0), Vector3.new(0, 0, 0), Vector3.new(size.X, thickness, size.Z))
	createWall(pos - Vector3.new(0, size.Y / 2, 0), Vector3.new(0, 0, 0), Vector3.new(size.X, thickness, size.Z))

	createWall(pos + Vector3.new(size.X / 2, 0, 0), Vector3.new(0, 0, 0), Vector3.new(thickness, size.Y, size.Z))
	createWall(pos - Vector3.new(size.X / 2, 0, 0), Vector3.new(0, 0, 0), Vector3.new(thickness, size.Y, size.Z))

	createWall(pos + Vector3.new(0, 0, size.Z / 2), Vector3.new(0, 0, 0), Vector3.new(size.X, size.Y, thickness))
	createWall(pos - Vector3.new(0, 0, size.Z / 2), Vector3.new(0, 0, 0), Vector3.new(size.X, size.Y, thickness))
	return Parent
end

return Utils
