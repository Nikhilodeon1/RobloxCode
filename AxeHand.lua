Axehandlocal ServerStorage = game:GetService("ServerStorage")
local Players = game:GetService("Players")

Players.PlayerAdded:Connect(function(player)
	player.CharacterAdded:Connect(function(character)
		local backpack = player:WaitForChild("Backpack")

		-- Get Axe and Pickaxe from ServerStorage
		local axe = ServerStorage:FindFirstChild("Axe")
		local pickaxe = ServerStorage:FindFirstChild("Pickaxe")

		if axe then
			local axeClone = axe:Clone()
			axeClone.Parent = backpack
			-- Auto-equip Axe (goes to slot 1)
			local humanoid = character:WaitForChild("Humanoid")
			humanoid:EquipTool(axeClone)
		else
			warn("Axe not found in ServerStorage!")
		end

		if pickaxe then
			local pickaxeClone = pickaxe:Clone()
			pickaxeClone.Parent = backpack
			-- The pickaxe will appear in slot 2 because it's added second
		else
			warn("Pickaxe not found in ServerStorage!")
		end
	end)
end)
