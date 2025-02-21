SMODS.Atlas({key="BaliatroPostcard", path="BaliatroPostcards.png", px = 71, py = 95, atlas_table="ASSET_ATLAS"}):register()
SMODS.Atlas({key="BaliatroPacks", path="BaliatroPacks.png", px = 71, py = 95, atlas_table="ASSET_ATLAS"}):register()

SMODS.ConsumableType {
	object_type = "ConsumableType",
	key = "Postcard",
	primary_colour = HEX("14b341"),
	secondary_colour = HEX("d0fcdd"),
	collection_rows = { 5, 5, 5, },
	shop_rate = 0.0,
	loc_txt = {},
	default = "c_baliatro_tokyo",
	can_stack = false,
    can_divide = false,

    set_badges = function(self, obj, card, badges)
        local cv = {"Common", "Uncommon", "Rare", "Legendary"}
        local ct = cv[obj.rarity] or obj.rarity
        local smr = SMODS.Rarities[ct]
        badges[#badges + 1] = create_badge(localize('k_'..ct:lower()), smr.badge_colour)
    end,

    rarities = {
        { key = "Common" },
        { key = "Uncommon" },
        { key = "Rare" },
    }
}

SMODS.Booster {
	key = "postcard_normal_1",
    name = "Postcard Pack",
	kind = "Postcard",
	atlas = "BaliatroPacks",
	pos = { x = 1, y = 0 },
	config = { extra = 3, choose = 1 },
	cost = 4,
	order = 1,
	weight = 0.95,
    loc_txt = {
		name = "Postcard Pack",
        text = {
            "Choose {C:attention}#1#{} of up to",
            "{C:attention}#2#{} {C:money}Postcards{}",
        }
	},
	create_card = function(self, card)
		return create_card("Postcard", G.pack_cards, nil, nil, true, true, nil, "postcard_pack")
	end,
	ease_background_colour = function(self)
		ease_colour(G.C.DYN_UI.MAIN, mix_colours(G.C.SECONDARY_SET.Planet, G.C.BLACK, 0.9))
		ease_background_colour({ new_colour = G.C.PALE_GREEN, special_colour = G.C.BLACK, contrast = 3 })
	end,
	loc_vars = BALIATRO.booster_pack_locvars,
	group_key = "k_baliatro_postcard_pack",
    set_ability = BALIATRO.booster_pack_set_ability,
}

SMODS.Booster {
	key = "postcard_jumbo_1",
    name = "Jumbo Postcard Pack",
	kind = "Postcard",
	atlas = "BaliatroPacks",
	pos = { x = 2, y = 0 },
	config = { extra = 4, choose = 1 },
	cost = 4,
	order = 2,
	weight = 0.18,
    loc_txt = {
        name = "Jumbo Postcard Pack",
        text = {
            "Choose {C:attention}#1#{} of up to",
            "{C:attention}#2#{} {C:money}Postcards{}",
        }
    },
	create_card = function(self, card)
		return create_card("Postcard", G.pack_cards, nil, nil, true, true, nil, "postcard_pack")
	end,
	ease_background_colour = function(self)
		ease_colour(G.C.DYN_UI.MAIN, mix_colours(G.C.SECONDARY_SET.Planet, G.C.BLACK, 0.9))
		ease_background_colour({ new_colour = G.C.PALE_GREEN, special_colour = G.C.BLACK, contrast = 3 })
	end,
	loc_vars = BALIATRO.booster_pack_locvars,
	group_key = "k_baliatro_postcard_pack",
    set_ability = BALIATRO.booster_pack_set_ability,
}

-- 1. Tokyo
-- Fill your empty joker slots with Photographic Rental Ramens.
SMODS.Consumable {
    set = "Postcard",
    key = "tokyo",
    name = "postcard-Tokyo",
    atlas = "BaliatroPostcard",
	pos = { x = 1, y = 0 },
    cost = 10,
    order = 1,
    rarity = 1,

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = G.P_CENTERS.j_ramen
        info_queue[#info_queue+1] = G.P_CENTERS.e_baliatro_photographic
        info_queue[#info_queue+1] = {key='rental', set='Other', vars={G.GAME.rental_rate or 3}}
        return {vars={}}
    end,

    can_use = function(self, card)
        return #G.jokers.cards < G.jokers.config.card_limit
    end,

    use = function(self, card, area, copier)
        local used_tarot = copier or card
        for i = 1, G.jokers.config.card_limit - #G.jokers.cards do
            G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
                if G.jokers.config.card_limit > #G.jokers.cards then
                    play_sound('timpani')
                    local gen = create_card('Joker', G.jokers, nil, nil, nil, nil, "j_ramen", 'tokyo')
                    gen:set_edition({baliatro_photographic = true})
                    gen:set_rental(true)
                    gen:add_to_deck()
                    G.jokers:emplace(gen)
                    used_tarot:juice_up(0.3, 0.5)
                end
                return true end }))
        end
    end
}



