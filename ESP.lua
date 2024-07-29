local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local ESPEnabled = false
local highlights = {}

local function createHighlight(character)
    local highlight = Instance.new("Highlight")
    highlight.Adornee = character
    highlight.FillColor = Color3.new(1, 0, 0) -- Change the color as needed
    highlight.FillTransparency = 0.5
    highlight.OutlineColor = Color3.new(1, 1, 1)
    highlight.OutlineTransparency = 0.5
    highlight.Parent = character
    return highlight
end

local function loadESP(player)
    if player ~= LocalPlayer then
        local character = player.Character or player.CharacterAdded:Wait()
        local highlight = createHighlight(character)
        highlights[player.UserId] = highlight

        player.CharacterAdded:Connect(function(newCharacter)
            if highlights[player.UserId] then
                highlights[player.UserId]:Destroy()
            end
            highlights[player.UserId] = createHighlight(newCharacter)
        end)
    end
end

local function unloadESP(player)
    if player ~= LocalPlayer and highlights[player.UserId] then
        highlights[player.UserId]:Destroy()
        highlights[player.UserId] = nil
    end
end

local function toggleESP(enabled)
    ESPEnabled = enabled
    if enabled then
        for _, player in ipairs(Players:GetPlayers()) do
            loadESP(player)
        end

        Players.PlayerAdded:Connect(loadESP)
        Players.PlayerRemoving:Connect(unloadESP)
    else
        for _, player in ipairs(Players:GetPlayers()) do
            unloadESP(player)
        end
    end
end

toggleESP(false) -- Start with ESP disabled.

-- Example of connecting to a toggle button:
-- ToggleButton:OnChanged(function(value)
--     toggleESP(value)
-- end)
