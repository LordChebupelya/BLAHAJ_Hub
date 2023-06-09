--[[
BLAHAJ Hub v0.3 DEV
by LordChebupelya

This is the hub that i suddenly decided to develop lol

This one is for a random clicking simulator
Here is the link: https://web.roblox.com/games/5490351219/X100-CLICKS-Clicker-Madness

Arrayfield UI Library: https://arraydocumentation.vercel.app/en/introduction

CHANGELOG

v0.3 DEV: 
ported to another ui lib (again)
added CMD (at least the label for it)
added full lockdown

v0.2 DEV: 
ported to another ui lib

v0.1 DEV: 
initial release
]]

-- Variables

-- Universal

getgenv().speedHack = false;
getgenv().jumpHack = false;

getgenv().speedBindLock = false;
getgenv().jumpBindLock = false;

-- Clicker Madness

getgenv().autotap = false;
getgenv().autoRebirth = false;
getgenv().buyEgg = false;

local clickMod = require(game:GetService("Players").SashaKotesha2.PlayerScripts.Aero.Controllers.UI.Click)

local remotePath = game:GetService("ReplicatedStorage").Aero.AeroRemoteServices;

-- Functions

-- Clicker Madness

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
-- Credits to Arrays for a great UI Library 

-- Core

getgenv().SecureMode = true


local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/UI-Interface/CustomFIeld/main/RayField.lua'))()

local Window = Rayfield:CreateWindow({
    Name = "BLAHAJ Hub",
    LoadingTitle = "Loading Script UI...",
    LoadingSubtitle = "Made by LordChebupelya",
    ConfigurationSaving = {
       Enabled = true,
       FolderName = nil, -- Create a custom folder for your hub/game
       FileName = "BLAHAJ_Hub_config"
    },
    Discord = {
       Enabled = false,
       Invite = "", -- The Discord invite code, do not include discord.gg/
       RememberJoins = true -- Set this to false to make them join the discord every time they load it up
    },
    KeySystem = true, -- Set this to true to use our key system
    KeySettings = {
       Title = "BLAHAJ Hub",
       Subtitle = "Password System",
       Note = "Enter the password for the script",
       FileName = "BLAHAJKey",
       SaveKey = true,
       GrabKeyFromSite = false, -- If this is true, set Key below to the RAW site you would like Rayfield to get the key from
       Key = "HackTheWorld"
    }
 })

-- Clicker Madness

