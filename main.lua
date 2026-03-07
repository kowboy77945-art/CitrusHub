local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "CITRUS HUB 🍋 | Premium Edition",
   LoadingTitle = "Загрузка CITRUS HUB...",
   LoadingSubtitle = "by Citrus",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "CitrusConfig",
      FileName = "MainHub"
   },
   KeySystem = true, -- Включаем систему ключей
   KeySettings = {
      Title = "CITRUS HUB | Key System",
      Subtitle = "Введите ключ доступа",
      Note = "Ключ: chub7dayfree (7 дней)",
      FileName = "CitrusKey",
      SaveKey = true,
      GrabKeyFromSite = false,
      Key = {"chub7dayfree"}
   }
})

-- Переменные для функций
local FlySpeed = 50
local Flying = false
local Camera = workspace.CurrentCamera
local Player = game.Players.LocalPlayer

-- ВКЛАДКА: ГЛАВНАЯ
local MainTab = Window:CreateTab("Главная", 4483362458)

MainTab:CreateSection("Управление персонажем")

-- Улучшенный FLY (Полет за камерой)
MainTab:CreateToggle({
   Name = "Fly (Полет за камерой)",
   CurrentValue = false,
   Flag = "FlyToggle",
   Callback = function(Value)
      Flying = Value
      local char = Player.Character or Player.CharacterAdded:Wait()
      local root = char:WaitForChild("HumanoidRootPart")
      
      if Flying then
         local bv = Instance.new("BodyVelocity")
         bv.Name = "CitrusFly"
         bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
         bv.Parent = root
         
         task.spawn(function()
            while Flying do
               bv.Velocity = Camera.CFrame.LookVector * FlySpeed
               task.wait()
            end
            bv:Destroy()
         end)
      end
   end,
})

-- Ползунок скорости полета
MainTab:CreateSlider({
   Name = "Скорость полета",
   Range = {10, 300},
   Increment = 10,
   Suffix = "Скорость",
   CurrentValue = 50,
   Flag = "FlySpeedSlider",
   Callback = function(Value)
      FlySpeed = Value
   end,
})

-- ВКЛАДКА: AIMBOT
local AimTab = Window:CreateTab("Aimbot", 4483362458)

AimTab:CreateToggle({
   Name = "Aimbot (Auto-Lock)",
   CurrentValue = false,
   Flag = "AimToggle",
   Callback = function(Value)
      _G.AimbotEnabled = Value
      task.spawn(function()
         while _G.AimbotEnabled do
            local target = nil
            local dist = math.huge
            for _, v in pairs(game.Players:GetPlayers()) do
               if v ~= Player and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                  local screenPos, onScreen = Camera:WorldToViewportPoint(v.Character.HumanoidRootPart.Position)
                  if onScreen then
                     local mag = (Vector2.new(screenPos.X, screenPos.Y) - Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)).Magnitude
                     if mag < dist then
                        target = v
                        dist = mag
                     end
                  end
               end
            end
            if target then
               Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Character.HumanoidRootPart.Position)
            end
            task.wait()
         end
      end)
   end,
})

-- ВКЛАДКА: НАСТРОЙКИ
local SettingsTab = Window:CreateTab("Настройки", 4483362458)

SettingsTab:CreateSlider({
   Name = "Угол обзора (FOV)",
   Range = {70, 120},
   Increment = 1,
   Suffix = "°",
   CurrentValue = 80,
   Flag = "FOVSlider",
   Callback = function(Value)
      Camera.FieldOfView = Value
   end,
})

SettingsTab:CreateButton({
   Name = "Удалить чит (Destroy UI)",
   Callback = function()
      Rayfield:Destroy()
   end,
})

-- ИНФОРМАЦИЯ
local InfoTab = Window:CreateTab("Инфо", 4483362458)
InfoTab:CreateParagraph({Title = "CITRUS HUB", Content = "Автор: Citrus\nКлюч: chub7dayfree\nСтатус: Работает"})