-- 2. Boston
-- Add Photographic to a random joker. If you have no editionless Jokers, create a random Photographic Joker. (must have room)
-- Photographic: Multiplies multiplicative Mult granted by this Joker by X1.1
SMODS.Consumable {
    set = "Postcard",
    key = "boston",
    name = "postcard-Boston",
    atlas = "BaliatroPostcard",
	pos = { x = 2, y = 0 },
    cost = 10,
    order = 2,
    rarity = 3,

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = G.P_CENTERS.e_baliatro_photographic
        return {vars={}}
    end,

    can_use = function(self, card)
        return #BALIATRO.find_editionless_jokers() > 0 or G.jokers.config.card_limit > #G.jokers.cards
    end,

    use = function(self, card, area, copier)
        local used_tarot = copier or card
        local temp_pool = BALIATRO.find_editionless_jokers()
        local eligible_card = nil
        if #temp_pool > 0 then
            eligible_card = pseudorandom_element(temp_pool, pseudoseed('boston'))
        else
            eligible_card = create_card('Joker', G.jokers, nil, nil, nil, nil, nil, 'boston')
            eligible_card:add_to_deck()
            G.jokers:emplace(eligible_card)
        end
        local edition = {baliatro_photographic = true}
        eligible_card:set_edition(edition, true)
        used_tarot:juice_up(0.3, 0.5)
    end
}

-- 3. Nice
-- Add Scenic to a random joker. If you have no editionless Jokers, create a random Scenic Joker. (must have room)
-- Scenic: +0 Chips. Add 5 Chip(s) to this effect each time the Joker with this edition triggers, increase the added amount by 5%, and subtract 0.05% from the next increase.
SMODS.Consumable {
    set = "Postcard",
    key = "nice",
    name = "postcard-Nice",
    atlas = "BaliatroPostcard",
	pos = { x = 3, y = 0 },
    cost = 10,
    order = 3,
    rarity = 1,

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = G.P_CENTERS.e_baliatro_scenic
        return {vars={}}
    end,

    can_use = function(self, card)
        return #BALIATRO.find_editionless_jokers() > 0 or G.jokers.config.card_limit > #G.jokers.cards
    end,

    use = function(self, card, area, copier)
        local used_tarot = copier or card
        local temp_pool = BALIATRO.find_editionless_jokers()
        local eligible_card = nil
        if #temp_pool > 0 then
            eligible_card = pseudorandom_element(temp_pool, pseudoseed('nice'))
        else
            eligible_card = create_card('Joker', G.jokers, nil, nil, nil, nil, nil, 'nice')
            eligible_card:add_to_deck()
            G.jokers:emplace(eligible_card)
        end
        local edition = {baliatro_scenic = true}
        eligible_card:set_edition(edition, true)
        used_tarot:juice_up(0.3, 0.5)
    end
}

