-- [[ CITRUS HUB - KAVO EDITION (STABLE) ]] --
local KavoLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = KavoLib.CreateLib("CITRUS HUB 🍋", "DarkTheme")

-- Вкладка Ключа
local AuthTab = Window:NewTab("Ключ (Key)")
local AuthSection = AuthTab:NewSection("Введите ключ доступа")

AuthSection:NewTextBox("Ключ", "Введите тут", function(text)
    if text == "chub7dayfree" then
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "CITRUS HUB",
            Text = "Доступ разрешен!",
            Duration = 5
        })
    end
end)

-- Вкладка Полета
local FlyTab = Window:NewTab("Полет (Fly)")
local FlySection = FlyTab:NewSection("Управление полетом")

FlySection:NewButton("🚀 ЗАПУСТИТЬ FLY GUI", "Появится меню управления полетом", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/XNEOFF/FlyGuiV3/main/FlyGuiV3.lua"))()
end)

-- Вкладка Визуал
local VisualTab = Window:NewTab("Визуал")
local VisualSection = VisualTab:NewSection("Настройки камеры")

VisualSection:NewSlider("Угол обзора (FOV)", "Меняет дальность зрения", 120, 70, function(s)
    game.Workspace.CurrentCamera.FieldOfView = s
end)

-- Инфо
local InfoTab = Window:NewTab("Инфо")
local InfoSection = InfoTab:NewSection("Автор: Citrus")
InfoSection:NewLabel("Ключ: chub7dayfree")
InfoSection:NewLabel("Версия: 1.2 (Stable)")

-- Кнопка закрытия/открытия меню (обычно справа сверху)
