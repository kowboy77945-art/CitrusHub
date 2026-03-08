local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "CITRUS HUB 🍋 | GOD MODE",
   LoadingTitle = "Загрузка Silent Engine...",
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

-- ПЕРЕМЕННЫЕ
local Player = game.Players.LocalPlayer
local Mouse = Player:GetMouse()
local Camera = workspace.CurrentCamera

local Config = {
    SilentAim = false,
    FovRadius = 300,
    WallShot = false,
    FlySpeed = 50,
    Flying = false,
    InfJump = false
}

-- ФУНКЦИЯ ПОИСКА БЛИЖАЙШЕЙ ЦЕЛИ
local function GetClosestTarget()
    local target = nil
    local shortestDistance = Config.FovRadius

    for _, v in pairs(game.Players:GetPlayers()) do
        if v ~= Player and v.Character and v.Character:FindFirstChild("HumanoidRootPart") and v.Character.Humanoid.Health > 0 then
            local pos, onScreen = Camera:WorldToViewportPoint(v.Character.HumanoidRootPart.Position)
            if onScreen then
                local distance = (Vector2.new(pos.X, pos.Y) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude
                if distance < shortestDistance then
                    target = v
                    shortestDistance = distance
                end
            end
        end
    end
    return target
end

-- ЛОГИКА SILENT AIM (HOOKING)
local mt = getrawmetatable(game)
local oldNamecall = mt.__namecall
setreadonly(mt, false)

mt.__namecall = newcclosure(function(self, ...)
    local method = getnamecallmethod()
    local args = {...}

    if Config.SilentAim and method == "FindPartOnRayWithIgnoreList" or method == "Raycast" then
        local target = GetClosestTarget()
        if target then
            -- Если стреляем, подменяем направление пули на цель
            return oldNamecall(self, Ray.new(Camera.CFrame.Position, (target.Character.HumanoidRootPart.Position - Camera.CFrame.Position).Unit * 1000), args[2])
        end
    end
    return oldNamecall(self, ...)
end)

setreadonly(mt, true)

-- ВКЛАДКА БОЙ
local CombatTab = Window:CreateTab("Бой", 4483362458)

CombatTab:CreateToggle({
   Name = "True Silent Aim (Без доводки камеры)",
   CurrentValue = false,
   Callback = function(Value) Config.SilentAim = Value end,
})

CombatTab:CreateSlider({
   Name = "Радиус попадания (FOV)",
   Range = {50, 1000},
   Increment = 10,
   CurrentValue = 300,
   Callback = function(v) Config.FovRadius = v end,
})

-- ВКЛАДКА ИГРОК
local PlayerTab = Window:CreateTab("Игрок", 4483362458)

PlayerTab:CreateToggle({
   Name = "Идеальный Fly (Джойстик)",
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
   Name = "Скорость Полета / Бега",
   Range = {16, 500},
   Increment = 5,
   CurrentValue = 50,
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

game:GetService("UserInputService").JumpRequest:Connect(function()
    if Config.InfJump then Player.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping") end
end)

-- ВКЛАДКА ВИЗУАЛЫ
local VisualTab = Window:CreateTab("Визуалы", 4483362458)
VisualTab:CreateButton({
   Name = "Включить ESP (Highlight)",
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

Rayfield:Notify({Title = "CITRUS HUB", Content = "Elite Silent Aim запущен!", Duration = 5})
