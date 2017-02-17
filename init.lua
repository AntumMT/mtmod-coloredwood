-- Colored Wood mod by Vanessa Ezekowitz
-- based on my unifieddyes template.
--
-- License:  WTFPL
--
-- This mod provides 89 colors of wood, fences, and sticks, and enough
-- cross-compatible recipes to make everything fit together naturally.
--
-- Colored wood is created by placing a regular wood block on the ground
-- and then right-clicking on it with some dye.
-- All materials are flammable and can be used as fuel.
--
-- Hues are on a 30 degree spacing starting at red = 0 degrees.
-- "s50" in a file/item name means "saturation: 50%".
-- Texture brightness levels for the colors are 100%, 66% ("medium"),
-- and 33% ("dark").

coloredwood = {}

coloredwood.enable_stairsplus = true
if minetest.setting_getbool("coloredwood_enable_stairsplus") == false or not minetest.get_modpath("moreblocks") then
	coloredwood.enable_stairsplus = false
end

coloredwood.shades = {
	"dark_",
	"medium_",
	""		-- represents "no special shade name", e.g. full.
}

coloredwood.shades2 = {
	"Dark ",
	"Medium ",
	""		-- represents "no special shade name", e.g. full.
}

coloredwood.default_hues = {
	"white",
	"grey",
	"dark_grey",
	"black",
	"violet",
	"blue",
	"cyan",
	"dark_green",
	"green",
	"yellow",
	"orange",
	"red",
	"magenta"
}

coloredwood.hues = {
	"red",
	"orange",
	"yellow",
	"lime",
	"green",
	"aqua",
	"cyan",
	"skyblue",
	"blue",
	"violet",
	"magenta",
	"redviolet"
}

coloredwood.hues2 = {
	"Red ",
	"Orange ",
	"Yellow ",
	"Lime ",
	"Green ",
	"Aqua ",
	"Cyan ",
	"Sky Blue ",
	"Blue ",
	"Violet ",
	"Magenta ",
	"Red-violet "
}

coloredwood.greys = {
	"black",
	"darkgrey",
	"grey",
	"lightgrey",
	"white"
}

coloredwood.greys2 = {
	"Black ",
	"Dark Grey ",
	"Medium Grey ",
	"Light Grey ",
	"White "
}

coloredwood.greys3 = {
	"dye:black",
	"dye:dark_grey",
	"dye:grey",
	"dye:light_grey",
	"dye:white"
}

coloredwood.hues_plus_greys = {}

for _, hue in ipairs(coloredwood.hues) do
	table.insert(coloredwood.hues_plus_greys, hue)
end

table.insert(coloredwood.hues_plus_greys, "grey")

-- helper functions

local function is_stairsplus(name)
	local s1, s2

	local a,b = string.find(name, ":stair")
	if a then s1 = string.sub(name, a+1, b) end

	a,b = string.find(name, ":slab")
	if a then s1 = string.sub(name, a+1, b) end

	a,b = string.find(name, ":panel")
	if a then s1 = string.sub(name, a+1, b) end

	a,b = string.find(name, ":micro")
	if a then s1 = string.sub(name, a+1, b) end

	a,b = string.find(name, ":slope")
	if a then s1 = string.sub(name, a+1, b) end

	local h, s, v = unifieddyes.get_hsv(name)

	a,b = string.find(name, "_"..h..s)
	if a then s2 = string.sub(name, b+1)
		if string.find(s2, "wood") then s2 = string.sub(s2, 5) end
	end
	return s1, s2
end

-- the actual nodes!

for _, color in ipairs(coloredwood.hues_plus_greys) do
	minetest.register_node("coloredwood:wood_"..color, {
		description = "Colored wooden planks",
		tiles = { "coloredwood_base.png" },
		paramtype = "light",
		paramtype2 = "colorfacedir",
		palette = "unifieddyes_palette_"..color.."s.png",
		walkable = true,
		sunlight_propagates = false,
		ud_replacement_node = "coloredwood:wood_"..color,
		groups = {snappy=1,choppy=2,oddly_breakable_by_hand=2,flammable=2, not_in_creative_inventory=1, ud_param2_colorable = 1},
		sounds = default.node_sound_wood_defaults(),
		after_dig_node = unifieddyes.after_dig_node,
		drop = "default:wood"
	})

	-- moreblocks/stairsplus support

	if coloredwood.enable_stairsplus then

	--	stairsplus:register_all(modname, subname, recipeitem, {fields})

		stairsplus:register_all(
			"coloredwood",
			"wood_"..color,
			"coloredwood:wood_"..color,
			{
				description = "Colored wood",
				tiles = { "coloredwood_base.png" },
				paramtype = "light",
				paramtype2 = "colorfacedir",
				palette = "unifieddyes_palette_"..color.."s.png",
				groups = {snappy=1,choppy=2,oddly_breakable_by_hand=2,flammable=2, not_in_creative_inventory=1, ud_param2_colorable = 1},
				after_dig_node = unifieddyes.after_dig_node
			}
		)
	end
end

