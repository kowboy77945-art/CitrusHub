local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "CITRUS HUB 🍋 | GOD EDITION",
   LoadingTitle = "Активация протокола AimKill...",
   LoadingSubtitle = "by Citrus",
   KeySystem = false,
   KeySettings = {
      Title = "CITRUS HUB | ACCESS",
      Subtitle = "Введите ключ",
      Note = "Ключ: chub7dayfree",
      FileName = "CitrusKey",
      SaveKey = true,
      Key = {"chub7dayfree"}
   }
})

-- ПЕРЕМЕННЫЕ
local Player = game.Players.LocalPlayer
local Camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local Config = {
    AimKill = false,
    SilentAim = false,
    FlySpeed = 100,
    KillRadius = 2000, -- Радиус в котором он ищет жертв
    Height = 50 -- Высота взлета для AimKill
}

-- Функция поиска ближайшей жертвы
local function GetNearestVictim()
    local target = nil
    local shortestDist = Config.KillRadius

    for _, v in pairs(game.Players:GetPlayers()) do
        if v ~= Player and v.Character and v.Character:FindFirstChild("HumanoidRootPart") and v.Character.Humanoid.Health > 0 then
            local dist = (v.Character.HumanoidRootPart.Position - Player.Character.HumanoidRootPart.Position).Magnitude
            if dist < shortestDist then
                target = v
                shortestDist = dist
            end
        end
    end
    return target
end

-- ВКЛАДКА: RAGE (УНИЧТОЖЕНИЕ)
local RageTab = Window:CreateTab("Rage 🔥", 4483362458)

RageTab:CreateToggle({
   Name = "AimKill (Авто-убийство всех)",
   CurrentValue = false,
   Callback = function(Value)
      Config.AimKill = Value
      local char = Player.Character or Player.CharacterAdded:Wait()
      local root = char:WaitForChild("HumanoidRootPart")
      
      if Config.AimKill then
          -- Взлет в небо
          root.CFrame = root.CFrame * CFrame.new(0, Config.Height, 0)
          local bv = Instance.new("BodyVelocity", root)
          bv.Name = "AimKillFly"
          bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
          bv.Velocity = Vector3.new(0, 0, 0)

          task.spawn(function()
              while Config.AimKill do
                  local victim = GetNearestVictim()
                  if victim then
                      -- Наводка камеры на жертву
                      local aimPart = victim.Character:FindFirstChild("Head") or victim.Character.HumanoidRootPart
                      Camera.CFrame = CFrame.new(Camera.CFrame.Position, aimPart.Position)
                      
                      -- Эмуляция стрельбы (MouseButton1)
                      game:GetService("VirtualInputManager"):SendMouseButtonEvent(0, 0, 0, true, game, 1)
                      task.wait(0.05) -- Скорость стрельбы
                      game:GetService("VirtualInputManager"):SendMouseButtonEvent(0, 0, 0, false, game, 1)
                  end
                  task.wait(0.01)
              end
              bv:Destroy()
          end)
      end
   end,
})

RageTab:CreateSlider({
   Name = "Высота взлета AimKill",
   Range = {10, 200},
   Increment = 10,
   CurrentValue = 50,
   Callback = function(v) Config.Height = v end,
})

-- ВКЛАДКА: LEGIT (ДЛЯ ОБЫЧНОЙ ИГРЫ)
local LegitTab = Window:CreateTab("Legit 🎯", 4483362458)

LegitTab:CreateToggle({
   Name = "Silent Aim (Попадание рядом)",
   CurrentValue = false,
   Callback = function(v) Config.SilentAim = v end,
})

-- Логика Silent Aim
RunService.RenderStepped:Connect(function()
    if Config.SilentAim and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
        local target = GetNearestVictim()
        if target then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Character.HumanoidRootPart.Position)
        end
    end
end)

-- ВКЛАДКА: PLAYER
local PlayerTab = Window:CreateTab("Игрок", 4483362458)

PlayerTab:CreateSlider({
   Name = "Speed / Скорость",
   Range = {16, 500},
   Increment = 10,
   CurrentValue = 16,
   Callback = function(v) Player.Character.Humanoid.WalkSpeed = v end,
})

PlayerTab:CreateButton({
   Name = "Включить ESP",
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

Rayfield:Notify({Title = "CITRUS HUB", Content = "AimKill Система активирована!", Duration = 5})
