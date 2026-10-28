-- BlockSpin Pro Hub - Ultimate Edition V7.2 (Advanced AutoFarm Engine)
if not game:IsLoaded() then game.Loaded:Wait() end

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

local GUI_Parent = gethui and gethui() or CoreGui

-- إزالة الواجهة القديمة
if GUI_Parent:FindFirstChild("BlockSpinProV7") then GUI_Parent.BlockSpinProV7:Destroy() end

-- إعدادات FOV
local SilentFOV_Radius, AimbotFOV_Radius = 100, 100
local silentFovCircle = Drawing.new("Circle")
silentFovCircle.Visible = false; silentFovCircle.Radius = SilentFOV_Radius; silentFovCircle.Filled = false
silentFovCircle.Color = Color3.fromRGB(255, 69, 0); silentFovCircle.Thickness = 1.5; silentFovCircle.Transparency = 0.7

local aimbotFovCircle = Drawing.new("Circle")
aimbotFovCircle.Visible = false; aimbotFovCircle.Radius = AimbotFOV_Radius; aimbotFovCircle.Filled = false
aimbotFovCircle.Color = Color3.fromRGB(0, 191, 255); aimbotFovCircle.Thickness = 1.5; aimbotFovCircle.Transparency = 0.7

-- بناء الواجهة (نفس هيكلك السابق)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BlockSpinProV7"
ScreenGui.Parent = GUI_Parent
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.ResetOnSpawn = false

local FloatingIcon = Instance.new("TextButton")
FloatingIcon.Parent = ScreenGui
FloatingIcon.BackgroundColor3 = Color3.fromRGB(15, 15, 22)
FloatingIcon.Position = UDim2.new(0, 35, 0, 150)
FloatingIcon.Size = UDim2.new(0, 54, 0, 54)
FloatingIcon.Font = Enum.Font.SourceSansBold
FloatingIcon.Text = "🛡️"
FloatingIcon.TextColor3 = Color3.fromRGB(255, 69, 0)
FloatingIcon.TextSize = 26
local IconCorner = Instance.new("UICorner"); IconCorner.CornerRadius = UDim.new(1, 0); IconCorner.Parent = FloatingIcon
local IconStroke = Instance.new("UIStroke"); IconStroke.Color = Color3.fromRGB(255, 69, 0); IconStroke.Thickness = 2.5; IconStroke.Parent = FloatingIcon

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 25)
MainFrame.Position = UDim2.new(0.5, -210, 0.5, -220)
MainFrame.Size = UDim2.new(0, 420, 0, 440)
MainFrame.Visible = false
local MainCorner = Instance.new("UICorner"); MainCorner.CornerRadius = UDim.new(0, 16); MainCorner.Parent = MainFrame
local MainStroke = Instance.new("UIStroke"); MainStroke.Color = Color3.fromRGB(255, 69, 0); MainStroke.Thickness = 2; MainStroke.Parent = MainFrame

local TopBar = Instance.new("Frame")
TopBar.Parent = MainFrame
TopBar.BackgroundColor3 = Color3.fromRGB(24, 24, 35)
TopBar.Size = UDim2.new(1, 0, 0, 48)
local TopCorner = Instance.new("UICorner"); TopCorner.CornerRadius = UDim.new(0, 16); TopCorner.Parent = TopBar

local Title = Instance.new("TextLabel")
Title.Parent = TopBar
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0, 18, 0, 0)
Title.Size = UDim2.new(0.7, 0, 1, 0)
Title.Font = Enum.Font.SourceSansBold
Title.Text = "BLOCKSPIN | Pro Hub V7.2"
Title.TextColor3 = Color3.fromRGB(255, 69, 0)
Title.TextSize = 16
Title.TextXAlignment = Enum.TextXAlignment.Left

local CloseXBtn = Instance.new("TextButton")
CloseXBtn.Parent = TopBar
CloseXBtn.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
CloseXBtn.Position = UDim2.new(1, -38, 0.5, -13)
CloseXBtn.Size = UDim2.new(0, 26, 0, 26)
CloseXBtn.Font = Enum.Font.SourceSansBold
CloseXBtn.Text = "X"
CloseXBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseXBtn.TextSize = 13
CloseXBtn.AutoButtonColor = false
local XCorner = Instance.new("UICorner"); XCorner.CornerRadius = UDim.new(1, 0); XCorner.Parent = CloseXBtn

