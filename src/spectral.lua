SMODS.Atlas({key="BaliatroSpectral", path="BaliatroSpectral.png", px = 71, py = 95, atlas_table="ASSET_ATLAS"}):register()

SMODS.Consumable {
	object_type = "Consumable",
	set = "Spectral",
	key = "transcendence",
	pos = { x = 1, y = 0 },
	cost = 10,
	order = 50,
	atlas = "BaliatroSpectral",
	hidden = true, --default soul_rate of 0.3% in spectral packs is used
    soul_rate = 0.006,
	soul_set = "Spectral",
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue+1] = {key = "baliatro_immortal", set="Other"}
		return {vars={}}
	end,

	can_use = function(self, card)
		return #G.hand.highlighted == 1 and not G.hand.highlighted[1].edition
	end,
	use = function(self, card, area, copier)
        local used_tarot = copier or card
        local target = G.hand.highlighted[1]
        target:set_edition({negative = true}, true)
        target:set_immortal(true)
        used_tarot:juice_up(0.3, 0.5)
	end,
}

return {
    name = "Baliatro Spectral",
}