-- 4. New York
-- Double most numeric values on a selected, compatible Joker. Does not affect values on Editions. Remove Eternal from the joker. Apply Mortgage to the joker.
SMODS.Consumable {
    set = "Postcard",
    key = "new_york",
    name = "postcard-NewYork",
    atlas = "BaliatroPostcard",
	pos = { x = 4, y = 0 },
    cost = 10,
    order = 4,
    config = {
        odds = 3,
    },
    rarity = 4,
    hidden = true,
    soul_rate = 0.006,
    soul_set = "Postcard",

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = {key='eternal', set='Other'}
        info_queue[#info_queue+1] = {key='baliatro_mortgage', set='Other', vars={G.GAME.mortgage_rate or 15, 12}}
        return { vars = { (G.GAME and G.GAME.probabilities.normal) or 1, card.ability.consumeable.odds }}
    end,

    can_use = function(self, card)
        return #G.jokers.highlighted == 1 and (G.jokers.highlighted[1].config.center.new_york and G.jokers.highlighted[1].config.center.new_york.compatible and not G.jokers.highlighted[1].ability.mortgage)
    end,

    use = function(self, card, area, copier)
        local used_tarot = copier or card
        local doubled_keys = {"mult", "h_mult", "h_x_mult", "h_dollars", "p_dollars", "t_mult", "t_chips", "x_mult", "h_size", "d_size"}
        local joker = G.jokers.highlighted[1]
        local target = joker.ability
        local center = joker.config.center
        for i, key in ipairs(doubled_keys) do
            if target[key] then
                target[key] = target[key] * 2
            end
        end
        if target.extra then
            if type(target.extra) == 'table' then
                for key, value in pairs(target.extra) do
                    if type(value) == 'number' then
                        if not center.new_york or (center.new_york and (not center.new_york.ignore_extra_fields or not center.new_york.ignore_extra_fields[key])) then
                            if center.new_york and center.new_york.divide_extra_fields and center.new_york.divide_extra_fields[key] then
                                target.extra[key] = value / 2.0
                            elseif center.new_york and center.new_york.one_minus_multiply_extra_fields and center.new_york.one_minus_multiply_extra_fields[key] then
                                target.extra[key] = target.extra[key] + target.extra[key] - 1
                            else
                                target.extra[key] = value * 2
                            end
                        end
                    end
                end
            elseif type(target.extra) == 'number' then
                if center.new_york and center.new_york.divide_extra_number then
                    target.extra = math.floor(target.extra / 2.0)
                else
                    target.extra = target.extra * 2
                end
            end
        end
        joker:set_eternal(nil)
        joker:set_mortgage(true)
        --if pseudorandom('newyork') < G.GAME.probabilities.normal / card.ability.consumeable.odds then
        --    joker:set_perishable(true)
        --else
        --    joker:set_mortgage(true)
        --end
        used_tarot:juice_up(0.3, 0.5)
    end
}

-- 5. Budapest
-- Destroy a random joker, create a copy of a random Joker, then apply an Eternal sticker to a random joker.
SMODS.Consumable {
    set = "Postcard",
    key = "budapest",
    name = "postcard-Budapest",
    atlas = "BaliatroPostcard",
	pos = { x = 5, y = 0 },
    cost = 10,
    order = 5,
    rarity = 1,

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = {key='eternal', set='Other'}
        return { vars = {}}
    end,

    can_use = function(self, card)
        return true
    end,

    use = function(self, card, area, copier)
        local used_tarot = copier or card
        local destroy_pool = BALIATRO.find_destructible_jokers()
        local destroyed_joker = nil
        local joker_pool = {}
        if #destroy_pool then
            destroyed_joker = pseudorandom_element(destroy_pool, pseudoseed('budapest'))
            if destroyed_joker then
                G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.3, func = function()
                    destroyed_joker:start_dissolve(nil, nil)
                    used_tarot:juice_up(0.3, 0.5)
                    return true
                end}))
            end
        end
        for i, joker in ipairs(G.jokers.cards) do
            if joker ~= destroyed_joker then
                table.insert(joker_pool, joker)
            end
        end
        if #joker_pool then
            local chosen_joker = pseudorandom_element(joker_pool, pseudoseed('budapest'))
            if chosen_joker then
                G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
                    local copy = copy_card(chosen_joker, nil, nil, nil, nil)
                    copy:start_materialize()
                    copy:add_to_deck()
                    copy:set_edition(nil, true)
                    G.jokers:emplace(copy)
                    used_tarot:juice_up(0.3, 0.5)
                    return true
                end }))
            end
        end
        local eternal_pool = BALIATRO.find_eternalable_jokers()
        if #eternal_pool then
            local eternal_joker = pseudorandom_element(eternal_pool, pseudoseed('budapest'))
            if eternal_joker then
                eternal_joker:set_eternal(true)
                used_tarot:juice_up(0.3, 0.5)
            end
        end
    end
}

-- 6. Mecca
-- Create a random Mortgage Legendary joker. (must have room)
-- Mortgage tagged jokers are Eternal. When a blind is selected or skipped, lose $15. If you go into debt, destroy all jokers, including Eternal and Mortgage jokers. After 12 payments, remove the Mortgage tag.
SMODS.Consumable {
    set = "Postcard",
    key = "mecca",
    name = "postcard-Mecca",
    atlas = "BaliatroPostcard",
	pos = { x = 6, y = 0 },
    cost = 10,
    order = 6,
    rarity = 3,

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = {key='baliatro_mortgage', set='Other', vars={G.GAME.mortgage_rate or 15, 12}}
        return { vars = {}}
    end,

    can_use = function(self, card)
        return #G.jokers.cards < G.jokers.config.card_limit or self.area == G.jokers
    end,

    use = function(self, card, area, copier)
        local used_tarot = copier or card
        G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
            play_sound('timpani')
            local card = create_card('Joker', G.jokers, true, nil, nil, nil, nil, 'mecc')
            card:add_to_deck()
            card:set_mortgage(true)
            G.jokers:emplace(card)
            check_for_unlock{type = 'spawn_legendary'}
            used_tarot:juice_up(0.3, 0.5)
            return true end }))
    end
}

