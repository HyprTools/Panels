-- test script, not full beta

local players = game:GetService("Players")
local replicatedStorage = game:GetService("ReplicatedStorage")
local runService = game:GetService("RunService")
local teams = game:GetService("Teams")

local player = players.LocalPlayer
local customizeFlag: Model = workspace:WaitForChild("CustomizeFlag")

local starterPlayerReportRequest: RemoteEvent = replicatedStorage:WaitForChild("StarterPlayerReportRequest")
local updateNameTag: RemoteEvent = replicatedStorage:WaitForChild("UpdateNameTag")
local updateNameTagFlair: RemoteEvent = replicatedStorage:WaitForChild("UpdateNameTagFlair")

local spamColor = BrickColor.new("Institutional white")
local nameTagData = {
	player.DisplayName,
	"",
	Color3.new(1, 0, 0),
	ColorSequence.new(Color3(1, 0, 0), Color3(0.5, 0, 0)),
	"Gay"
}
local nameTagFlair = {
	"",
	""
}

local rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()
local window = rayfield:CreateWindow({
	Name = "LGBTQ+ Hangout Panel - HyprTools",
	LoadingTitle = "LGBTQ+ Hangout Panel",
	LoadingSubtitle = "HyprTools",
	ShowText = "HyprTools",
	Theme = "Default",
	
	ToggleUIKeybind = "K",
	
	Discord = {
		Enabled = true,
		Invite = "",
		RememberJoins = true
	}
})

-- GENERAL

local function warnPlayer(warnMsg: string)
	rayfield:Notify({
		Title = "Warning",
		Content = warnMsg,
		Duration = 6.5,
		Image = "triangle-alert",
	})
end

-- WORLD

local worldTab = window:CreateTab("World", "earth")

local brickColors = {}
for i = 0, 127 do
	brickColors[i] = BrickColor.palette(i).Name
end

local paintSection worldTab:CreateSection("Paint Custom Flag")
local spamColorDropdown = worldTab:CreateDropdown({
	Name = "Flag",
	Options = brickColors,
	CurrentOption = "Institutional white",
	Callback = function(value)
		spamColor = BrickColor.new(value)
	end
})

local function isTouchingFlag()
	local rootPart = player.Character:WaitForChild("HumanoidRootPart")
	local hit = rootPart.Touched:Wait()

	if hit.Parent == customizeFlag then
		return true
	else
		return false
	end
end

local heartbeatEvent = nil
local spamColorToggle = worldTab:CreateToggle({
	Name = "Toggle Spam Paint",
	CurrentValue = false,
	Callback = function(value)
		if value then
			if not isTouchingFlag() then
				warnPlayer("Go to the flag to spam it!")
				return
			end
			
			local paintBucket = player.Backpack:FindFirstChild("PaintBucket") or player.Character:FindFirstChild("PaintBucket")
			if not paintBucket then
				warnPlayer("Cannot find your paint bucket!")
				return
			end
			
			if heartbeatEvent then heartbeatEvent:Disconnect() end
			heartbeatEvent = runService.Heartbeat:Connect(function()
				for _, child in customizeFlag:GetChildren() do
					if not child:IsA("BasePart") or child.Name == "Border" then continue end
					
				end
			end)
		else
			heartbeatEvent:Disconnect()
		end
	end,
})

local reportSection = worldTab:CreateSection("Report")
local reportInput = worldTab:CreateInput({
	Name = "ReportPlayer",
	PlaceholderText = "Username",
	RemoveTextAfterFocusLost = false,
	Callback = function(value)
		
	end
})
local reasonInput = worldTab:CreateInput({
	Name = "Reason",
	PlaceholderText = "Reason",
	RemoveTextAfterFocusLost = false,
	Callback = function(value)
		
	end
})
local spamReportToggle = worldTab:CreateToggle({
	Name = "Spam Report",
	CurrentValue = false,
	Callback = function(value)
		
	end
})
local submitReport = worldTab:CreateButton({
	Name = "Submit Report",
	Callback = function()
		
	end
})

-- PROFILE

local profileTab = window:CreateTab("Profile", "user-round-pen")

local nameTagSection = profileTab:CreateSection("Name Tag")
local displayNameInput = profileTab:CreateInput({
	Name = "Display Name",
	PlaceholderText = "NAHH",
	RemoveTextAfterFocusLost = false,
	Callback = function(value)
		nameTagData[1] = value
		warnPlayer("Idk if you can change your name or not.")
		updateNameTag:FireServer(nameTagData)
	end
})
local pronounsInput = profileTab:CreateInput({
	Name = "Pronouns",
	PlaceholderText = "Walmart/Bag",
	RemoveTextAfterFocusLost = false,
	Callback = function(value)
		nameTagData[2] = value
		updateNameTag:FireServer(nameTagData)
	end
})

local teamOptions = {}
for _, team in teams:GetTeams() do
	table.insert(teamOptions, team.Name)
end

local teamDropdown = profileTab:CreateDropdown({
	Name = "Orientation Team",
	Options = teamOptions,
	MultipleOptions = false,
	Callback = function(value)
		local team: Team = teams:FindFirstChild(value)
		if not team then
			warnPlayer("Cannot find a team based on the name!")
			return
		end
		
		local teamColor = team.TeamColor.Color
		nameTagData[3] = teamColor
		updateNameTag:FireServer(nameTagData)
	end
})
local colorPicker = profileTab:CreateColorPicker({
	Name = "Name Tag Color",
	Callback = function(value)
		updateNameTag:FireServer(nameTagData)
	end
})
local colorSeqDropdown = profileTab:CreateDropdown({
	Name = "Color Sequence",
	Options = {
		"Rainbow",
		"Custom"
	},
	MultipleOptions = false,
	Callback = function(value)
		updateNameTag:FireServer(nameTagData)
	end
})

local flairSection = profileTab:CreateSection("Flair")
local flairDirectionDropdown = profileTab:CreateDropdown({
	Name = "Flair Direction",
	Options = {
		"Left",
		"Right"
	},
	MultipleOptions = false,
	CsdwurrentOption = "Left",
	Callback = function(value)
		nameTagFlair[1] = value
		updateNameTagFlair:FireServer(nameTagFlair)
	end
})
local flairEmojiInput = profileTab:CreateInput({
	Name = "Flair Emoji",
	PlaceholderText = "?",
	RemoveTextAfterFocusLost = false,
	Callback = function(value)
		nameTagFlair[2] = value
		updateNameTagFlair:FireServer(nameTagFlair)
	end
})
