local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local highlights = {}

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
    else
        for _, player in ipairs(Players:GetPlayers()) do
            unloadESP(player)
        end
    end
end

-- Usage example: Call this function to toggle the ESP on or off.
toggleESP(true) -- Set to false if you want it off by default.

-- Make sure to include the toggle handling in your main UI script.