local TabsBar = Instance.new("Frame")
TabsBar.Parent = MainFrame
TabsBar.BackgroundTransparency = 1
TabsBar.Position = UDim2.new(0, 10, 0, 55)
TabsBar.Size = UDim2.new(1, -20, 0, 35)
local TabsLayout = Instance.new("UIListLayout"); TabsLayout.Parent = TabsBar; TabsLayout.FillDirection = Enum.FillDirection.Horizontal; TabsLayout.SortOrder = Enum.SortOrder.LayoutOrder; TabsLayout.Padding = UDim.new(0, 6)

local ContentContainer = Instance.new("Frame")
ContentContainer.Parent = MainFrame
ContentContainer.BackgroundTransparency = 1
ContentContainer.Position = UDim2.new(0, 10, 0, 95)
ContentContainer.Size = UDim2.new(1, -20, 1, -105)

local tabs = {}
local function createTabContent(name)
    local scrolling = Instance.new("ScrollingFrame")
    scrolling.Name = name .. "Content"
    scrolling.Parent = ContentContainer
    scrolling.BackgroundTransparency = 1
    scrolling.Size = UDim2.new(1, 0, 1, 0)
    scrolling.CanvasSize = UDim2.new(0, 0, 0, 0)
    scrolling.ScrollBarThickness = 4
    scrolling.Visible = false
    local list = Instance.new("UIListLayout"); list.Parent = scrolling; list.HorizontalAlignment = Enum.HorizontalAlignment.Center; list.SortOrder = Enum.SortOrder.LayoutOrder; list.Padding = UDim.new(0, 8)
    list:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() scrolling.CanvasSize = UDim2.new(0, 0, 0, list.AbsoluteContentSize.Y + 15) end)
    return scrolling
end

local function createTabButton(name, iconText)
    local btn = Instance.new("TextButton")
    btn.Parent = TabsBar
    btn.BackgroundColor3 = Color3.fromRGB(26, 26, 36)
    btn.Size = UDim2.new(0, 92, 1, 0)
    btn.Font = Enum.Font.SourceSansBold
    btn.Text = iconText .. " " .. name
    btn.TextColor3 = Color3.fromRGB(180, 180, 180)
    btn.TextSize = 13
    btn.AutoButtonColor = false
    local corner = Instance.new("UICorner"); corner.CornerRadius = UDim.new(0, 8); corner.Parent = btn
    local stroke = Instance.new("UIStroke"); stroke.Color = Color3.fromRGB(45, 45, 60); stroke.Thickness = 1; stroke.Parent = btn
    local content = createTabContent(name)
    btn.Activated:Connect(function()
        for _, t in pairs(tabs) do
            t.content.Visible = false; t.btn.BackgroundColor3 = Color3.fromRGB(26, 26, 36); t.btn.TextColor3 = Color3.fromRGB(180, 180, 180); t.stroke.Color = Color3.fromRGB(45, 45, 60)
        end
        content.Visible = true; btn.BackgroundColor3 = Color3.fromRGB(35, 35, 50); btn.TextColor3 = Color3.fromRGB(255, 69, 0); stroke.Color = Color3.fromRGB(255, 69, 0)
    end)
    tabs[name] = {btn = btn, content = content, stroke = stroke}
    return content
end

local combatTab = createTabButton("Combat", "🎯")
local visualsTab = createTabButton("Visuals", "👁️")
local utilityTab = createTabButton("Utility", "📦")
local autofarmTab = createTabButton("AutoFarm", "🤖")

tabs["Combat"].content.Visible = true; tabs["Combat"].btn.BackgroundColor3 = Color3.fromRGB(35, 35, 50); tabs["Combat"].btn.TextColor3 = Color3.fromRGB(255, 69, 0); tabs["Combat"].stroke.Color = Color3.fromRGB(255, 69, 0)