-- force on_rightclick for stairsplus default wood stair/slab/etc nodes

	if coloredwood.enable_stairsplus then

	for _, i in pairs(minetest.registered_nodes) do
		if string.find(i.name, "moreblocks:stair_wood")
			  or string.find(i.name, "moreblocks:slab_wood")
			  or string.find(i.name, "moreblocks:panel_wood")
			  or string.find(i.name, "moreblocks:micro_wood")
			  or string.find(i.name, "moreblocks:slope_wood") then
			local s1, s2 = is_stairsplus(i.name)
			minetest.override_item(i.name, {
				ud_replacement_node = "coloredwood:"..s1.."_wood_grey",
				paramtype2 = "colorfacedir",
				groups = {choppy = 2, oddly_breakable_by_hand = 2, flammable = 2, wood = 1, not_in_creative_inventory=1, ud_param2_colorable = 1},
			})
		end
	end

	-- fix drops for colored versions of stairsplus nodes

	for _, i in pairs(minetest.registered_nodes) do
		if string.find(i.name, "coloredwood:stair_")
		  or string.find(i.name, "coloredwood:slab_")
		  or string.find(i.name, "coloredwood:panel_")
		  or string.find(i.name, "coloredwood:micro_")
		  or string.find(i.name, "coloredwood:slope_")
			then

			mname = string.gsub(i.name, "coloredwood:", "moreblocks:")
			local s1, s2 = is_stairsplus(mname)

			minetest.override_item(i.name, {
				drop = "moreblocks:"..s1.."_wood"..s2
			})
		end
	end
end

minetest.override_item("default:wood", {
	paramtype2 = "colorfacedir",
	ud_replacement_node = "coloredwood:wood_grey",
	groups = {choppy = 2, oddly_breakable_by_hand = 2, flammable = 2, wood = 1, ud_param2_colorable = 1},
})

minetest.register_node("coloredwood:fence", {
	drawtype = "fencelike",
	description = "Colored wooden fence",
	tiles = { "coloredwood_fence_base.png" },
	paramtype = "light",
	paramtype2 = "color",
	palette = "unifieddyes_palette.png",
	walkable = true,
	groups = {choppy = 2, oddly_breakable_by_hand = 2, flammable = 2, ud_param2_colorable = 1},
	sounds = default.node_sound_wood_defaults(),
	selection_box = {
		type = "fixed",
		fixed = {-1/7, -1/2, -1/7, 1/7, 1/2, 1/7},
	},
	after_dig_node = unifieddyes.after_dig_node,
	drop = "default:fence_wood"
})

minetest.override_item("default:fence_wood", {
	ud_replacement_node = "coloredwood:fence",
	groups = {choppy = 2, oddly_breakable_by_hand = 2, flammable = 2, ud_param2_colorable = 1}
})

-- ============================
-- convert the old static nodes

coloredwood.old_static_nodes = {}

for _, hue in ipairs(coloredwood.hues) do
	for _, sat in ipairs({"", "_s50"}) do
		for _, val in ipairs ({"dark_", "medium_", "light_", ""}) do
			table.insert(coloredwood.old_static_nodes, "coloredwood:wood_"..val..hue..sat)
			table.insert(coloredwood.old_static_nodes, "coloredwood:fence_"..val..hue..sat)
		end
	end
end

for _, shade in ipairs(coloredwood.greys) do
	table.insert(coloredwood.old_static_nodes, "coloredwood:wood_"..shade)
	table.insert(coloredwood.old_static_nodes, "coloredwood:fence_"..shade)
end

-- add all of the stairsplus nodes, if moreblocks is installed.
if coloredwood.enable_stairsplus then
	for _, shape in ipairs(circular_saw.names) do
		local a = shape[1]
		local b = shape[2]
		for _, hue in ipairs(coloredwood.hues) do
			for _, shade in ipairs(coloredwood.shades) do
				table.insert(coloredwood.old_static_nodes, "coloredwood:"..a.."_wood_"..shade..hue..b)
				table.insert(coloredwood.old_static_nodes, "coloredwood:"..a.."_wood_"..shade..hue.."_s50"..b)
			end
			table.insert(coloredwood.old_static_nodes, "coloredwood:"..a.."_wood_light_"..hue..b) -- light doesn't have extra shades or s50
		end
	end

	for _, shape in ipairs(circular_saw.names) do
		local a = shape[1]
		local b = shape[2]
		for _, hue in ipairs(coloredwood.greys) do
			for _, shade in ipairs(coloredwood.shades) do
				table.insert(coloredwood.old_static_nodes, "coloredwood:"..a.."_wood_"..hue..b)
			end
		end
	end
end

minetest.register_lbm({
	name = "coloredwood:convert",
	label = "Convert wood blocks, fences, stairsplus stuff, etc to use param2 color",
	run_at_every_load = false,
	nodenames = coloredwood.old_static_nodes,
	action = function(pos, node)
		local meta = minetest.get_meta(pos)

		if meta and (meta:get_string("dye") ~= "") then return end -- node has already been converted before.

		local name = node.name
		local hue, sat, val = unifieddyes.get_hsv(name)

		local color = val..hue..sat

		local s1, s2 = is_stairsplus(name)

		if s1 then

			local paletteidx, _ = unifieddyes.getpaletteidx("unifieddyes:"..color, true)
			local cfdir = paletteidx + (node.param2 % 32)
			local newname = "coloredwood:"..s1.."_wood_"..hue..s2

			minetest.set_node(pos, { name = newname, param2 = cfdir })
			local meta = minetest.get_meta(pos)
			meta:set_string("dye", "unifieddyes:"..color)

		elseif string.find(name, ":fence") then
			local paletteidx, hue = unifieddyes.getpaletteidx("unifieddyes:"..color, false)
			minetest.set_node(pos, { name = "coloredwood:fence", param2 = paletteidx })
			meta:set_string("dye", "unifieddyes:"..color)
		else
			local paletteidx, hue = unifieddyes.getpaletteidx("unifieddyes:"..color, true)
			if hue ~= 0 and hue ~= nil then
				minetest.set_node(pos, { name = "coloredwood:wood_"..coloredwood.hues[hue], param2 = paletteidx })
				meta:set_string("dye", "unifieddyes:"..color)
			else
				minetest.set_node(pos, { name = "coloredwood:wood_grey", param2 = paletteidx })
				meta:set_string("dye", "unifieddyes:"..color)
			end
		end
	end
})

print("[Colored Wood] Loaded!")
