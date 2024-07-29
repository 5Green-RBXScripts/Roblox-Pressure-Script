local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local ESPEnabled = false

local highlights = {}  -- Table to store highlight instances

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
        highlights[player.UserId] = highlight  -- Store the highlight in the table

        player.CharacterAdded:Connect(function(newCharacter)
            highlight:Destroy()
            highlights[player.UserId] = createHighlight(newCharacter)  -- Update the stored highlight
        end)
    end
end

local function unloadESP(player)
    if player ~= LocalPlayer then
        local highlight = highlights[player.UserId]
        if highlight then
            highlight:Destroy()  -- Destroy the highlight if it exists
            highlights[player.UserId] = nil  -- Remove from the table
        end
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

        -- Clear highlights for all players
        for _, highlight in pairs(highlights) do
            if highlight then
                highlight:Destroy()
            end
        end
        highlights = {}  -- Clear the highlights table
    end
end

toggleESP(false) -- Start with ESP disabled, or set to true if you want it on by default.

-- Example of connecting to a toggle button:
-- ToggleButton:OnChanged(function(value)
--     toggleESP(value)
-- end)
