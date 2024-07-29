local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local ESPEnabled = false
local highlights = {}

local function createHighlight(character)
    local highlight = Instance.new("Highlight")
    highlight.Adornee = character
    highlight.FillColor = Color3.new(0.3, 0.5, 0.3) -- Change color as needed
    highlight.FillTransparency = 0.5
    highlight.OutlineColor = Color3.new(0, 1, 0)
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
    if enabled then
        for _, player in ipairs(Players:GetPlayers()) do
            loadESP(player)
        end

        Players.PlayerAdded:Connect(loadESP)
        Players.PlayerRemoving:Connect(unloadESP)

        ESPEnabled = true
    else
        for _, player in ipairs(Players:GetPlayers()) do
            unloadESP(player)
        end

        ESPEnabled = false
    end
end

-- Call this function to toggle the ESP on or off as needed.
toggleESP(false) -- Set to false to turn it off by default.