-- 7. Moscow
-- Create 10 random Negative Common Rental jokers.
SMODS.Consumable {
    set = "Postcard",
    key = "moscow",
    name = "postcard-Moscow",
    atlas = "BaliatroPostcard",
	pos = { x = 7, y = 0 },
    cost = 10,
    order = 7,
    config = {
        count = 10,
    },
    rarity = 1,

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = G.P_CENTERS.e_negative
        info_queue[#info_queue+1] = {key='rental', set='Other', vars={G.GAME.rental_rate or 3}}
        return { vars = { card.ability.consumeable.count }}
    end,

    can_use = function(self, card)
        return true
    end,

    use = function(self, card, area, copier)
        local used_tarot = copier or card
        for i = 1, card.ability.consumeable.count do
            G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
                play_sound('timpani')
                local gen = create_card('Joker', G.jokers, nil, 0.01, nil, nil, nil, 'moscow')
                gen:set_edition({negative = true})
                gen:set_rental(true)
                gen:add_to_deck()
                G.jokers:emplace(gen)
                used_tarot:juice_up(0.3, 0.5)
                return true
            end}))
        end
    end
}

-- 8. Amsterdam
-- Add Polychrome to all Editionless Jokers. Permanently lose 1 hand and 1 discard.
SMODS.Consumable {
    set = "Postcard",
    key = "amsterdam",
    name = "postcard-Amsterdam",
    atlas = "BaliatroPostcard",
	pos = { x = 8, y = 0 },
    cost = 10,
    order = 8,
    config = {
        hands = 1,
        discards = 1,
    },
    rarity = 3,

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = G.P_CENTERS.e_polychrome
        return { vars = {card.ability.consumeable.hands, card.ability.consumeable.discards}}
    end,

    can_use = function(self, card)
        return true
    end,

    use = function(self, card, area, copier)
        local used_tarot = copier or card
        local editionless = BALIATRO.find_editionless_jokers()
        for i, joker in ipairs(editionless) do
            joker:set_edition({polychrome = true})
        end
        G.GAME.round_resets.hands = G.GAME.round_resets.hands - card.ability.consumeable.hands
        ease_hands_played(-card.ability.consumeable.hands)
        G.GAME.round_resets.discards = G.GAME.round_resets.discards - card.ability.consumeable.discards
        ease_discard(-card.ability.consumeable.discards)
        used_tarot:juice_up(0.3, 0.5)
    end
}

-- 9. Detroit
-- -3 to Ante if you have no Mortgage Jokers. Create 1 Negative Mortgage Burglar. Ante cannot go below 0 when using this card.
SMODS.Consumable {
    set = "Postcard",
    key = "detroit",
    name = "postcard-Detroit",
    atlas = "BaliatroPostcard",
	pos = { x = 9, y = 0 },
    cost = 10,
    order = 9,
    config = {
        antes = 3,
        burglars = 1,
    },
    rarity = 3,

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = {key='baliatro_mortgage', set='Other', vars={G.GAME.mortgage_rate or 15, 12}}
        info_queue[#info_queue+1] = G.P_CENTERS.e_negative
        info_queue[#info_queue+1] = G.P_CENTERS.j_burglar
        return { vars = { card.ability.consumeable.antes, card.ability.consumeable.burglars }}
    end,

    can_use = function(self, card)
        for i, joker in ipairs(G.jokers.cards) do
            if joker.ability.baliatro_mortgage then
                return false
            end
        end
        return true
    end,

    use = function(self, card, area, copier)
        local used_tarot = copier or card
        ease_ante(-card.ability.consumeable.antes)
        G.GAME.round_resets.blind_ante = G.GAME.round_resets.blind_ante or G.GAME.round_resets.ante
        G.GAME.round_resets.blind_ante = math.max(0, G.GAME.round_resets.blind_ante + -card.ability.consumeable.antes)
        for i = 1, card.ability.consumeable.burglars do
            G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
                play_sound('timpani')
                local gen = create_card('Joker', G.jokers, nil, nil, nil, nil, "j_burglar", 'detroit')
                gen:set_edition({negative = true})
                gen:set_mortgage(true)
                gen:add_to_deck()
                G.jokers:emplace(gen)
                used_tarot:juice_up(0.3, 0.5)
                return true
            end }))
        end
    end
}

