-- StarterGui > WorldGui > LocalScript
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local progressValue = ReplicatedStorage:WaitForChild("WorldProgress")
local label = script.Parent:WaitForChild("ProgressLabel")

-- Update the label
local function updateLabel()
	label.Text = progressValue.Value .. "/1000"
end

-- Initial update
updateLabel()

-- Update when value changes
progressValue:GetPropertyChangedSignal("Value"):Connect(updateLabel)
