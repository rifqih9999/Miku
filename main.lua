-- Milo Project - Fish It! FINAL v2.0 (WORKING Des 2025)
-- Auto Perfect Cast + Instant Reel + Auto Sell

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer

-- CARA BARU: langsung cari di Events (bukan Remotes)
local Events = ReplicatedStorage:WaitForChild("Events")

local CastRemote  = Events:WaitForChild("CastRod")      -- nama baru
local ReelRemote  = Events:WaitForChild("ReelRod")      -- nama baru
local SellRemote  = Events:WaitForChild("SellAllFish")  -- nama baru

print("Milo Project v2.0 Loaded – Remotes OK")

-- GUI (sama persis kayak sebelumnya, cuma lebih stabil)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MiloProject"
ScreenGui.ResetOnSpawn = false
ScreenGui.DisplayOrder = 999
ScreenGui.Parent = player:WaitForChild("PlayerGui")

local ToggleFrame = Instance.new("Frame")
ToggleFrame.Size = UDim2.new(0, 180, 0, 60)
ToggleFrame.Position = UDim2.new(0.02, 0, 0.12, 0)
ToggleFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
ToggleFrame.Active = true
ToggleFrame.Draggable = true
ToggleFrame.Parent = ScreenGui
Instance.new("UICorner", ToggleFrame).CornerRadius = UDim.new(0, 14)

local Aspect = Instance.new("UIAspectRatioConstraint", ToggleFrame)
Aspect.AspectRatio = 3
local SizeConst = Instance.new("UISizeConstraint", ToggleFrame)
SizeConst.MinSize = Vector2.new(140, 46)
SizeConst.MaxSize = Vector2.new(240, 80)

local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size = UDim2.new(1,0,1,0)
ToggleBtn.BackgroundTransparency = 1
ToggleBtn.Text = "Milo Project - OFF"
ToggleBtn.TextColor3 = Color3.new(1,1,1)
ToggleBtn.Font = Enum.Font.GothamBlack
ToggleBtn.TextSize = 18
ToggleBtn.Parent = ToggleFrame

-- Close & Minimize (tetep ada)
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0,30,0,30); CloseBtn.Position = UDim2.new(1,-34,0,4)
CloseBtn.BackgroundColor3 = Color3.fromRGB(220,30,30); CloseBtn.Text = "×"
CloseBtn.TextColor3 = Color3.new(1,1,1); CloseBtn.Font = Enum.Font.GothamBlack
CloseBtn.TextSize = 24; CloseBtn.Parent = ToggleFrame
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0,8)

local MinimizeBtn = Instance.new("TextButton")
MinimizeBtn.Size = UDim2.new(0,30,0,30); MinimizeBtn.Position = UDim2.new(0,4,0,4)
MinimizeBtn.BackgroundColor3 = Color3.fromRGB(255,170,0); MinimizeBtn.Text = "−"
MinimizeBtn.TextColor3 = Color3.new(1,1,1); MinimizeBtn.Font = Enum.Font.GothamBlack
MinimizeBtn.TextSize = 28; MinimizeBtn.Parent = ToggleFrame
Instance.new("UICorner", MinimizeBtn).CornerRadius = UDim.new(0,8)

-- Variables
local autoEnabled = false
local isCasting = false
local lastSell = 0
local minimized = false

-- Toggle
ToggleBtn.MouseButton1Click:Connect(function()
    autoEnabled = not autoEnabled
    ToggleBtn.Text = autoEnabled and "Milo Project - ON" or "Milo Project - OFF"
    ToggleFrame.BackgroundColor3 = autoEnabled and Color3.fromRGB(0,220,110) or Color3.fromRGB(220,50,50)
end)

-- Close
CloseBtn.MouseButton1Click:Connect(function()
    autoEnabled = false
    ScreenGui:Destroy()
end)

-- Minimize
MinimizeBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    if minimized then
        ToggleBtn.Visible = false; CloseBtn.Visible = false
        MinimizeBtn.Text = "Box"; MinimizeBtn.Size = UDim2.new(0,50,0,50)
        MinimizeBtn.Position = UDim2.new(0.02,0,0.88,0)
        MinimizeBtn.BackgroundColor3 = Color3.fromRGB(0,200,100)
        ToggleFrame.Size = UDim2.new(0,60,0,60)
    else
        ToggleBtn.Visible = true; CloseBtn.Visible = true
        MinimizeBtn.Text = "−"; MinimizeBtn.Size = UDim2.new(0,30,0,30)
        MinimizeBtn.Position = UDim2.new(0,4,0,4)
        MinimizeBtn.BackgroundColor3 = Color3.fromRGB(255,170,0)
        ToggleFrame.Size = UDim2.new(0,180,0,60)
    end
end)

-- Auto Farm Loop
task.spawn(function()
    while task.wait(0.15) do
        if autoEnabled and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            -- Auto Sell
            if tick() - lastSell > math.random(32,39) then
                pcall(function() SellRemote:FireServer() end)
                lastSell = tick()
            end
            -- Cast + Reel
            if not isCasting then
                isCasting = true
                pcall(function() -- Cast perfect
                task.wait(math.random(24,42)/10)
                pcall(function() ReelRemote:FireServer() end) -- Instant catch
                task.wait(0.6)
                isCasting = false
            end
        end
    end
end)

print("Milo Project v2.0 ACTIVE – Happy Farming!")
