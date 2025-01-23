SMODS.Consumable {
	object_type = "Consumable",
	set = "Tarot",
	key = "ace_of_wands",
	pos = { x = 0, y = 0 },
	cost = 4,
	order = 23,
	atlas = "BaliatroSpectral",
	config = {
		targets = 1,
	},

	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue+1] = G.P_CENTERS["e_baliatro_faded_foil"]
		info_queue[#info_queue+1] = G.P_CENTERS["e_baliatro_faded_holo"]
		info_queue[#info_queue+1] = G.P_CENTERS["e_baliatro_faded_polychrome"]
		return {vars={(card and card.ability.consumeable.targets) or self.config.targets}}
	end,

	can_use = function(self, card)
		if #G.hand.highlighted > 0 and #G.hand.highlighted <= card.ability.consumeable.targets then
			for i, highlight in ipairs(G.hand.highlighted) do
				if highlight.edition then
					return false
				end
			end
			return true
		end
		return false
	end,

	use = function(self, card, area, copier)
        local used_tarot = copier or card
		local roll = pseudorandom(pseudoseed('aoc'))
		local ed = {}
		if roll < 1 / 3 then
			ed = {baliatro_faded_foil = true}
		elseif roll < 2 / 3 then
			ed = {baliatro_faded_holo = true}
		else
			ed = {baliatro_faded_polychrome = true}
		end
		for i, highlight in ipairs(G.hand.highlighted) do
			highlight:set_edition(ed, true)
		end
        used_tarot:juice_up(0.3, 0.5)
	end,
}

return {
    name = "Baliatro Tarot",
}