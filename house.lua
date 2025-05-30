-- ServerScriptService > Script

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local houseModel = ReplicatedStorage:WaitForChild("House")
local progress = ReplicatedStorage:FindFirstChild("WorldProgress")

-- Make sure progress exists
if not progress then
	progress = Instance.new("IntValue")
	progress.Name = "WorldProgress"
	progress.Value = 0
	progress.Parent = ReplicatedStorage
end

-- Loop through all BuildZones
for _, buildZone in pairs(workspace:GetChildren()) do
	if buildZone:IsA("BasePart") and buildZone.Name == "BuildZone" then
		local prompt = buildZone:FindFirstChildOfClass("ProximityPrompt")

		if prompt then
			prompt.Triggered:Connect(function(player)
				if not houseModel.PrimaryPart then
					warn("House model is missing a PrimaryPart.")
					return
				end

				-- Check for HouseToken tool
				local token
				local backpack = player:FindFirstChild("Backpack")
				local character = player.Character

				if backpack then
					token = backpack:FindFirstChild("HouseToken")
				end
				if not token and character then
					token = character:FindFirstChild("HouseToken")
				end

				if not token then
					warn(player.Name .. " tried to build without a HouseToken.")
					return
				end

				-- Optional: prevent multiple houses per zone
				if buildZone:FindFirstChild("SpawnedHouse") then return end

				-- 🏠 Spawn the house
				local newHouse = houseModel:Clone()
				newHouse.Name = "SpawnedHouse"
				newHouse:SetPrimaryPartCFrame(buildZone.CFrame + Vector3.new(0, newHouse.PrimaryPart.Size.Y / 2, 0))
				newHouse.Parent = workspace

				-- Attach house to zone so it can't be rebuilt here
				local marker = Instance.new("BoolValue")
				marker.Name = "SpawnedHouse"
				marker.Parent = buildZone

				-- 🧹 Consume the HouseToken tool
				token:Destroy()

				-- 📈 Increase progress
				progress.Value = math.clamp(progress.Value + 20, 0, 100)
			end)
		end
	end
end
