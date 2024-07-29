local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local ESPEnabled = false
local highlights = {} -- Table to keep track of highlights

local function createHighlight(character)
    local highlight = Instance.new("Highlight")
    highlight.Adornee = character
    highlight.FillColor = Color3.new(1, 0, 0) -- Change color as needed
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
            -- Remove old highlight if exists
            if highlights[player.UserId] then
                highlights[player.UserId]:Destroy()
            end
            highlight = createHighlight(newCharacter)
            highlights[player.UserId] = highlight
        end)
    end
end

local function unloadESP(player)
    if player ~= LocalPlayer then
        if highlights[player.UserId] then
            highlights[player.UserId]:Destroy()
            highlights[player.UserId] = nil
        end
    end
end

local function toggleESP(enabled)
    ESPEnabled = enabled
    if enabled then
        for _, player in ipairs(Players:GetPlayers()) do
            loadESP(player)
        end

        Players.PlayerAdded:Connect(function(player)
            if ESPEnabled then
                loadESP(player)
            end
        end)

        Players.PlayerRemoving:Connect(function(player)
            unloadESP(player)
        end)
    else
        for _, player in ipairs(Players:GetPlayers()) do
            unloadESP(player)
        end
    end
end

toggleESP(false) -- Set to false initially

-- Example of connecting to a toggle button:
-- ToggleButton:OnChanged(function(value)
--     toggleESP(value)
-- end)
