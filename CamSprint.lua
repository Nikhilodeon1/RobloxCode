local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

local runSpeed = 24
local walkSpeed = 16
local isSprinting = false

local normalFOV = 70
local sprintFOV = 85
local tweenTime = 0.25

-- Function to update speed and FOV
local function updateSprinting()
	local character = player.Character or player.CharacterAdded:Wait()
	local humanoid = character:WaitForChild("Humanoid")

	humanoid.WalkSpeed = isSprinting and runSpeed or walkSpeed

	local targetFOV = isSprinting and sprintFOV or normalFOV
	local tweenInfo = TweenInfo.new(tweenTime, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
	local tween = TweenService:Create(camera, tweenInfo, {FieldOfView = targetFOV})
	tween:Play()
end

-- Toggle sprinting when Q is pressed
UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end
	if input.KeyCode == Enum.KeyCode.Q then
		isSprinting = not isSprinting
		updateSprinting()
	end
end)

-- Reset everything on character respawn
player.CharacterAdded:Connect(function(character)
	local humanoid = character:WaitForChild("Humanoid")
	humanoid.WalkSpeed = walkSpeed
	camera.FieldOfView = normalFOV
	isSprinting = false
end)

local player = game.Players.LocalPlayer
local camera = workspace.CurrentCamera

-- Wait for the character to load
player.CharacterAdded:Connect(function(character)
	-- Set camera mode to first person only
	player.CameraMode = Enum.CameraMode.LockFirstPerson
end)

-- If character already loaded before script runs, set it immediately
if player.Character then
	player.CameraMode = Enum.CameraMode.LockFirstPerson
end
