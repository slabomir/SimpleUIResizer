local FRAMES_SCALE = 1.15
local BUTTONS_SCALE = 1.45
local BAGS_SCALE = 0.55

function MyAddOnSettingsFrame_OnLoad(self)
  local name = "helloworld"
  -- Set the name for the Category for the Panel
	self.name = "My AddOn" -- .. GetAddOnMetadata("MyAddon", "Version")

	-- When the player clicks okay, run this function.
	self.okay = function (self) print("MyAddOnSettings: Okay clicked") end

	-- When the player clicks cancel, run this function.
  self.cancel = function (self) print("MyAddOnSettings: Cancel clicked.") end
  
  local slider = CreateFrame("Slider", nil, self, "OptionsSliderTemplate") --frameType, frameName, frameParent, frameTemplate   
  slider:SetPoint("CENTER",0,0)
  slider.textLow = _G[name.."Low"]
  slider.textHigh = _G[name.."High"]
  slider.text = _G[name.."Text"]
  slider:SetMinMaxValues(0.65, 4)
  slider.minValue, slider.maxValue = slider:GetMinMaxValues() 
  -- slider.textLow:SetText(slider.minValue)
  -- slider.textHigh:SetText(slider.maxValue)
  -- slider.text:SetText(name)
  slider:SetValue(1)
  slider:SetValueStep(1)
  slider:SetScript("OnValueChanged", function(self,event,arg1) print(event) end)

  InterfaceOptions_AddCategory(self, true)
end


local function scaleMenus(self, event, frame)
  if (self == nil and event == nil and frame ~= nil) then
    frame:UnregisterAllEvents()
    frame = nil
  end
  MainMenuBar:SetMovable(true)
  MainMenuBar:SetUserPlaced(true)
  MainMenuBar:SetMovable(false)
  PlayerFrame:SetScale(FRAMES_SCALE)
  TargetFrame:SetScale(FRAMES_SCALE)
  MainMenuBar:SetScale(BUTTONS_SCALE)
  MicroButtonAndBagsBar:SetScale(BAGS_SCALE)

  for i = 1, #MICRO_BUTTONS do
    _G[MICRO_BUTTONS[i]]:SetScale(BAGS_SCALE)
  end

  -- MultiActionBar_Update()
  -- UIParent_ManageFramePositions()
  ValidateActionBarTransition()
end

local function scaleUp(self, event, a)
  if a == "player" then
    ValidateActionBarTransition()
    C_Timer.After(
      1,
      function()
        if (UnitAffectingCombat("player")) then
          local combatExit = CreateFrame("Frame", nil, UIParent)
          combatExit:RegisterEvent("PLAYER_REGEN_ENABLED")
          combatExit:SetScript(
            "OnEvent",
            function()
              scaleMenus(nil, nil, combatExit)
            end
          )
          return
        end
        scaleMenus()
      end
    )
  end
end

local f = CreateFrame("Frame", nil, UIParent)
f:RegisterEvent("PLAYER_ENTERING_WORLD")
f:HookScript("OnEvent", scaleMenus)

local r = CreateFrame("Frame", nil, UIParent)
r:RegisterEvent("UNIT_ENTERED_VEHICLE")

local exitVehicle = CreateFrame("Frame", nil, UIParent)
exitVehicle:RegisterEvent("UNIT_EXITED_VEHICLE")
exitVehicle:SetScript("OnEvent", scaleUp)

r:SetScript(
  "OnEvent",
  function(self, event, a, b, c)
    if a == "player" and b == true then
      MainMenuBar:SetMovable(true)
      MainMenuBar:SetUserPlaced(false)

      MicroButtonAndBagsBar:SetScale(1)

      for i = 1, #MICRO_BUTTONS do
        _G[MICRO_BUTTONS[i]]:SetScale(1)
      end

      MainMenuBar:ChangeMenuBarSizeAndPosition(true)
      MainMenuBar:SetMovable(true)
      MainMenuBar:SetUserPlaced(false)
      MainMenuBar:ChangeMenuBarSizeAndPosition(true)
    end
  end
)

SLASH_SIMPLEUIRESET1 = "/uireset"
SLASH_SIMPLEUISCALE1 = "/uiscale"
SlashCmdList["SIMPLEUIRESET"] = function()
  MainMenuBar:SetMovable(true)
  MainMenuBar:SetUserPlaced(false)

  MicroButtonAndBagsBar:SetScale(1)

  for i = 1, #MICRO_BUTTONS do
    _G[MICRO_BUTTONS[i]]:SetScale(1)
  end

  MainMenuBar:ChangeMenuBarSizeAndPosition(true)
  MainMenuBar:SetMovable(true)
  MainMenuBar:SetUserPlaced(false)
  MainMenuBar:ChangeMenuBarSizeAndPosition(true)
  ActionBarController_ResetToDefault(true)
  ValidateActionBarTransition()
end

SlashCmdList["SIMPLEUISCALE"] = function()
  scaleMenus()
end