-- 10. Las Vegas
-- Create a Transcendence, Soul, Black Hole or Eternal Foil Obelisk. Ignores slot limits. Lose half your dollars.
SMODS.Consumable {
    set = "Postcard",
    key = "las_vegas",
    name = "postcard-LasVegas",
    atlas = "BaliatroPostcard",
	pos = { x = 0, y = 1 },
    cost = 10,
    order = 10,
    config = {
        meme_chance = 0.33,
    },
    rarity = 3,

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = G.P_CENTERS.c_baliatro_transcendence
        info_queue[#info_queue+1] = G.P_CENTERS.c_soul
        info_queue[#info_queue+1] = G.P_CENTERS.c_black_hole
        info_queue[#info_queue+1] = {key='eternal', set='Other'}
        info_queue[#info_queue+1] = G.P_CENTERS.e_foil
        info_queue[#info_queue+1] = G.P_CENTERS.j_obelisk
        return {vars={}}
    end,

    can_use = function(self, card)
        return true
    end,

    use = function(self, card, area, copier)
        local used_tarot = copier or card
        local meme_chance = card.ability.consumeable.meme_chance
        local other_chance = (1 - meme_chance) / 3
        local roll = pseudorandom('lasvegas')
        if roll < other_chance then
            G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
                play_sound('timpani')
                local gen = create_card('Spectral', G.consumeables, nil, nil, nil, nil, "c_soul", 'las_vegas')
                gen:add_to_deck()
                G.consumeables:emplace(gen)
                used_tarot:juice_up(0.3, 0.5)
                return true
            end }))
        elseif roll < other_chance * 2 then
            G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
                play_sound('timpani')
                local gen = create_card('Spectral', G.consumeables, nil, nil, nil, nil, "c_baliatro_transcendence", 'las_vegas')
                gen:add_to_deck()
                G.consumeables:emplace(gen)
                used_tarot:juice_up(0.3, 0.5)
                return true
            end }))
        elseif roll < other_chance * 3 then
            G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
                play_sound('timpani')
                local gen = create_card('Spectral', G.consumeables, nil, nil, nil, nil, "c_black_hole", 'las_vegas')
                gen:add_to_deck()
                G.consumeables:emplace(gen)
                used_tarot:juice_up(0.3, 0.5)
                return true
            end }))
        else
            G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
                play_sound('timpani')
                local gen = create_card('Joker', G.consumeables, nil, nil, nil, nil, "j_obelisk", 'las_vegas')
                gen:set_eternal(true)
                gen:set_edition({foil = true})
                gen:add_to_deck()
                G.jokers:emplace(gen)
                used_tarot:juice_up(0.3, 0.5)
                return true
            end }))
        end
        if G.GAME.dollars > 0 then
            ease_dollars(-math.floor(G.GAME.dollars / 2))
        end
    end
}

