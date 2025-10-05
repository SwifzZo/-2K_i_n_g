
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/GhostDuckyy/UI-Libraries/main/Neverlose/source.lua"))()


local Window = Library:Window({
    text = "Wish x"
})

local TabSection = Window:TabSection({
    text = "By OneWish Beta"
})

local Tab = TabSection:Tab({
    text = " Auto System",
    icon = "rbxassetid://7999345313",
})

local Main1 = Tab:Section({
    text = "Main 1 System"
})


local player = game:GetService("Players").LocalPlayer
local vim = game:GetService("VirtualInputManager")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local function clickButton(button)
	if not button then return end
	local x = button.AbsolutePosition.X + (button.AbsoluteSize.X / 2)
	local y = button.AbsolutePosition.Y + (button.AbsoluteSize.Y / 2)
	vim:SendMouseButtonEvent(x, y, 0, true, game, 1)
	vim:SendMouseButtonEvent(x, y, 0, false, game, 1)
end
function EquipWeapon(ToolSe)
    if game.Players.LocalPlayer.Backpack:FindFirstChild(ToolSe) then
        Tool = game.Players.LocalPlayer.Backpack:FindFirstChild(ToolSe)
        wait(.001)
        game.Players.LocalPlayer.Character.Humanoid:EquipTool(Tool)
    end
end

Main1:Toggle({
    text = "Auto Equip Rod",
    state = false,
    callback = function(state)
        _G.AutoEquipRod = state
        if state then
            task.spawn(function()
                local Players = game:GetService("Players")
                local LocalPlayer = Players.LocalPlayer
                while _G.AutoEquipRod do
                    task.wait(0.1)
                    pcall(function()
                        for i, v in pairs(LocalPlayer.Backpack:GetChildren()) do
                            if v:IsA("Tool") and v.Name:lower():find("rod") then
                                EquipWeapon(v.Name)
                            end
                        end
                    end)
                end
            end)
        end
    end
})

Main1:Toggle({
    text = "AutoCast",
    state = false,
    callback = function(v)
        _G.AutoCast = v

        if v then
            task.spawn(function()
                local Players = game:GetService("Players")
                local LocalPlayer = Players.LocalPlayer
                local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
                local HR = Character:WaitForChild("HumanoidRootPart")
                local StandHR = workspace:FindFirstChild("StandHR")

                while _G.AutoCast do
                    task.wait(0.2)
                    pcall(function()
                        if StandHR and HR and (StandHR.Position - HR.Position).Magnitude >= 1 then
                            HR.CFrame = StandHR.CFrame
                        end
                        local Rod = Character:FindFirstChildOfClass("Tool")
                        if Rod and Rod:FindFirstChild("events") and Rod.events:FindFirstChild("castAsync") then
                            local values = Rod:FindFirstChild("values")
                            if values and values:FindFirstChild("casted") then
                                if values.casted.Value == false then
                                    Rod.events.castAsync:InvokeServer(100, 1)
                                end
                            end
                        end
                    end)
                end
            end)
        end
    end
})


Main1:Dropdown({
    text = "Shake Delay",
    list  = {"0.1","0.3","0.5","0.8"},
    default = "0.3",
    callback = function(value)
        ShakeDelay = tonumber(value)
    end
})


Main1:Toggle({
	text = "Auto Shake",
	state = false,
	callback = function(state)
		_G.AutoShake = state
		if state then
			task.spawn(function()
				while _G.AutoShake do
					task.wait(ShakeDelay)
					local gui = player:FindFirstChild("PlayerGui")
					if gui then
						local shakeui = gui:FindFirstChild("shakeui")
						if shakeui and shakeui.Enabled then
							local safezone = shakeui:FindFirstChild("safezone")
							if safezone then
								for _, obj in pairs(safezone:GetChildren()) do
									if obj.Name == "button" and obj:IsA("ImageButton") and obj.Visible then
										clickButton(obj)
									end
								end
							end
						end
					end
				end
			end)
		end
	end
})

