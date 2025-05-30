local treeModel = game.ReplicatedStorage:WaitForChild("Tree")
local terrain = workspace.Terrain
local NUM_TREES = 120

local X_MIN, X_MAX = -500, 500  -- Replace with your terrain bounds
local Z_MIN, Z_MAX = -500, 500

for i = 1, NUM_TREES do
	local success = false

	-- Try up to 100 times to find grass terrain
	for attempt = 1, 100 do
		local x = math.random(X_MIN, X_MAX)
		local z = math.random(Z_MIN, Z_MAX)
		local y = 500  -- start ray above map

		local origin = Vector3.new(x, y, z)
		local direction = Vector3.new(0, -1000, 0)

		local raycastParams = RaycastParams.new()
		raycastParams.FilterType = Enum.RaycastFilterType.Include
		raycastParams.FilterDescendantsInstances = {workspace}

		local result = workspace:Raycast(origin, direction, raycastParams)

		if result and result.Material == Enum.Material.Grass then
			local clone = treeModel:Clone()
			clone.Parent = workspace

			clone:SetPrimaryPartCFrame(
				CFrame.new(result.Position) * CFrame.Angles(0, math.rad(math.random(0, 360)), 0)
			)

			success = true
			break
		end
	end

	if not success then
		warn("Couldn't place tree #" .. i .. " on grass terrain.")
	end
end
