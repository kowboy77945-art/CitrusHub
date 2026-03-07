-- [[ CITRUS HUB | GITHUB VERSION ]] --
local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()

-- Создание окна
local Window = OrionLib:MakeWindow({
    Name = "CITRUS HUB 🍋", 
    HidePremium = false, 
    SaveConfig = true, 
    IntroText = "CITRUS HUB BY CITRUS",
    ConfigFolder = "CitrusHub_GitHub"
})

-- Вкладка авторизации
local Auth = Window:MakeTab({
    Name = "Ключ (Key)",
    Icon = "rbxassetid://4483345998"
})

Auth:AddTextbox({
    Name = "Введите ключ",
    Default = "",
    TextDisappear = true,
    Callback = function(Value)
        if Value == "chub7dayfree" then
            OrionLib:MakeNotification({
                Name = "Доступ разрешен!",
                Content = "Добро пожаловать, Citrus!",
                Time = 5
            })
        end
    end	  
})

-- Вкладка функций
local Main = Window:MakeTab({
    Name = "Функции (Main)",
    Icon = "rbxassetid://4483345998"
})

Main:AddButton({
    Name = "🚀 АКТИВИРОВАТЬ FLY (ПОЛЕТ)",
    Callback = function()
        -- Загрузка лучшего Fly GUI для мобильных
        loadstring(game:HttpGet("https://raw.githubusercontent.com/XNEOFF/FlyGuiV3/main/FlyGuiV3.lua"))()
    end
})

Main:AddSlider({
    Name = "Угол обзора (FOV)",
    Min = 70, Max = 120, Default = 80,
    Color = Color3.fromRGB(255, 255, 0),
    Increment = 1,
    ValueName = "FOV",
    Callback = function(Value)
        game.Workspace.CurrentCamera.FieldOfView = Value
    end    
})

-- Вкладка информации
local Info = Window:MakeTab({
    Name = "Информация",
    Icon = "rbxassetid://4483345998"
})

Info:AddParagraph("Проект:","CITRUS HUB")
Info:AddParagraph("Автор:","Citrus")
Info:AddParagraph("Хостинг:","GitHub (kowboy77945-art)")
Info:AddParagraph("Ключ:","chub7dayfree")

OrionLib:Init()