Main1:Toggle({
	text = "Auto Reel",
	state = false,
	callback = function(state)
		_G.AutoReel = state

		local reelFinished = ReplicatedStorage:WaitForChild("events"):WaitForChild("reelfinished")

		if state then
			task.spawn(function()
				while _G.AutoReel do
					task.wait(0.1)

					local gui = player:FindFirstChild("PlayerGui")
					if gui then
						local reelGui = gui:FindFirstChild("reel")
						if reelGui then
							local bar = reelGui:FindFirstChild("bar")
							if bar then
								task.wait(1) 
								reelFinished:FireServer(100, true)
							end
						end
					end
				end
			end)
		end
	end
})


Main1:Toggle({
    text = "Lock",
    state = false,
    callback = function(state)
        _G.FreezeChar = state

        local LocalPlayer = game:GetService("Players").LocalPlayer
        local lastCFrame

        task.spawn(function()
            while _G.FreezeChar do
                task.wait(0.03)
                pcall(function()
                    local character = LocalPlayer.Character
                    if character then
                        local HR = character:FindFirstChild("HumanoidRootPart")
                        local humanoid = character:FindFirstChildOfClass("Humanoid")
                        if HR and humanoid then
                            if not lastCFrame then
                                lastCFrame = HR.CFrame
                            end
                            HR.CFrame = lastCFrame
                            humanoid.WalkSpeed = 0
                            humanoid.JumpPower = 0
                        end
                    end
                end)
            end
            local character = LocalPlayer.Character
            if character then
                local humanoid = character:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    humanoid.WalkSpeed = 16
                    humanoid.JumpPower = 50
                end
            end
        end)
    end
})


local Main2 = Tab:Section({
    text = "Main 2 System"
})

local SellDelay = 30 

Main2:Slider({
    text = "Sell Delay (seconds)",
    min = 5,
    max = 120,
    value = SellDelay,
    callback = function(v)
        SellDelay = v
    end
})

Main2:Toggle({
    text = "Auto Sell",
    state = false,
    callback = function(state)
        _G.AutoSellState = state

        if state then
            task.spawn(function()
                local ReplicatedStorage = game:GetService("ReplicatedStorage")
                local SellEvent = ReplicatedStorage:WaitForChild("events"):WaitForChild("SellAll")

                while _G.AutoSellState do
                    pcall(function()
                        local args = {
                            [1] = {
                                ["voice"] = 12,
                                ["npc"] = workspace:WaitForChild("world"):WaitForChild("npcs"):WaitForChild("Marc Merchant"),
                                ["idle"] = workspace:WaitForChild("world"):WaitForChild("npcs"):WaitForChild("Marc Merchant"):WaitForChild("description"):WaitForChild("idle")
                            }
                        }
                        SellEvent:InvokeServer(unpack(args))
                        print("[AutoSell] Sold all items! Waiting", SellDelay, "seconds...")
                    end)
                    task.wait(SellDelay)
                end
            end)
        end
    end
})


Main2:Button({
    text = "Sell",
    callback = function()
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SellEvent = ReplicatedStorage:WaitForChild("events"):WaitForChild("SellAll")
	local args = {
	[1] = {
	["voice"] = 12,
	["npc"] = workspace:WaitForChild("world"):WaitForChild("npcs"):WaitForChild("Marc Merchant"),
	["idle"] = workspace:WaitForChild("world"):WaitForChild("npcs"):WaitForChild("Marc Merchant"):WaitForChild("description"):WaitForChild("idle")
		}
	}
	SellEvent:InvokeServer(unpack(args))
end
})




local TpTab = TabSection:Tab({
    text = " Tp",
    icon = "rbxassetid://7999345313",
})
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

function Tween(x, y, z, r00, r01, r02, r10, r11, r12, r20, r21, r22)
    pcall(function()
        local char = player.Character or player.CharacterAdded:Wait()
        local hrp = char:WaitForChild("HumanoidRootPart")
        local platform = Instance.new("Part")
        platform.Size = Vector3.new(10, 1, 10)
        platform.Anchored = true
        platform.CanCollide = true
        platform.Transparency = 1
        platform.CFrame = hrp.CFrame - Vector3.new(0, 3, 0)
        platform.Parent = workspace
        local connection
        connection = RunService.RenderStepped:Connect(function()
            if hrp and platform then
                platform.CFrame = hrp.CFrame - Vector3.new(0, 3, 0)
            else
                connection:Disconnect()
            end
        end)
        local targetCFrame = CFrame.new(x, y, z, r00, r01, r02, r10, r11, r12, r20, r21, r22)
        local tweenInfo = TweenInfo.new(2, Enum.EasingStyle.Linear)
        local tween = TweenService:Create(hrp, tweenInfo, {CFrame = targetCFrame})
        tween:Play()
        tween.Completed:Connect(function()
            connection:Disconnect() -- หยุดตาม HRP
            task.wait(0.1)
            if platform then
                platform:Destroy()
            end
        end)
    end)
