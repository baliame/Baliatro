SMODS.Atlas({key="BaliatroSpectral", path="BaliatroSpectral.png", px = 71, py = 95, atlas_table="ASSET_ATLAS"})

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
	config = {
		max_highlighted = 2,
		min_highlighted = 1,
	},
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue+1] = G.P_CENTERS['e_negative_playing_card']
		info_queue[#info_queue+1] = {key = "baliatro_immortal", set="Other"}
		return {vars={(card and card.ability.consumeable.max_highlighted) or self.config.max_highlighted}}
	end,

	can_use = function(self, card)
		for _, other in ipairs(G.hand.highlighted) do
			if other.edition then return false end
		end
		return #G.hand.highlighted >= card.ability.consumeable.min_highlighted and #G.hand.highlighted <= card.ability.consumeable.max_highlighted
	end,
	use = function(self, card, area, copier)
        local used_tarot = copier or card
		for _, other in ipairs(G.hand.highlighted) do
        	other:set_edition({negative = true}, true)
        	other:set_immortal(true)
		end
        used_tarot:juice_up(0.3, 0.5)
	end,
}

return {
    name = "Baliatro Spectral",
}
