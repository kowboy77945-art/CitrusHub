local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "CITRUS HUB 🍋 | PRO VERSION",
   LoadingTitle = "Загрузка CITRUS HUB...",
   LoadingSubtitle = "by Citrus",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "CitrusHub",
      FileName = "Main"
   },
   KeySystem = true,
   KeySettings = {
      Title = "CITRUS HUB | Ключ",
      Subtitle = "Введите ключ доступа",
      Note = "Ключ можно получить у автора (chub7dayfree)",
      FileName = "CitrusKey",
      SaveKey = true,
      GrabKeyFromSite = false,
      Key = {"chub7dayfree"} -- Твой ключ
   }
})

-- Переменные
local Player = game.Players.LocalPlayer
local Camera = workspace.CurrentCamera
local Mouse = Player:GetMouse()
local FlySpeed = 50
local Flying = false

-- ВКЛАДКА: ГЛАВНАЯ (FLY & SPEED)
local MainTab = Window:CreateTab("Игрок", 4483362458)

MainTab:CreateToggle({
   Name = "Fly (Полет по камере)",
   CurrentValue = false,
   Flag = "FlyToggle",
   Callback = function(Value)
      Flying = Value
      local char = Player.Character or Player.CharacterAdded:Wait()
      local root = char:WaitForChild("HumanoidRootPart")
      local hum = char:WaitForChild("Humanoid")
      
      if Flying then
         local bv = Instance.new("BodyVelocity", root)
         bv.Name = "CitrusFly"
         bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
         bv.Velocity = Vector3.new(0,0,0)
         
         task.spawn(function()
            while Flying do
               -- Управление через направление камеры и джойстик
               bv.Velocity = Camera.CFrame.LookVector * (hum.MoveDirection.Magnitude > 0 and FlySpeed or 0)
               if hum.MoveDirection.Magnitude > 0 then
                   bv.Velocity = Camera.CFrame:VectorToWorldSpace(Vector3.new(hum.MoveDirection.X, 0, hum.MoveDirection.Z).Unit * FlySpeed)
               else
                   bv.Velocity = Vector3.new(0,0,0)
               end
               task.wait()
            end
            bv:Destroy()
         end)
      end
   end,
})

MainTab:CreateSlider({
   Name = "Скорость Полета/Бега",
   Range = {16, 300},
   Increment = 1,
   CurrentValue = 50,
   Callback = function(Value)
      FlySpeed = Value
      Player.Character.Humanoid.WalkSpeed = Value
   end,
})

-- ВКЛАДКА: COMBAT (SILENT AIM)
local CombatTab = Window:CreateTab("Бой", 4483362458)

CombatTab:CreateToggle({
   Name = "Silent Aim (Ближний игрок)",
   CurrentValue = false,
   Callback = function(Value)
      _G.SilentAim = Value
      task.spawn(function()
         while _G.SilentAim do
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
                -- Эмуляция Silent Aim через направление взгляда в сторону цели
               Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Character.HumanoidRootPart.Position)
            end
            task.wait()
         end
      end)
   end,
})

-- ВКЛАДКА: VISUALS (ESP)
local VisualsTab = Window:CreateTab("Визуалы", 4483362458)

VisualsTab:CreateButton({
   Name = "Включить ESP (Boxes)",
   Callback = function()
      -- Простой ESP
      for _, v in pairs(game.Players:GetPlayers()) do
          if v ~= Player and v.Character then
              local highlight = Instance.new("Highlight", v.Character)
              highlight.FillColor = Color3.fromRGB(255, 165, 0)
              highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
          end
      end
      Rayfield:Notify({Title = "ESP", Content = "Подсветка игроков включена", Duration = 3})
   end,
})

-- ВКЛАДКА: MISC (ДРУГОЕ)
local MiscTab = Window:CreateTab("Разное", 4483362458)

MiscTab:CreateButton({
   Name = "Infinite Jump (Бесконечный прыжок)",
   Callback = function()
      game:GetService("UserInputService").JumpRequest:Connect(function()
          Player.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
      end)
   end,
})

MiscTab:CreateToggle({
   Name = "NoClip (Сквозь стены)",
   CurrentValue = false,
   Callback = function(Value)
      _G.NoClip = Value
      game:GetService("RunService").Stepped:Connect(function()
          if _G.NoClip then
              for _, part in pairs(Player.Character:GetDescendants()) do
                  if part:IsA("BasePart") then part.CanCollide = false end
              end
          end
      end)
   end,
})

Rayfield:Notify({Title = "CITRUS HUB", Content = "Скрипт успешно загружен!", Duration = 5})