local function createFeatureToggle(parentTab, name, desc, callback)
    local btn = Instance.new("TextButton")
    btn.Parent = parentTab
    btn.BackgroundColor3 = Color3.fromRGB(24, 24, 32)
    btn.Size = UDim2.new(0.98, 0, 0, 48)
    btn.Font = Enum.Font.SourceSansBold
    btn.Text = ""
    btn.AutoButtonColor = false
    local corner = Instance.new("UICorner"); corner.CornerRadius = UDim.new(0, 10); corner.Parent = btn
    local stroke = Instance.new("UIStroke"); stroke.Color = Color3.fromRGB(45, 45, 60); stroke.Thickness = 1.2; stroke.Parent = btn
    local nameLabel = Instance.new("TextLabel"); nameLabel.Parent = btn; nameLabel.BackgroundTransparency = 1; nameLabel.Position = UDim2.new(0, 14, 0, 8); nameLabel.Size = UDim2.new(0.7, 0, 0, 16); nameLabel.Font = Enum.Font.SourceSansBold; nameLabel.Text = name; nameLabel.TextColor3 = Color3.fromRGB(240, 240, 240); nameLabel.TextSize = 14; nameLabel.TextXAlignment = Enum.TextXAlignment.Left
    local descLabel = Instance.new("TextLabel"); descLabel.Parent = btn; descLabel.BackgroundTransparency = 1; descLabel.Position = UDim2.new(0, 14, 0, 24); descLabel.Size = UDim2.new(0.7, 0, 0, 16); descLabel.Font = Enum.Font.SourceSans; descLabel.Text = desc; descLabel.TextColor3 = Color3.fromRGB(140, 140, 140); descLabel.TextSize = 11; descLabel.TextXAlignment = Enum.TextXAlignment.Left
    local statusBox = Instance.new("Frame"); statusBox.Parent = btn; statusBox.BackgroundColor3 = Color3.fromRGB(50, 50, 65); statusBox.Position = UDim2.new(1, -38, 0.5, -12); statusBox.Size = UDim2.new(0, 24, 0, 24)
    local boxCorner = Instance.new("UICorner"); boxCorner.CornerRadius = UDim.new(0, 6); boxCorner.Parent = statusBox

    local state = false
    btn.Activated:Connect(function()
        state = not state
        if state then
            statusBox.BackgroundColor3 = Color3.fromRGB(255, 69, 0)
            stroke.Color = Color3.fromRGB(255, 69, 0)
        else
            statusBox.BackgroundColor3 = Color3.fromRGB(50, 50, 65)
            stroke.Color = Color3.fromRGB(45, 45, 60)
        end
        callback(state)
    end)
    return btn
end

-- المتغيرات
local silentEnabled, aimbotEnabled, espEnabled, autoLootEnabled = false, false, false, false
local autoChefEnabled, autoJanitorEnabled, autoGasEnabled, autoAtmEnabled = false, false, false, false

createFeatureToggle(combatTab, "Silent Aim", "تصويب صامت ذكي", function(enabled) silentEnabled = enabled; silentFovCircle.Visible = enabled end)
createFeatureToggle(combatTab, "Aimbot", "قفل الأيم داخل الدائرة", function(enabled) aimbotEnabled = enabled; aimbotFovCircle.Visible = enabled end)
createFeatureToggle(visualsTab, "Players ESP", "تلوين أجسام اللاعبين", function(enabled) espEnabled = enabled end)
createFeatureToggle(utilityTab, "Auto Loot", "التقاط الغنائم", function(enabled) autoLootEnabled = enabled end)
createFeatureToggle(autofarmTab, "Auto Chef Job", "الطباخ الآلي (مع الضغط المطول)", function(enabled) autoChefEnabled = enabled end)
createFeatureToggle(autofarmTab, "Auto Janitor Job", "المساح الآلي (أولوية الربح)", function(enabled) autoJanitorEnabled = enabled end)
createFeatureToggle(autofarmTab, "Auto Gas Station", "نقل الصناديق الآلي", function(enabled) autoGasEnabled = enabled end)
createFeatureToggle(autofarmTab, "Auto ATM Hack", "تهكير الصراف الآلي", function(enabled) autoAtmEnabled = enabled end)

