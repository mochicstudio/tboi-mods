local mod = RegisterMod("DottinDips", 1)
local game = Game()

local DipVariant = {
	DOT = Isaac.GetEntityVariantByName("Dot")
}
local DOT_CHANCE = 25
local Dots = {}

function hsb2rgb(hue, saturation, brightness, alpha)
	while hue > 1 do
		hue = hue -1
	end

	if (saturation <= 0) then
		return Color(brightness, brightness, brightness, alpha, 0, 0, 0)
	end

	local H = hue * 6
	local I = math.floor(H)
	local F = H - I
	local P = brightness * (1.0 - saturation)
	local Q = brightness * (1.0 - (saturation * F))
	local T = brightness * (1.0 - (saturation * (1.0 -F)))

	if I == 0 then
		return Color(brightness, T, P, alpha, 0, 0, 0)
	elseif I == 1 then
		return Color(Q, brightness, P, alpha, 0, 0, 0)
	elseif I == 2 then
		return Color(P, brightness, T, alpha, 0, 0, 0)
	elseif I == 3 then
		return Color(P, Q, brightness, alpha, 0, 0, 0)
	elseif I == 4 then
		return Color(T, P, brightness, alpha, 0, 0, 0)
	else
		return Color(brightness, P, Q, alpha, 0, 0, 0)
	end
end

-- Only for debug
-- function Dots:onUpdate(player)
-- 	if game:GetFrameCount() == 1 then
-- 		for x = 0,2 do
-- 			for y = 0,2 do
-- 				Isaac.Spawn(EntityType.ENTITY_DIP, 0, 0, Vector(270 + 50 * x, 200 + 50 * y), Vector(0,0), nil)
-- 			end
-- 		end
-- 	end
-- end

function Dots:NPCUpdate(Dip)
	local DipData = Dip:GetData()

	if type(DipData) == "table" and DipData.DipInit == nil and Dip:IsActiveEnemy() then
		DipData.DipInit = true
		if Dip.Variant == 0 and math.random(50) <= DOT_CHANCE then
			local NewDip = Isaac.Spawn(EntityType.ENTITY_DIP, DipVariant.DOT, 0, Dip.Position, Vector(0,0), nil)
			NewDip:SetColor(hsb2rgb(math.random(100)/100, 1, 1, 1), 0, 0, false, false)
			NewDip:GetData().DipInit = true
			Dip:Remove()

			-- If your enemy variant has the same HP as the neutral one you can use Morph
			-- Dip:Morph(EntityType.ENTITY_DIP, DipVariant.DOT, 0, 0)
		end

		-- If you spawn variant from a room type, we set the color. Not on this case.
		-- if Dip.Variant == DipVariant.DOT then
		-- 	Dip:SetColor(hsb2rgb(math.random(100)/100, 1, 1, 1), 0, 0, false, false)
		-- end
	end

	-- AI, kind of
	if Dip.Variant == DipVariant.DOT and Dip:GetPlayerTarget() ~= nil then
		Dip.Velocity = (Dip:GetPlayerTarget().Position - Dip.Position):Normalized() * Dip.Velocity:Length()
	end
end

-- Only for debug
-- mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, Dots.onUpdate)
mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, Dots.NPCUpdate, EntityType.ENTITY_DIP)