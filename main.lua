local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "CITRUS HUB 🍋 | FINAL ELITE",
   LoadingTitle = "Загрузка чита...",
   LoadingSubtitle = "by Citrus",
   KeySystem = false,
   KeySettings = {
      Title = "CITRUS HUB",
      Subtitle = "Авторизация",
      Note = "Ключ: chub7dayfree",
      FileName = "CitrusKey",
      SaveKey = true,
      Key = {"chub7dayfree"}
   }
})

-- Переменные
local Player = game.Players.LocalPlayer
local Camera = workspace.CurrentCamera
local Mouse = Player:GetMouse()
local UserInputService = game:GetService("UserInputService")

local Config = {
    SilentAim = false,
    SilentRadius = 300,
    FlySpeed = 50,
    Flying = false,
    InfJump = false
}

-- Функция поиска цели (самый стабильный метод)
local function GetTarget()
    local closestTarget = nil
    local maxDist = Config.SilentRadius

    for _, v in pairs(game.Players:GetPlayers()) do
        if v ~= Player and v.Character and v.Character:FindFirstChild("HumanoidRootPart") and v.Character.Humanoid.Health > 0 then
            local pos, onScreen = Camera:WorldToViewportPoint(v.Character.HumanoidRootPart.Position)
            if onScreen then
                local distance = (Vector2.new(pos.X, pos.Y) - UserInputService:GetMouseLocation()).Magnitude
                if distance < maxDist then
                    closestTarget = v
                    maxDist = distance
                end
            end
        end
    end
    return closestTarget
end

-- ВКЛАДКА COMBAT (БОЙ)
local CombatTab = Window:CreateTab("Бой", 4483362458)

CombatTab:CreateToggle({
   Name = "Silent Aim (Попадание рядом)",
   CurrentValue = false,
   Callback = function(Value)
      Config.SilentAim = Value
      
      -- Основной цикл Сайлент Аима
      task.spawn(function()
          while Config.SilentAim do
              -- Если игрок нажимает на экран (стреляет)
              if UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
                  local target = GetTarget()
                  if target then
                      -- Направляем "невидимый" луч в голову противника
                      local aimPart = target.Character:FindFirstChild("Head") or target.Character.HumanoidRootPart
                      -- Микро-коррекция для регистрации урона игрой
                      Camera.CFrame = CFrame.new(Camera.CFrame.Position, aimPart.Position)
                  end
              end
              task.wait(0.02) -- Оптимальная задержка, чтобы не лагало и не блокировало кнопку
          end
      end)
   end,
})

CombatTab:CreateSlider({
   Name = "Радиус захвата (Silent FOV)",
   Range = {50, 1000},
   Increment = 10,
   CurrentValue = 300,
   Callback = function(v) Config.SilentRadius = v end,
})

-- ВКЛАДКА ДВИЖЕНИЕ
local PlayerTab = Window:CreateTab("Игрок", 4483362458)

PlayerTab:CreateToggle({
   Name = "Fly (Полет по камере)",
   CurrentValue = false,
   Callback = function(Value)
      Config.Flying = Value
      local char = Player.Character
      local root = char:WaitForChild("HumanoidRootPart")
      
      if Config.Flying then
          local bv = Instance.new("BodyVelocity", root)
          bv.Name = "CitrusFlyFinal"
          bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
          
          task.spawn(function()
              while Config.Flying do
                  local hum = char:FindFirstChildOfClass("Humanoid")
                  if hum and hum.MoveDirection.Magnitude > 0 then
                      -- Летит туда, куда смотришь
                      bv.Velocity = Camera.CFrame:VectorToWorldSpace(Vector3.new(hum.MoveDirection.X, 0, hum.MoveDirection.Z)).Unit * Config.FlySpeed
                      bv.Velocity = bv.Velocity + Vector3.new(0, Camera.CFrame.LookVector.Y * Config.FlySpeed, 0)
                  else
                      bv.Velocity = Vector3.new(0, 0, 0)
                  end
                  task.wait()
              end
              bv:Destroy()
          end)
      end
   end,
})

PlayerTab:CreateSlider({
   Name = "Скорость (Speed)",
   Range = {16, 500},
   Increment = 5,
   CurrentValue = 16,
   Callback = function(v) 
      Config.FlySpeed = v 
      if Player.Character:FindFirstChild("Humanoid") then Player.Character.Humanoid.WalkSpeed = v end
   end,
})

PlayerTab:CreateToggle({
   Name = "Infinity Jump",
   CurrentValue = false,
   Callback = function(v) Config.InfJump = v end,
})

UserInputService.JumpRequest:Connect(function()
    if Config.InfJump then Player.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping") end
end)

-- ВКЛАДКА ВИЗУАЛЫ
local VisualTab = Window:CreateTab("Визуалы", 4483362458)

VisualTab:CreateButton({
   Name = "ESP (Подсветка игроков)",
   Callback = function()
      for _, v in pairs(game.Players:GetPlayers()) do
          if v ~= Player and v.Character then
              local h = v.Character:FindFirstChild("Highlight") or Instance.new("Highlight", v.Character)
              h.FillColor = Color3.fromRGB(255, 0, 0)
              h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
          end
      end
   end,
})

Rayfield:Notify({Title = "CITRUS HUB", Content = "Всё готово! Приятной игры!", Duration = 5})
