-- [[ CITRUS HUB - STABLE FLY VERSION ]] --
local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()

-- Создание окна
local Window = OrionLib:MakeWindow({
    Name = "CITRUS HUB 🍋", 
    HidePremium = false, 
    SaveConfig = true, 
    IntroText = "CITRUS HUB BY CITRUS",
    ConfigFolder = "CitrusFly"
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
                Content = "Приятного полета, Citrus!",
                Time = 5
            })
        end
    end	  
})

-- Вкладка только для Полета
local Main = Window:MakeTab({
    Name = "Полет (Fly)",
    Icon = "rbxassetid://4483345998"
})

Main:AddButton({
    Name = "🚀 АКТИВИРОВАТЬ FLY GUI",
    Callback = function()
        -- Запуск лучшего мобильного Fly
        loadstring(game:HttpGet("https://raw.githubusercontent.com/XNEOFF/FlyGuiV3/main/FlyGuiV3.lua"))()
    end
})

Main:AddParagraph("Инфо","Нажми на кнопку выше, и на экране появятся кнопки управления полетом.")

-- Вкладка инфо
local Info = Window:MakeTab({
    Name = "Информация",
    Icon = "rbxassetid://4483345998"
})

Info:AddParagraph("Название:","CITRUS HUB")
Info:AddParagraph("Версия:","1.0 (Fly Edition)")
Info:AddParagraph("Ключ:","chub7dayfree")

OrionLib:Init()
