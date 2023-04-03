--[[
BLAHAJ Hub v0.3 DEV
by LordChebupelya

This is the hub that i suddenly decided to develop lol

This one is for a random clicking simulator
Here is the link: https://web.roblox.com/games/5490351219/X100-CLICKS-Clicker-Madness

Arrayfield UI Library: 

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
-- Credits to Rayfield creators for a great UI Library 

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
    local ClickerSection = ClickerSim:CreateSection("Farming", false)
    --[[
        local Toggle = Tab:CreateToggle({
            Name = "Toggle Example",
            Info = "Toggle info/Description.", -- Speaks for itself, Remove if none.
            CurrentValue = false,
            Flag = "Toggle1", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
            Callback = function(Value)
            -- The function that takes place when the toggle is pressed
            -- The variable (Value) is a boolean on whether the toggle is true or false
        end,
    })
    ]]    
    local autotap_toggle = ClickerSim:CreateToggle({
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
     local rebirth_amount = ClickerSim:CreateDropdown({
        Name = "Rebirth Amount",
        Options = {"1","10","100","1000","10000"},
        CurrentOption = "Not Selected",
        MultiSelections = false
        Flag = "rebirthAmount_dropdown", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
        Callback = function(Option)
            selectedRebirth = Option;
        -- The function that takes place when the selected option is changed
        -- The variable (Option) is a string for the value that the dropdown was changed to
        end,
     })
     local rebirth_toggle = ClickerSim:CreateToggle({
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
     local Worlds = ClickerSim:CreateSection("Worlds", false)
     local World = ClickerSim:CreateDropdown({
        Name = "Select World",
        Options = {"Lava", "Desert", "Ocean", "Winter", "Toxic", "Candy", "Forest", "Storm", "Blocks", "Space", "Dominus", "Infinity", "Future", "City", "Moon", "Fire"},
        MultiSelections = false
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
else
    return end
end

-- Player

local Player = Window:CreateTab("Player", 0) -- Title, Image
local PlayerSection = Player:CreateSection("Player")

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
local Flyhack = Player:CreateButton({
    Name = "FlyHack",
    Info = "fly like a bird", -- Speaks for itself, Remove if none.
    Interact = 'Changable',
    Callback = function()
        loadstring(game:HttpGet('https://raw.githubusercontent.com/Nicuse/RobloxScripts/main/BypassedFly.lua'))()
        Rayfield:Notify({
            Title = "Module toggled",
            Content = "FlyHack has been toggled!",
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
    -- The function that takes place when the button is pressed
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

-- CMD 

-- tab, section, paragraph (for output) and textbox. imagine that they are here
-- not here yet. but soon

-- Menu Settings

local Settings = Window:CreateTab("Settings", 0) -- Title, Image
local SettingsSection = Settings:CreateSection("Settings")
local speedHackBind = Settings:CreateKeybind({
    Name = "Toggle SpeedHack",
    CurrentKeybind = "",
    HoldToInteract = false,
    Flag = "speedHackBind", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
    Callback = function(Keybind)
        if speedHack and keybind and not speedBindLock then
            speedHack:Set(false)
            getgenv().speedHack = false;
            game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 16
            WalkSpeedSlider:Set(16)
        elseif not speedHack and keybind and not speedBindLock then
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
        if jumpHack and keybind and not jumpBindLock then
            jumpHack:Set(false)
            getgenv().jumpHack = false;
            game.Players.LocalPlayer.Character.Humanoid.JumpPower = 50
            JumpPowerSlider:Set(16)
        elseif not jumpHack and keybind and not jumpBindLock then
            jumpHack:Set(true)
            getgenv().jumpHack = true;
        end
    -- The function that takes place when the keybind is pressed
    -- The variable (Keybind) is a boolean for whether the keybind is being held or not (HoldToInteract needs to be true)
    end,
 })
 local Lockdown = Tab:CreateToggle({
    Name = "Lockdown",
    Info = "Locks EVERYTHING (real)", -- Speaks for itself, Remove if none.
    CurrentValue = false,
    Flag = "Lockdown", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
    Callback = function(Value)
        if Value then
            getgenv().autotap = false;
            getgenv().autoRebirth = false;
            getgenv().buyEgg = false;
            getgenv().speedHack = false;
            getgenv().jumpHack = false;
            getgenv().speedBindLock = true;
            getgenv().jumpBindLock = true;
            autotap_toggle:Set(false)
            rebirth_toggle:Set(false)
            autoEgg:Set(false)
            speedHack:Set(false)
            game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 16
            WalkSpeedSlider:Set(16)
            jumpHack:Set(false)
            game.Players.LocalPlayer.Character.Humanoid.JumpPower = 50
            JumpPowerSlider:Set(50)
            autotap_toggle:Lock('Lockdown')
            rebirth_amount:Lock('Lockdown')
            rebirth_toggle:Lock('Lockdown')
            autoEgg:Lock('Lockdown')
            World:Lock('Lockdown')
            tpWorld:Lock('Lockdown')
            speedHack:Lock('Lockdown')
            WalkSpeedSlider:Lock('Lockdown')
            jumpHack:Lock('Lockdown')
            JumpPowerSlider:Lock('Lockdown')
            infiniteyield:Lock('Lockdown')
            orca:Lock('Lockdown')
            simplespy:Lock('Lockdown')
            securedex:Lock('Lockdown')
            realzzhub:Lock('Lockdown')
        else
            autotap_toggle:Unlock()
            rebirth_amount:Unlock()
            rebirth_toggle:Unlock()
            autoEgg:Unlock()
            World:Unlock()
            tpWorld:Unlock()
            speedHack:Unlock()
            WalkSpeedSlider:Unlock()
            jumpHack:Unlock()
            JumpPowerSlider:Unlock()
            infiniteyield:Unlock()
            orca:Unlock()
            simplespy:Unlock()
            securedex:Unlock()
            realzzhub:Unlock()
        end
    -- The function that takes place when the toggle is pressed
    -- The variable (Value) is a boolean on whether the toggle is true or false
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

--[[
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

        -- this is the fix for the keybind

        if jumpHack then
            jumpHack:Set(false)
            getgenv().jumpHack = false;
            game.Players.LocalPlayer.Character.Humanoid.JumpPower = 16
            JumpPowerSlider:Set(16)
        elseif not jumpHack then
            jumpHack:Set(true)
            getgenv().jumpHack = true;
        end
        

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
]]

Rayfield:LoadConfiguration()