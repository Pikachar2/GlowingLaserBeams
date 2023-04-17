local laser_beam_blend_mode = "additive"
local r = 1
local g = 0
local b = 0
local glow_r = 0.5
local glow_g = 0.05
local glow_b = 0.05
local path = ""
local glow_blend_mode = nil
local graphics_location = "__GlowingLaserBeams__/graphics/"
local laserBeam = "laser-beam"


	--if settings.startup["laserfix-color"].value == "'Disco'" then
	--	r = 1
	--	g = 1
	--	b = 1
	--	glow_r = 1
	--	glow_g = 1
	--	glow_b = 1
	--	path = "disco/"
	--else
		r = settings.startup["laserfix-r"].value
		g = settings.startup["laserfix-g"].value
		b = settings.startup["laserfix-b"].value
		glow_r=settings.startup["laserfix-glow-r"].value
		glow_g=settings.startup["laserfix-glow-g"].value
		glow_b=settings.startup["laserfix-glow-b"].value
	--end
	
	data.raw.beam[laserBeam].head =
	{
		layers = 
		{
			table.deepcopy(data.raw.beam[laserBeam].head),
			table.deepcopy(data.raw.beam[laserBeam].head)
		}
	}
	data.raw.beam[laserBeam].head.layers[1].filename = graphics_location .. "beam-body-color.png"
	data.raw.beam[laserBeam].head.layers[1].tint = {r=r,g=g,b=b}
	data.raw.beam[laserBeam].head.layers[2].filename = graphics_location .. "beam-body-light.png"
	
	data.raw.beam[laserBeam].tail =
	{
		layers = 
		{
			table.deepcopy(data.raw.beam[laserBeam].tail),
			table.deepcopy(data.raw.beam[laserBeam].tail)			
		}
	}
	data.raw.beam[laserBeam].tail.layers[1].filename = graphics_location .. "beam-end-color.png"
	data.raw.beam[laserBeam].tail.layers[1].tint = {r=r,g=g,b=b}
	data.raw.beam[laserBeam].tail.layers[2].filename = graphics_location .. "beam-end-light.png"
	
	data.raw.beam[laserBeam].body =
    {
		layers = 
		{
			table.deepcopy(data.raw.beam[laserBeam].body[1]),
			table.deepcopy(data.raw.beam[laserBeam].body[1])			
		}
    }
data.raw.beam[laserBeam].body.layers[1].filename = graphics_location .. "beam-body-color.png"
data.raw.beam[laserBeam].body.layers[1].tint = {r=r,g=g,b=b}
data.raw.beam[laserBeam].body.layers[2].filename = graphics_location .. "beam-body-light.png"

if settings.startup["laserfix-doubletint"].value then
	data.raw.beam[laserBeam].head.layers[2].tint = {r=r,g=g,b=b}
	data.raw.beam[laserBeam].tail.layers[2].tint = {r=r,g=g,b=b}
	data.raw.beam[laserBeam].body.layers[2].tint = {r=r,g=g,b=b}
end

data.raw.beam[laserBeam].ground_light_animations.head.tint = {r=glow_r,g=glow_g,b=glow_b}
data.raw.beam[laserBeam].ground_light_animations.tail.tint = {r=glow_r,g=glow_g,b=glow_b}
data.raw.beam[laserBeam].ground_light_animations.body.tint = {r=glow_r,g=glow_g,b=glow_b}


data.raw.beam[laserBeam].light_animations.head.filename = graphics_location .. "hr-laser-body-light.png"
data.raw.beam[laserBeam].light_animations.body[1].filename = graphics_location .. "hr-laser-body-light.png"