-- الأيم بوت والسايلنت أيم (كما هي)
local currentLockedTarget = nil
local cachedSilentTarget = nil

local function getClosestSilentTarget()
    local closest = nil
    local shortest = silentFovCircle.Radius
    local mouse = UserInputService:GetMouseLocation()
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Humanoid") and p.Character.Humanoid.Health > 0 then
            local part = math.random(1, 10) <= 3 and p.Character:FindFirstChild("Head") or p.Character:FindFirstChild("HumanoidRootPart")
            if part then
                local pos, onScreen = Camera:WorldToViewportPoint(part.Position)
                if onScreen then
                    local dist = (Vector2.new(pos.X, pos.Y) - mouse).Magnitude
                    if dist < shortest then shortest = dist; closest = part end
                end
            end
        end
    end
    return closest
end

local function getClosestAimbotTarget()
    local camCenter = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    if currentLockedTarget and currentLockedTarget.Parent and currentLockedTarget.Parent:FindFirstChild("Humanoid") and currentLockedTarget.Parent.Humanoid.Health > 0 then
        local pos, onScreen = Camera:WorldToViewportPoint(currentLockedTarget.Position)
        if onScreen and (Vector2.new(pos.X, pos.Y) - camCenter).Magnitude <= aimbotFovCircle.Radius * 1.3 then return currentLockedTarget end
    end
    local closest = nil
    local shortest = aimbotFovCircle.Radius
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Humanoid") and p.Character.Humanoid.Health > 0 then
            local part = p.Character:FindFirstChild("HumanoidRootPart")
            if part then
                local pos, onScreen = Camera:WorldToViewportPoint(part.Position)
                if onScreen then
                    local dist = (Vector2.new(pos.X, pos.Y) - camCenter).Magnitude
                    if dist < shortest then shortest = dist; closest = part end
                end
            end
        end
    end
    currentLockedTarget = closest
    return currentLockedTarget
end

local oldNamecall
oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
    local method = getnamecallmethod()
    if silentEnabled and not checkcaller() and (method == "Raycast" or method == "FindPartOnRay") and self == Workspace then
        if cachedSilentTarget and cachedSilentTarget.Parent then
            local args = {...}
            pcall(function()
                if method == "Raycast" and typeof(args[1]) == "Vector3" and typeof(args[2]) == "Vector3" then
                    args[2] = (cachedSilentTarget.Position - args[1]).Unit * args[2].Magnitude
                elseif method == "FindPartOnRay" and typeof(args[1]) == "Ray" then
                    args[1] = Ray.new(args[1].Origin, (cachedSilentTarget.Position - args[1].Origin).Unit * args[1].Direction.Magnitude)
                end
            end)
            return oldNamecall(self, unpack(args))
        end
    end
    return oldNamecall(self, ...)
end)

RunService.RenderStepped:Connect(function()
    local camCenter = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    silentFovCircle.Position = camCenter
    aimbotFovCircle.Position = camCenter
    if silentEnabled then cachedSilentTarget = getClosestSilentTarget() else cachedSilentTarget = nil end
    if aimbotEnabled then
        pcall(function()
            local targetPart = getClosestAimbotTarget()
            if targetPart then Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, targetPart.Position), 0.35) else currentLockedTarget = nil end
        end)
    end
end)

-- نظام Auto Loot المدرع (كما هو)
local activeDrops = {}
local collectedParts = {}

Workspace.DescendantAdded:Connect(function(obj)
    if obj:IsA("BasePart") then
        task.delay(0.1, function()
            if obj and obj.Parent and obj:FindFirstChild("TouchInterest") then activeDrops[obj] = true end
        end)
    end
end)
Workspace.DescendantRemoving:Connect(function(obj) if activeDrops[obj] then activeDrops[obj] = nil; collectedParts[obj] = nil end end)
task.spawn(function()
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") and obj:FindFirstChild("TouchInterest") then activeDrops[obj] = true end
    end
end)

