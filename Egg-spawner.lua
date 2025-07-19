local Players = game:GetService("Players")
local player = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- List of egg types
local eggTypes = {
    "Bug Egg",
    "Paradise Egg", 
    "Dinosaur Egg",
    "Primal Egg",
    "Oasis Egg",
    "Night Egg",
    "Bee Egg",
    "Premium Night Egg",
    "Premium Anti Bee Egg",
    "Mythical Egg",
    "Anti Bee Egg"
}

-- Upright rotation fix for each egg
local uprightFix = {
    ["Bug Egg"] = CFrame.Angles(0, 0, math.rad(90)),
    ["Anti Bee Egg"] = CFrame.Angles(0, 0, math.rad(90)),
    ["Paradise Egg"] = CFrame.Angles(0, 0, math.rad(90)),
    ["Bee Egg"] = CFrame.Angles(0, 0, math.rad(90)),
    ["Mythical Egg"] = CFrame.Angles(0, 0, math.rad(90)),
    ["Primal Egg"] = CFrame.Angles(0, 0, math.rad(90)),
}

-- UI Creation
local function createSpawnUI()
    while not player:FindFirstChild("PlayerGui") do task.wait() end
    if player.PlayerGui:FindFirstChild("g3zmarUI") then
        player.PlayerGui.g3zmarUI:Destroy()
    end

    local screenGui = Instance.new("ScreenGui", player.PlayerGui)
    screenGui.Name = "g3zmarUI"
    screenGui.ResetOnSpawn = false

    local mainFrame = Instance.new("Frame", screenGui)
    mainFrame.Size = UDim2.new(0, 220, 0, 140)
    mainFrame.Position = UDim2.new(0.5, -110, 0.6, 0)
    mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    mainFrame.Active = true
    mainFrame.Draggable = true

    local title = Instance.new("TextLabel", mainFrame)
    title.Size = UDim2.new(0.9, 0, 0.15, 0)
    title.Position = UDim2.new(0.05, 0, 0.05, 0)
    title.Text = "g3zmar hub v.1"
    title.Font = Enum.Font.FredokaOne
    title.TextSize = 18
    title.TextColor3 = Color3.fromRGB(0, 255, 255)
    title.BackgroundTransparency = 1

    local dropdownButton = Instance.new("TextButton", mainFrame)
    dropdownButton.Size = UDim2.new(0.9, 0, 0.2, 0)
    dropdownButton.Position = UDim2.new(0.05, 0, 0.25, 0)
    dropdownButton.Text = "▼ Select Egg Type"
    dropdownButton.Font = Enum.Font.FredokaOne
    dropdownButton.TextSize = 16
    dropdownButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    dropdownButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)

    local dropdownFrame = Instance.new("ScrollingFrame", mainFrame)
    dropdownFrame.Size = UDim2.new(0.9, 0, 0, 150)
    dropdownFrame.Position = UDim2.new(0, 0, 1, 5)
    dropdownFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    dropdownFrame.Visible = false
    dropdownFrame.ScrollBarThickness = 6

    local uiListLayout = Instance.new("UIListLayout", dropdownFrame)

    for _, eggName in ipairs(eggTypes) do
        local option = Instance.new("TextButton", dropdownFrame)
        option.Size = UDim2.new(1, 0, 0, 25)
        option.Text = eggName
        option.Font = Enum.Font.FredokaOne
        option.TextSize = 14
        option.TextColor3 = Color3.fromRGB(255, 255, 255)
        option.BackgroundColor3 = Color3.fromRGB(60, 60, 60)

        option.MouseButton1Click:Connect(function()
            dropdownButton.Text = "▼ " .. eggName
            dropdownFrame.Visible = false
        end)
    end

    uiListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        dropdownFrame.CanvasSize = UDim2.new(0, 0, 0, uiListLayout.AbsoluteContentSize.Y)
        dropdownFrame.Size = UDim2.new(0.9, 0, 0, math.min(150, uiListLayout.AbsoluteContentSize.Y))
    end)

    dropdownButton.MouseButton1Click:Connect(function()
        dropdownFrame.Visible = not dropdownFrame.Visible
    end)

    local spawnButton = Instance.new("TextButton", mainFrame)
    spawnButton.Size = UDim2.new(0.9, 0, 0.2, 0)
    spawnButton.Position = UDim2.new(0.05, 0, 0.75, 0)
    spawnButton.Text = "🪺 SPAWN"
    spawnButton.Font = Enum.Font.FredokaOne
    spawnButton.TextSize = 16
    spawnButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    spawnButton.BackgroundColor3 = Color3.fromRGB(0, 150, 150)

    spawnButton.MouseButton1Click:Connect(function()
        local selectedEgg = string.gsub(dropdownButton.Text, "▼ ", "")
        if selectedEgg == "Select Egg Type" then
            spawnButton.Text = "❌ SELECT EGG!"
            task.wait(1)
            spawnButton.Text = "🪺 SPAWN"
            return
        end

        spawnButton.Text = "🔍 CLONING EGG..."

        local originalEgg
        for _, obj in ipairs(workspace:GetDescendants()) do
            if obj:IsA("Model") and obj.Name == selectedEgg then
                originalEgg = obj
                break
            end
        end

        if not originalEgg then
            spawnButton.Text = "❌ EGG NOT FOUND"
            task.wait(1)
            spawnButton.Text = "🪺 SPAWN"
            return
        end

        local eggClone = originalEgg:Clone()
        eggClone.Parent = workspace

        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = player.Character.HumanoidRootPart
            local basePos = hrp.Position + Vector3.new(0, 5, -5)

            local rayParams = RaycastParams.new()
            rayParams.FilterDescendantsInstances = {player.Character}
            rayParams.FilterType = Enum.RaycastFilterType.Blacklist
            local ray = workspace:Raycast(basePos, Vector3.new(0, -100, 0), rayParams)

            if not eggClone.PrimaryPart then
                local part = eggClone:FindFirstChildWhichIsA("BasePart")
                if part then eggClone.PrimaryPart = part end
            end

            if eggClone.PrimaryPart then
                local finalPos = ray and ray.Position or basePos
                local height = eggClone:GetExtentsSize().Y / 2
                local baseCFrame = CFrame.new(finalPos + Vector3.new(0, height, 0))
                local uprightRotation = uprightFix[selectedEgg] or CFrame.Angles(0, 0, 0)

                eggClone:SetPrimaryPartCFrame(baseCFrame * uprightRotation)
                spawnButton.Text = "✅ " .. selectedEgg .. " SPAWNED!"
            else
                spawnButton.Text = "⚠️ NO PRIMARYPART"
            end
        end

        task.wait(1)
        spawnButton.Text = "🪺 SPAWN"
    end)
end

local function initialize()
    local success, err = pcall(createSpawnUI)
    if not success then
        warn("UI Error:", err)
        task.wait(2)
        initialize()
    end
end

if player.Character then
    initialize()
else
    player.CharacterAdded:Connect(initialize)
end
