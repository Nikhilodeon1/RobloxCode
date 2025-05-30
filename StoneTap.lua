-- 📁 Script inside ServerScriptService or similar
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local ServerStorage = game:GetService("ServerStorage")
local Terrain = workspace.Terrain
local progress = ReplicatedStorage:FindFirstChild("WorldProgress")

-- RemoteEvent to trigger stone harvesting
local stoneClicked = ReplicatedStorage:WaitForChild("StoneClicked")

-- ✅ Check if player is holding the Pickaxe tool
local function isHoldingPickaxe(player)
	local character = player.Character
	if not character then 
		warn("No character found for player.")
		return false 
	end
	local pickaxe = character:FindFirstChild("Pickaxe")
	if pickaxe and pickaxe:IsA("Tool") then
		return true
	else
		warn("Pickaxe not equipped.")
	end
	return false
end

-- ✅ Add or increment Stone tool with amount
local function giveStone(player, amount)
	local backpack = player:FindFirstChild("Backpack")
	if not backpack then 
		warn("No backpack found.")
		return 
	end

	local character = player.Character

	-- Utility: Find existing Stone tool with IntValue
	-- Inside giveStone
	local function findStoneTool(container)
		for _, item in pairs(container:GetChildren()) do
			if item:IsA("Tool") and item.Name:match("^Stone %(") and item:FindFirstChild("Amount") then
				return item
			end
		end
		return nil
	end


	local existing = findStoneTool(backpack) or (character and findStoneTool(character))

	if existing then
		local amt = existing:FindFirstChild("Amount")
		if amt then
			amt.Value += amount
			existing.Name = "Stone (" .. amt.Value .. ")"
			print(player.Name .. " now has " .. amt.Value .. " stone.")
		end
	else
		local stoneTemplate = ServerStorage:FindFirstChild("Stone")
		if stoneTemplate then
			local newStone = stoneTemplate:Clone()
			local amt = newStone:FindFirstChild("Amount")
			if amt then
				amt.Value = amount
			end
			newStone.Name = "Stone (" .. amount .. ")"
			newStone.Parent = backpack
			print(player.Name .. " received new stone.")
		else
			warn("Stone template not found in ServerStorage.")
		end
	end
end

-- ✅ Main handler when terrain clicked
local function onStoneClicked(player, position)
	if not position or typeof(position) ~= "Vector3" then
		warn("Invalid position passed.")
		return
	end

	if not isHoldingPickaxe(player) then
		print("❌ Pickaxe not equipped.")
		return
	end

	-- Convert position to voxel region
	local function roundToFour(num)
		return math.floor(num / 4) * 4
	end

	local function getOrderedRegion(pos, size)
		local halfSize = size / 2

		local p1 = Vector3.new(
			roundToFour(pos.X - halfSize.X),
			roundToFour(pos.Y - halfSize.Y),
			roundToFour(pos.Z - halfSize.Z)
		)

		local p2 = Vector3.new(
			roundToFour(pos.X + halfSize.X),
			roundToFour(pos.Y + halfSize.Y),
			roundToFour(pos.Z + halfSize.Z)
		)

		local min = Vector3.new(
			math.min(p1.X, p2.X),
			math.min(p1.Y, p2.Y),
			math.min(p1.Z, p2.Z)
		)

		local max = Vector3.new(
			math.max(p1.X, p2.X),
			math.max(p1.Y, p2.Y),
			math.max(p1.Z, p2.Z)
		)

		return Region3.new(min, max)
	end

	local regionSize = Vector3.new(8, 8, 8)
	local region = getOrderedRegion(position + Vector3.new(0, 2, 0), regionSize)

	local materials, _ = Terrain:ReadVoxels(region, 4)

	if not materials then
		warn("ReadVoxels returned nil.")
		return
	end

	if #materials >= 1 and #materials[1] >= 1 and #materials[1][1] >= 1 then
		local centerMaterial = materials[1][1][1]
		print("Center material:", centerMaterial.Name)

		if centerMaterial == Enum.Material.Asphalt then
			print("✅ Asphalt detected. Giving stone...")
			giveStone(player, 3)
			progress.Value = math.clamp(progress.Value + 20, 0, 1000)
		else
			print("Clicked material is not Asphalt:", centerMaterial.Name)
		end
	else
		warn("Malformed voxel data.")
	end
end

-- 📌 Connect remote event
stoneClicked.OnServerEvent:Connect(onStoneClicked)