local function collectLoot()
    local char = LocalPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    for obj, _ in pairs(activeDrops) do
        if obj and obj.Parent and obj:FindFirstChild("TouchInterest") then
            local pName = obj.Parent.Name:lower()
            local oName = obj.Name:lower()
            if not (pName:find("shop") or pName:find("pawn") or pName:find("sell") or pName:find("market") or pName:find("npc") or pName:find("trade") or pName:find("register") or oName:find("shop") or oName:find("pawn") or oName:find("sell") or oName:find("market") or oName:find("npc") or oName:find("trade") or oName:find("register")) then
                local distance = (hrp.Position - obj.Position).Magnitude
                if distance <= 8 and not collectedParts[obj] then
                    collectedParts[obj] = true
                    pcall(function()
                        firetouchinterest(hrp, obj, 0)
                        task.wait()
                        firetouchinterest(hrp, obj, 1)
                    end)
                    task.delay(2, function() collectedParts[obj] = nil end)
                end
            end
        else
            activeDrops[obj] = nil
        end
    end
end

task.spawn(function()
    while task.wait(0.4) do
        if autoLootEnabled then pcall(collectLoot) end
    end
end)

-- نظام ESP (كما هو)
local activeHighlights = {}
local function applyHighlight(char)
    if char and not char:FindFirstChild("BlockSpinHighlight") then
        local hl = Instance.new("Highlight")
        hl.Name = "BlockSpinHighlight"
        hl.Adornee = char
        hl.FillColor = Color3.fromRGB(255, 69, 0)
        hl.OutlineColor = Color3.fromRGB(255, 255, 255)
        hl.FillTransparency = 0.4
        hl.Parent = char
        table.insert(activeHighlights, hl)
    end
end
RunService.RenderStepped:Connect(function()
    if espEnabled then
        for _, p in ipairs(Players:GetPlayers()) do if p ~= LocalPlayer and p.Character then applyHighlight(p.Character) end end
    else
        for _, hl in ipairs(activeHighlights) do if hl then hl:Destroy() end end
        activeHighlights = {}
    end
end)

-- ==========================================
-- 🚀 محرك الأوتوفارم المتقدم (V7.2)
-- ==========================================

local function moveTo(targetPos)
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("Humanoid") then
        char.Humanoid:MoveTo(targetPos)
        -- ننتظر حتى نصل أو تنتهي المهلة
        local distance = (char.HumanoidRootPart.Position - targetPos).Magnitude
        local timeout = tick() + (distance / 16) + 2
        while tick() < timeout do
            distance = (char.HumanoidRootPart.Position - targetPos).Magnitude
            if distance < 5 then break end
            task.wait(0.1)
        end
    end
end

local function getClosestPromptByKeywords(keywords, maxDist)
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return nil end
    local hrp = char.HumanoidRootPart
    local closest, shortest = nil, maxDist or 50
    
    local params = OverlapParams.new()
    params.FilterDescendantsInstances = {char}
    params.FilterType = Enum.RaycastFilterType.Exclude
    
    local partsNear = Workspace:GetPartBoundsInRadius(hrp.Position, shortest, params)
    for _, part in pairs(partsNear) do
        local prompt = part:FindFirstChildOfClass("ProximityPrompt")
        if prompt then
            local searchStr = (part.Name .. " " .. prompt.ActionText .. " " .. prompt.ObjectText):lower()
            local matches = false
            for _, kw in ipairs(keywords) do
                if searchStr:find(kw) then matches = true; break end
            end
            if matches then
                local dist = (hrp.Position - part.Position).Magnitude
                if dist < shortest then
                    shortest = dist
                    closest = {prompt = prompt, part = part}
                end
            end
        end
    end
    return closest, shortest
end

-- متغيرات الحالة للفارم
local isHackingAtm, isCooking, isCleaning, isGasWorking = false, false, false, false

