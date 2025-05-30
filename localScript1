-- StarterPlayerScripts > LocalScript

local UIS = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local mouse = player:GetMouse()

local HOLD_TIME = 1.5 -- How long to hold E to summon
local holding = false
local holdStart = 0

-- Remote event to trigger spawn from client to server
local spawnEvent = Instance.new("RemoteEvent", ReplicatedStorage)
spawnEvent.Name = "SpawnHouseEvent"

-- Detect E key hold
UIS.InputBegan:Connect(function(input, processed)
	if processed then return end
	if input.KeyCode == Enum.KeyCode.E then
		holdStart = tick()
		holding = true
	end
end)

UIS.InputEnded:Connect(function(input)
	if input.KeyCode == Enum.KeyCode.E then
		holding = false
	end
end)

-- Check if we're looking at BuildZone and held E long enough
RunService.RenderStepped:Connect(function()
	if holding and (tick() - holdStart >= HOLD_TIME) then
		local target = mouse.Target
		if target and target.Name == "BuildZone" then
			spawnEvent:FireServer(target.Position)
			holding = false
		end
	end
end)
