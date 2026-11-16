if settings.startup["laserfix-color"].value ~= "Disco" then return end

local disco_color_names = { "red", "orange", "yellow", "green", "cyan", "blue", "purple", "magenta" }

-- Map every base laser beam to its 8 disco variants registered in data-updates.lua
local beam_to_disco_map = {}
for name, _ in pairs(data.raw.beam) do
	local lower = string.lower(name)
	if string.find(lower, "laser", 1, true) and not string.find(lower, "disco", 1, true) then
		local variants = {}
		for _, color_name in ipairs(disco_color_names) do
			local variant_name = name .. "-disco-" .. color_name
			if data.raw.beam[variant_name] then
				table.insert(variants, variant_name)
			end
		end
		if #variants > 0 then
			beam_to_disco_map[name] = variants
		end
	end
end

-- Builds a cascading 1-of-N uniform random Trigger using valid BeamTriggerDelivery + nested-result
local function buildUniformRandomBeamAction(beam_names, base_delivery, index)
	index = index or 1
	local remaining = #beam_names - index + 1
	local p = 1 / remaining

	local delivery = table.deepcopy(base_delivery)
	delivery.beam = beam_names[index]

	if index == #beam_names then
		return {
			type = "direct",
			action_delivery = delivery
		}
	end

	return {
		{
			type = "direct",
			probability = p,
			action_delivery = delivery
		},
		{
			type = "direct",
			probability = 1 - p,
			action_delivery = {
				type = "instant",
				target_effects = {
					{
						type = "nested-result",
						action = buildUniformRandomBeamAction(beam_names, base_delivery, index + 1)
					}
				}
			}
		}
	}
end

-- Finds any BeamTriggerDelivery firing one of our mapped laser beams
local function findTargetBeamDelivery(action)
	if type(action) ~= "table" then return nil end
	if action.action_delivery then
		if action.action_delivery.type == "beam" and beam_to_disco_map[action.action_delivery.beam] then
			return action.action_delivery
		end
		for _, del in ipairs(action.action_delivery) do
			if type(del) == "table" and del.type == "beam" and beam_to_disco_map[del.beam] then
				return del
			end
		end
	end
	for _, sub in ipairs(action) do
		local found = findTargetBeamDelivery(sub)
		if found then return found end
	end
	return nil
end

-- Replaces any ammo_type.action firing a mapped laser beam with its Disco variants
local function patchAmmoType(ammo_type)
	if type(ammo_type) ~= "table" then return end
	local ammo_list = ammo_type.action and { ammo_type } or ammo_type
	for _, ammo in pairs(ammo_list) do
		if type(ammo) == "table" and ammo.action then
			local beam_delivery = findTargetBeamDelivery(ammo.action)
			if beam_delivery then
				local disco_variants = beam_to_disco_map[beam_delivery.beam]
				if disco_variants then
					ammo.action = buildUniformRandomBeamAction(disco_variants, beam_delivery, 1)
				end
			end
		end
	end
end

-- Patch all electric turrets (Laser Turrets, K2 Laser Artillery, SE Turrets, etc.)
for _, turret in pairs(data.raw["electric-turret"]) do
	if turret.attack_parameters then
		patchAmmoType(turret.attack_parameters.ammo_type)
	end
end

-- Patch all active defense equipment (Personal Laser Defense MK1/MK2/MK3, etc.)
for _, equip in pairs(data.raw["active-defense-equipment"]) do
	if equip.attack_parameters then
		patchAmmoType(equip.attack_parameters.ammo_type)
	end
end

-- Patch handheld / vehicle laser ammo (K2 Impulse Rifle, Laser Magazines, etc.)
for _, ammo in pairs(data.raw["ammo"]) do
	patchAmmoType(ammo.ammo_type)
end

-- Patch guns with built-in attack_parameters
for _, gun in pairs(data.raw["gun"]) do
	if gun.attack_parameters then
		patchAmmoType(gun.attack_parameters.ammo_type)
	end
end
