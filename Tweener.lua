local ts = game:GetService("TweenService")
local rs = game:GetService("RunService")
local ti = TweenInfo.new(0.2)

local TPfolder = workspace:WaitForChild("TweenParts")

local char = script.Parent
local hrp = char:WaitForChild("HumanoidRootPart")


local partData = {}
local activationDistance = 6
local posOffset = Vector3.new(0,6,0)
local sizeOffset = Vector3.new(0,10,0)

local function tweenDown(parter, ogPOS, ogSize)
	local goals = {
		Position = ogPOS - posOffset,
		Size = ogSize - sizeOffset
	}
	local tween = ts:Create(parter, ti, goals)
	tween:Play()
end

local function tweenUp(parter, ogPOS, ogSize)
	local goals = {
		Position = ogPOS,
		Size = ogSize
	}
	local tween = ts:Create(parter, ti, goals)
	tween:Play()
end

rs.Heartbeat:Connect(function()
	if not hrp then return end

	for _, part in TPfolder:GetChildren() do
		if part:IsA("BasePart") then
			
			if not partData[part] then
				partData[part] = {
					state = false,
					ogPOS = part.Position,
					ogSize = part.Size
				}
			end

			local data = partData[part]
			local mag = (hrp.Position - data.ogPOS).Magnitude

			if mag <= activationDistance and not data.state then
				tweenDown(part, data.ogPOS, data.ogSize)
				data.state = true

			elseif mag > activationDistance and data.state then
				tweenUp(part, data.ogPOS, data.ogSize)
				data.state = false
			end
		end
	end
end)
