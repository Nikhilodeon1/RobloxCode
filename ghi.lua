-- ServerScriptService -> Script
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local progressValue = Instance.new("IntValue")
progressValue.Name = "WorldProgress"
progressValue.Value = 20 -- Start value
progressValue.Parent = ReplicatedStorage

