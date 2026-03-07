local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "CITRUS HUB 🍋 | ELITE",
   LoadingTitle = "Загрузка...",
   LoadingSubtitle = "by Citrus",
   ConfigurationSaving = { Enabled = false },
   KeySystem = true,
   KeySettings = {
      Title = "CITRUS HUB",
      Subtitle = "Авторизация",
      Note = "Введите ваш персональный доступ",
      FileName = "CitrusKey",
      SaveKey = true,
      GrabKeyFromSite = false,
      Key = {"chub7dayfree"} -- Твой секретный ключ
   }
})

-- Переменные управления
local Player = game.Players.LocalPlayer
local Camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local Vars = {
    FlySpeed = 50,
    WalkSpeed = 16,
    JumpPower = 50,
    Flying = false,
    SilentAim = false,
    InfJump = false
}

-- ГЛАВНАЯ ВКЛАДКА (ДВИЖЕНИЕ)
local MainTab = Window:CreateTab("Игрок", 4483362458)

MainTab:CreateToggle({
   Name = "Fly (Стабильный полет)",
   CurrentValue = false,
   Callback = function(Value)
      Vars.Flying = Value
      local char = Player.Character or Player.CharacterAdded:Wait()
      local root = char:WaitForChild("HumanoidRootPart")
      
      if Vars.Flying then
          local bv = Instance.new("BodyVelocity", root)
          bv.Name = "CitrusFlyVelocity"
          bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
          bv.Velocity = Vector3.new(0,0,0)
          
          task.spawn(function()
              while Vars.Flying do
                  local hum = char:FindFirstChildOfClass("Humanoid")
                  if hum and hum.MoveDirection.Magnitude > 0 then
                      -- Летим туда, куда смотрит камера + джойстик
                      bv.Velocity = Camera.CFrame:VectorToWorldSpace(Vector3.new(hum.MoveDirection.X, hum.MoveDirection.Y, hum.MoveDirection.Z) * 1).Unit * Vars.FlySpeed
                  else
                      bv.Velocity = Vector3.new(0, 0, 0) -- Замираем, если не трогаем джойстик
                  end
                  task.wait()
              end
              bv:Destroy()
          end)
      end
   end,
})

MainTab:CreateSlider({
   Name = "Скорость (Fly/Run)",
   Range = {16, 500},
   Increment = 5,
   CurrentValue = 50,
   Callback = function(Value)
      Vars.FlySpeed = Value
      if Player.Character and Player.Character:FindFirstChild("Humanoid") then
          Player.Character.Humanoid.WalkSpeed = Value
      end
   end,
})

MainTab:CreateToggle({
   Name = "Infinite Jump (Прыжки спамом)",
   CurrentValue = false,
   Callback = function(Value)
      Vars.InfJump = Value
   end,
})

-- Обработка бесконечного прыжка
UserInputService.JumpRequest:Connect(function()
    if Vars.InfJump and Player.Character then
        Player.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
    end
end)

-- ВКЛАДКА БОЙ (SILENT AIM)
local CombatTab = Window:CreateTab("Бой", 4483362458)

CombatTab:CreateToggle({
   Name = "Silent Aim (Улучшенный)",
   CurrentValue = false,
   Callback = function(Value)
      Vars.SilentAim = Value
      
      task.spawn(function()
          while Vars.SilentAim do
              local target = nil
              local shortestMouseDist = math.huge
              
              for _, v in pairs(game.Players:GetPlayers()) do
                  if v ~= Player and v.Character and v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid.Health > 0 then
                      local pos, onScreen = Camera:WorldToViewportPoint(v.Character.HumanoidRootPart.Position)
                      if onScreen then
                          local mouseDist = (Vector2.new(pos.X, pos.Y) - Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)).Magnitude
                          if mouseDist < shortestMouseDist then
                              target = v
                              shortestMouseDist = mouseDist
                          end
                      end
                  end
              end
              
              if target then
                  -- Магия Silent Aim: пули летят в цель (коррекция камеры)
                  local aimPart = target.Character:FindFirstChild("Head") or target.Character.HumanoidRootPart
                  Camera.CFrame = CFrame.new(Camera.CFrame.Position, aimPart.Position)
              end
              task.wait(0.01) -- Частота проверки для плавной наводки
          end
      end)
   end,
})

-- ВКЛАДКА ВИЗУАЛЫ
local VisualTab = Window:CreateTab("Визуалы", 4483362458)

VisualTab:CreateButton({
   Name = "ESP: Подсветка целей",
   Callback = function()
      for _, v in pairs(game.Players:GetPlayers()) do
          if v ~= Player and v.Character then
              local h = v.Character:FindFirstChild("CitrusESP") or Instance.new("Highlight", v.Character)
              h.Name = "CitrusESP"
              h.FillColor = Color3.fromRGB(255, 0, 0)
              h.OutlineColor = Color3.fromRGB(255, 255, 255)
              h.FillTransparency = 0.5
          end
      end
   end,
})

Rayfield:Notify({Title = "Запуск", Content = "CITRUS HUB готов к работе!", Duration = 3})