if game.PlaceId == 5490351219 then
    local selectedWorld;
    local selectedRebirth;
    local ClickerSim = Window:CreateTab("Clicker Madness", 0) -- Title, Image (default id: 4483362458)
    local ClickerSection = ClickerSim:CreateSection("Farming", true)
    local autotapToggle = ClickerSim:CreateToggle({
        Name = "AutoTap",
        Info = "Taps for you",
        CurrentValue = false,
        Flag = "autotap", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
        Callback = function(Value) 
            if Value then
                getgenv().autotap = true;
                tap()
                Rayfield:Notify({
                    Title = "Module Toggled",
                    Content = "AutoTap is now ON",
                    Duration = 6.5,
                    Image = 0,
                    Actions = { -- Notification Buttons
                       Ignore = {
                          Name = "Ok",
                          Callback = function()
                          print("oke")
                       end
                    },
                 },
                 })
            else
                getgenv().autotap = false;
                Rayfield:Notify({
                    Title = "Module Toggled",
                    Content = "AutoTap is now OFF",
                    Duration = 6.5,
                    Image = 4483362458,
                    Actions = { -- Notification Buttons
                       Ignore = {
                          Name = "Ok",
                          Callback = function()
                          print("oke")
                       end
                    },
                 },
                 })
            end
        -- The function that takes place when the toggle is pressed
        -- The variable (Value) is a boolean on whether the toggle is true or false
        end,
     })
     local rebirthAmount = ClickerSim:CreateDropdown({
        Name = "Rebirth Amount",
        Options = {"1","10","100","1000","10000"},
        CurrentOption = "Not Selected",
        MultiSelections = false,
        Flag = "rebirthAmount_dropdown", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
        Callback = function(Option)
            selectedRebirth = Option;
        -- The function that takes place when the selected option is changed
        -- The variable (Option) is a string for the value that the dropdown was changed to
        end,
     })
     local rebirthToggle = ClickerSim:CreateToggle({
        Name = "AutoRebirth",
        Info = "Automatically buys rebirths for you",
        CurrentValue = false,
        Flag = "autoRebirth", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
        Callback = function(Value) 
            if Value then
                getgenv().autoRebirth = true;
                rebirth(selectedRebirth)
                Rayfield:Notify({
                    Title = "Module Toggled",
                    Content = "AutoRebirth is now ON",
                    Duration = 6.5,
                    Image = 0,
                    Actions = { -- Notification Buttons
                       Ignore = {
                          Name = "Ok",
                          Callback = function()
                          print("oke")
                       end
                    },
                 },
                 })
            else
                getgenv().autoRebirth = false;
                Rayfield:Notify({
                    Title = "Module Toggled",
                    Content = "AutoRebirth is now OFF",
                    Duration = 6.5,
                    Image = 4483362458,
                    Actions = { -- Notification Buttons
                       Ignore = {
                          Name = "Ok",
                          Callback = function()
                          print("oke")
                       end
                    },
                 },
                 })
            end
        -- The function that takes place when the toggle is pressed
        -- The variable (Value) is a boolean on whether the toggle is true or false
        end,
     })
     local autoEgg = ClickerSim:CreateToggle({
        Name = "Auto Buy Egg",
        Info = "Automatically buys basic eggs for you",
        CurrentValue = false,
        Flag = "autoEgg", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
        Callback = function(Value) 
            if Value then
                getgenv().buyEgg = true;
                egg('basic')
                Rayfield:Notify({
                    Title = "Module Toggled",
                    Content = "Auto Buy Egg is now ON",
                    Duration = 6.5,
                    Image = 0,
                    Actions = { -- Notification Buttons
                       Ignore = {
                          Name = "Ok",
                          Callback = function()
                          print("oke")
                       end
                    },
                 },
                 })
            else
                getgenv().buyEgg = false;
                Rayfield:Notify({
                    Title = "Module Toggled",
                    Content = "Auto Buy Egg is now OFF",
                    Duration = 6.5,
                    Image = 4483362458,
                    Actions = { -- Notification Buttons
                       Ignore = {
                          Name = "Ok",
                          Callback = function()
                          print("oke")
                       end
                    },
                 },
                 })
            end
        -- The function that takes place when the toggle is pressed
        -- The variable (Value) is a boolean on whether the toggle is true or false
        end,
     })
     local Worlds = ClickerSim:CreateSection("Worlds", true)
     local World = ClickerSim:CreateDropdown({
        Name = "Select World",
        Options = {"Lava", "Desert", "Ocean", "Winter", "Toxic", "Candy", "Forest", "Storm", "Blocks", "Space", "Dominus", "Infinity", "Future", "City", "Moon", "Fire"},
        MultiSelections = false,
        CurrentOption = "World Not Selected",
        Flag = "world", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
        Callback = function(Option)
            selectedWorld = Option;  
        -- The function that takes place when the selected option is changed
        -- The variable (Option) is a string for the value that the dropdown was changed to
        end,
     })
     local tpWorld = ClickerSim:CreateButton({
        Name = "Teleport!",
        Callback = function()
            teleportWorld(selectedWorld);
            Rayfield:Notify({
                Title = "Teleport",
                Content = "Teleported to selected World!",
                Duration = 6.5,
                Image = 4483362458,
                Actions = { -- Notification Buttons
                   Ignore = {
                      Name = "Ok",
                      Callback = function()
                      print("oke")
                   end
                },
             },
             })
        -- The function that takes place when the button is pressed
        end,
     })
end

-- Player

local Player = Window:CreateTab("Player", 0) -- Title, Image
local PlayerSection = Player:CreateSection("Player", true)