task.spawn(function()
    while task.wait(1) do
        local char = LocalPlayer.Character
        if not char or not char:FindFirstChild("Humanoid") or char.Humanoid.Health <= 0 then continue end

        -- 1. الطباخ الآلي (Auto Chef)
        if autoChefEnabled and not isCooking then
            local promptData, dist = getClosestPromptByKeywords({"cook", "meat", "steak", "grill", "patty", "order", "serve"}, 40)
            if promptData then
                if dist > 6 then
                    moveTo(promptData.part.Position)
                else
                    isCooking = true
                    task.spawn(function()
                        -- الضغط المطول (Hold)
                        promptData.prompt:InputHoldBegin()
                        task.wait(promptData.prompt.HoldDuration + 0.1)
                        promptData.prompt:InputHoldEnd()
                        task.wait(2.5) -- انتظار انتهاء دورة الطبخ
                        isCooking = false
                    end)
                end
            end
        end

        -- 2. المساح الآلي (Auto Janitor) - مع أولوية الربح
        if autoJanitorEnabled and not isCleaning then
            -- نبحث عن بقع الماء (Puddles)
            local puddles = {}
            local params = OverlapParams.new()
            params.FilterDescendantsInstances = {char}
            params.FilterType = Enum.RaycastFilterType.Exclude
            
            for _, obj in pairs(Workspace:GetDescendants()) do
                if obj:IsA("BasePart") and (obj.Name:lower():find("puddle") or obj.Name:lower():find("spill") or obj.Name:lower():find("water")) then
                    table.insert(puddles, obj)
                end
            end
            
            if #puddles > 0 then
                -- ترتيب البقع حسب قيمة الربح (إذا كان موجوداً في الخصائص، وإلا نأخذ الأقرب)
                table.sort(puddles, function(a, b)
                    local aVal = a:GetAttribute("CashValue") or a:GetAttribute("Reward") or 0
                    local bVal = b:GetAttribute("CashValue") or b:GetAttribute("Reward") or 0
                    return aVal > bVal
                end)
                
                local targetPuddle = puddles[1]
                local dist = (char.HumanoidRootPart.Position - targetPuddle.Position).Magnitude
                
                if dist > 5 then
                    moveTo(targetPuddle.Position)
                else
                    isCleaning = true
                    task.spawn(function()
                        -- التنظيف يحتاج وقوف فوق البقعة فقط (بدون ضغط مطول)
                        task.wait(3) -- ننتظر 3 ثواني حتى تختفي البقعة
                        isCleaning = false
                    end)
                end
            end
        end

        -- 3. محطة الوقود (Auto Gas Station)
        if autoGasEnabled and not isGasWorking then
            -- البحث عن الصناديق
            local boxPrompt, dist = getClosestPromptByKeywords({"box", "crate", "package", "gas", "deliver"}, 50)
            if boxPrompt then
                if dist > 5 then
                    moveTo(boxPrompt.part.Position)
                else
                    isGasWorking = true
                    task.spawn(function()
                        boxPrompt.prompt:InputHoldBegin()
                        task.wait(boxPrompt.prompt.HoldDuration)
                        boxPrompt.prompt:InputHoldEnd()
                        task.wait(3) -- وقت حمل الصندوق
                        isGasWorking = false
                    end)
                end
            end
        end

        -- 4. تهكير الصراف الآلي (Auto ATM Hack) - مع الضغط المطول
        if autoAtmEnabled and not isHackingAtm then
            local atmData, dist = getClosestPromptByKeywords({"atm", "hack", "swipe", "bank"}, 35)
            if atmData then
                if dist > 5 then
                    moveTo(atmData.part.Position)
                else
                    isHackingAtm = true
                    task.spawn(function()
                        atmData.prompt:InputHoldBegin()
                        task.wait(atmData.prompt.HoldDuration + 0.1)
                        atmData.prompt:InputHoldEnd()
                        task.wait(1.5) -- انتظار انتهاء الاختراق
                        isHackingAtm = false
                    end)
                end
            end
        end
    end
end)

-- تحريك الأيقونة وإغلاق القائمة
local dragging, dragStart, startPos
FloatingIcon.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = true; dragStart = input.Position; startPos = FloatingIcon.Position end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        FloatingIcon.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end
end)

local function toggleMenu() MainFrame.Visible = not MainFrame.Visible end
FloatingIcon.Activated:Connect(toggleMenu)
CloseXBtn.Activated:Connect(toggleMenu)

print("BlockSpin Pro Hub V7.2 - Advanced AutoFarm Engine Loaded!")
