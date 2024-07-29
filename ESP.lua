local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local highlights = {}

local function createHighlight(character)
    local highlight = Instance.new("Highlight")
    highlight.Adornee = character
    highlight.FillColor = Color3.new(0.3, 0.5, 0.3) -- Change color as needed
    highlight.FillTransparency = 0.5
    highlight.OutlineColor = Color3.new01, 1, 0)
    highlight.OutlineTransparency = 0.5
    highlight.Parent = character
    return highlight
end

local function loadESP(player)
    if player ~= LocalPlayer then
        player.CharacterAdded:Connect(function(character)
            character:WaitForChild("Humanoid", 5) -- Wait for humanoid
            createHighlight(character)
        end)

        -- Check if character already exists and apply highlight
        if player.Character then
            createHighlight(player.Character)
        end
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

return {
    toggleESP = toggleESP
}
