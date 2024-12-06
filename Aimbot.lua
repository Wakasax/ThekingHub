local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local camera = workspace.CurrentCamera

-- Cria um GUI para exibir o nome
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = player:WaitForChild("PlayerGui")

local nameLabel = Instance.new("TextLabel")
nameLabel.Size = UDim2.new(0, 200, 0, 50) -- Tamanho do label
nameLabel.Position = UDim2.new(0.5, -100, 0, 10) -- Centralizado na parte superior
nameLabel.Text = "TheKing"
nameLabel.TextColor3 = Color3.new(1, 1, 1) -- Cor do texto
nameLabel.BackgroundTransparency = 1 -- Transparente
nameLabel.TextScaled = true -- Escala o texto
nameLabel.Parent = screenGui

local aimbotEnabled = true -- Ativar/desativar aimbot
local aimbotSensitivity = 0.1 -- Sensibilidade do aimbot

function findClosestEnemy()
    local closestEnemy
    local closestDistance = math.huge

    for _, v in pairs(game.Players:GetPlayers()) do
        if v ~= player and v.Character and v.Character:FindFirstChild("Humanoid") and v.Character:FindFirstChild("HumanoidRootPart") then
            local distance = (character.HumanoidRootPart.Position - v.Character.HumanoidRootPart.Position).Magnitude
            if distance < closestDistance then
                closestEnemy = v
                closestDistance = distance
            end
        end
    end

    return closestEnemy
end

-- Cria um marcador
local marker = Instance.new("Part")
marker.Parent = workspace
marker.CanCollide = false
marker.Transparency = 0.5
marker.Size = Vector3.new(0.1, 0.1, 0.1)
marker.Color = Color3.new(1, 0, 0)
marker.Anchored = true

-- Função para ajustar a mira
function aimAtEnemy(enemy)
    if enemy and enemy.Character and enemy.Character:FindFirstChild("HumanoidRootPart") then
        local enemyPosition = enemy.Character.HumanoidRootPart.Position
        local direction = (enemyPosition - camera.CFrame.Position).unit
        local newCFrame = CFrame.new(camera.CFrame.Position, enemyPosition)
        camera.CFrame = camera.CFrame:Lerp(newCFrame, aimbotSensitivity)
    end
end

-- Atalhos de teclado para ativar/desativar o aimbot
game:GetService("User InputService").InputBegan:Connect(function(input, gameProcessed)
    if input.KeyCode == Enum.KeyCode.F then -- Pressione F para ativar/desativar o aimbot
        aimbotEnabled = not aimbotEnabled
    end
end)

while true do
    if aimbotEnabled then
        local enemy = findClosestEnemy()
        if enemy then
            marker.Visible = true
            marker.Position = character.HumanoidRootPart.Position + (enemy.Character.HumanoidRootPart.Position - character.HumanoidRootPart.Position).Unit * 5
            aimAtEnemy(enemy)
        else
            marker.Visible = false
        end
    else
        marker.Visible = false
    end
    wait(0.1) -- Atraso para melhorar o desempenho
end
