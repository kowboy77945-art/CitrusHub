local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "CITRUS HUB 🍋 | ELITE",
   LoadingTitle = "Загрузка системы боя...",
   LoadingSubtitle = "by Citrus",
   KeySystem = true,
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

local Config = {
    Aimbot = false,
    SilentAim = false,
    ShowFov = true,
    FovRadius = 150,
    FovColor = Color3.fromRGB(255, 255, 0)
}

-- Создание круга FOV
local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 2
FOVCircle.NumSides = 460
FOVCircle.Filled = false
FOVCircle.Transparency = 0.7
FOVCircle.Visible = Config.ShowFov
FOVCircle.Radius = Config.FovRadius
FOVCircle.Color = Config.FovColor

-- Обновление круга каждый кадр
game:GetService("RunService").RenderStepped:Connect(function()
    FOVCircle.Position = Vector2.new(Mouse.X, Mouse.Y + 36)
    FOVCircle.Radius = Config.FovRadius
    FOVCircle.Visible = Config.ShowFov
end)

-- Функция поиска ближайшей цели в FOV
local function GetClosestTarget()
    local target = nil
    local dist = Config.FovRadius

    for _, v in pairs(game.Players:GetPlayers()) do
        if v ~= Player and v.Character and v.Character:FindFirstChild("HumanoidRootPart") and v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid.Health > 0 then
            local pos, onScreen = Camera:WorldToViewportPoint(v.Character.HumanoidRootPart.Position)
            if onScreen then
                local mouseDist = (Vector2.new(pos.X, pos.Y) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude
                if mouseDist < dist then
                    target = v
                    dist = mouseDist
                end
            end
        end
    end
    return target
end

-- ВКЛАДКА БОЙ
local CombatTab = Window:CreateTab("Бой (Combat)", 4483362458)

CombatTab:CreateToggle({
   Name = "Aimbot (Поворот камеры)",
   CurrentValue = false,
   Callback = function(Value)
      Config.Aimbot = Value
      task.spawn(function()
          while Config.Aimbot do
              local target = GetClosestTarget()
              if target then
                  Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Character.Head.Position)
              end
              task.wait()
          end
      end)
   end,
})

CombatTab:CreateSection("Silent Aim")

CombatTab:CreateToggle({
   Name = "Silent Aim (Магнит пуль)",
   CurrentValue = false,
   Callback = function(Value)
      Config.SilentAim = Value
      -- Логика Silent Aim (наведение в момент "выстрела" или фокуса)
      task.spawn(function()
          while Config.SilentAim do
              local target = GetClosestTarget()
              if target and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
                  -- Направляем камеру только в момент клика/зажима для точности попадания
                  Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Character.HumanoidRootPart.Position)
              end
              task.wait()
          end
      end)
   end,
})

CombatTab:CreateSlider({
   Name = "Радиус круга (FOV)",
   Range = {50, 800},
   Increment = 10,
   CurrentValue = 150,
   Callback = function(Value)
      Config.FovRadius = Value
   end,
})

CombatTab:CreateToggle({
   Name = "Показывать круг FOV",
   CurrentValue = true,
   Callback = function(Value)
      Config.ShowFov = Value
   end,
})

-- ВКЛАДКА ИГРОК (FLY)
local PlayerTab = Window:CreateTab("Игрок", 4483362458)

local Flying = false
local FlySpeed = 50
PlayerTab:CreateToggle({
   Name = "Стабильный Fly",
   CurrentValue = false,
   Callback = function(Value)
      Flying = Value
      local root = Player.Character:WaitForChild("HumanoidRootPart")
      if Flying then
          local bv = Instance.new("BodyVelocity", root)
          bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
          task.spawn(function()
              while Flying do
                  local hum = Player.Character:FindFirstChildOfClass("Humanoid")
                  bv.Velocity = Camera.CFrame.LookVector * (hum.MoveDirection.Magnitude > 0 and FlySpeed or 0)
                  -- Если не двигаемся - висим ровно
                  if hum.MoveDirection.Magnitude == 0 then bv.Velocity = Vector3.new(0,0.1,0) end
                  task.wait()
              end
              bv:Destroy()
          end)
      end
   end,
})

PlayerTab:CreateSlider({
   Name = "Скорость полета",
   Range = {16, 500},
   Increment = 10,
   CurrentValue = 50,
   Callback = function(Value) FlySpeed = Value end,
})

-- ВКЛАДКА ВИЗУАЛЫ
local VisualTab = Window:CreateTab("Визуалы", 4483362458)
VisualTab:CreateButton({
   Name = "ESP: Подсветка игроков",
   Callback = function()
      for _, v in pairs(game.Players:GetPlayers()) do
          if v ~= Player and v.Character then
              local h = v.Character:FindFirstChild("Highlight") or Instance.new("Highlight", v.Character)
              h.FillColor = Color3.fromRGB(255, 0, 0)
          end
      end
   end,
})

Rayfield:Notify({Title = "CITRUS HUB", Content = "Скрипт готов!", Duration = 5})
