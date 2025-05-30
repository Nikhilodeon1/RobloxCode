local npc = workspace:WaitForChild("MerchantNPC")
local clickPart = npc:WaitForChild("Head") -- or whichever part has ClickDetector
local clickDetector = clickPart:WaitForChild("ClickDetector")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local remoteEvent = ReplicatedStorage:WaitForChild("OpenTradingMenu")

clickDetector.MouseClick:Connect(function(player)
	remoteEvent:FireClient(player)
end)
