local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "CITRUS HUB 🍋 | ELITE V3",
   LoadingTitle = "Запуск системы CITRUS...",
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

-- Настройки
local Player = game.Players.LocalPlayer
local Camera = workspace.CurrentCamera
local Mouse = Player:GetMouse()
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local Config = {
    SilentAim = false,
    Aimbot = false,
    FovRadius = 150,
    ShowFov = true,
    FlySpeed = 50,
    Flying = false
}

-- Создание круга FOV (Исправленный метод для DeltaX)
local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 2
FOVCircle.NumSides = 60
FOVCircle.Filled = false
FOVCircle.Transparency = 1
FOVCircle.Color = Color3.fromRGB(255, 255, 0)

RunService.RenderStepped:Connect(function()
    FOVCircle.Visible = Config.ShowFov
    FOVCircle.Radius = Config.FovRadius
    FOVCircle.Position = Vector2.new(UserInputService:GetMouseLocation().X, UserInputService:GetMouseLocation().Y)
end)

-- Функция поиска цели
local function GetClosestTarget()
    local target = nil
    local dist = Config.FovRadius

    for _, v in pairs(game.Players:GetPlayers()) do
        if v ~= Player and v.Character and v.Character:FindFirstChild("HumanoidRootPart") and v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid.Health > 0 then
            local pos, onScreen = Camera:WorldToViewportPoint(v.Character.HumanoidRootPart.Position)
            if onScreen then
                local mousePos = UserInputService:GetMouseLocation()
                local mag = (Vector2.new(pos.X, pos.Y) - mousePos).Magnitude
                if mag < dist then
                    target = v
                    dist = mag
                end
            end
        end
    end
    return target
end

-- ВКЛАДКА COMBAT
local CombatTab = Window:CreateTab("Бой", 4483362458)

CombatTab:CreateToggle({
   Name = "Silent Aim (Магнит попаданий)",
   CurrentValue = false,
   Callback = function(Value)
      Config.SilentAim = Value
      task.spawn(function()
          while Config.SilentAim do
              if UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
                  local target = GetClosestTarget()
                  if target then
                      -- Мгновенная микро-коррекция для попадания
                      local aimPart = target.Character:FindFirstChild("Head") or target.Character.HumanoidRootPart
                      Camera.CFrame = CFrame.new(Camera.CFrame.Position, aimPart.Position)
                  end
              end
              task.wait(0.01)
          end
      end)
   end,
})

CombatTab:CreateSlider({
   Name = "Радиус Silent FOV",
   Range = {50, 800},
   Increment = 10,
   CurrentValue = 150,
   Callback = function(v) Config.FovRadius = v end,
})

CombatTab:CreateToggle({
   Name = "Показывать Круг",
   CurrentValue = true,
   Callback = function(v) Config.ShowFov = v end,
})

-- ВКЛАДКА PLAYER (FLY)
local PlayerTab = Window:CreateTab("Игрок", 4483362458)

PlayerTab:CreateToggle({
   Name = "Улучшенный Fly",
   CurrentValue = false,
   Callback = function(Value)
      Config.Flying = Value
      local root = Player.Character:WaitForChild("HumanoidRootPart")
      if Config.Flying then
          local bv = Instance.new("BodyVelocity", root)
          bv.Name = "CitrusStableFly"
          bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
          
          task.spawn(function()
              while Config.Flying do
                  local hum = Player.Character:FindFirstChildOfClass("Humanoid")
                  local dir = hum.MoveDirection
                  if dir.Magnitude > 0 then
                      bv.Velocity = Camera.CFrame:VectorToWorldSpace(Vector3.new(dir.X, 0, dir.Z)).Unit * Config.FlySpeed
                      -- Добавляем подъем/спуск по взгляду камеры
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
   Name = "Скорость Полета",
   Range = {16, 500},
   Increment = 10,
   CurrentValue = 50,
   Callback = function(v) Config.FlySpeed = v end,
})

PlayerTab:CreateButton({
   Name = "Infinite Jump (Вкл навсегда)",
   Callback = function()
       UserInputService.JumpRequest:Connect(function()
           Player.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
       end)
   end,
})

-- ВКЛАДКА VISUALS
local VisualTab = Window:CreateTab("Визуалы", 4483362458)
VisualTab:CreateButton({
   Name = "Включить ESP (Подсветка)",
   Callback = function()
      for _, v in pairs(game.Players:GetPlayers()) do
          if v ~= Player and v.Character then
              local h = v.Character:FindFirstChild("Highlight") or Instance.new("Highlight", v.Character)
              h.FillColor = Color3.fromRGB(255, 0, 0)
              h.OutlineColor = Color3.fromRGB(255, 255, 255)
          end
      end
   end,
})

Rayfield:Notify({Title = "CITRUS HUB", Content = "Система обновлена и готова!", Duration = 5})
