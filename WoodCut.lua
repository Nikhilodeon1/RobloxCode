local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local player = Players.LocalPlayer
local mouse = player:GetMouse()
local treeClicked = ReplicatedStorage:WaitForChild("TreeClicked")

mouse.Button1Down:Connect(function()
	local target = mouse.Target
	if target and target.Parent then
		local parentModel = target:FindFirstAncestorWhichIsA("Model")
		if parentModel and (parentModel.Name == "Tree" or parentModel.Name == "Tree2" or parentModel.Name == "Tree3") then
			print("Clicked on a tree: " .. parentModel.Name) -- DEBUG
			treeClicked:FireServer(parentModel)
		else
			print("Clicked object is not a tree.")
		end
	else
		print("Clicked nothing.")
	end
end)
