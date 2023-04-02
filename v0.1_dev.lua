--[[
BLAHAJ Hub v0.1 DEV
by LordChebupelya

This is the hub that i suddenly decided to develop lol

This one is for a random clicking simulator
Here is the link: https://web.roblox.com/games/5490351219/X100-CLICKS-Clicker-Madness

UI Library by xHeptc: https://xheptcofficial.gitbook.io/kavo-library/
]]

-- Variables

-- Universal

getgenv().speedHack = false;
getgenv().jumpHack = false;

-- Clicker Madness

getgenv().autotap = false;
getgenv().autoRebirth = false;
getgenv().buyEgg = false;

local clickMod = require(game:GetService("Players").SashaKotesha2.PlayerScripts.Aero.Controllers.UI.Click)

local remotePath = game:GetService("ReplicatedStorage").Aero.AeroRemoteServices;

-- Functions

--Clicker Madness

function unlockGamepasses()
    local gamepassesMod = require(game:GetService("ReplicatedStorage").Aero.Shared.Gamepasses)
    gamepassesMod.HasPassOtherwisePrompt = function() return true end;
end

function tap() 
    spawn(function() 
        while wait() do
            if not autotap then break end;
            clickMod:Click()
        end
    end)
end

function rebirth(rebirthAmount)
    spawn(function() 
        while wait() do
            if not autoRebirth then break end;
            local args = {[1] = rebirthAmount}
            remotePath.RebirthService.BuyRebirths:FireServer(unpack(args))
        end
    end)
end

function egg(eggType) --, eggLimit
    spawn(function()
        --local iteration = 0;
        while wait() do
            if not buyEgg then break end; --or iteration == eggLimit
            remotePath.EggService.Purchase:FireServer(eggType)
            --iteration = iteration +1
        end
    end)
end

-- getPlayerPos function if i will ever need it (i will need it for character coordinates like in minecraft)

function getPlayerPos()
    local player = game:GetService("Players").LocalPlayer
    if player.Character then
        return player.Character.HumainoidRootPart.Position
    end
    return false;
end

--[[
tap()
rebirth(1000)
egg('basic', 5)     -- egg types: basic
]]
function teleportTO(placeCFrame)
    local plyr = game.Players.LocalPlayer;
    if plyr then
        plyr.Character.HumanoidRootPart.CFrame = placeCFrame;      -- Found the solution myself :D 
    end
end
function teleportWorld(world)
    if game:GetService("Workspace").Worlds:FindFirstChild(world) then
        teleportTO(game:GetService("Workspace").Worlds[world].Teleport.CFrame)
    end
end

-- UILib
-- Credits to xHeptc for a great UI Library

-- Core

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()

local Window = Library.CreateLib("BLAHAJ Hub", "Ocean") -- Themes: LightTheme, DarkTheme, GrapeTheme, BloodTheme, Ocean, Midnight, Sentinel, Synapse

-- Clicker Madness

if game.PlaceId == 5490351219 then
    local selectedWorld;
    local selectedRebirth;
    local ClickerSim = Window:NewTab("Clicker Sim")
    local Farming = ClickerSim:NewSection("Farming")
    Farming:NewToggle("AutoTap", "Basically taps for you", function(state)
        if state then
            getgenv().autotap = true;
            tap()
            print("Toggled AutoTap On")
        else
            getgenv().autotap = false;
            print("Toggled AutoTap Off")
        end
    end)
    Farming:NewDropdown("Rebirth Amount", "Select The Amount of Rebirths to buy", {"1", "10", "100", "1000", "10000"}, function(value)
        selectedRebirth = value;
    end)    
    Farming:NewToggle("AutoRebirth", "Spams Buy Rebirth For You", function(state)
        if state and selectedRebirth then
            getgenv().autoRebirth = true;
            rebirth(selectedRebirth)
            print("Toggled AutoRebirth On")
        else
            getgenv().autoRebirth = false;
            print("Toggled AutoRebirth Off")
        end
    end)
    Farming:NewToggle("Auto Buy Egg", "Spams Buy Egg For You", function(state)
        if state then
            getgenv().buyEgg = true;
            egg('basic')
            print("Toggled Auto Buy Egg On")
        else
            getgenv().buyEgg = false;
            print("Toggled Auto Buy Egg Off")
        end
    end)
    local Worlds = ClickerSim:NewSection("Worlds")
    Worlds:NewDropdown("World", "Select a world to teleport to", {"Lava", "Desert", "Ocean", "Winter", "Toxic", "Candy", "Forest", "Storm", "Blocks", "Space", "Dominus", "Infinity", "Future", "City", "Moon", "Fire"}, function(value)
        selectedWorld = value;
    end)
    Worlds:NewButton("Teleport to World", "Teleports you to the selected world", function()
        if selectedWorld then
            teleportWorld(selectedWorld)
        end
    end)
    local Exploiting = ClickerSim:NewSection("Exploiting")
    Exploiting:NewButton("Unlock Gamepasses", "Unlocks Gamepasses", function()
        unlockGamepasses()
    end)
end

-- Player

local PlayerTab = Window:NewTab("Player")
local PlayerSection = PlayerTab:NewSection("Player")

PlayerSection:NewToggle("WalkSpeed", "Changes your WalkSpeed", function(state)
    if state then
        getgenv().speedHack = true;
        print("Toggled SpeedHack On")
    else
        getgenv().speedHack = false;
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 16
        print("Toggled SpeedHack Off")
    end
end)
PlayerSection:NewSlider("WalkSpeed", "Changes your WalkSpeed", 500, 16, function(s) 
    if speedHack then
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = s
    end
end)
PlayerSection:NewToggle("JumpPower", "Changes your JumpPower", function(state)
    if state then
        getgenv().jumpHack = true;
        print("Toggled JumpHack On")
    else
        getgenv().jumpHack = false;
        game.Players.LocalPlayer.Character.Humanoid.JumpPower = 50
        print("Toggle Off")
    end
end)
PlayerSection:NewSlider("JumpPower", "Changes your JumpPower", 500, 50, function(s) 
    if jumpHack then
        game.Players.LocalPlayer.Character.Humanoid.JumpPower = s
    end
end)

-- Scripts

local Scripts = Window:NewTab("Scripts")
local Scripts2 = Scripts:NewSection("Scripts")
Scripts2:NewButton("Infinite Yield", "Runs Infinite Yield Script", function()
    loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))()
end)
Scripts2:NewButton("Orca by 0866", "Runs Orca Script", function()
    loadstring(game:HttpGet('https://raw.githubusercontent.com/richie0866/orca/master/public/latest.lua'))()
end)
Scripts2:NewButton("Simple Spy", "Runs Simple Spy Script", function()
    loadstring(game:HttpGet('https://raw.githubusercontent.com/exxtremestuffs/SimpleSpySource/master/SimpleSpy.lua'))()
end)
Scripts2:NewButton("Secure Dex", "Runs Secure Dex Script", function()
    loadstring(game:HttpGet('https://raw.githubusercontent.com/Babyhamsta/RBLX_Scripts/main/Universal/BypassedDarkDexV3.lua', true))()
end)
Scripts2:NewButton("RealZzHub", "Runs RealZzHub Script", function()
    loadstring(game:HttpGet('https://raw.githubusercontent.com/RealZzHub/MainV2/main/Main.lua'))()
end)

