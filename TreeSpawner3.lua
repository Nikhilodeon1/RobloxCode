local treeModel = game.ReplicatedStorage:WaitForChild("Tree3")
local NUM_TREES = 20

local X_MIN, X_MAX = -500, 500  -- adjust to your map size
local Z_MIN, Z_MAX = -500, 500

for i = 1, NUM_TREES do
	local success = false

	for attempt = 1, 100 do
		local x = math.random(X_MIN, X_MAX)
		local z = math.random(Z_MIN, Z_MAX)
		local y = 500

		local origin = Vector3.new(x, y, z)
		local direction = Vector3.new(0, -1000, 0)

		local rayParams = RaycastParams.new()
		rayParams.FilterType = Enum.RaycastFilterType.Include
		rayParams.FilterDescendantsInstances = {workspace}

		local result = workspace:Raycast(origin, direction, rayParams)

		if result and result.Material == Enum.Material.Sand then
			local clone = treeModel:Clone()
			clone.Parent = workspace
			local offset = Vector3.new(0, 5, 0) -- lift trees 5 studs up
			clone:SetPrimaryPartCFrame(
				CFrame.new(result.Position + offset) * CFrame.Angles(0, math.rad(math.random(0, 360)), 0)
			)
			success = true
			break
		end
	end

	if not success then
		warn("Could not place Tree3 #" .. i .. " on sand.")
	end
end