local speedHack = Player:CreateToggle({
    Name = "Change WalkSpeed",
    Info = "SpeedHack: walk faster than allowed (no bypass yet)",
    CurrentValue = false,
    Flag = "speedHack_active", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
    Callback = function(Value)
        getgenv().speedHack = Value;
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 16
        WalkSpeedSlider:Set(16) -- The new slider integer value
        Rayfield:Notify({
            Title = "Module Toggled",
            Content = "SpeedHack has been toggled!",
            Duration = 6.5,
            Image = 4483362458,
            Actions = { -- Notification Buttons
               Ignore = {
                  Name = "Ok",
                  Callback = function()
                  print("oke")
               end
            },
         },
         })
    -- The function that takes place when the toggle is pressed
    -- The variable (Value) is a boolean on whether the toggle is true or false
    end,
})
local WalkSpeedSlider = Player:CreateSlider({
    Name = "WalkSpeed",
    Info = "Changes your WalkSpeed",
    Range = {16, 500},
    Increment = 10,
    Suffix = "WalkSpeed",
    CurrentValue = 10,
    Flag = "walkSpeed", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
    Callback = function(Value)
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
    -- The function that takes place when the slider changes
    -- The variable (Value) is a number which correlates to the value the slider is currently at
    end,
})
local jumpHack = Player:CreateToggle({
    Name = "Change JumpPower",
    Info = "JumpHack: allows you to jump higher than allowed (no bypass yet)",
    CurrentValue = false,
    Flag = "jumpHack_active", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
    Callback = function(Value)
        getgenv().speedHack = Value;
        game.Players.LocalPlayer.Character.Humanoid.JumpPower = 50
        JumpPowerSlider:Set(50)
        Rayfield:Notify({
            Title = "Module Toggled",
            Content = "JumpHack has been toggled!",
            Duration = 6.5,
            Image = 4483362458,
            Actions = { -- Notification Buttons
               Ignore = {
                  Name = "Ok",
                  Callback = function()
                  print("oke")
               end
            },
         },
         })
    -- The function that takes place when the toggle is pressed
    -- The variable (Value) is a boolean on whether the toggle is true or false
    end,
})
local JumpPowerSlider = Player:CreateSlider({
    Name = "JumpPower",
    Info = "Changes your JumpPower",
    Range = {50, 500},
    Increment = 10,
    Suffix = "JumpPower",
    CurrentValue = 10,
    Flag = "JumpPower", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
    Callback = function(Value)
        game.Players.LocalPlayer.Character.Humanoid.JumpPower = Value
    -- The function that takes place when the slider changes
    -- The variable (Value) is a number which correlates to the value the slider is currently at
    end,
})

-- Scripts

local Scripts = Window:CreateTab("Scripts", 0) -- Title, Image
local ScriptsSection = Scripts:CreateSection("Scripts", true)
local infiniteyield = Scripts:CreateButton({
    Name = "Execute Infinite Yield",
    Callback = function()
        loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))()
    -- The function that takes place when the button is pressed
    end,
})
local orca = Scripts:CreateButton({
    Name = "Execute Orca by 0866",
    Callback = function()
        loadstring(game:HttpGet('https://raw.githubusercontent.com/richie0866/orca/master/public/latest.lua'))()
    -- The function that takes place when the button is pressed
    end,
})
local simplespy = Scripts:CreateButton({
    Name = "Execute Simple Spy",
    Callback = function()
        loadstring(game:HttpGet('https://raw.githubusercontent.com/exxtremestuffs/SimpleSpySource/master/SimpleSpy.lua'))()
    -- The function that takes place when the button is pressed
    end,
})
local securedex = Scripts:CreateButton({
    Name = "Execute Secure Dex",
    Callback = function()
        loadstring(game:HttpGet('https://raw.githubusercontent.com/Babyhamsta/RBLX_Scripts/main/Universal/BypassedDarkDexV3.lua', true))()
    -- The function that takes place when the button is pressed
    end,
})
local realzzhub = Scripts:CreateButton({
    Name = "Execute RealZzHub",
    Callback = function()
        loadstring(game:HttpGet('https://raw.githubusercontent.com/RealZzHub/MainV2/main/Main.lua'))()
    -- The function that takes place when the button is pressed
    end,
})