-- 11. Monte Carlo
-- Randomly gain one of the following options 2 times, then lose 1 times: 1 Hand Size, 1 Discard, 1 Hand, 1 Consumable Slot, 1 Booster Pack Slot, 3 Interest levels, 3 levels to all Hands
SMODS.Consumable {
    set = "Postcard",
    key = "monte_carlo",
    name = "postcard-MonteCarlo",
    atlas = "BaliatroPostcard",
	pos = { x = 1, y = 1 },
    cost = 10,
    order = 11,
    config = {
        wins = 2,
        losses = 1,
        hand_size = 1,
        discards = 1,
        hands = 1,
        consumable_slots = 1,
        booster_pack_slots = 1,
        interest_levels = 3,
        all_hand_levels = 3,
    },
    rarity = 1,

    loc_vars = function(self, info_queue, card)
        return {vars={
            card.ability.consumeable.wins,
            card.ability.consumeable.losses,
            card.ability.consumeable.hand_size,
            card.ability.consumeable.discards,
            card.ability.consumeable.hands,
            card.ability.consumeable.consumable_slots,
            card.ability.consumeable.booster_pack_slots,
            card.ability.consumeable.interest_levels,
            card.ability.consumeable.all_hand_levels,
        }}
    end,

    can_use = function(self, card)
        return true
    end,

    use = function(self, card, area, copier)
        local used_tarot = copier or card
        used_tarot:juice_up()
        local order = {}
        local options = {"hand_size", "discards", "hands", "consumable_slots", "booster_pack_slots", "interest_levels", "all_hand_levels"}
        for i = 1, card.ability.consumeable.wins do
            order[#order+1] = 1
        end
        for i = 1, card.ability.consumeable.losses do
            order[#order+1] = -1
        end
        local delay_subsequent = 1.2
        for idx, outcome in ipairs(order) do
            local delay_events = (idx == 1 and 0.2) or delay_subsequent
            local odds = 1 / #options
            local roll = pseudorandom('montecarlo')
            for i, option in ipairs(options) do
                if roll <= i * odds then
                    if option == 'hand_size' then
                        G.E_MANAGER:add_event(Event({trigger = 'after', delay = delay_events, blockable = true,
                        func = function()
                            local amt = card.ability.consumeable.hand_size * outcome
                            G.hand:change_size(amt)
                            card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize{type='variable',key='a_baliatro_monte_carlo_hand_size',vars={amt}}})
                            return true
                        end}))
                    elseif option == 'discards' then
                        G.E_MANAGER:add_event(Event({trigger = 'after', delay = delay_events, blockable = true,
                        func = function()
                            local amt = card.ability.consumeable.discards * outcome
                            G.GAME.round_resets.discards = G.GAME.round_resets.discards + amt
                            ease_discard(amt)
                            card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize{type='variable',key='a_baliatro_monte_carlo_discards',vars={amt}}})
                            return true
                        end}))
                    elseif option == 'hands' then
                        G.E_MANAGER:add_event(Event({trigger = 'after', delay = delay_events, blockable = true,
                        func = function()
                            local amt = card.ability.consumeable.hands * outcome
                            G.GAME.round_resets.hands = G.GAME.round_resets.hands + amt
                            ease_hands_played(amt)
                            card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize{type='variable',key='a_baliatro_monte_carlo_hands',vars={amt}}})
                            return true
                        end}))
                    elseif option == 'consumable_slots' then
                        G.E_MANAGER:add_event(Event({trigger = 'after', delay = delay_events, blockable = true,
                        func = function()
                            local amt = card.ability.consumeable.consumable_slots * outcome
                            G.consumeables.config.card_limit = G.consumeables.config.card_limit + amt
                            card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize{type='variable',key='a_baliatro_monte_carlo_consumable_slots',vars={amt}}})
                            return true
                        end}))
                    elseif option == 'booster_pack_slots' then
                        G.E_MANAGER:add_event(Event({trigger = 'after', delay = delay_events, blockable = true,
                        func = function()
                            local amt = card.ability.consumeable.booster_pack_slots * outcome
                            G.GAME.shop_booster_packs = G.GAME.shop_booster_packs + amt
                            card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize{type='variable',key='a_baliatro_monte_carlo_booster_pack_slots',vars={amt}}})
                            -- todo: booster packs should immediately become available or disappear in shop
                            return true
                        end}))
                    elseif option == 'interest_levels' then
                        G.E_MANAGER:add_event(Event({trigger = 'after', delay = delay_events, blockable = true,
                        func = function()
                            local amt = card.ability.consumeable.interest_levels * outcome
                            BALIATRO.use_special_planet("baliatro_interest", nil, nil, amt, true)
                            card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize{type='variable',key='a_baliatro_monte_carlo_interest_levels',vars={amt}}})
                            return true
                        end}))
                    elseif option == 'all_hand_levels' then
                        G.E_MANAGER:add_event(Event({trigger = 'after', delay = delay_events, blockable = true,
                        func = function()
                            local amt = card.ability.consumeable.all_hand_levels * outcome
                            for k, v in pairs(G.GAME.hands) do
                                local hamt = amt
                                if hamt < 0 and G.GAME.hands[k].level > 1 then
                                    hamt = math.max(hamt, 1 - G.GAME.hands[k].level)
                                end
                                if hamt ~= 0 then
                                    level_up_hand(nil, k, true, amt)
                                end
                            end
                            card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize{type='variable',key='a_baliatro_monte_carlo_all_hand_levels',vars={amt}}})
                            return true
                        end}))
                    end
                    break
                end
            end
        end
    end
}


-- 12. Munich
-- Remove Perishable and Negative from a random Perishable Joker. If you have no Perishable Jokers, gain +1 Consumable Slot instead.
SMODS.Consumable {
    set = "Postcard",
    key = "munich",
    name = "postcard-Munich",
    atlas = "BaliatroPostcard",
	pos = { x = 2, y = 1 },
    cost = 10,
    order = 12,
    config = {
        consumable_slots = 1,
        joker_slots = 1,
    },
    rarity = 2,

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = {key='perishable', set='Other', vars = {G.GAME.perishable_rounds or 1, G.GAME.perishable_rounds}}
        info_queue[#info_queue+1] = G.P_CENTERS.e_negative
        return { vars = {card.ability.consumeable.joker_slots, card.ability.consumeable.consumable_slots}}
    end,

    can_use = function(self, card)
        return true
    end,

    use = function(self, card, area, copier)
        local used_tarot = copier or card
        local perishables = BALIATRO.collect_perishables()
        if #perishables > 0 then
            local target = pseudorandom_element(perishables, pseudoseed('munich'))
            target:clear_perishable()
            target:set_debuff()
            if target.edition.key == 'e_negative' then
                target:set_edition(nil, true, true)
            end
            card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize{type='variable',key='a_baliatro_minus_joker_slots',vars={card.ability.consumeable.joker_slots}}})
            --G.jokers.config.card_limit = G.jokers.config.card_limit - card.ability.consumeable.joker_slots
        else
            card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize{type='variable',key='a_baliatro_plus_consumable_slots',vars={card.ability.consumeable.consumable_slots}}})
            G.consumeables.config.card_limit = G.consumeables.config.card_limit + card.ability.consumeable.consumable_slots
        end
        used_tarot:juice_up()
    end
}


