-- First, we create a namespace for our addon by declaring a top-level table that will hold everything else.
NeverForget = {}
local BLACKLIST_NO_FOOD_DRINK_BUFFS =
{
	43752,63570,66776,77123,85501,85502,85503,86755,91369,92232,99462,99463,118985,116467
}

local DRINK_BUFF_ABILITIES = {
	61322,
	61325, 
61328,
	61335, 
	61340, 
	61345, 
	61350, 
	66125, 
	66132, 
	66137, 
	66141, 
	66586, 
	66590, 
	66594,
	68416, 
	72816, 
	72965,
	72968, 
	72971,
	84700,
	84704,
	84720,
	84731,
	84732,
	84733,
	84735,
	85497,
	86559,
	86560,
	86673,
	86674,
	86677,
	86678,
	86746,
	86747,
	86791,
	89957,
	92433,
	92476,
	100488,
	127531
}

local FOOD_BUFF_ABILITIES = {
	17407,
	17577,
	17581,
	17608,
	17614,
	61218,
	61255,
	61257,
	61259,
	61260,
	61261,
	61294,
	66128,
	66130,
	66551,
	66568,
	66576,
	68411,
	72819,
	72822,
	72824,
	72956,
	72959,
	72961,
	84678,
	84681,
	84709,
	84725,
	84736,
	85484,
	86749,
	86787,
	86789,
	89955,
	89971,
	92435,
	92437,
	92474,
	92477,
	100498,
	100502,
	107748,
	107789,
	127537,
	127572,
	127578,
	127596,
	127619,
	127736,
}
-- This isn't strictly necessary, but we'll use this string later when registering events.
-- Better to define it in a single place rather than retyping the same string.
NeverForget.name = "NeverForget"
 
-- Next we create a function that will initialize our addon
function NeverForget:Initialize()

	self.savedVariables = ZO_SavedVars:New("NeverForgetSavedVariables", 1, nil, {})
	self:RestorePosition()
	EVENT_MANAGER:RegisterForEvent(self.name, EVENT_EFFECT_CHANGED  , self.OnPlayerBuffed)
end
 
-- Then we create an event handler function which will be called when the "addon loaded" event
-- occurs. We'll use this to initialize our addon after all of its resources are fully loaded.
function NeverForget.OnAddOnLoaded(event, addonName)
  -- The event fires each time *any* addon loads - but we only care about when our own addon loads.
  if addonName == NeverForget.name then
    NeverForget:Initialize()
  end
end
 
-- Finally, we'll register our event handler function to be called when the proper event occurs.
EVENT_MANAGER:RegisterForEvent(NeverForget.name, EVENT_ADD_ON_LOADED , NeverForget.OnAddOnLoaded)

--Event handler for status change

function NeverForget.OnPlayerBuffed()
	local buffActive = IsFoodBuffActive("player")
	updateUI(buffActive);
end

function IsFoodBuffActive(unitTag)
-- Returns 1: bool isBuffActive
	local numBuffs = GetNumBuffs(unitTag)
	if numBuffs > 0 then
		local abilityId, buffTypeFoodDrink
		for i = 1, numBuffs do
			abilityId = select(11, GetUnitBuffInfo(unitTag, i))
			buffTypeFoodDrink = GetIfFoodOrDrinkBuff(abilityId)
			if buffTypeFoodDrink then
				return true
			end
		end
	end
	return false
end

function GetIfFoodOrDrinkBuff(abilityId)
	if inarray(DRINK_BUFF_ABILITIES, abilityId) then return true end
	if inarray(FOOD_BUFF_ABILITIES, abilityId) then return true end
	return false
end

function inarray(tab, val)
    for index, value in ipairs(tab) do
        if value == val then
            return true
        end
    end

    return false
end

function updateUI(state)
  NeverForgetIndicator:SetHidden(state)
end

function NeverForget.OnIndicatorMoveStop()
  NeverForget.savedVariables.left = NeverForgetIndicator:GetLeft()
  NeverForget.savedVariables.top = NeverForgetIndicator:GetTop()
end

function NeverForget:RestorePosition()
  local left = self.savedVariables.left
  local top = self.savedVariables.top
 
  NeverForgetIndicator:ClearAnchors()
  NeverForgetIndicator:SetAnchor(TOPLEFT, GuiRoot, TOPLEFT, left, top)
end