-- CMD 

-- tab, section, paragraph (for output) and textbox. imagine that they are here
-- not here yet. but soon

local cmdTab = Window:CreateTab("CMD", 0) -- Title, Image
local cmdSec = cmdTab:CreateSection("CMD",true) -- The 2nd argument is to tell if its only a Title and doesnt contain elements
local cmdOutput = cmdTab:CreateParagraph({Title = "CMD Output", Content = "Loaded!",cmdSec})
local cmdInput = cmdTab:CreateInput({
    Name = ">",
    Info = "Input for cmd", -- Speaks for itself, Remove if none.
    PlaceholderText = "<command>",
    NumbersOnly = false, -- If the user can only type numbers. Remove if none.
    --CharacterLimit = 15, --max character limit. Remove if none.
    OnEnter = true, -- Will callback only if the user pressed ENTER while the box is focused.
    RemoveTextAfterFocusLost = false,
    Callback = function(Text)
        if Text == "lock test" then
            cmdOutput:Set({Title = "CMD Output", Content = "Testing Lock..."})
            cmdInput:Lock('LockTest')
            cmdInput:Unlock('LockTest')
            cmdOutput:Set({Title = "CMD Output", Content = "Finished!"})
            wait(3)
            cmdOutput:Set({Title = "CMD Output", Content = ""})
        else
            cmdOutput:Set({Title = "CMD Output", Content = "ERROR: invalid syntax"})
            wait(3)
            cmdOutput:Set({Title = "CMD Output", Content = ""})
        end
    -- The function that takes place when the input is changed
    -- The variable (Text) is a string for the value in the text box
    end,
 })

-- Menu Settings

local Settings = Window:CreateTab("Settings", 0) -- Title, Image
local SettingsSection = Settings:CreateSection("Settings", true)
--[[
local speedHackBind = Settings:CreateKeybind({
    Name = "Toggle SpeedHack",
    CurrentKeybind = "",
    HoldToInteract = false,
    Flag = "speedHackBind", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
    Callback = function(Keybind)
        if speedHack and not speedBindLock then
            speedHack:Set(false)
            getgenv().speedHack = false;
            game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 16
            WalkSpeedSlider:Set(16)
        elseif not speedHack and not speedBindLock then
            speedHack:Set(true)
            getgenv().speedHack = true;
        end
    -- The function that takes place when the keybind is pressed
    -- The variable (Keybind) is a boolean for whether the keybind is being held or not (HoldToInteract needs to be true)
    end,
 })
 local jumpHackBind = Settings:CreateKeybind({
    Name = "Toggle JumpHack",
    CurrentKeybind = "",
    HoldToInteract = false,
    Flag = "jumpHackBind", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
    Callback = function(Keybind)
        if jumpHack and not jumpBindLock then
            jumpHack:Set(false)
            getgenv().jumpHack = false;
            game.Players.LocalPlayer.Character.Humanoid.JumpPower = 50
            JumpPowerSlider:Set(50)
        elseif not jumpHack and not jumpBindLock then
            jumpHack:Set(true)
            getgenv().jumpHack = true;
        end
    -- The function that takes place when the keybind is pressed
    -- The variable (Keybind) is a boolean for whether the keybind is being held or not (HoldToInteract needs to be true)
    end,
 })
]]
local DestroyGUI = Settings:CreateButton({
    Name = "Destroy the GUI",
    Callback = function()
        getgenv().autotap = false;
        getgenv().autoRebirth = false;
        getgenv().buyEgg = false;
        getgenv().speedHack = false;
        getgenv().jumpHack = false;
        Rayfield:Destroy()
    -- The function that takes place when the button is pressed
    end,
 })

Rayfield:LoadConfiguration()