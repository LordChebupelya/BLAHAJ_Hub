--[[
BLAHAJ Hub v0.2 DEV
by LordChebupelya

This is the hub that i suddenly decided to develop lol

This one is for a random clicking simulator
Here is the link: https://web.roblox.com/games/5490351219/X100-CLICKS-Clicker-Madness

Rayfield UI Library: https://rayfield.dev/
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
-- Credits to Rayfield creators for a great UI Library 

-- Core

getgenv().SecureMode = true

local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/shlexware/Rayfield/main/source'))()

local Window = Rayfield:CreateWindow({
    Name = "BLAHAJ Hub",
    LoadingTitle = "Loading BLAHAJ Hub...",
    LoadingSubtitle = "Created by LordChebupelya",
    ConfigurationSaving = {
       Enabled = true,
       FolderName = nil, -- Create a custom folder for your hub/game
       FileName = "BLAHAJ_Hub_config"
    },
    Discord = {
       Enabled = false,
       Invite = "noinvitelink", -- The Discord invite code, do not include discord.gg/. E.g. discord.gg/ABCD would be ABCD.
       RememberJoins = true -- Set this to false to make them join the discord every time they load it up
    },
    KeySystem = true, -- Set this to true to use our key system
    KeySettings = {
       Title = "BLAHAJ Hub",
       Subtitle = "Key System",
       Note = "Enter the password",
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
    local ClickerSection = ClickerSim:CreateSection("Farming")
    local Toggle = ClickerSim:CreateToggle({
        Name = "AutoTap",
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
     local Dropdown = ClickerSim:CreateDropdown({
        Name = "Rebirth Amount",
        Options = {"1","10","100","1000","10000"},
        CurrentOption = "Not Selected",
        Flag = "rebirthAmount", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
        Callback = function(Option)
            selectedRebirth = Option;
        -- The function that takes place when the selected option is changed
        -- The variable (Option) is a string for the value that the dropdown was changed to
        end,
     })
     local Toggle = ClickerSim:CreateToggle({
        Name = "AutoRebirth",
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
     local Toggle = ClickerSim:CreateToggle({
        Name = "Auto Buy Egg",
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
     local Worlds = ClickerSim:CreateSection("Worlds")
     local World = ClickerSim:CreateDropdown({
        Name = "Select World",
        Options = {"Lava", "Desert", "Ocean", "Winter", "Toxic", "Candy", "Forest", "Storm", "Blocks", "Space", "Dominus", "Infinity", "Future", "City", "Moon", "Fire"},
        CurrentOption = "World Not Selected",
        Flag = "world", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
        Callback = function(Option)
            selectedWorld = Option;  
        -- The function that takes place when the selected option is changed
        -- The variable (Option) is a string for the value that the dropdown was changed to
        end,
     })
     local teleportButton = ClickerSim:CreateButton({
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
local PlayerSection = Player:CreateSection("Player")

local speedHack = Player:CreateToggle({
    Name = "Change WalkSpeed",
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
local ScriptsSection = Scripts:CreateSection("Scripts")
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

-- Menu Settings

local Settings = Window:CreateTab("Settings", 0) -- Title, Image
local SettingsSection = Settings:CreateSection("Settings")
local speedHackBind = Settings:CreateKeybind({
    Name = "Toggle SpeedHack",
    CurrentKeybind = "",
    HoldToInteract = false,
    Flag = "speedHackBind", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
    Callback = function(Keybind)
        if speedHack and keybind then
            speedHack:Set(false)
            getgenv().speedHack = false;
            game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 16
            WalkSpeedSlider:Set(16)
        elseif not speedHack and keybind then
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
        jumpHack:Set(true)
        getgenv().jumpHack = true;
        --[[
        if jumpHack then
            jumpHack:Set(false)
            getgenv().jumpHack = false;
            game.Players.LocalPlayer.Character.Humanoid.JumpPower = 16
            JumpPowerSlider:Set(16)
        elseif not jumpHack then
            jumpHack:Set(true)
            getgenv().jumpHack = true;
        end
        ]]

    -- The function that takes place when the keybind is pressed
    -- The variable (Keybind) is a boolean for whether the keybind is being held or not (HoldToInteract needs to be true)
    end,
 })
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