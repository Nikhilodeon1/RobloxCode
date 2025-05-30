local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local ServerStorage = game:GetService("ServerStorage")
local progress = ReplicatedStorage:FindFirstChild("WorldProgress")


local treeClicked = ReplicatedStorage:WaitForChild("TreeClicked")

-- Check if player is holding the Axe tool
local function isHoldingAxe(player)
	local character = player.Character
	if not character then 
		warn("No character found for player.")
		return false 
	end
	local axe = character:FindFirstChild("Axe")
	if axe and axe:IsA("Tool") then
		return true
	else
		warn("Axe not equipped.")
	end
	return false
end

-- Give wood to player as a Tool in Backpack
local function giveWood(player, amount)
	local backpack = player:FindFirstChild("Backpack")
	if not backpack then 
		warn("No backpack found.")
		return 
	end

	local character = player.Character

	-- Utility function: Check for any tool named "Wood", ignoring custom names
	local function findWoodTool(container)
		for _, item in pairs(container:GetChildren()) do
			if item:IsA("Tool") and item.Name:match("^Wood %(") and item:FindFirstChild("Amount") then
				return item
			end
		end
		return nil
	end


	-- Look in backpack and character for a wood tool
	local existing = findWoodTool(backpack) or (character and findWoodTool(character))

	if existing then
		local amt = existing:FindFirstChild("Amount")
		if amt then
			amt.Value += amount
			existing.Name = "Wood (" .. amt.Value .. ")"
			print(player.Name .. " now has " .. amt.Value .. " wood.")
		end
	else
		local woodTemplate = ServerStorage:FindFirstChild("Wood")
		if woodTemplate then
			local newWood = woodTemplate:Clone()
			local amt = newWood:FindFirstChild("Amount")
			if amt then
				amt.Value = amount
			end
			newWood.Name = "Wood (" .. amount .. ")"
			newWood.Parent = backpack
			print(player.Name .. " received new wood.")
		else
			warn("Wood template not found in ServerStorage.")
		end
	end
end



-- Function to hide tree parts
local function hideTree(treeModel)
	for _, part in pairs(treeModel:GetDescendants()) do
		if part:IsA("BasePart") then
			part.Transparency = 1
			part.CanCollide = false
		elseif part:IsA("ClickDetector") then
			part:Destroy()
		end
	end
end

-- Main function called when tree clicked
local function onTreeClicked(player, treeModel)
	if not treeModel or not treeModel:IsA("Model") then 
		warn("Invalid tree clicked.")
		return 
	end

	if isHoldingAxe(player) then
		print("✅ Axe is equipped.")
		giveWood(player, 5)
		hideTree(treeModel)
		progress.Value = math.clamp(progress.Value + 20, 0, 1000)
	else
		print("❌ Axe not equipped.")
	end
end

-- Connect the RemoteEvent
treeClicked.OnServerEvent:Connect(onTreeClicked)