end


local Tp = TpTab:Section({
    text = "Information"
})
Tp:Button({
    text = "Ancient Isle",
    callback = function()
    Tween(5943.60742, 498.524963, 507.076294, 0.0654257536, -0, -0.997857451, 0, 1, -0, 0.997857451, 0, 0.0654257536)
end
})
Tp:Button({
    text = "Castaway Cliffs",
    callback = function()
    Tween(540.5, 406.500031, -1955.75, -0.0257130861, 0, 0.999669373, 0, 1, 0, -0.999669373, 0, -0.0257130861)
end
})
Tp:Button({
    text = "Exit Northern",
    callback = function()
    Tween(17454.1289, 238.242859, 3070.04468, 1, 0, 0, 0, 1, 0, 0, 0, 1)
end
})
Tp:Button({
    text = "Forsaken Shores",
    callback = function()
    Tween(-2801.83496, 345.647247, 1533.48462, 1, 0, 0, 0, 1, 0, 0, 0, 1)
end
})
Tp:Button({
    text = "Grand Reef",
    callback = function()
    Tween(-3582.33496, 345.647247, 518.084656, 1, 0, 0, 0, 1, 0, 0, 0, 1)
end
})
Tp:Button({
    text = "Lost Jungle",
    callback = function()
    Tween(-2775.89648, 465.842285, -2121.5957, 1, 0, 0, 0, 1, 0, 0, 0, 1)
end
})
Tp:Button({
    text = "Moosewood",
    callback = function()
    Tween(484.861145, 294.572845, 274.825012, 1, 0, 0, 0, 1, 0, 0, 0, 1)
end
})
Tp:Button({
    text = "Mushgrove Swamp",
    callback = function()
    Tween(2662.08105, 397.321472, -728.827026, 1, 0, 0, 0, 1, 0, 0, 0, 1)
end
})
Tp:Button({
    text = "Northern Expedition",
    callback = function()
    Tween(-1594.46899, 235.272858, 3672.854, 1, 0, 0, 0, 1, 0, 0, 0, 1)
end
})
Tp:Button({
    text = "Northern Expedition",
    callback = function()
    Tween(19590.6797, 341.402863, 5280.54443, 1, 0, 0, 0, 1, 0, 0, 0, 1)
end
})
Tp:Button({
    text = "Pirate Ship",
    callback = function()
    Tween(-3814.76758, 158.85675, 575.917114, 0.885196388, 0, 0.465217561, 0, 1, 0, -0.465217561, 0, 0.885196388)
end
})
Tp:Button({
    text = "Roslit Bay",
    callback = function()
    Tween(-1496.55969, 384.380219, 500.728699, 1, 0, 0, 0, 1, 0, 0, 0, 1)
end
})
Tp:Button({
    text = "Snowcap Island",
    callback = function()
    Tween(2658.32715, 492.773834, 2550.50537, 0.884703815, 0.0967384726, -0.456005305, 0.0390400924, 0.959416866, 0.279276192, 0.464515895, -0.264879227, 0.845023036)
end
})

Tp:Button({
    text = "Statue Of Sovereignty",
    callback = function()
    Tween(-13.0207491, 381.091461, -1128.81299, 0.834096551, -0, -0.551618457, 0, 1, -0, 0.551618457, 0, 0.834096551)
end
})

Tp:Button({
    text = "Sunstone Island",
    callback = function()
    Tween(-1035.39636, 427.592255, -1144.09583, 1, 0, 0, 0, 1, 0, 0, 0, 1)
end
})
Tp:Button({
    text = "Terrapin Island",
    callback = function()
    Tween(50.320713, 297.993866, 1992.42078, 0.885196388, 0, 0.465217561, 0, 1, 0, -0.465217561, 0, 0.885196388)
end
})

