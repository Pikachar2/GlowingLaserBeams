local graphics_location = "__GlowingLaserBeams__/graphics/"
local double_tint = settings.startup["laserfix-doubletint"].value
local color_mode = settings.startup["laserfix-color"].value

-- Safely applies custom sprites and tints to any beam prototype (vanilla or modded)
local function applyBeamStyle(beam, color, glow_color)
	local gs = beam.graphics_set
	if not gs or not gs.beam then return end

	local function stylePart(part, color_png, light_png)
		if not part then return end
		if part.layers and part.layers[1] then
			part.layers[1].filename = graphics_location .. color_png
			part.layers[1].tint = color
			if part.layers[2] then
				part.layers[2].filename = graphics_location .. light_png
				if double_tint then
					part.layers[2].tint = color
				end
			end
		elseif part.filename then
			part.tint = color
		end
	end

	-- Head
	gs.beam.head = table.deepcopy(gs.beam.head)
	stylePart(gs.beam.head, "beam-body-color.png", "hr-laser-body-light.png")

	-- Tail
	gs.beam.tail = table.deepcopy(gs.beam.tail)
	stylePart(gs.beam.tail, "beam-end-color.png", "beam-end-light.png")

	-- Body
	gs.beam.body = table.deepcopy(gs.beam.body)
	if gs.beam.body and gs.beam.body[1] then
		for i = 1, #gs.beam.body do
			stylePart(gs.beam.body[i], "beam-body-color.png", "hr-laser-body-light.png")
		end
	else
		stylePart(gs.beam.body, "beam-body-color.png", "hr-laser-body-light.png")
	end

	-- Ground glow
	if gs.ground then
		if gs.ground.head then gs.ground.head.tint = glow_color end
		if gs.ground.tail then gs.ground.tail.tint = glow_color end
		if gs.ground.body then gs.ground.body.tint = glow_color end
	end
end

-- Auto-detect all vanilla and modded laser beam prototypes
local target_beams = {}
for name, beam in pairs(data.raw.beam) do
	local lower = string.lower(name)
	if string.find(lower, "laser", 1, true) and not string.find(lower, "disco", 1, true) then
		table.insert(target_beams, beam)
	end
end

if color_mode == "Disco" then
	local disco_colors = {
		{ name = "red",     c = {r = 1.0, g = 0.1, b = 0.1}, g = {r = 0.5,  g = 0.05, b = 0.05} },
		{ name = "orange",  c = {r = 1.0, g = 0.5, b = 0.0}, g = {r = 0.5,  g = 0.25, b = 0.0}  },
		{ name = "yellow",  c = {r = 1.0, g = 1.0, b = 0.1}, g = {r = 0.5,  g = 0.5,  b = 0.05} },
		{ name = "green",   c = {r = 0.1, g = 1.0, b = 0.1}, g = {r = 0.05, g = 0.5,  b = 0.05} },
		{ name = "cyan",    c = {r = 0.1, g = 1.0, b = 1.0}, g = {r = 0.05, g = 0.5,  b = 0.5}  },
		{ name = "blue",    c = {r = 0.2, g = 0.4, b = 1.0}, g = {r = 0.1,  g = 0.2,  b = 0.5}  },
		{ name = "purple",  c = {r = 0.7, g = 0.1, b = 1.0}, g = {r = 0.35, g = 0.05, b = 0.5}  },
		{ name = "magenta", c = {r = 1.0, g = 0.1, b = 0.7}, g = {r = 0.5,  g = 0.05, b = 0.35} },
	}

	for _, base_beam in ipairs(target_beams) do
		applyBeamStyle(base_beam, disco_colors[1].c, disco_colors[1].g)

		for _, entry in ipairs(disco_colors) do
			local new_beam = table.deepcopy(base_beam)
			new_beam.name = base_beam.name .. "-disco-" .. entry.name
			applyBeamStyle(new_beam, entry.c, entry.g)
			data:extend({ new_beam })
		end
	end
else
	local core_color = settings.startup["laserfix-core-color"].value
	local glow_color = settings.startup["laserfix-glow-color"].value

	for _, base_beam in ipairs(target_beams) do
		applyBeamStyle(base_beam, core_color, glow_color)
	end
end
