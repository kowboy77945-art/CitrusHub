local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "CITRUS HUB 🍋 | ELITE V4",
   LoadingTitle = "Загрузка Elite Системы...",
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

-- Настройки и переменные
local Player = game.Players.LocalPlayer
local Camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local Config = {
    SilentAim = false,
    SilentFov = 150,
    ShowFov = true,
    WallShot = false, -- Стрельба сквозь стены
    FlySpeed = 50,
    Flying = false,
    WalkSpeed = 16,
    JumpPower = 50,
    InfJump = false
}

-- Визуальный круг FOV
local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 2
FOVCircle.NumSides = 60
FOVCircle.Filled = false
FOVCircle.Transparency = 1
FOVCircle.Color = Color3.fromRGB(255, 255, 0)

RunService.RenderStepped:Connect(function()
    FOVCircle.Visible = Config.ShowFov
    FOVCircle.Radius = Config.SilentFov
    FOVCircle.Position = Vector2.new(UserInputService:GetMouseLocation().X, UserInputService:GetMouseLocation().Y)
end)

-- Функция поиска цели для Сайлента
local function GetClosestTarget()
    local target = nil
    local dist = Config.SilentFov

    for _, v in pairs(game.Players:GetPlayers()) do
        if v ~= Player and v.Character and v.Character:FindFirstChild("HumanoidRootPart") and v.Character.Humanoid.Health > 0 then
            local pos, onScreen = Camera:WorldToViewportPoint(v.Character.HumanoidRootPart.Position)
            if onScreen then
                local mag = (Vector2.new(pos.X, pos.Y) - UserInputService:GetMouseLocation()).Magnitude
                if mag < dist then
                    -- Проверка видимости (если WallShot выключен)
                    if not Config.WallShot then
                        local ray = Ray.new(Camera.CFrame.Position, (v.Character.HumanoidRootPart.Position - Camera.CFrame.Position).Unit * 500)
                        local hit = workspace:FindPartOnRayWithIgnoreList(ray, {Player.Character})
                        if hit and hit:IsDescendantOf(v.Character) then
                            target = v
                            dist = mag
                        end
                    else
                        target = v
                        dist = mag
                    end
                end
            end
        end
    end
    return target
end

-- ВКЛАДКА COMBAT (БОЙ)
local CombatTab = Window:CreateTab("Бой", 4483362458)

CombatTab:CreateToggle({
   Name = "Silent Aim (Попадание сбоку)",
   CurrentValue = false,
   Callback = function(Value)
      Config.SilentAim = Value
      task.spawn(function()
          while Config.SilentAim do
              if UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
                  local target = GetClosestTarget()
                  if target then
                      -- Направляем "пули" (камеру) на цель только в момент клика
                      local aimPart = target.Character:FindFirstChild("Head") or target.Character.HumanoidRootPart
                      Camera.CFrame = CFrame.new(Camera.CFrame.Position, aimPart.Position)
                  end
              end
              task.wait(0.01)
          end
      end)
   end,
})

CombatTab:CreateToggle({
   Name = "WallShot (Стрельба сквозь стены)",
   CurrentValue = false,
   Callback = function(Value) Config.WallShot = Value end,
})

CombatTab:CreateSlider({
   Name = "Silent FOV (Радиус)",
   Range = {50, 800},
   Increment = 10,
   CurrentValue = 150,
   Callback = function(v) Config.SilentFov = v end,
})

CombatTab:CreateToggle({
   Name = "Показывать Круг FOV",
   CurrentValue = true,
   Callback = function(v) Config.ShowFov = v end,
})

-- ВКЛАДКА PLAYER (ДВИЖЕНИЕ)
local PlayerTab = Window:CreateTab("Игрок", 4483362458)

PlayerTab:CreateToggle({
   Name = "Улучшенный Fly (Джойстик)",
   CurrentValue = false,
   Callback = function(Value)
      Config.Flying = Value
      local char = Player.Character
      local root = char:WaitForChild("HumanoidRootPart")
      if Config.Flying then
          local bv = Instance.new("BodyVelocity", root)
          bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
          task.spawn(function()
              while Config.Flying do
                  local hum = char:FindFirstChildOfClass("Humanoid")
                  if hum.MoveDirection.Magnitude > 0 then
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
   Name = "Speed (Скорость)",
   Range = {16, 300},
   Increment = 5,
   CurrentValue = 16,
   Callback = function(v) Player.Character.Humanoid.WalkSpeed = v end,
})

PlayerTab:CreateToggle({
   Name = "Infinity Jump",
   CurrentValue = false,
   Callback = function(v) Config.InfJump = v end,
})

UserInputService.JumpRequest:Connect(function()
    if Config.InfJump then Player.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping") end
end)

-- ВКЛАДКА VISUALS (ESP)
local VisualTab = Window:CreateTab("Визуалы", 4483362458)

VisualTab:CreateButton({
   Name = "Включить ESP",
   Callback = function()
      for _, v in pairs(game.Players:GetPlayers()) do
          if v ~= Player and v.Character then
              local h = v.Character:FindFirstChild("Highlight") or Instance.new("Highlight", v.Character)
              h.FillColor = Color3.fromRGB(255, 0, 0)
              h.OutlineColor = Color3.fromRGB(255, 255, 255)
              h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop -- Видно сквозь стены
          end
      end
   end,
})

Rayfield:Notify({Title = "CITRUS HUB", Content = "Elite v4 успешно загружен!", Duration = 5})
