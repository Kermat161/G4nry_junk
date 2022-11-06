local WorkspacePlayers = game:GetService("Workspace").Game.Players;
local Players = game:GetService('Players');
local localplayer = Players.LocalPlayer;

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/9Strew/roblox/main/proc/jans"))()
local Esp = loadstring(game:HttpGet("https://raw.githubusercontent.com/9Strew/roblox/main/proc/kiriotesp"))()
Esp.Enabled = false
Esp.Tracers = false
Esp.Boxes = false

local Window = Library:CreateWindow("🧟🎃 Evade", Vector2.new(500, 300), Enum.KeyCode.RightShift)
local Evade = Window:CreateTab("General")
local Gamee = Window:CreateTab("Game")
local Configs = Window:CreateTab("Settings")

local EvadeSector = Evade:CreateSector("Character", "left")
local Visuals = Evade:CreateSector("Visuals", "right")
local Credits = Evade:CreateSector("Credits", "left")

local Gamesec = Gamee:CreateSector("Utils", "right")
local World = Gamee:CreateSector("World", "left")

getgenv().Settings = {
    NoCameraShake = false,
    Downedplayeresp = false,
    Speed = 1450,
    Jump = 3,
    reviveTime = 3,
    DownedColor = Color3.fromRGB(255,170,0),
    PlayerColor = Color3.fromRGB(255,255,255)
}


local WalkSpeed = EvadeSector:AddSlider("Speed", 1450, 1450, 12000, 100, function(Value)
    Settings.Speed = Value
end)


local JumpPower = EvadeSector:AddSlider("JumpPower", 3, 3, 20, 1, function(Value)
    Settings.Jump = Value
end)

--// because silder does not detect dotted values 

World:AddButton('Full Bright', function()
   	Game.Lighting.Brightness = 4
	Game.Lighting.FogEnd = 100000
	Game.Lighting.GlobalShadows = false
    Game.Lighting.ClockTime = 12
end)

World:AddToggle('No Camera Shake', false, function(State)
    Settings.NoCameraShake = State
end)

Gamesec:AddToggle('Fast Revive', false, function(State)
    if State then
        workspace.Game.Settings:SetAttribute("ReviveTime", 2.2)
    else
        workspace.Game.Settings:SetAttribute("ReviveTime", Settings.reviveTime)
    end
end)

Visuals:AddToggle('Enable Esp', false, function(State)
    Esp.Enabled = State
end)

Visuals:AddToggle('Bot Esp', false, function(State)
    Esp.NPCs = State
end)

Visuals:AddToggle('Ticket Esp', false, function(State)
    Esp.TicketEsp = State
end)

Visuals:AddToggle('Downed Player Esp', false, function(State)
    Settings.Downedplayeresp = State
end)

Visuals:AddToggle('Boxes', false, function(State)
    Esp.Boxes = State
end)

Visuals:AddToggle('Tracers', false, function(State)
    Esp.Tracers = State
end)

Visuals:AddToggle('Players', false, function(State)
    Esp.Players = State
end)

Visuals:AddToggle('Distance', false, function(State)
    Esp.Distance = State
end)

Visuals:AddColorpicker("Player Color", Color3.fromRGB(255,255,255), function(Color)
    Settings.PlayerColor = Color
end)

Visuals:AddColorpicker("Downed Player Color", Color3.fromRGB(255,170,0), function(Color)
    Settings.DownedColor = Color
end)

Credits:AddLabel("Developed By xCLY And batusd")
Credits:AddLabel("UI Lib: Jans Lib")
Credits:AddLabel("ESP Lib: Kiriot")
Configs:CreateConfigSystem()

local FindAI = function()
    for _,v in pairs(WorkspacePlayers:GetChildren()) do
        if not Players:FindFirstChild(v.Name) then
            return v
        end
    end
end

--Kiriot
Esp:AddObjectListener(WorkspacePlayers, {
    Color =  Color3.fromRGB(255,0,0),
    Type = "Model",
    PrimaryPart = function(obj)
        local hrp = obj:FindFirstChild('HRP')
        while not hrp do
            wait()
            hrp = obj:FindFirstChild('HRP')
        end
        return hrp
    end,
    Validator = function(obj)
        return not game.Players:GetPlayerFromCharacter(obj)
    end,
    CustomName = function(obj)
        return '[AI] '..obj.Name
    end,
    IsEnabled = "NPCs",
})

Esp:AddObjectListener(game:GetService("Workspace").Game.Effects.Tickets, {
    CustomName = "Ticket",
    Color = Color3.fromRGB(41,180,255),
    IsEnabled = "TicketEsp"
})

--Tysm CJStylesOrg
Esp.Overrides.GetColor = function(char)
   local GetPlrFromChar = Esp:GetPlrFromChar(char)
   if GetPlrFromChar then
       if Settings.Downedplayeresp and GetPlrFromChar.Character:GetAttribute("Downed") then
           return Settings.DownedColor
       end
   end
   return Settings.PlayerColor
end

local old
old = hookmetamethod(game,"__namecall",newcclosure(function(self,...)
    local Args = {...}
    local method = getnamecallmethod()
    if tostring(self) == 'Communicator' and method == "InvokeServer" and Args[1] == "update" then
        return Settings.Speed, Settings.Jump 
    end
    return old(self,...)
end))