-- 13. Paris
-- Each card in your current deck has a 1 in 8 chance to gain a random enhancement, 1 in 16 to chance to gain a random seal and 1 in 24 chance to gain a random non-negative edition. Cards that gain at least two of these also gain Immortal.
SMODS.Consumable {
    set = "Postcard",
    key = "paris",
    name = "postcard-Paris",
    atlas = "BaliatroPostcard",
	pos = { x = 3, y = 1 },
    cost = 10,
    order = 13,
    config = {
        enhancement_odds = 5,
        seal_odds = 10,
        edition_odds = 10,
    },
    rarity = 3,

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = {key = "baliatro_immortal", set="Other"}
        return { vars = {(G.GAME and G.GAME.probabilities.normal) or 1, card.ability.consumeable.enhancement_odds, card.ability.consumeable.seal_odds, card.ability.consumeable.edition_odds}}
    end,

    can_use = function(self, card)
        return true
    end,

    use = function(self, card, area, copier)
        local used_tarot = copier or card
        for _, playing_card in ipairs(G.deck.cards) do
            local counter = 0
            if playing_card.config.center.key == "c_base" and pseudorandom('paris') < G.GAME.probabilities.normal / card.ability.consumeable.enhancement_odds then
                counter = counter + 1
                playing_card:set_ability(G.P_CENTERS[SMODS.poll_enhancement({guaranteed = true})])
            end
            if not playing_card.seal and pseudorandom('paris') < G.GAME.probabilities.normal / card.ability.consumeable.seal_odds then
                counter = counter + 1
                playing_card:set_seal(SMODS.poll_seal({guaranteed = true}))
            end
            if not playing_card.edition  and pseudorandom('paris') < G.GAME.probabilities.normal / card.ability.consumeable.edition_odds then
                counter = counter + 1
                playing_card:set_edition(poll_edition('paris', 1, false, true))
                if playing_card.edition.negative then
                    counter = counter + 2
                end
            end
            if counter >= 2 then
                playing_card:set_immortal(true)
            end
        end
        used_tarot:juice_up()
    end
}

-- 14. London
-- Upgrade up to 2 compatible Common jokers. Upgraded Jokers cannot be Perishable, but retain all other stickers. Lose $10
SMODS.Consumable {
    set = "Postcard",
    key = "london",
    name = "postcard-London",
    atlas = "BaliatroPostcard",
	pos = { x = 4, y = 1 },
    cost = 10,
    order = 14,
    config = {
        max = 1,
        prob = 3,
        odds = 4,
        lose = 10,
    },
    rarity = 1,

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = {key='perishable', set='Other', vars = {G.GAME.perishable_rounds or 1, G.GAME.perishable_rounds}}
        return { vars = {card.ability.consumeable.max, card.ability.consumeable.prob, card.ability.consumeable.odds, card.ability.consumeable.lose }}
    end,

    can_use = function(self, card)
        if #G.jokers.highlighted >= 1 and #G.jokers.highlighted <= card.ability.consumeable.max then
            for i, highlight in ipairs(G.jokers.highlighted) do
                if highlight.config.center.rarity ~= 1 then
                    return false
                end
                if not highlight.config.center.upgrades_to then
                    return false
                end
            end
            return true
        end
        return false
    end,

    use = function(self, card, area, copier)
        local used_tarot = copier or card
        for i, highlight in ipairs(G.jokers.highlighted) do
            local apply_perish = false
            if highlight.edition and highlight.edition.negative and G.GAME.probabilities.normal * card.ability.consumeable.prob / card.ability.consumeable.odds < pseudorandom('london') then
                apply_perish = true
            end
            BALIATRO.upgrade_joker(highlight, apply_perish)
        end
        ease_dollars(-card.ability.consumeable.lose)
        G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.2,func = function() G.jokers:unhighlight_all(); return true end }))
        used_tarot:juice_up()
    end
}

