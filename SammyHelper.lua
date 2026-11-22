-- Sammy Helper - client-side companion UI
-- For personal testing only. This script does NOT read the game screen,
-- bypass game systems, or redeem codes automatically.

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local old = playerGui:FindFirstChild("SammyHelperGui")
if old then old:Destroy() end

local gui = Instance.new("ScreenGui")
gui.Name = "SammyHelperGui"
gui.ResetOnSpawn = false
gui.Parent = playerGui

local panel = Instance.new("Frame")
panel.Name = "Panel"
panel.Size = UDim2.fromOffset(285, 330)
panel.Position = UDim2.new(0.5, -142, 0.5, -165)
panel.BackgroundColor3 = Color3.fromRGB(25, 30, 42)
panel.BorderSizePixel = 0
panel.Parent = gui
Instance.new("UICorner", panel).CornerRadius = UDim.new(0, 12)

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(70, 145, 255)
stroke.Thickness = 1.5
stroke.Parent = panel

local header = Instance.new("TextLabel")
header.Size = UDim2.new(1, -42, 0, 38)
header.Position = UDim2.fromOffset(12, 2)
header.BackgroundTransparency = 1
header.Text = "SAMMY HELPER"
header.TextColor3 = Color3.fromRGB(255,255,255)
header.Font = Enum.Font.GothamBold
header.TextSize = 16
header.TextXAlignment = Enum.TextXAlignment.Left
header.Parent = panel

local close = Instance.new("TextButton")
close.Size = UDim2.fromOffset(30, 28)
close.Position = UDim2.new(1, -36, 0, 6)
close.Text = "X"
close.TextColor3 = Color3.new(1,1,1)
close.BackgroundColor3 = Color3.fromRGB(170,55,65)
close.Font = Enum.Font.GothamBold
close.TextSize = 14
close.Parent = panel
Instance.new("UICorner", close).CornerRadius = UDim.new(0, 7)
close.MouseButton1Click:Connect(function() gui:Destroy() end)

local function makeLabel(text, y)
    local l = Instance.new("TextLabel")
    l.Size = UDim2.new(1, -24, 0, 20)
    l.Position = UDim2.fromOffset(12, y)
    l.BackgroundTransparency = 1
    l.Text = text
    l.TextColor3 = Color3.fromRGB(205,215,230)
    l.Font = Enum.Font.GothamSemibold
    l.TextSize = 12
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.Parent = panel
    return l
end

local function makeBox(placeholder, y, height)
    local box = Instance.new("TextBox")
    box.Size = UDim2.new(1, -24, 0, height)
    box.Position = UDim2.fromOffset(12, y)
    box.BackgroundColor3 = Color3.fromRGB(39,47,63)
    box.TextColor3 = Color3.new(1,1,1)
    box.PlaceholderColor3 = Color3.fromRGB(150,160,175)
    box.PlaceholderText = placeholder
    box.Text = ""
    box.ClearTextOnFocus = false
    box.Font = Enum.Font.Gotham
    box.TextSize = 12
    box.TextWrapped = true
    box.TextXAlignment = Enum.TextXAlignment.Left
    box.TextYAlignment = Enum.TextYAlignment.Top
    box.MultiLine = true
    box.Parent = panel
    Instance.new("UICorner", box).CornerRadius = UDim.new(0, 7)
    return box
end

local function makeButton(text, y, callback)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, -24, 0, 30)
    b.Position = UDim2.fromOffset(12, y)
    b.BackgroundColor3 = Color3.fromRGB(48,112,205)
    b.TextColor3 = Color3.new(1,1,1)
    b.Text = text
    b.Font = Enum.Font.GothamBold
    b.TextSize = 12
    b.Parent = panel
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 7)
    b.MouseButton1Click:Connect(callback)
    return b
end

makeLabel("RIDDLE / CLUE (paste Sammy's text)", 45)
local riddleBox = makeBox("Paste the riddle or clue here...", 67, 58)

makeLabel("ANALYSIS", 132)
local result = makeBox("Your notes and possible answer will appear here.", 154, 54)
result.TextEditable = false

makeButton("CHECK CLUE WORDS", 214, function()
    local s = string.lower(riddleBox.Text)
    if s:gsub("%s", "") == "" then
        result.Text = "Paste the riddle first."
        return
    end
    local words = {}
    for word in s:gmatch("[%w']+") do
        if #word >= 4 then table.insert(words, word) end
    end
    local seen, unique = {}, {}
    for _, word in ipairs(words) do
        if not seen[word] then
            seen[word] = true
            table.insert(unique, word)
        end
    end
    result.Text = "Important clue words:\n" .. table.concat(unique, ", ")
        .. "\n\nThis is a clue extractor, not a guaranteed riddle answer."
end)

makeLabel("REDEEM CODE (manual helper)", 250)
local codeBox = makeBox("Paste the code announced by Sammy...", 272, 28)
codeBox.TextYAlignment = Enum.TextYAlignment.Center

makeButton("SHOW CODE", 305, function()
    result.Text = "Code to enter in the game's official Codes menu:\n" .. codeBox.Text
end)

-- Drag the panel using its header.
local dragging, dragStart, startPos
header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = panel.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        panel.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