-- 15. Cairo
-- Apply Eternal to up to 1 selected non-Perishable Joker. Create 1 Ankh.
SMODS.Consumable {
    set = "Postcard",
    key = "cairo",
    name = "postcard-Cairo",
    atlas = "BaliatroPostcard",
	pos = { x = 5, y = 1 },
    cost = 10,
    order = 12,
    config = {
        max = 1,
        created_amt = 1,
        created_set = 'Spectral',
        created_card = 'c_ankh',
    },
    rarity = 2,

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = {key='perishable', set='Other', vars = {G.GAME.perishable_rounds or 1, G.GAME.perishable_rounds}}
        info_queue[#info_queue+1] = {key='eternal', set='Other', vars = {}}
        return { vars = {card.ability.consumeable.max, card.ability.consumeable.created_amt}}
    end,

    can_use = function(self, card)
        if #G.jokers.highlighted > 0 and #G.jokers.highlighted <= card.ability.consumeable.max then
            for _, joker in ipairs(G.jokers.highlighted) do
                if joker.ability.perishable then
                    return false
                end
            end
            return true
        end
        return false
    end,

    use = function(self, card, area, copier)
        local used_tarot = copier or card
        for _, joker in ipairs(G.jokers.highlighted) do
            joker:set_eternal(true)
        end
        BALIATRO.guided_create_card(card.ability.consumeable.created_amt, card.ability.consumeable.created_set, card.ability.consumeable.created_card, 'cairo')
        used_tarot:juice_up()
    end
}

-- 16. Copenhagen
-- The times each hand type was played and the times each rank was scored is set to the double of highest of each.
SMODS.Consumable {
    set = "Postcard",
    key = "copenhagen",
    name = "postcard-Copenhagen",
    atlas = "BaliatroPostcard",
	pos = { x = 6, y = 1 },
    cost = 10,
    order = 16,
    config = {
    },
    rarity = 2,

    can_use = function(self, card)
        return true
    end,

    use = function(self, card, area, copier)
        local used_tarot = copier or card
        local mph = BALIATRO.most_played_hand_times() * 2
        local msr = BALIATRO.most_scored_rank_scores() * 2
        for k, v in pairs(G.GAME.hands) do
            v.played = mph
        end
        for k, _ in pairs(G.GAME.ranks_scored) do
            G.GAME.ranks_scored[k] = msr
        end
        used_tarot:juice_up()
    end
}

-- 17. Singapore
-- Increase the rank of all cards in your deck by one. Fill your empty consumeable slots with Strength.
SMODS.Consumable {
    set = "Postcard",
    key = "singapore",
    name = "postcard-Singapore",
    atlas = "BaliatroPostcard",
	pos = { x = 7, y = 1 },
    cost = 10,
    order = 17,
    config = {
    },
    rarity = 2,

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = G.P_CENTERS['c_strength']
        return { vars = {}}
    end,

    can_use = function(self, card)
        return true
    end,

    use = function(self, card, area, copier)
        local used_tarot = copier or card
        for _, playing_card in ipairs(G.deck.cards) do
            local rank = SMODS.Ranks[playing_card.base.value]
            local new_rank = rank.next[1]
            SMODS.change_base(playing_card, nil, new_rank)
        end
        G.E_MANAGER:add_event(Event({
            trigger = 'before',
            delay = 0.0,
            func = (function()
                for i = #G.consumeables.cards + G.GAME.consumeable_buffer, G.consumeables.config.card_limit do
                    local created_card = create_card("Tarot", G.consumeables, nil, nil, nil, nil, "c_strength", "singapore")
                    created_card:add_to_deck()
                    G.consumeables:emplace(created_card)
                    G.GAME.consumeable_buffer = 0
                end
                return true
            end )
        }))

        used_tarot:juice_up()
    end
}

-- 18. Kyoto
-- Apply Haunted to 2 random cards in your deck.
SMODS.Consumable {
    set = "Postcard",
    key = "kyoto",
    name = "postcard-Kyoto",
    atlas = "BaliatroPostcard",
	pos = { x = 8, y = 1 },
    cost = 10,
    order = 17,
    config = {
        amt = 4,
    },
    rarity = 2,

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = G.P_CENTERS.e_baliatro_haunted
        return { vars = {card.ability.consumeable.amt}}
    end,

    can_use = function(self, card)
        return true
    end,

    use = function(self, card, area, copier)
        local used_tarot = copier or card
        local targets = BALIATRO.collect_haunted_targets(card.ability.consumeable.amt)
        for i, other in ipairs(targets) do
            other:set_edition('e_baliatro_haunted')
        end
        used_tarot:juice_up()
    end
}

return {
    name = "Baliatro Postcards",
}