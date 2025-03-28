SMODS.Atlas({key="Baliatro", path="Baliatro.png", px = 71, py = 95, atlas_table="ASSET_ATLAS"})

-- 1. Red Ulti
-- Last played hand is a 7 Hearts High Card -> Win
-- Uncommon
SMODS.Joker {
    name = "Red Ulti",
    key = "redulti",
    config = {
        extra = {
            activated = false,
        }
    },
    pos = {
        x = 1,
        y = 0,
    },
    unlocked = true,
    blueprint_compat = false,
    eternal_compat = false,
    perishable_compat = true,
    cost = 6,
    rarity = 2,
    atlas = "Baliatro",

    new_york = {
        compatible = false,
        divide_extra_fields = {},
        ignore_extra_fields = {},
        divide_extra_number = false,
        one_minus_multiply_extra_fields = {},
    },

    calculate = function(self, card, context)
        if not card.ability.extra.activated and not context.blueprint and context.cardarea == G.jokers and context.joker_main and G.GAME.current_round.hands_left == 0 and not G.GAME.current_round.ulti then
            G.GAME.current_round.ulti = true
            if #context.scoring_hand == 1 then
                local scored_card = context.scoring_hand[1]
                if scored_card:is_suit("Hearts") and scored_card.base.value == '7' and not scored_card.debuff then
                    card.ability.extra.activated = true
                    card.ability.extra.destroy = scored_card
                    return {
                        chips = G.GAME.blind.chips,
                        mult = 1,
                        message = localize('baliatro_ulti'),
                    }
                end
            end
        elseif card.ability.extra.activated and context.destroying_card then
            return not context.blueprint and card.ability.extra.destroy == context.destroying_card
        elseif context.end_of_round and not context.blueprint and card.ability.extra.activated and not context.individual then
            G.GAME.current_round.ulti = false
            G.E_MANAGER:add_event(Event({
                func = function()
                    play_sound("tarot1")
                    card.T.r = -0.2
                    card:juice_up(0.3, 0.4)
                    card.states.drag.is = true
                    card.children.center.pinch.x = true
                    G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.3, blockable = false,
                        func = function()
                            G.jokers:remove_card(card)
                            card:remove()
                            card = nil
                        return true; end}))
                    return true
                end
            }))
            return {
                message = localize('baliatro_ulti'),
                colour = G.C.FILTER
            }
        end
    end
}

-- 2. Eigenstate
-- If played hand contains a Straight and at least one Edition Card, create a random Moon and an Ace of Wands. (once per round)
-- Common
SMODS.Joker {
    name = "Eigenstate",
    key = "eigenstate",
    config = {
        extra = {
            activated = false,
            can_activate = true,
            stop_juicing = false,
        }
    },
    pos = {
        x = 2,
        y = 0,
    },
    unlocked = true,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    cost = 4,
    rarity = 1,
    atlas = "Baliatro",

    new_york = {
        compatible = false,
        divide_extra_fields = {},
        ignore_extra_fields = {},
        divide_extra_number = false,
        one_minus_multiply_extra_fields = {},
    },

    calculate = function(self, card, context)
        if context.setting_blind and not context.blueprint then
            card.ability.extra.stop_juicing = false
            local eval = function() return (not card.ability.extra.stop_juicing) and card.ability.extra.can_activate end
            juice_card_until(card, eval, true)
        elseif card.ability.extra.can_activate and context.cardarea == G.jokers and context.joker_main then
            local editions = 0
            for i = 1, #context.scoring_hand do
                if context.scoring_hand[i].edition then
                    editions = editions + 1
                end
            end
            if editions >= 1 and next(context.poker_hands["Straight"]) and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
                card.ability.extra.activated = true
                card.ability.extra.stop_juicing = true
                local create_wands = false
                G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                if #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
                    create_wands = true
                    G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                end
                G.E_MANAGER:add_event(Event({
                    trigger = 'before',
                    delay = 0.0,
                    func = (function()
                            local card = BALIATRO.create_moon(G.consumeables, 'eig')
                            card:add_to_deck()
                            G.consumeables:emplace(card)
                            local card2 = create_card('Tarot', G.consumeables, nil, nil, nil, nil, 'c_baliatro_ace_of_wands', 'eig')
                            card2:add_to_deck()
                            G.consumeables:emplace(card2)
                            G.GAME.consumeable_buffer = 0
                        return true
                    end)}))
                return {
                    message = localize('k_plus_planet') .. ' ' .. localize('k_plus_tarot'),
                    colour = G.C.SECONDARY_SET.Planet,
                }
            end
        elseif context.cardarea == G.jokers and context.after and not context.blueprint and card.ability.extra.activated then
            card.ability.extra.can_activate = false
            card.ability.extra.activated = false
        elseif context.end_of_round and not context.blueprint then
            card.ability.extra.stop_juicing = true
            card.ability.extra.can_activate = true
        end
    end
}


-- 3. Sharpening Stone
-- +2 Mult. Remove any upgradable Edition from played scoring cards. For each Edition type removed in a hand, upgrade that Edition by 1 level. Gains +2 Mult per Edition removed.
-- Uncommon
SMODS.Joker {
    name = "Sharpening Stone",
    key = "sharpening_stone",
    pos = {
        x = 3,
        y = 0,
    },
    config = {
        extra = {
            upgrade_amount = 1,
            mult = 2,
            mult_gain = 2,
        }
    },
    unlocked = true,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    cost = 6,
    rarity = 2,
    atlas = "Baliatro",

    new_york = {
        compatible = true,
    },

    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.upgrade_amount, card.ability.extra.mult, card.ability.extra.mult_gain}}
    end,

    calculate = function(self, card, context)
        if context.cardarea == G.jokers and context.before and not context.blueprint then
            local editions = {}
            local gained_mult = 0
            for i = 1, #context.scoring_hand do
                local scored_card = context.scoring_hand[i]
                if scored_card.edition and not scored_card.sharpened then
                    local ed = scored_card.edition.type
                    if ed:find("baliatro_faded_") then
                        ed = ed:gsub("baliatro_faded_", "")
                    end
                    local up_ed = "baliatro_"..ed
                    if G.GAME.spec_planets[up_ed] then
                        editions[ed] = true
                        scored_card.sharpened = true
                        scored_card:set_edition(nil, true, true)
                        gained_mult = gained_mult + card.ability.extra.mult_gain
                        G.E_MANAGER:add_event(Event({
                            func = function()
                                scored_card:juice_up()
                                scored_card.sharpened = nil
                                return true
                            end
                        }))
                    end
                end
            end

            for k, v in pairs(editions) do
                local up_ed = "baliatro_"..k
                BALIATRO.use_special_planet(up_ed, nil, nil, card.ability.extra.upgrade_amount)
            end

            if gained_mult > 0 then
                card.ability.extra.mult = card.ability.extra.mult + gained_mult
                return {
                    message = localize('k_upgrade_ex'),
                    card = card,
                }
            end
        elseif context.joker_main and not context.blueprint then
            return {
                mult = card.ability.extra.mult,
                card = card,
            }
        end
    end
}

-- 4. Pumpjack
-- Transfer up to 1 Mult to Chips when a played Foil card is scored. Each repeat within the same hand is 10X higher. At least 1 Mult will remain.
-- (Joker has +1 transfer and +0.5X multiplier per level of Foil)
-- Uncommon
SMODS.Joker {
    name = "Pumpjack",
    key = "pumpjack",
    pos = {
        x = 4,
        y = 0,
    },
    config = {
        extra = {
            transfer = 1,
            base_transfer = 1,
            level_gain = 1,
            subsequent_transfer = 10,
            level_subsequent_gain = 0.5,
        }
    },
    unlocked = true,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    cost = 4,
    rarity = 2,
    atlas = "Baliatro",

    can_appear = function(self)
        return BALIATRO.tally_edition('e_foil') > 0 or BALIATRO.tally_edition('e_baliatro_faded_foil') > 0
    end,

    new_york = {
        compatible = true,
    },

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = G.P_CENTERS.e_foil
        info_queue[#info_queue+1] = G.P_CENTERS.e_baliatro_faded_foil
        local foil = G.GAME.spec_planets["baliatro_foil"]
        local base_transfer = card.ability.extra.base_transfer + card.ability.extra.level_gain * (foil.level - 1)
        local subsequent_transfer = card.ability.extra.subsequent_transfer + card.ability.extra.level_subsequent_gain * (foil.level - 1)
        return { vars = { base_transfer, subsequent_transfer, card.ability.extra.level_gain, card.ability.extra.level_subsequent_gain }}
    end,

    calculate = function(self, card, context)
        local foil = G.GAME.spec_planets["baliatro_foil"]
        if context.cardarea == G.jokers and context.before and not context.blueprint then
            card.ability.extra.transfer = card.ability.extra.base_transfer + card.ability.extra.level_gain * (foil.level - 1)
        elseif context.cardarea == G.play and context.individual and context.other_card and context.other_card:is_foil() then
            local ret = {
                baliatro_transfer = card.ability.extra.transfer
            }
            card.ability.extra.transfer = card.ability.extra.transfer * (card.ability.extra.subsequent_transfer + card.ability.extra.level_subsequent_gain * (foil.level - 1))
            return ret
        end
    end
}

-- 5.
-- 1 in 2 chance to gain $2 when a Holographic card is discarded.
-- 1 in 4 chance to add Holographic to cards discarded with a Holographic card.
-- (Joker has +$1 per 4 levels of Holographic)
-- Common
SMODS.Joker {
    name = "Golden Mirror",
    key = "golden_mirror",
    pos = {
        x = 5,
        y = 0,
    },
    config = {
        extra = {
            base_gain = 2,
            level_divisor = 4,
            odds = 2,
            odds_add = 4,
            has_holo = false,
            convert_holo = 'e_baliatro_faded_holo',
        }
    },
    unlocked = true,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    cost = 5,
    rarity = 1,
    atlas = "Baliatro",

    can_appear = function(self)
        return BALIATRO.tally_edition('e_holo') > 0 or BALIATRO.tally_edition('e_baliatro_faded_holo') > 0
    end,

    new_york = {
        compatible = true,
        divide_extra_fields = {"odds", "odds_add"},
        ignore_extra_fields = {"level_divisor"},
    },

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = G.P_CENTERS.e_holo
        info_queue[#info_queue+1] = G.P_CENTERS.e_baliatro_faded_holo
        local holo = G.GAME.spec_planets["baliatro_holo"]
        local dollars = math.floor(card.ability.extra.base_gain + (holo.level - 1) / card.ability.extra.level_divisor)
        return { vars = { (G.GAME.probabilities.normal or 1), card.ability.extra.odds, card.ability.extra.odds_add, dollars, card.ability.extra.level_divisor }}
    end,

    calculate = function(self, card, context)
        local holo = G.GAME.spec_planets["baliatro_holo"]
        local scorer = context.blueprint_card or card
        local dollars = math.floor(card.ability.extra.base_gain + (holo.level - 1) / card.ability.extra.level_divisor)
        if context.pre_discard and not context.blueprint then
            card.ability.extra.has_holo = false
            card.ability.extra.convert_holo = 'e_baliatro_faded_holo'
            for i, other_card in ipairs(context.full_hand) do
                if other_card:is_holographic() then
                    card.ability.extra.has_holo = true
                    if other_card.edition.key == 'e_holo' then
                        card.ability.extra.convert_holo = 'e_holo'
                    end
                end
            end
        elseif card.ability.extra.has_holo and context.discard and context.other_card then
            if context.other_card:is_holographic() then
                local gold_poll = pseudorandom('golden_mirror')
                if gold_poll < G.GAME.probabilities.normal / card.ability.extra.odds then
                    ease_dollars(dollars)
                    return {
                        message = localize('$')..dollars,
                        colour = G.C.MONEY,
                        card = scorer,
                    }
                end
            else
                local convert_poll = pseudorandom('golden_mirror')
                if not context.other_card.edition and convert_poll < G.GAME.probabilities.normal / card.ability.extra.odds_add then
                    context.other_card:set_edition(card.ability.extra.convert_holo)
                    return {
                        message = localize('k_baliatro_converted_card_ex'),
                        card = scorer,
                    }
                end
            end
        end
    end
}

-- 6.
-- The first time each Blind you play your least played, discovered hand, create 1 Ace of Wands.
-- Uncommon
SMODS.Joker {
    name = "Meditation",
    key = "meditation",
    pos = {
        x = 6,
        y = 0,
    },
    config = {
        extra = {
            activated = false,
            can_activate = true,
            created_highroll_type = "Spectral",
            created_highroll_card = "c_aura",
            created_type = "Tarot",
            created_card = "c_baliatro_ace_of_wands",
            amount = 1,
            odds = 4,
            stop_juicing = false,
        }
    },
    unlocked = true,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    cost = 6,
    rarity = 2,
    atlas = "Baliatro",

    new_york = {
        compatible = true,
        ignore_extra_fields = {"odds"},
    },

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = G.P_CENTERS[card.ability.extra.created_card]
        info_queue[#info_queue+1] = G.P_CENTERS[card.ability.extra.created_highroll_card]
        return { vars = {card.ability.extra.amount }}
    end,

    calculate = function(self, card, context)
        if context.setting_blind and not context.blueprint then
            card.ability.extra.stop_juicing = false
            local eval = function() return (not card.ability.extra.stop_juicing) and card.ability.extra.can_activate end
            juice_card_until(card, eval, true)
        elseif card.ability.extra.can_activate and context.cardarea == G.jokers and context.joker_main then
            local curr_played = (G.GAME.hands[context.scoring_name].played or 1) - 1
            for k, v in pairs(G.GAME.hands) do
                if k ~= context.scoring_name and v.played < curr_played and v.visible then
                    return nil
                end
            end

            card.ability.extra.activated = true
            local created_amt = math.min(G.consumeables.config.card_limit - (#G.consumeables.cards + G.GAME.consumeable_buffer), card.ability.extra.amount)
            if created_amt > 0 then
                G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + created_amt
                local ctype = card.ability.extra.created_type
                local ccard = card.ability.extra.created_card
                if G.GAME.probabilities.normal / card.ability.extra.odds < pseudorandom('meditation') then
                    ctype = card.ability.extra.created_highroll_type
                    ccard = card.ability.extra.created_highroll_card
                end
                G.E_MANAGER:add_event(Event({
                    trigger = 'before',
                    delay = 0.0,
                    func = (function()
                        for j = 1, created_amt do
                            local card = create_card(ctype, G.consumeables, nil, nil, nil, nil, ccard, "meditation")
                            card:add_to_deck()
                            G.consumeables:emplace(card)
                            G.GAME.consumeable_buffer = 0
                        end
                        return true
                    end)}))
                return {
                    message = localize('baliatro_plus_aura'),
                    colour = G.C.SECONDARY_SET.Spectral,
                }
            end
        elseif context.cardarea == G.jokers and context.after and card.ability.extra.activated then
            card.ability.extra.activated = false
            card.ability.extra.can_activate = false
        elseif context.end_of_round then
            card.ability.extra.stop_juicing = true
            card.ability.extra.can_activate = true
        end
    end
}

-- 7.
-- Retrigger each scoring card for each unscoring card played. Recharge 1.5 repeats, when 5 scoring cards are played. Destroyed if remaining repeats hit 0. (50 repeats remaining)
-- Common
SMODS.Joker {
    name = "Battery",
    key = "battery",
    pos = {
        x = 7,
        y = 0,
    },
    config = {
        extra = {
            maximum = 18,
            remaining = 18,
            recharges = 1.5,
            draining = 0,
        }
    },
    unlocked = true,
    blueprint_compat = true,
    eternal_compat = false,
    perishable_compat = true,
    cost = 4,
    rarity = 1,
    atlas = "Baliatro",

    new_york = {
        compatible = true,
    },

    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.recharges, card.ability.extra.remaining, card.ability.extra.maximum}}
    end,

    calculate = function(self, card, context)
        if context.cardarea == G.jokers and context.before and not context.blueprint then
            if #context.scoring_hand == 5 then
                card.ability.extra.remaining = math.min(card.ability.extra.remaining + card.ability.extra.recharges, card.ability.extra.maximum)
                return {
                    message = 'Recharged!',
                }
            end
        elseif context.cardarea == G.play and context.repetition and not context.repetition_only and card.ability.extra.remaining - card.ability.extra.draining and #context.scoring_hand < #context.full_hand then
            local total_played = #context.full_hand
            local scoring = #context.scoring_hand
            local repeats = math.min(total_played - scoring, math.floor(card.ability.extra.remaining - card.ability.extra.draining))
            if not context.blueprint then
                card.ability.extra.draining = card.ability.extra.draining + repeats
                --card.ability.extra.remaining = card.ability.extra.remaining - repeats
            end
            return {
                message = localize('k_again_ex'),
                repetitions = repeats,
                card = context.blueprint_card or card
            }
        elseif context.cardarea == G.jokers and context.after and not context.blueprint then
            card.ability.extra.remaining = card.ability.extra.remaining - card.ability.extra.draining
            if card.ability.extra.remaining <= 0 then
                G.E_MANAGER:add_event(Event({func = function()
                    play_sound('tarot1')
                    card.T.r = -0.2
                    card:juice_up(0.3, 0.4)
                    card.states.drag.is = true
                    card.children.center.pinch.x = true
                    -- This part destroys the card.
                    G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.3, blockable = false, func = function()
                        G.jokers:remove_card(card)
                        card:remove()
                        card = nil
                        return true;
                    end }))
                    return true
                end }))
                return {
                    message = localize("baliatro_depleted")
                }
            else
                local drained = card.ability.extra.draining
                card.ability.extra.draining = 0
                return {
                    message = localize{type='variable', key='a_baliatro_drained', vars={drained}}
                }
            end
        end
    end
}

-- 8.
-- Polychrome cards gain 5% more multiplier each hand each time a Wild Card is scored for that hand only.
-- Rare
SMODS.Joker {
    name = "Parade",
    key = "parade",
    pos = {
        x = 4,
        y = 1,
    },
    config = {
        extra = {
            base_gain = 1.05,
        }
    },
    unlocked = true,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    cost = 8,
    rarity = 3,
    atlas = "Baliatro",

    can_appear = function(self)
        return BALIATRO.tally_edition('e_polychrome') > 0 or BALIATRO.tally_edition('e_baliatro_faded_polychrome') > 0
    end,

    new_york = {
        compatible = true,
        one_minus_multiply_extra_fields = {"base_gain"},
    },

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = G.P_CENTERS.e_polychrome
        info_queue[#info_queue+1] = G.P_CENTERS.e_baliatro_faded_polychrome
        local gain = (card.ability.extra.base_gain - 1) * 100
        return {vars = {gain}}
    end,

    calculate = function(self, card, context)
        local poly = G.GAME.spec_planets['baliatro_polychrome']
        local gain = card.ability.extra.base_gain
        if context.cardarea == G.jokers and context.before and not context.blueprint then
            poly.remult = 1
        elseif context.cardarea == G.play and context.individual and context.other_card and SMODS.has_enhancement(context.other_card, 'm_wild') then
            poly.remult = poly.remult * gain
            return {
                message = localize("baliatro_parade"),
            }
        end
    end
}

-- 9.
-- Editionless Wild Cards gain Polychrome when scored. 1 in 2 chance for added Polychrome not to be faded. Double the required score for Blind for each Polychrome card in each scoring hand.
-- Uncommon
SMODS.Joker {
    name = "Fool's Gambit",
    key = "fools_gambit",
    pos = {
        x = 5,
        y = 1,
    },
    config = {
        extra = {
            odds = 2,
        }
    },

    new_york = {
        compatible = true,
        divide_extra_fields = {'odds'},
    },

    unlocked = true,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    cost = 6,
    rarity = 2,
    atlas = "Baliatro",

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = G.P_CENTERS['e_polychrome']
        info_queue[#info_queue+1] = G.P_CENTERS['e_baliatro_faded_polychrome']
        return {vars = {(G.GAME and G.GAME.probabilities.normal) or 1, card.ability.extra.odds}}
    end,

    calculate = function(self, card, context)
        if context.blueprint then return end
        if context.before  then
            local counter = 1
            for _, other in ipairs(context.scoring_hand) do
                if not other.edition and SMODS.has_any_suit(other) then
                    local add_ed = 'e_baliatro_faded_polychrome'
                    if pseudorandom('foolsgambit') < G.GAME.probabilities.normal / card.ability.extra.odds then
                        add_ed = 'e_polychrome'
                    end
                    other:set_edition(add_ed)
                end
                if other.edition and (other.edition.key == 'e_polychrome' or other.edition.key == 'e_baliatro_faded_polychrome') then
                    G.GAME.blind.chips = G.GAME.blind.chips * 2
                    counter = counter * 2
                    G.GAME.blind.chip_text = number_format(G.GAME.blind.chips)
                end
            end
            if counter > 1 then
                return {
                    message = localize{type='variable', key='a_baliatro_multiply_blind', vars={counter}}
                }
            end
        end
    end
}

-- 10.
-- If scored hand contains at least 3 different Editions, apply X3 Mult each time an Edition is first scored.
-- (Joker has +X0.25 per level of Foil, Holographic, or Polychrome)
-- Rare

-- 11.
-- Photographic Edition triggers twice.
-- Rare

-- 12.
-- Gain $8 if discarded hand is Straight Flush. Lose $1 otherwise. (Hand changes each time you discard)
-- Common
SMODS.Joker {
    name = "Slot Machine",
    key = "slot_machine",
    pos = {
        x = 6,
        y = 1,
    },
    config = {
        extra = {
            dollars = 6,
            lose = 1,
            hand = "Pair",
        }
    },

    new_york = {
        compatible = true,
    },

    unlocked = true,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    cost = 5,
    rarity = 1,
    atlas = "Baliatro",

    set_ability = function(self, card, initial, delay_sprites)
        card.ability.extra.hand = pseudorandom_element(BALIATRO.collect_visible_hands(), pseudoseed('slots'))
    end,

    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.dollars, card.ability.extra.hand, card.ability.extra.lose}}
    end,

    calculate = function(self, card, context)
        if context.pre_discard and not context.individual then
            local text, disp_text = G.FUNCS.get_poker_hand_info(G.hand.highlighted)
            if text == card.ability.extra.hand then
                card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = localize{type = 'variable', key = 'a_baliatro_money', vars={card.ability.extra.dollars}}})
                ease_dollars(card.ability.extra.dollars)
            else
                card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = localize{type = 'variable', key = 'a_baliatro_money', vars={-card.ability.extra.lose}}})
                ease_dollars(-card.ability.extra.lose)
            end
        elseif context.discard and not context.blueprint then
            card.ability.extra.hand = pseudorandom_element(BALIATRO.collect_visible_hands(), pseudoseed('slots'))
        end
    end
}

-- 13.
-- If a discard only contains one card, add two Ethereal copies to your hand.
-- Ethereal: Edition. Ethereal cards cannot be discarded, are destroyed after a hand is scored or any card is discarded, and grant +1 Hand Size while held.
-- Common
SMODS.Joker {
    name = "Undertaker",
    key = "undertaker",
    pos = {
        x = 0,
        y = 0,
    },
    config = {
        extra = {
            copies = 2,
        }
    },

    new_york = {
        compatible = true,
    },

    unlocked = true,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    cost = 5,
    rarity = 1,
    atlas = "Baliatro",

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = G.P_CENTERS.e_baliatro_ethereal
        return {vars = {card.ability.extra.copies}}
    end,

    calculate = function(self, card, context)
        if context.discard and #context.full_hand == 1 then
            local amt = card.ability.extra.copies
            G.playing_card = (G.playing_card and G.playing_card + amt) or amt
            local pcc = {}
            for i = 1, amt do
                pcc[#pcc+1] = BALIATRO.ethereal_copy(context.full_hand[1], true)
            end
            return {
                message = localize('k_copied_ex'),
                colour = G.C.CHIPS,
                card = context.blueprint_card or card,
                playing_cards_created = pcc
            }
        end
    end
}

-- 14.
-- When the Blind is selected, add a random playing card to your hand. Add Polychrome (15%), Holographic (25%), or Foil to this card. 2 in 3 chance to add a Faded variant instead. Edition cards have +4 mult when scored.
-- Common
SMODS.Joker {
    name = "Gacha Joker",
    key = "gacha",
    pos = {
        x = 7,
        y = 1,
    },
    config = {
        extra = {
            base = 3,
            odds = 4,
            poly_roll = 0.1,
            holo_roll = 0.35,
            mult = 4,
        }
    },

    new_york = {
        compatible = true,
        ignore_extra_fields = {"base"},
    },

    unlocked = true,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    cost = 4,
    rarity = 1,
    atlas = "Baliatro",

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = G.P_CENTERS.e_foil
        info_queue[#info_queue+1] = G.P_CENTERS.e_holo
        info_queue[#info_queue+1] = G.P_CENTERS.e_polychrome
        info_queue[#info_queue+1] = G.P_CENTERS.e_baliatro_faded_foil
        info_queue[#info_queue+1] = G.P_CENTERS.e_baliatro_faded_holo
        info_queue[#info_queue+1] = G.P_CENTERS.e_baliatro_faded_polychrome
        return {vars = {card.ability.extra.poly_roll * 100, (card.ability.extra.holo_roll - card.ability.extra.poly_roll) * 100, card.ability.extra.base * ((G.GAME and G.GAME.probabilities.normal) or 1), card.ability.extra.odds, card.ability.extra.mult}}
    end,

    calculate = function(self, card, context)
        if context.first_hand_drawn then
            local scorer = context.blueprint_card or card
            G.E_MANAGER:add_event(Event({func = function()
                local _card = create_playing_card({front = pseudorandom_element(G.P_CARDS, pseudoseed('gacha')), center = G.P_CENTERS.c_base}, G.hand, nil, nil, {G.C.SECONDARY_SET.Enhanced})

                local ed = 'foil'
                local ed_roll = pseudorandom('gacha')
                if ed_roll < card.ability.extra.poly_roll then
                    ed = 'polychrome'
                elseif ed_roll < card.ability.extra.holo_roll then
                    ed = 'holo'
                end
                local faded_roll = pseudorandom('gacha')
                if faded_roll < G.GAME.probabilities.normal * card.ability.extra.base / card.ability.extra.odds then
                    ed = 'baliatro_faded_' .. ed
                end
                _card:set_edition{[ed] = true}
                G.GAME.blind:debuff_card(_card)
                G.hand:sort()
                scorer:juice_up()
                return true
            end }))
            playing_card_joker_effects({true})
        elseif context.individual and context.cardarea == G.play and not context.repetition then
            if context.other_card.edition then
                return {
                    mult = card.ability.extra.mult,
                    card = context.blueprint_card or card
                }
            end
        end
    end
}

-- 15.
-- +1 Mult for each hand played. Reset to 0 mult when discarding. Upon reaching +5 mult, apply Holographic to a random card in the scored hand, and reset to 0 mult after scoring. (Currently has +0 Mult)
-- Common

-- 16.
-- +5 Chips for each card discarded. -1 Chips for each card played. Upon reaching +100 chips, apply Foil to a random card in hand, and reset to 0 chips. (Currently has +0 Chips)
-- Common

-- 17.
-- At the end of the round, gain +1 Mult per 1 dollar of interest gained. (Currently has +0 Mult)
-- Common
SMODS.Joker {
    name = "Daytrader",
    key = "daytrader",
    pos = {
        x = 8,
        y = 1,
    },
    config = {
        extra = {
            mult = 0,
            mult_per_x_dollar = 1,
            x = 2,
        }
    },
    unlocked = true,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    cost = 4,
    rarity = 1,
    atlas = "Baliatro",

    new_york = {
        compatible = true,
        ignore_extra_fields = {"x"}
    },


    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.mult_per_x_dollar, card.ability.extra.x, card.ability.extra.mult}}
    end,

    calculate = function(self, card, context)
        if context.joker_main then
            if card.ability.extra.mult > 0 then
                return {
                    mult_mod = card.ability.extra.mult,
                    message = localize{type='variable', key='a_mult', vars={card.ability.extra.mult}},
                    card = card,
                }
            end
        elseif context.end_of_round and not context.repetition and not context.individual and not context.blueprint then
            local interest = BALIATRO.calculate_interest_amount()
            local mult_gain = math.floor(card.ability.extra.mult_per_x_dollar * interest / card.ability.extra.x)
            if mult_gain > 0 then
                card.ability.extra.mult = card.ability.extra.mult + mult_gain
                return {
                    message = localize{type='variable', key='a_mult', vars={mult_gain}},
                    card = card,
                }
            end
        end
    end
}

-- 18.
-- Create two Lethargic copies of the first card scored in the first hand played each round. Remove Negative from any copies created by this card.
-- Lethargic: Enhancement: X0.5 Mult when scored
-- Uncommon

-- 19.
-- +0 Mult. If scored hand is Pair, destroy a played, unscored card. Gains +4 Mult, if a card is destroyed. Add a random playing card to the deck at the end of the round if this effect was not used. (Once per round)
-- Common
SMODS.Joker {
    name = "Gallows Humour",
    key = "gallows_humour",
    pos = {
        x = 9,
        y = 1,
    },
    config = {
        extra = {
            mult = 0,
            mult_gain = 4,
            can_activate = true,
            stop_juicing = false,
        },
        supports_destroy_unscoring = true,
    },
    unlocked = true,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    cost = 6,
    rarity = 2,
    atlas = "Baliatro",

    new_york = {
        compatible = true,
    },

    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.mult, card.ability.extra.mult_gain}}
    end,

    calculate = function(self, card, context)
        if context.blueprint then return end
        if context.setting_blind then
            card.ability.extra.stop_juicing = false
            local eval = function() return (not card.ability.extra.stop_juicing) and card.ability.extra.can_activate end
            juice_card_until(card, eval, true)
        elseif context.before and card.ability.extra.can_activate then
            if context.scoring_name == 'Pair' then
                card.ability.extra.can_activate = false
                card.ability.extra.stop_juicing = true
                local eligible = BALIATRO.unscored(context)
                if #eligible then
                    card.ability.extra.destroyed = pseudorandom_element(eligible, pseudoseed('gallows'))
                    --G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.15, func = function()
                    --    destroyed.destroyed = true
                    --    destroyed:start_dissolve()
                    --    card:juice_up()
                    --    return true
                    --end }))
                    card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.mult_gain
                    return {
                        card = card,
                        message = localize("k_baliatro_destroyed_card_ex"),
                    }
                end
            end
        elseif context.joker_main and card.ability.extra.mult > 0 then
            return {
                message = localize{type='variable',key='a_mult',vars={card.ability.extra.mult}},
                mult_mod = card.ability.extra.mult
            }
        --elseif context.destroying_unscored_card and context.destroying_unscored_card == card.ability.extra.destroyed then
        elseif context.cardarea == 'unscored' and card.ability.extra.destroyed and context.destroy_card == card.ability.extra.destroyed then
            card.ability.extra.destroyed = nil
            return {remove = true}
        elseif context.end_of_round and not context.blueprint and not context.repetition and not context.individual then
            local added_card = false
            if card.ability.extra.can_activate then
                added_card = true
                create_playing_card({front = pseudorandom_element(G.P_CARDS, pseudoseed('gallows')), center = G.P_CENTERS.c_base}, G.deck, nil, nil, {G.C.SECONDARY_SET.Enhanced})
            end
            card.ability.extra.stop_juicing = true
            card.ability.extra.can_activate = true
            card.ability.extra.destroyed = nil
            if added_card then
                return {
                    card = card,
                    message = localize("k_baliatro_plus_card_ex"),
                }
            end
        end
    end
}

-- 20.
-- If scored hand is Three of a Kind, convert a random unscored card to an immortal copy of a random scored card. +3 Mult, if a card is converted. (Once per round)
-- Common
SMODS.Joker {
    name = "Killing Joke",
    key = "killing_joke",
    pos = {
        x = 0,
        y = 2,
    },
    config = {
        extra = {
            mult = 0,
            mult_gain = 3,
            can_activate = true,
            activated = false,
            stop_juicing = false,
        }
    },
    unlocked = true,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    cost = 5,
    rarity = 1,
    atlas = "Baliatro",

    new_york = {
        compatible = true,
    },

    loc_vars = function(self, info_queue, card)
		info_queue[#info_queue+1] = {key = "baliatro_immortal", set="Other"}
        return {vars = {card.ability.extra.mult, card.ability.extra.mult_gain}}
    end,

    calculate = function(self, card, context)
        if context.blueprint then return end
        if context.setting_blind then
            card.ability.extra.stop_juicing = false
            local eval = function() return (not card.ability.extra.stop_juicing) and card.ability.extra.can_activate end
            juice_card_until(card, eval, true)
        elseif context.before and card.ability.extra.can_activate then
            if context.scoring_name == 'Three of a Kind' then
                card.ability.extra.can_activate = false
                card.ability.extra.activated = true
                card.ability.extra.stop_juicing = true
                card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.mult_gain
                return {
                    card = card,
                    message = localize("k_baliatro_converted_card_ex"),
                }
            end
        elseif context.joker_main and card.ability.extra.mult > 0 then
            return {
                message = localize{type='variable',key='a_mult',vars={card.ability.extra.mult}},
                mult_mod = card.ability.extra.mult
            }
        elseif context.after and context.cardarea == G.jokers and card.ability.extra.activated then
            card.ability.extra.stop_juicing = true
            card.ability.extra.activated = false
            local eligible_target = BALIATRO.filter_immortal(context.scoring_hand)
            local eligible = BALIATRO.filter_immortal(BALIATRO.unscored(context))
            if #eligible_target > 0 and #eligible > 0 then
                local target = pseudorandom_element(eligible_target, pseudoseed('killing'))
                local converted = pseudorandom_element(eligible, pseudoseed('killing'))
                G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.15, func = function()
                    converted:flip()
                    play_sound('card1', 1)
                    card:juice_up(0.3, 0.3)
                    return true
                end }))
                G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.25, func = function()
                    copy_card(target, converted)
                    converted:set_immortal(true)
                    converted:flip()
                    play_sound('tarot2', 1, 0.6)
                    return true
                end }))
            end
        elseif context.end_of_round and not context.blueprint and not context.repetition and not context.individual then
            card.ability.extra.stop_juicing = true
            card.ability.extra.activated = false
            card.ability.extra.can_activate = true
        end
    end
}

-- 21.
-- If scored hand is Four of a Kind, +4 Mult and gain $ equal to the sell value of all of your jokers (up to $25, once per round)
-- Common
SMODS.Joker {
    name = "Tempered Joker",
    key = "tempered_joker",
    pos = {
        x = 1,
        y = 2,
    },
    config = {
        extra = {
            mult = 4,
            max = 25,
            can_activate = true,
            activated = false,
            stop_juicing = false,
        }
    },
    unlocked = true,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    cost = 5,
    rarity = 1,
    atlas = "Baliatro",

    new_york = {
        compatible = true,
    },

    calculate_value = function(self, card)
        local money = 0
        if G.jokers and G.jokers.cards and #G.jokers.cards > 0 then
            for _, joker in ipairs(G.jokers.cards) do
                if joker.ability.set == 'Joker' then
                    money = money + joker.sell_cost
                end
            end
            money = math.min(card.ability.extra.max, math.floor(money))
        end
        return money
    end,

    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.mult, card.ability.extra.max, self:calculate_value(card)}}
    end,

    calculate = function(self, card, context)
        if context.blueprint then return end
        if context.setting_blind then
            card.ability.extra.stop_juicing = false
            local eval = function() return (not card.ability.extra.stop_juicing) and card.ability.extra.can_activate end
            juice_card_until(card, eval, true)
        elseif context.before and card.ability.extra.can_activate then
            if context.scoring_name == 'Four of a Kind' then
                card.ability.extra.activated = true
                card.ability.extra.stop_juicing = true
            end
        elseif context.joker_main and card.ability.extra.activated then
            local money = self:calculate_value(card) or nil
            return {
                mult_mod = card.ability.extra.mult,
                dollars = money,
            }
        elseif context.after and context.cardarea == G.jokers and card.ability.extra.activated then
            card.ability.extra.can_activate = false
            card.ability.extra.stop_juicing = true
            card.ability.extra.activated = false
        elseif context.end_of_round and not context.blueprint and not context.repetition and not context.individual then
            card.ability.extra.stop_juicing = true
            card.ability.extra.activated = false
            card.ability.extra.can_activate = true
        end
    end
}

-- 22.
-- Gain $3 when each suit is scored for the first time in played hand. Lose $6 per hand played. Cards with multiple suits only count as a single suit.
-- Common
SMODS.Joker {
    name = "Tax Collector",
    key = "tax_collector",
    pos = {
        x = 2,
        y = 2,
    },
    config = {
        extra = {
            dollars = 3,
            lose = 8,
            wilds = 0,
            suits = {},
            scoring = {},
            non_scoring = {},
            scored_by = {}
        }
    },

    new_york = {
        compatible = true,
    },

    unlocked = true,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    cost = 5,
    rarity = 1,
    atlas = "Baliatro",

    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.dollars, card.ability.extra.lose}}
    end,

    has_scored = function(self, card, scorer, played)
        return card.ability.extra.scored_by[played] and card.ability.extra.scored_by[played][scorer]
    end,

    set_scored = function(self, card, scorer, played)
        if not card.ability.extra.scored_by[played] then
            card.ability.extra.scored_by[played] = {[scorer] = true}
        else
            card.ability.extra.scored_by[played][scorer] = true
        end
    end,

    calculate = function(self, card, context)
        local scorer = context.blueprint_card or card
        if context.cardarea == G.jokers and context.before then
            card.ability.extra.wilds = 0
            card.ability.extra.suits = {}
            card.ability.extra.scoring = {}
            card.ability.extra.non_scoring = {}
            card.ability.extra.scored_by = {}
            return {
                dollars = -card.ability.extra.lose,
            }
        elseif context.cardarea == G.play and context.individual and not context.repetition then
            if SMODS.has_no_suit(context.other_card) then return end
            if BALIATRO.in_array(context.other_card, card.ability.extra.scoring) and not self:has_scored(card, scorer, context.other_card) then
                self:set_scored(card, scorer, context.other_card)
                return {
                    card = scorer,
                    dollars = card.ability.extra.dollars,
                }
            elseif not BALIATRO.in_array(context.other_card, card.ability.extra.non_scoring) then
                if card.ability.extra.wilds + #card.ability.extra.suits < 4 then
                    local scores = false
                    if SMODS.has_any_suit(context.other_card) then
                        card.ability.extra.wilds = card.ability.extra.wilds + 1
                        scores = true
                    elseif not BALIATRO.in_array(context.other_card.base.suit, card.ability.extra.suits) then
                        table.insert(card.ability.extra.suits, context.other_card.base.suit)
                        scores = true
                    end
                    if scores then
                        table.insert(card.ability.extra.scoring, context.other_card)
                        self:set_scored(card, scorer, context.other_card)
                        return {
                            card = scorer,
                            dollars = card.ability.extra.dollars,
                        }
                    end
                end
                table.insert(card.ability.extra.non_scoring, context.other_card)
            end
        elseif context.cardarea == G.jokers and context.after then
            card.ability.extra.wilds = 0
            card.ability.extra.suits = {}
            card.ability.extra.scoring = {}
            card.ability.extra.non_scoring = {}
            card.ability.extra.scored_by = {}
        end
    end
}

-- 23.
-- At the end of each round, multiply this joker's value randomly by 0% to 200%. Value cannot go below $1. Has Mult equal to this joker's value. (Currently +4 Mult)
-- Common

-- 24.
-- X1.75 Mult if played hand contains any Edition card.
-- Common
SMODS.Joker {
    name = "Display Case",
    key = "display_case",
    pos = {
        x = 3,
        y = 2,
    },
    config = {
        extra = {
            xmult = 1.75,
        }
    },

    new_york = {
        compatible = true,
    },

    unlocked = true,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    cost = 5,
    rarity = 1,
    atlas = "Baliatro",

    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.xmult}}
    end,

    calculate = function(self, card, context)
        if context.joker_main then
            for i, other_card in ipairs(context.scoring_hand) do
                if other_card.edition then
                    return {
                        xmult = card.ability.extra.xmult,
                    }
                end
            end
        end
    end
}

-- 25.
-- When you defeat a Boss Blind, if no scoring hands played contained 1 or 5 cards, create two random Booster Pack tags.
-- Common

-- 26.
-- Lose $10 when you skip a Blind. Skipping a Blind does not skip the Blind.
-- Common

-- 27.
-- This Joker gains +5 Mult, if scored hand contains a 2, 7 and J. Ranks change at the end of the round. (Currently has +2 Mult) (Cards in deck do not influence rank selection)
-- Common

-- 28.
-- This Joker gains +25 Chips if scored hand contains a Three of a Kind. This Joker grants no chips to hands that contain a Three of a Kind. (Currently has +25 Chips)
-- Common

-- 29.
-- Gain +$2 and set Mult to 1 when a played K is scored. Rank changes at the end of the round. (Cards in deck influence rank selection)
-- Common

-- 30.
-- On the last hand of the round, if all hands played were Full House, destroy this Joker and create a random Postcard. (Must have room)
-- Common

-- 31.
-- When any non-negative consumable is played, create a negative copy.
-- Legendary
SMODS.Joker {
    name = "Puck",
    key = "puck",
    config = {
    },
    pos = {
        x = 0,
        y = 0,
    },
    unlocked = true,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    cost = 10,
    rarity = 4,
    atlas = "Baliatro",

    new_york = {
        compatible = false,
    },

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = G.P_CENTERS["e_negative_consumable"]
        info_queue[#info_queue+1] = G.P_CENTERS["e_baliatro_ephemeral"]
        return {vars={}}
    end,

    calculate = function(self, card, context)
        if context.using_consumeable and not (context.consumeable.edition and (context.consumeable.edition.negative or context.consumeable.edition.ephemeral)) and not (context.consumeable.config.center.hidden or context.consumeable.config.center.rarity == 4) and not context.blueprint then
            G.E_MANAGER:add_event(Event({func = function()
                local copy = copy_card(context.consumeable)
                copy:set_edition({negative = true}, true)
                copy:add_to_deck()
                G.consumeables:emplace(copy)
                return true
            end}))
            card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = localize('k_duplicated_ex')})
        end
    end
}

-- 32.
-- Vouchers can appear multiple times. The shop has +1 Voucher slot.
-- Legendary
SMODS.Joker {
    name = "El Primo",
    key = "el_primo",
    config = {
        extra = {
            grants_can_repeat_vouchers = true,
            voucher_slots = 1,
        }
    },
    pos = {
        x = 0,
        y = 0,
    },
    unlocked = true,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    cost = 10,
    rarity = 4,
    atlas = "Baliatro",

    new_york = {
        compatible = false,
    },

    loc_vars = function(self, info_queue, card)
        return {vars={card.ability.extra.voucher_slots}}
    end,

    add_to_deck = function(self, card, from_debuff)
        SMODS.change_voucher_limit(1)
    end,

    remove_from_deck = function(self, card, from_debuff)
        SMODS.change_voucher_limit(-1)
    end
}

-- 33.
-- Retrigger the 3rd scoring card of each hand 3 times. Position changes at the end of round. (Cannot be higher than the number of scoring cards in last hand of the last round)
-- Common

-- 34.
-- Add the number of charges on this Joker to the times you played your most played hand. Each time you play your most played hand, this Joker gains +1 charge, otherwise set charges to 0. (Currently has 0 charges)
-- Common

-- 35.
-- This Joker gains +1 charge for each consecutive time you play your most played hand. When playing any other hand, add Mult equal to charges, add charges to times you played that hand, and set charges to 0. (Currently has 0 charges)
-- Common

-- 35.
-- Copies the ability of the Joker to the right of this. The Joker to the left of this is debuffed. If this is your leftmost Joker, this Joker does nothing.
-- Uncommon

-- 36.
-- All 7s count as Wild Cards. Wild Cards are not debuffed by the Club, the Window, the Goad or the Head.
-- Common
SMODS.Joker {
    name = "Sinful Joker",
    key = "sinful_joker",
    config = {
        extra = {
            protect_wild = true,
        }
    },
    pos = {
        x = 0,
        y = 0,
    },
    unlocked = true,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    cost = 4,
    rarity = 1,
    atlas = "Baliatro",

    new_york = {
        compatible = false,
    },

    card_has_any_suit = function(self, card, other_card)
        return other_card.base.id == 7
    end,
}

-- 37.
-- When a played Blue Seal is scored, add the number of times you played your most played hand as charges to this Joker. Create a Planet card for your most played hand upon reaching 20 charges.
-- Common

-- 38.
-- Before scoring your most played hand, transfer the number of times it was played to a different random hand and add the number of times it was played as Chips to this Joker.
-- Common

-- 39.
-- X3 Mult. Loses X0.1 Mult, when you reroll the shop.
-- Uncommon
SMODS.Joker {
    name = "Bibimbap",
    key = "bibimbap",
    config = {
        extra = {
            xmult = 3,
            reroll_cost = 0.1,
        }
    },
    pos = {
        x = 0,
        y = 0,
    },
    unlocked = true,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    cost = 6,
    rarity = 2,
    atlas = "Baliatro",

    new_york = {
        compatible = true,
    },

    loc_vars = function(self, info_queue, card)
        return { vars = {card.ability.extra.xmult, card.ability.extra.reroll_cost}}
    end,

    calculate = function(self, card, context)
        if context.joker_main then
            return {
                xmult = card.ability.extra.xmult,
            }
        elseif context.reroll_shop and not context.blueprint then
            card.ability.extra.xmult = card.ability.extra.xmult - card.ability.extra.reroll_cost
            if card.ability.extra.xmult <= 1 then
                G.E_MANAGER:add_event(Event({func = function()
                    play_sound('tarot1')
                    card.T.r = -0.2
                    card:juice_up(0.3, 0.4)
                    card.states.drag.is = true
                    card.children.center.pinch.x = true
                    G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.3, blockable = false, func = function()
                        G.jokers:remove_card(card)
                        card:remove()
                        card = nil
                        return true
                    end}))
                    return true
                end}))
                return {
                    message = localize('k_eaten_ex'),
                    colour = G.C.FILTER
                }
            else
                return {
                    delay = 0.2,
                    message = localize{type='variable',key='a_xmult_minus',vars={card.ability.extra.xmult}},
                    colour = G.C.RED
                }
            end
        end
    end
}

-- 40.
-- Retrigger scoring Aces six times total. Retriggers are split evenly between all scoring cards of that rank, up to 3 per card. Rank changes each round (idol logic)
-- Rare
SMODS.Joker {
    name = "The Effigy",
    key = "effigy",
    config = {
        extra = {
            retriggers = 6,
            max_per_card = 3,
        }
    },
    pos = {
        x = 0,
        y = 0,
    },
    unlocked = true,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    cost = 8,
    rarity = 3,
    atlas = "Baliatro",

    new_york = {
        compatible = true,
    },

    loc_vars = function(self, info_queue, card)
        return { vars = {card.ability.extra.retriggers, localize(G.GAME.current_round.effigy_card.rank, 'ranks'), card.ability.extra.max_per_card}}
    end,

    calculate = function(self, card, context)
        local scorer = context.blueprint_card or card
        if context.before and context.cardarea == G.jokers and not context.blueprint then
            --local rem = card.ability.extra.retriggers + (5 - #context.full_hand)
            local rem = card.ability.extra.retriggers
            local cards = 0
            local reps = {}

            for i, scoring_card in ipairs(context.scoring_hand) do
                if scoring_card:get_id() == G.GAME.current_round.effigy_card.id then
                    cards = cards + 1
                end
            end

            if cards > 0 then
                for i, scoring_card in ipairs(context.scoring_hand) do
                    if scoring_card:get_id() == G.GAME.current_round.effigy_card.id then
                        local upcoming = math.min(card.ability.extra.max_per_card, BALIATRO.round(rem / cards))
                        cards = cards - 1
                        rem = rem - upcoming
                        reps[i] = upcoming
                    else
                        reps[i] = 0
                    end
                end
            else
                for i = 1, #context.scoring_hand do
                    reps[i] = 0
                end
            end

            card.ability.extra.current_hand = reps
        elseif context.cardarea == G.play and context.repetition and not context.repetition_only then
            for i, scoring_card in ipairs(context.scoring_hand) do
                if scoring_card == context.other_card then
                    return {
                        message = localize('k_again_ex'),
                        repetitions = card.ability.extra.current_hand[i],
                        card = context.blueprint_card or card
                    }
                end
            end
        end
    end
}

-- 41.
-- Scoring Bonus cards gain +10 extra Chips when scored. Scoring Mult cards gain +2 extra Mult when scored. Scoring Gold cards cain +$1 when scored.
-- Common
SMODS.Joker {
    name = "Chef Joker",
    key = "chef_joker",
    config = {
        extra = {
            chips = 10,
            mult = 4,
            dollars = 1,
        }
    },
    pos = {
        x = 0,
        y = 0,
    },
    unlocked = true,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    cost = 4,
    rarity = 1,
    atlas = "Baliatro",

    new_york = {
        compatible = true,
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.chips, card.ability.extra.mult, card.ability.extra.dollars }}
    end,

    calculate = function(self, card, context)
        if context.cardarea == G.play and context.individual and not context.repetition then
            local other = context.other_card
            if SMODS.has_enhancement(other, 'm_gold') then
                other.ability.h_dollars = other.ability.h_dollars + card.ability.extra.dollars
                return {
                    extra = {message = localize{type='variable', key='a_baliatro_cooking_money', vars = {card.ability.extra.dollars}}},
                    card = card
                }
            elseif SMODS.has_enhancement(other, 'm_bonus') then
                other.ability.bonus = other.ability.bonus + card.ability.extra.chips
                return {
                    extra = {message = localize{type='variable', key='a_baliatro_cooking_chips', vars = {card.ability.extra.chips}}},
                    card = card
                }
            elseif SMODS.has_enhancement(other, 'm_mult') then
                other.ability.mult = other.ability.mult + card.ability.extra.mult
                return {
                    extra = {message = localize{type='variable', key='a_baliatro_cooking_mult', vars = {card.ability.extra.mult}}},
                    card = card
                }
            end
        end
    end
}

-- 42.
-- X3 Mult if all other Jokers are Common.
-- Uncommon
SMODS.Joker {
    name = "Landlord",
    key = "landlord",
    pos = {
        x = 0,
        y = 0,
    },
    config = {
        extra = {
            xmult = 3,
        }
    },

    new_york = {
        compatible = true,
    },

    unlocked = true,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    cost = 6,
    rarity = 2,
    atlas = "Baliatro",

    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.xmult}}
    end,

    calculate = function(self, card, context)
        if context.joker_main then
            local active = true
            for i, other_joker in ipairs(G.jokers.cards) do
                if other_joker ~= card and other_joker.config.center.rarity ~= 1 and other_joker.config.center.rarity ~= "common" then
                    active = false
                end
            end
            if active then
                return {
                    xmult = card.ability.extra.xmult,
                }
            end
        end
    end
}

-- 43.
-- X1 Mult. Gain X0.25 Mult if hand played is Pair. Lose X0.25 Mult if hand played is High Card. Hands change each hand played. Gaining hand cannot be your most played hand and losing hand cannot be your least played hand.
-- Common
SMODS.Joker {
    name = "Scales",
    key = "scales",
    pos = {
        x = 0,
        y = 0,
    },
    config = {
        extra = {
            xmult = 1,
            gain = 0.3,
            lose = 0.1,
            gain_hand = nil,
            --lose_hand = "High Card"
        }
    },

    new_york = {
        compatible = true,
    },

    unlocked = true,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    cost = 6,
    rarity = 2,
    atlas = "Baliatro",

    setab = function(self, card)
        local all = BALIATRO.collect_visible_hands()
        local except_most = BALIATRO.filter_visible_hands{exclude_most_played = true, exclude_key = card.ability.extra.gain_hand}
        if #except_most == 0 then except_most = all end

        card.ability.extra.gain_hand = pseudorandom_element(except_most, pseudoseed('scales'))
        --card.ability.extra.lose_hand = card.ability.extra.gain_hand
        --local att = 0
        --while card.ability.extra.gain_hand == card.ability.extra.lose_hand do
        --    att = att + 1
        --    if att > 5 then
        --        except_least = all
        --    end
        --    card.ability.extra.lose_hand = pseudorandom_element(except_least, pseudoseed('scales'))
        --end
        return {
            message = localize('k_reset'),
            card = card,
        }
    end,

    set_ability = function(self, card, initial, delay_sprites)
        self:setab(card)
    end,

    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.xmult, card.ability.extra.gain, card.ability.extra.gain_hand, card.ability.extra.lose}}
    end,

    calculate = function(self, card, context)
        if context.before and not context.blueprint then
            if context.scoring_name == card.ability.extra.gain_hand then
                card.ability.extra.xmult = card.ability.extra.xmult + card.ability.extra.gain
                return {
                    message = localize('k_upgrade_ex'),
                    card = card,
                }
            else
                card.ability.extra.xmult = math.max(1, card.ability.extra.xmult - card.ability.extra.lose)
                return {
                    message = localize('k_downgrade_ex'),
                    card = card,
                }
            end
        elseif context.joker_main then
            return {
                xmult = card.ability.extra.xmult,
            }
        elseif context.after and not context.blueprint then
            return self:setab(card)
        end
    end
}

-- 44.
-- Every 7th time a 7 is scored within a hand, divide the score required to pass the blind by 7.
-- Rare
SMODS.Joker {
    name = "Sevenfold Avenger",
    key = "sevenfold_avenger",
    pos = {
        x = 4,
        y = 3,
    },
    config = {
        extra = {
            counter = 0,
        }
    },

    new_york = {
        compatible = false,
    },

    unlocked = true,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    cost = 8,
    rarity = 3,
    atlas = "Baliatro",

    calculate = function(self, card, context)
        if context.blueprint then return end
        if context.before  then
            card.ability.extra.counter = 0
        elseif context.individual and context.cardarea == G.play then
            local other = context.other_card
            if not SMODS.has_no_rank(other) and other.base.value == '7' then
                card.ability.extra.counter = card.ability.extra.counter + 1
                if card.ability.extra.counter % 7 == 0 then
                    G.GAME.blind.chips = math.floor(G.GAME.blind.chips / 7) or 1
                    G.GAME.blind.chip_text = number_format(G.GAME.blind.chips)
                    return {
                        message = localize{type='variable', key='a_divide_by_ex', vars={'7'}},
                        card = card,
                    }
                end
            end
        end
    end
}

-- 45.
-- The third scored card each hand grants X1 Mult when scored. If scored hand is Three of a Kind and third scoring card is not your most scored Rank, this gains +X0.3 Mult.
-- Uncommon
SMODS.Joker {
    name = "Triple Trouble",
    key = "triple_trouble",
    pos = {
        x = 0,
        y = 0,
    },
    config = {
        extra = {
            xmult = 1.1,
            xmult_gain = 0.05,
            gain_hand = 'Three of a Kind',
        }
    },

    new_york = {
        compatible = true,
    },

    unlocked = true,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    cost = 6,
    rarity = 2,
    atlas = "Baliatro",

    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.xmult, card.ability.extra.xmult_gain}}
    end,

    calculate = function(self, card, context)
        if context.before  and #context.scoring_hand >= 3 and context.scoring_name == 'Three of a Kind' and not context.blueprint then
            local third_card = context.scoring_hand[3]
            local value = third_card.base.value
            local most = BALIATRO.most_scored_rank_scores()
            if G.GAME.ranks_scored[value] ~= most then
                card.ability.extra.xmult = card.ability.extra.xmult + card.ability.extra.xmult_gain
                return {
                    message = localize('k_upgrade_ex'),
                    card = card,
                }
            end
        elseif context.individual and context.cardarea == G.play and #context.scoring_hand >= 3 and not context.repetition  then
            local other = context.other_card
            if context.scoring_hand[3] == other then
                return {
                    xmult = card.ability.extra.xmult,
                }
            end
        end
    end
}

-- 46.
-- Scoring cards grant Chips equal to the number of times their Rank has been scored.
-- Common
SMODS.Joker {
    name = "Appraiser Joker",
    key = "appraiser_joker",
    pos = {
        x = 0,
        y = 0,
    },

    config = {
        extra = {
            mult = 1,
        },
    },

    new_york = {
        compatible = true,
    },
    upgrades_to = 'j_baliatro_senior_appraiser_joker',

    unlocked = true,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    cost = 4,
    rarity = 1,
    atlas = "Baliatro",

    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.mult}}
    end,

    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and not context.repetition then
            local other = context.other_card
            local times_scored = G.GAME.ranks_scored[other.base.value]
            if times_scored > 0 then
                return {
                    chips = times_scored * card.ability.extra.mult,
                }
            end
        end
    end
}


-- 47.
-- X3 Mult if scored hand contains your most scored Rank.
-- Uncommon
SMODS.Joker {
    name = "The Favourite",
    key = "favourite",
    pos = {
        x = 3,
        y = 3,
    },
    config = {
        extra = {
            xmult = 3,
            activated = false,
        }
    },

    new_york = {
        compatible = true,
    },

    unlocked = true,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    cost = 6,
    rarity = 2,
    atlas = "Baliatro",

    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.xmult}}
    end,

    calculate = function(self, card, context)
        if context.before  and not context.blueprint then
            card.ability.extra.activated = false
            local most = BALIATRO.most_scored_rank_scores()
            for k, v in pairs(context.scoring_hand) do
                if G.GAME.ranks_scored[v.base.value] == most then
                    card.ability.extra.activated = true
                    break
                end
            end
        elseif context.joker_main and card.ability.extra.activated then
            return { xmult = card.ability.extra.xmult }
        end
    end
}

-- 48.
-- In the Nth hand played each round, retrigger the Nth scoring card N times. (example: second hand played, retrigger second card twice)
-- Uncommon
SMODS.Joker {
    name = "Straight of Jokers",
    key = "straight_of_jokers",
    pos = {
        x = 0,
        y = 0,
    },
    config = {
    },

    new_york = {
        compatible = false,
    },

    unlocked = true,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    cost = 6,
    rarity = 2,
    atlas = "Baliatro",

    loc_vars = function(self, info_queue, card)
        return {vars = {(G.GAME and G.GAME.current_round and G.GAME.current_round.hands_played + 1) or 1}}
    end,

    calculate = function(self, card, context)
        local n = G.GAME.current_round.hands_played + 1
        if context.repetition and not context.repetition_only and context.cardarea == G.play and #context.scoring_hand >= n and context.scoring_hand[n] == context.other_card then
            return {
                message = localize('k_again_ex'),
                repetitions = n,
                card = context.blueprint_card or card
            }
        end
    end
}

-- 49.
-- X4 Mult if the Nth hand played this round has N scoring card (example: second hand played has two scoring cards)
-- Uncommon
SMODS.Joker {
    name = "Jokers of a Kind",
    key = "jokers_of_a_kind",
    pos = {
        x = 0,
        y = 0,
    },
    config = {
        extra = {
            xmult = 4,
        }
    },

    new_york = {
        compatible = true,
    },

    unlocked = true,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    cost = 6,
    rarity = 2,
    atlas = "Baliatro",

    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.xmult, (G.GAME and G.GAME.current_round and G.GAME.current_round.hands_played + 1) or 1}}
    end,

    calculate = function(self, card, context)
        local n = G.GAME.current_round.hands_played + 1
        if context.joker_main and #context.scoring_hand == n then
            return {
                xmult = card.ability.extra.xmult
            }
        end
    end
}

-- 50.
-- X1 Mult. Gains X0.15 Mult if played hand is most scored hand and contains the least scored rank, or the least scored hand and contains the most scored rank.
-- Uncommon
SMODS.Joker {
    name = "Hadron Collider",
    key = "hadron_collider",
    pos = {
        x = 0,
        y = 0,
    },
    config = {
        extra = {
            xmult = 1,
            xmult_gain = 0.2,
        }
    },

    new_york = {
        compatible = true,
    },

    unlocked = true,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    cost = 6,
    rarity = 2,
    atlas = "Baliatro",

    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.xmult, card.ability.extra.xmult_gain}}
    end,

    calculate = function(self, card, context)
        if context.before  and not context.blueprint then
            local lsr = BALIATRO.least_scored_rank_scores()
            local msr = BALIATRO.most_scored_rank_scores()
            local lph = BALIATRO.least_played_hand_times()
            local mph = BALIATRO.most_played_hand_times()
            local contains_lsr = false
            local contains_msr = false
            local contains_lph = false
            local contains_mph = false

            if G.GAME.hands[context.scoring_name].played == lph  or G.GAME.hands[context.scoring_name].played == lph + 1 then contains_lph = true end
            if G.GAME.hands[context.scoring_name].played == mph then contains_mph = true end
            for k, v in ipairs(context.scoring_hand) do
                if G.GAME.ranks_scored[v.base.value] == lsr then contains_lsr = true end
                if G.GAME.ranks_scored[v.base.value] == msr then contains_msr = true end
            end

            if (contains_lsr and contains_mph) or (contains_msr and contains_lph) then
                card.ability.extra.xmult = card.ability.extra.xmult + card.ability.extra.xmult_gain
                return {
                    message = localize('k_upgrade_ex'),
                    card = card,
                }
            end
        elseif context.joker_main and card.ability.extra.xmult > 1 then
            return {
                xmult = card.ability.extra.xmult,
            }
        end
    end
}


-- 51.
-- After scoring, a random scoring card each hand that is not the most scored rank in that hand becomes the same rank as the most scored rank in that hand. If not possible, destroy this joker.
-- Uncommon

-- 52.
-- +0 Mult. Gain +2 Mult, when a card with the most scored rank is scored.
-- Common
SMODS.Joker {
    name = "Katamari Joker",
    key = "katamari_joker",
    pos = {
        x = 8,
        y = 3,
    },
    config = {
        extra = {
            mult = 0,
            mult_gain = 1,
        }
    },

    new_york = {
        compatible = true,
    },
    upgrades_to = 'j_baliatro_king_of_all_cosmos',

    unlocked = true,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    cost = 4,
    rarity = 1,
    atlas = "Baliatro",

    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.mult, card.ability.extra.mult_gain}}
    end,

    calculate = function(self, card, context)

        if context.individual and context.cardarea == G.play and not context.blueprint then
            local msr = BALIATRO.most_scored_rank_scores()
            if G.GAME.ranks_scored[context.other_card.base.value] == msr then
                card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.mult_gain
                return {
                    message = localize('k_upgrade_ex'),
                    card = card,
                }
            end
        elseif context.joker_main and card.ability.extra.mult > 0 then
            return {
                mult = card.ability.extra.mult,
            }
        end
    end
}

-- 53.
-- Scored Wild Cards grant +7 Mult. Create 1 Lovers if scored hand contains a Flush.
-- Common
SMODS.Joker {
    name = "Romeo",
    key = "romeo",
    pos = {
        x = 7,
        y = 3,
    },
    config = {
        extra = {
            created_amount = 1,
            created_card = "c_lovers",
            created_type = "Tarot",
            mult = 7,
            lose_mult = 1,
        }
    },

    new_york = {
        compatible = true,
    },

    unlocked = true,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    cost = 4,
    rarity = 1,
    atlas = "Baliatro",

    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.mult, card.ability.extra.created_amount, card.ability.extra.lose_mult}}
    end,

    calculate = function(self, card, context)

        if context.before and next(context.poker_hands["Flush"]) then
            local created_amt = math.min(G.consumeables.config.card_limit - (#G.consumeables.cards + G.GAME.consumeable_buffer), card.ability.extra.created_amount)
            if created_amt > 0 then
                G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + created_amt
                local ctype = card.ability.extra.created_type
                local ccard = card.ability.extra.created_card
                G.E_MANAGER:add_event(Event({
                    trigger = 'before',
                    delay = 0.0,
                    func = (function()
                        for j = 1, created_amt do
                            local card = create_card(ctype, G.consumeables, nil, nil, nil, nil, ccard, "romeo")
                            card:add_to_deck()
                            G.consumeables:emplace(card)
                            G.GAME.consumeable_buffer = 0
                        end
                        return true
                    end)}))
                return {
                    message = localize('k_plus_tarot'),
                    card = context.blueprint_card or card,
                    colour = G.C.SECONDARY_SET.Tarot,
                }
            end
        elseif context.individual and context.cardarea == G.play then
            if SMODS.has_any_suit(context.other_card) then
                return {
                    mult = card.ability.extra.mult,
                    card = context.blueprint_card or card,
                }
            end
        elseif context.using_consumeable and context.consumeable.config.center.key == card.ability.extra.created_card then
            card.ability.extra.mult = card.ability.extra.mult - card.ability.extra.lose_mult
            return {
                message = localize('k_downgrade_ex')
            }
        end
    end
}

-- 54.
-- All scored cards become one rank higher when scored. Scored cards subtract chips equal to the chip value of their old rank.
-- Common
SMODS.Joker {
    name = "Bodybuilder",
    key = "bodybuilder",
    pos = {
        x = 0,
        y = 0,
    },
    config = {
        extra = {
            odds = 2,
            mult = 4,
        }
    },

    new_york = {
        compatible = false,
    },

    unlocked = true,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    cost = 4,
    rarity = 1,
    atlas = "Baliatro",

    loc_vars = function(self, info_queue, card)
        return {vars = {(G.GAME and G.GAME.probabilities.normal) or 1, card.ability.extra.odds, card.ability.extra.mult}}
    end,

    calculate = function(self, card, context)

        if context.individual and context.cardarea == G.play and not context.repetition and pseudorandom('bodybuilder') < G.GAME.probabilities.normal / card.ability.extra.odds then
            local oc = context.other_card
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.15,
                func = function()
                    oc:flip()
                    play_sound('card1', 1)
                    oc:juice_up(0.3, 0.3)
                    delay(0.2)
                    return true
                end
            }))
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.1,
                func = function()
                    local rank = SMODS.Ranks[oc.base.value]
                    local new_rank = rank.next[1]
                    SMODS.change_base(oc, nil, new_rank)
                    oc:flip()
                    play_sound('tarot2', 1)
                    oc:juice_up(0.3, 0.3)
                    return true
                end
            }))
            return {
                message = localize('k_upgrade_ex'),
                card = context.blueprint_card or card,
            }
        elseif context.joker_main then
            return {
                mult = card.ability.extra.mult
            }
        end
    end
}

-- 55. Tug of War
-- If there are less cards in play than in hand, retrigger all scored cards 2 times. If there are less cards in hand than in play, retrigger all cards in hand 2 times.
-- Uncommon
SMODS.Joker {
    name = "Tug of War",
    key = "tug_of_war",
    config = {
        extra = {
            retriggers = 2,
            target_ca = nil,
        }
    },
    pos = {
        x = 6,
        y = 3,
    },
    unlocked = true,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    cost = 6,
    rarity = 2,
    atlas = "Baliatro",

    new_york = {
        compatible = true,
    },

    loc_vars = function(self, info_queue, card)
        return { vars = {card.ability.extra.retriggers }}
    end,

    calculate = function(self, card, context)
        local scorer = context.blueprint_card or card
        if context.before and context.cardarea == G.jokers and not context.blueprint then
            local target_ca = nil
            local message = 'k_nope_ex'
            if #G.hand.cards < #G.play.cards then
                target_ca = G.hand
                message = 'k_baliatro_hand_ex'
            elseif #G.play.cards < #G.hand.cards then
                target_ca = G.play
                message = 'k_baliatro_play_ex'
            end
            card.ability.extra.target_ca = target_ca
            return {
                message = localize(message),
                card = scorer,
            }
        elseif card.ability.extra.target_ca and context.cardarea == card.ability.extra.target_ca and context.repetition and not context.repetition_only then
            return {
                message = localize('k_again_ex'),
                repetitions = card.ability.extra.retriggers,
                card = scorer
            }
        end
    end
}

-- 56. The Bishop
-- Retrigger the first Bonus card played each hand. If the sum of ranks of scored cards is 28 to 32, create 1 Hierophant. Hierophants played on Enhanced cards permanently add 30 Chips to that card instead of enhancing it.
-- Common
SMODS.Joker {
    name = "The Bishop",
    key = "bishop",
    config = {
        extra = {
            retriggers = 1,
            min_score = 28,
            max_score = 32,
            bonus = 30,
            created_amt = 1,
            created_set = 'Tarot',
            created_card = 'c_heirophant',

            activated = false,

            overrides_consumeable = "c_heirophant",
        },
    },
    pos = {
        x = 1,
        y = 1,
    },
    unlocked = true,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    cost = 4,
    rarity = 1,
    atlas = "Baliatro",

    new_york = {
        compatible = true,
        ignore_extra_fields = {'min_score', 'max_score'}
    },

    on_already_enhanced = function(joker, other_card, used_tarot)
        other_card.ability.perma_bonus = (other_card.ability.perma_bonus or 0) + joker.ability.extra.bonus
    end,

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = G.P_CENTERS[card.ability.extra.created_card]
        return { vars = {card.ability.extra.retriggers, card.ability.extra.min_score, card.ability.extra.max_score, card.ability.extra.created_amt, card.ability.extra.bonus }}
    end,

    calculate = function(self, card, context)
        if context.blueprint then return end
        local scorer = context.blueprint_card or card
        if context.before and context.cardarea == G.jokers and not context.blueprint then
            card.ability.extra.activated = false
            local sum = BALIATRO.rank_sum(context)
            if sum >= card.ability.extra.min_score and sum <= card.ability.extra.max_score then
                BALIATRO.guided_create_card(card.ability.extra.created_amt, card.ability.extra.created_set, card.ability.extra.created_card, 'bishop')
                return {
                    message = localize('k_plus_tarot'),
                    card = scorer,
                }
            end
        elseif context.repetition and not context.repetition_only and not card.ability.extra.activated and SMODS.has_enhancement(context.other_card, 'm_bonus') and context.cardarea == G.play then
            card.ability.extra.activated = true
            return {
                message = localize('k_again_ex'),
                repetitions = card.ability.extra.retriggers,
                card = scorer
            }
        end
    end
}

-- 57. The Queen
-- Retrigger the first Mult card played each hand. If the sum of ranks of scored cards is 18 to 22, create an Empress. Empresses played on Enhanced cards permanently add 4 Mult to that card instead of enhancing it.
-- Common
SMODS.Joker {
    name = "The Queen",
    key = "queen",
    config = {
        extra = {
            retriggers = 1,
            min_score = 18,
            max_score = 22,
            bonus = 4,
            created_amt = 1,
            created_set = 'Tarot',
            created_card = 'c_empress',

            activated = false,

            overrides_consumeable = "c_empress",
        },
    },
    pos = {
        x = 3,
        y = 1,
    },
    unlocked = true,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    cost = 4,
    rarity = 1,
    atlas = "Baliatro",

    new_york = {
        compatible = true,
        ignore_extra_fields = {'min_score', 'max_score'}
    },

    on_already_enhanced = function(joker, other_card, used_tarot)
        other_card.ability.perma_mult = (other_card.ability.perma_mult or 0) + joker.ability.extra.bonus
    end,

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = G.P_CENTERS[card.ability.extra.created_card]
        return { vars = {card.ability.extra.retriggers, card.ability.extra.min_score, card.ability.extra.max_score, card.ability.extra.created_amt, card.ability.extra.bonus }}
    end,

    calculate = function(self, card, context)
        if context.blueprint then return end
        local scorer = context.blueprint_card or card
        if context.before and context.cardarea == G.jokers and not context.blueprint then
            card.ability.extra.activated = false
            local sum = BALIATRO.rank_sum(context)
            if sum >= card.ability.extra.min_score and sum <= card.ability.extra.max_score then
                BALIATRO.guided_create_card(card.ability.extra.created_amt, card.ability.extra.created_set, card.ability.extra.created_card, 'queen')
                return {
                    message = localize('k_plus_tarot'),
                    card = scorer,
                }
            end
        elseif context.repetition and not context.repetition_only and not card.ability.extra.activated and SMODS.has_enhancement(context.other_card, 'm_mult') and context.cardarea == G.play then
            card.ability.extra.activated = true
            return {
                message = localize('k_again_ex'),
                repetitions = card.ability.extra.retriggers,
                card = scorer
            }
        end
    end
}

-- 58. The Knight
-- Retrigger the first Lucky card played each hand. If a played hand contains 5 scoring cards and no enhancements, create a Magician. Magicians played on Enhanced cards permanently add $1 to that card instead of enhancing it.
-- Common
SMODS.Joker {
    name = "The Knight",
    key = "knight",
    config = {
        extra = {
            retriggers = 1,
            bonus = 1,
            created_amt = 1,
            created_set = 'Tarot',
            created_card = 'c_magician',

            activated = false,

            overrides_consumeable = "c_magician",
        },
    },
    pos = {
        x = 0,
        y = 1,
    },
    unlocked = true,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    cost = 4,
    rarity = 1,
    atlas = "Baliatro",

    new_york = {
        compatible = true,
    },

    on_already_enhanced = function(joker, other_card, used_tarot)
        other_card.ability.perma_p_dollars = (other_card.ability.perma_p_dollars or 0) + joker.ability.extra.bonus
    end,

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = G.P_CENTERS[card.ability.extra.created_card]
        return { vars = {card.ability.extra.retriggers, card.ability.extra.created_amt, card.ability.extra.bonus }}
    end,

    calculate = function(self, card, context)
        if context.blueprint then return end
        local scorer = context.blueprint_card or card
        if context.before and context.cardarea == G.jokers and not context.blueprint then
            card.ability.extra.activated = false
            local enh = 0
            for _, oc in ipairs(context.scoring_hand) do
                if oc.ability.set == 'Enhanced' then enh = enh + 1 end
            end
            if #context.scoring_hand == 5 and enh == 0 then
                BALIATRO.guided_create_card(card.ability.extra.created_amt, card.ability.extra.created_set, card.ability.extra.created_card, 'knight')
                return {
                    message = localize('k_plus_tarot'),
                    card = scorer,
                }
            end
        elseif context.repetition and not context.repetition_only and not card.ability.extra.activated and SMODS.has_enhancement(context.other_card, 'm_lucky') and context.cardarea == G.play then
            card.ability.extra.activated = true
            return {
                message = localize('k_again_ex'),
                repetitions = card.ability.extra.retriggers,
                card = scorer
            }
        end
    end
}

-- 59. The Rook
-- Retrigger the first Stone card played each hand. Stone cards count as Wild cards. If a played hand contains a Flush, create a Tower. Towers played on Enhanced cards permanently add +X0.03 Mult to that card instead of enhancing it.
-- Uncommon
SMODS.Joker {
    name = "The Rook",
    key = "rook",
    config = {
        extra = {
            retriggers = 1,
            bonus = 0.05,
            created_amt = 2,
            created_set = 'Tarot',
            created_card = 'c_tower',

            activated = false,

            overrides_consumeable = "c_tower",
        },
    },
    pos = {
        x = 9,
        y = 0,
    },
    unlocked = true,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    cost = 5,
    rarity = 2,
    atlas = "Baliatro",

    on_already_enhanced = function(joker, other_card, used_tarot)
        other_card.ability.perma_x_mult = (other_card.ability.perma_x_mult or 0) + joker.ability.extra.bonus
    end,

    card_has_any_suit = function(self, card, other_card)
        return SMODS.has_enhancement(other_card, 'm_stone')
    end,

    new_york = {
        compatible = true,
    },

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = G.P_CENTERS[card.ability.extra.created_card]
        return { vars = {card.ability.extra.retriggers, card.ability.extra.created_amt, card.ability.extra.bonus }}
    end,

    calculate = function(self, card, context)
        if context.blueprint then return end
        local scorer = context.blueprint_card or card
        if context.before and context.cardarea == G.jokers and not context.blueprint then
            card.ability.extra.activated = false
            if next(context.poker_hands['Flush']) then
                BALIATRO.guided_create_card(card.ability.extra.created_amt, card.ability.extra.created_set, card.ability.extra.created_card, 'rook')
                return {
                    message = localize('k_plus_tarot'),
                    card = scorer,
                }
            end
        elseif context.repetition and not context.repetition_only and not card.ability.extra.activated and SMODS.has_enhancement(context.other_card, 'm_stone') and context.cardarea == G.play then
            card.ability.extra.activated = true
            return {
                message = localize('k_again_ex'),
                repetitions = card.ability.extra.retriggers,
                card = scorer
            }
        end
    end
}


-- 60. The King
-- Retrigger the first Glass card played each round. When a Glass card breaks, all Glass cards in your full deck gain +X0.1 Mult permanently. Create a Justice when a Glass card breaks.
-- Rare

-- 61. The Pawn
-- Retrigger all Resistant cards. If a hand triggers the boss ability, create two Ace of Pentacles.
-- Common
SMODS.Joker {
    name = "The Pawn",
    key = "pawn",
    config = {
        extra = {
            retriggers = 1,
            created_amt = 2,
            created_set = 'Tarot',
            created_card = 'c_baliatro_ace_of_pentacles',
        },
    },
    pos = {
        x = 8,
        y = 0,
    },
    unlocked = true,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    cost = 5,
    rarity = 1,
    atlas = "Baliatro",

    new_york = {
        compatible = true,
    },

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = G.P_CENTERS[card.ability.extra.created_card]
        return { vars = {card.ability.extra.retriggers, card.ability.extra.created_amt }}
    end,

    calculate = function(self, card, context)
        local scorer = context.blueprint_card or card
        if context.joker_main and context.cardarea == G.jokers and G.GAME.blind.triggered then
            card.ability.extra.activated = false
            if next(context.poker_hands['Flush']) then
                BALIATRO.guided_create_card(card.ability.extra.created_amt, card.ability.extra.created_set, card.ability.extra.created_card, 'rook')
                return {
                    message = localize('k_plus_tarot'),
                    card = scorer,
                }
            end
        elseif context.repetition and not context.repetition_only and SMODS.has_enhancement(context.other_card, 'm_baliatro_resistant') and context.cardarea == G.play then
            return {
                message = localize('k_again_ex'),
                repetitions = card.ability.extra.retriggers,
                card = scorer
            }
        end
    end
}

-- 62. En Passant
-- Before scoring: Remove the Enhancement from the first scoring Enhanced card and give that Enhancement to the two adjacent scoring cards. Remove the Seal from the first scoring Sealed card and give that Seal to the two adjacent scoring cards.
-- Common
SMODS.Joker {
    name = "En Passant",
    key = "en_passant",
    config = {
    },
    pos = {
        x = 9,
        y = 2,
    },
    unlocked = true,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    cost = 4,
    rarity = 1,
    atlas = "Baliatro",
    upgrades_to = "j_baliatro_il_vaticano",

    new_york = {
        compatible = false,
    },

    calculate = function(self, card, context)
        if context.blueprint then return end
        local scorer = context.blueprint_card or card
        --v:set_ability(G.P_CENTERS.c_base, nil, true)
        if context.before then
            local act = false
            if #context.scoring_hand < 2 then
                return
            end

            for i, other in ipairs(context.scoring_hand) do
                if not other.debuff and other.ability.set == 'Enhanced' then
                    local e_key = other.config.center.key
                    local enh = G.P_CENTERS[e_key]
                    local pointless = true
                    if i > 1 then
                        local prev = context.scoring_hand[i-1]
                        if prev.ability.set ~= 'Enhanced' or prev.config.center.key ~= e_key then pointless = false end
                    end

                    if i < #context.scoring_hand then
                        local next = context.scoring_hand[i+1]
                        if next.ability.set ~= 'Enhanced' or next.config.center.key ~= e_key then pointless = false end
                    end

                    if not pointless then
                        other:set_ability(G.P_CENTERS.c_base, nil, true)
                        if i > 1 then
                            local prev = context.scoring_hand[i-1]
                            prev:set_ability(enh, nil, true)
                        end
                        if i < #context.scoring_hand then
                            local next = context.scoring_hand[i+1]
                            next:set_ability(enh, nil, true)
                        end

                        act = true
                    end
                    break
                end
            end

            for i, other in ipairs(context.scoring_hand) do
                if not other.debuff and other.seal then
                    local seal = other:get_seal()
                    local pointless = true
                    if i > 1 then
                        local prev = context.scoring_hand[i-1]
                        if prev:get_seal() ~= seal then pointless = false end
                    end

                    if i < #context.scoring_hand then
                        local next = context.scoring_hand[i+1]
                        if next:get_seal() ~= seal then pointless = false end
                    end

                    if not pointless then

                        other:set_seal(nil)
                        if i > 1 then
                            local prev = context.scoring_hand[i-1]
                            prev:set_seal(seal)
                        end
                        if i < #context.scoring_hand then
                            local next = context.scoring_hand[i+1]
                            next:set_seal(seal)
                        end

                        act = true
                    end
                    break
                end
            end
            if act then
                return {
                    message = localize('k_baliatro_en_passant_ex'),
                }
            end
        end
    end
}

-- 63. 1. e4
-- If no discards have been used and the first hand of the round is five scoring, plain cards, create 1 random Spectral card. 1 in 16 chance to create a Postcard instead.
-- Common
SMODS.Joker {
    name = "1. e4",
    key = "one_e_four",
    config = {
        extra = {
            odds = 16,
            created_amt = 1,
            created_set = 'Spectral',
            created_highroll_set = 'Postcard',
        },
    },
    pos = {
        x = 0,
        y = 3,
    },
    unlocked = true,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    cost = 4,
    rarity = 1,
    atlas = "Baliatro",

    new_york = {
        compatible = true,
        divide_extra_fields = {'odds'},
    },

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = {key='baliatro_plain', set='Other'}
        return { vars = {card.ability.extra.created_amt, (G.GAME and G.GAME.probabilities.normal) or 1, card.ability.extra.odds }}
    end,

    calculate = function(self, card, context)
        local scorer = context.blueprint_card or card
        if context.first_hand_drawn and not context.blueprint then
            local eval = function() return G.GAME.current_round.hands_played == 0 and G.GAME.current_round.discards_used == 0 end
            juice_card_until(card, eval, true)
        elseif context.before and #context.scoring_hand == 5 and G.GAME.current_round.discards_used == 0 and G.GAME.current_round.hands_played == 0 then
            for i, other in ipairs(context.scoring_hand) do
                if not BALIATRO.is_plain(other) then return end
            end
            local set = card.ability.extra.created_set
            if pseudorandom('1e4') < G.GAME.probabilities.normal / card.ability.extra.odds then
                set = card.ability.extra.created_highroll_set
            end

            local amt = math.min(G.consumeables.config.card_limit - (G.GAME.consumeable_buffer + #G.consumeables.cards), card.ability.extra.created_amt)

            if amt > 0 then
                G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + amt
                G.E_MANAGER:add_event(Event({trigger = 'before', delay = 0.0, func = (function()
                    for i = 1, amt do
                        local nc = create_card(set, G.consumeables, nil, nil, nil, nil, nil, '1e4')
                        nc:add_to_deck()
                        G.consumeables:emplace(nc)
                    end
                    G.GAME.consumeable_buffer = 0
                    return true
                end)}))

                return {
                    message = localize('k_plus_spectral'),
                    colour = G.C.SECONDARY_SET.Spectral,
                    card = scorer
                }
            end
        end
    end
}

-- 64. 1. ... e5
-- If no discards have been used and the second hand of the round is five scoring, plain cards, create two random Tarot cards.
-- Common
SMODS.Joker {
    name = "1. ... e5",
    key = "one_e_five",
    config = {
        extra = {
            created_amt = 2,
            created_set = 'Tarot',
        },
    },
    pos = {
        x = 1,
        y = 3,
    },
    unlocked = true,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    cost = 4,
    rarity = 1,
    atlas = "Baliatro",

    new_york = {
        compatible = true,
    },

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = {key='baliatro_plain', set='Other'}
        return { vars = {card.ability.extra.created_amt }}
    end,

    calculate = function(self, card, context)
        local scorer = context.blueprint_card or card
        if context.after and G.GAME.current_round.hands_played == 0 and not context.blueprint then
            local eval = function() return G.GAME.current_round.hands_played < 2 and G.GAME.current_round.discards_used == 0 end
            juice_card_until(card, eval, true)
        elseif context.before and #context.scoring_hand == 5 and G.GAME.current_round.discards_used == 0 and G.GAME.current_round.hands_played == 1 then
            for i, other in ipairs(context.scoring_hand) do
                if not BALIATRO.is_plain(other) then return end
            end
            local set = card.ability.extra.created_set
            local amt = math.min(G.consumeables.config.card_limit - (G.GAME.consumeable_buffer + #G.consumeables.cards), card.ability.extra.created_amt)

            if amt > 0 then
                G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + amt
                G.E_MANAGER:add_event(Event({trigger = 'before', delay = 0.0, func = (function()
                    for i = 1, amt do
                        local nc = create_card(set, G.consumeables, nil, nil, nil, nil, nil, '1e5')
                        nc:add_to_deck()
                        G.consumeables:emplace(nc)
                    end
                    G.GAME.consumeable_buffer = 0
                    return true
                end)}))

                return {
                    message = localize('k_plus_tarot'),
                    colour = G.C.SECONDARY_SET.Spectral,
                    card = scorer
                }
            end
        end
    end
}

-- 65. Real Estate
-- X1.5 Mult. All copies and future copies of this Joker gain +X1 Mult for each time this Joker is sold.
-- Common
SMODS.Joker {
    name = "Real Estate",
    key = "real_estate",
    config = {
        extra = {
            xmult_gain = 0.5,
        }
    },
    pos = {
        x = 6,
        y = 2,
    },
    unlocked = true,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    cost = 7,
    rarity = 1,
    atlas = "Baliatro",

    new_york = {
        compatible = true,
    },

    in_pool = function(self, args)
        return true, {allow_duplicates = true}
    end,

    loc_vars = function(self, info_queue, card)
		info_queue[#info_queue+1] = {key = "baliatro_unbound", set="Other"}
        return { vars = {(G.GAME and G.GAME.real_estate) or 1.5, card.ability.extra.xmult_gain}}
    end,

    calculate = function(self, card, context)
        local scorer = context.blueprint_card or card
        if context.joker_main then
            return {
                xmult = G.GAME.real_estate
            }
        elseif context.selling_self and not context.blueprint then
            G.GAME.real_estate = G.GAME.real_estate + card.ability.extra.xmult_gain
        end
    end
}

-- 66. Sandbag
-- X0.2 Mult. +3 hands per round.
-- Common
SMODS.Joker {
    name = "Sandbag",
    key = "sandbag",
    config = {
        extra = {
            xmult = 0.2,
            hands = 3,
        }
    },
    pos = {
        x = 5,
        y = 2,
    },
    unlocked = true,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    cost = 4,
    rarity = 1,
    atlas = "Baliatro",

    new_york = {
        compatible = true,
    },

    add_to_deck = function(self, card, from_debuff)
        G.GAME.round_resets.hands = G.GAME.round_resets.hands + card.ability.extra.hands
        ease_hands_played(card.ability.extra.hands)
    end,

    remove_from_deck = function(self, card, from_debuff)
        G.GAME.round_resets.hands = math.max(G.GAME.round_resets.hands - card.ability.extra.hands, 1)
        ease_hands_played(-math.min(G.GAME.current_round.hands_left - 1, -card.ability.extra.hands))
    end,

    loc_vars = function(self, info_queue, card)
        return { vars = {card.ability.extra.xmult, card.ability.extra.hands}}
    end,

    calculate = function(self, card, context)
        local scorer = context.blueprint_card or card
        if context.joker_main then
            return {
                xmult = card.ability.extra.xmult
            }
        end
    end
}

-- 67. Lesser Demon
-- If played hand is a Three of a Kind of 6es, create 2 Devil.
-- Uncommon
SMODS.Joker {
    name = "Lesser Demon",
    key = "lesser_demon",
    pos = {
        x = 4,
        y = 2,
    },
    config = {
        extra = {
            created_amount = 2,
            created_card = "c_devil",
            created_type = "Tarot",
            mult = 8,
        }
    },

    new_york = {
        compatible = true,
    },

    unlocked = true,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    cost = 5,
    rarity = 2,
    atlas = "Baliatro",

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = G.P_CENTERS['c_devil']
        return {vars = {card.ability.extra.created_amount, card.ability.extra.mult}}
    end,

    calculate = function(self, card, context)

        if context.before and context.scoring_name == "Three of a Kind" and #context.full_hand == 3 and context.scoring_hand[1].base.value == '6' then
            local created_amt = math.min(G.consumeables.config.card_limit - (#G.consumeables.cards + G.GAME.consumeable_buffer), card.ability.extra.created_amount)
            if created_amt > 0 then
                G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + created_amt
                local ctype = card.ability.extra.created_type
                local ccard = card.ability.extra.created_card
                G.E_MANAGER:add_event(Event({
                    trigger = 'before',
                    delay = 0.0,
                    func = (function()
                        for j = 1, created_amt do
                            local card = create_card(ctype, G.consumeables, nil, nil, nil, nil, ccard, "romeo")
                            card:add_to_deck()
                            G.consumeables:emplace(card)
                            G.GAME.consumeable_buffer = 0
                        end
                        return true
                    end)}))
                return {
                    message = localize('k_plus_tarot'),
                    card = context.blueprint_card or card,
                    colour = G.C.SECONDARY_SET.Tarot,
                }
            end
        elseif context.individual and context.cardarea == G.hand then
            if SMODS.has_enhancement(context.other_card, 'm_gold') then
                return {
                    mult = card.ability.extra.mult
                }
            end
        end
    end
}

-- 68. Afterimage
-- If your first hand played in round contains only one card, destroy it. If a card was destroyed this way in current round, after each discard or hand played, add an Ethereal copy of it to your hand.
SMODS.Joker {
    name = "Afterimage",
    key = "afterimage",

    pos = {
        x = 7,
        y = 2,
    },
    config = {
        extra = {
            remembered_card = nil,
        }
    },

    new_york = {
        compatible = false,
    },

    unlocked = true,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    cost = 6,
    rarity = 3,
    atlas = "Baliatro",

    loc_vars = function(self, info_queue, card)
        if not G.GAME.blind or not G.GAME.blind.in_blind or G.GAME.current_round.hands_played == 0 then
            return {vars = {localize('k_baliatro_afterimage_ready')}}
        elseif card.ability.extra.remembered_card then
            local rc = card.ability.extra.remembered_card
            return {vars = {localize{type='variable', key='a_baliatro_afterimage_remembered', vars={rc.base.value, rc.base.suit}}}}
        else
            return {vars = {localize('k_baliatro_afterimage_no_card')}}
        end
    end,

    calculate = function(self, card, context)
        if context.end_of_round then
            if not context.blueprint then
                card.ability.extra.remembered_card = nil
            end
        elseif context.first_hand_drawn then
            if not context.blueprint then
                card.ability.extra.remembered_card = nil
                local eval = function() return G.GAME.current_round.hands_played == 0 end
                juice_card_until(card, eval, true)
                end
        elseif context.before and G.GAME.current_round.hands_played == 0 and #context.full_hand == 1 then
            if not context.blueprint then
                context.full_hand[1].baliatro_afterimage_remove = true
                card.ability.extra.remembered_card = BALIATRO.skeleton_card(context.full_hand[1])
                return {
                    message = localize('k_baliatro_remembered_ex')
                }
            end
        elseif context.destroy_card and context.destroy_card.baliatro_afterimage_remove then
            if not context.blueprint then return {remove = true} end
        elseif context.after and context.cardarea == G.jokers then
            if card.ability.extra.remembered_card then
                local _card = BALIATRO.ethereal_copy(card.ability.extra.remembered_card)
                return {
                    message = localize('k_baliatro_remembrance_ex'),
                    colour = G.C.CHIPS,
                    card = context.blueprint_card or card,
                    playing_cards_created = {_card},
                }
            end
        elseif context.pre_discard then
            if card.ability.extra.remembered_card then
                local _card = BALIATRO.ethereal_copy(card.ability.extra.remembered_card, true)
                return {
                    message = localize('k_baliatro_remembrance_ex'),
                    colour = G.C.CHIPS,
                    card = context.blueprint_card or card,
                    playing_cards_created = {_card},
                }
            end
        end
    end
}

-- 69. Echo
-- +1 Hand Size. After each discard or hand played, add a random enhanced Ethereal playing card to your hand.
SMODS.Joker {
    name = "Echo",
    key = "echo",

    pos = {
        x = 8,
        y = 2,
    },
    config = {
        h_size = 1
    },

    new_york = {
        compatible = false,
    },

    unlocked = true,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    cost = 4,
    rarity = 1,
    atlas = "Baliatro",

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = G.P_CENTERS['e_baliatro_ethereal']
        return {vars = {card.ability.h_size}}
    end,

    create_card = function(self, on_discard)
        local _enh = SMODS.poll_enhancement({guaranteed = true})
        local _seal = SMODS.poll_seal({mod = 10})
        local _card = SMODS.create_card {set = "Enhanced", edition = 'e_baliatro_ethereal', enhancement = _enh, seal = _seal, area = G.hand, skip_materialize = true, soulable = false, key_append = "echo"}

        _card:set_edition('e_baliatro_ethereal')
        _card:add_to_deck()
        G.deck.config.card_limit = G.deck.config.card_limit + 1
        if on_discard then
            _card.edition.created_on_discard = G.GAME.current_round.discards_used
        end
        table.insert(G.playing_cards, _card)
        G.hand:emplace(_card)
        _card.states.visible = nil

        G.E_MANAGER:add_event(Event({
            func = function()
                _card:start_materialize()
                return true
            end
        }))
    end,

    calculate = function(self, card, context)
        if context.after and context.cardarea == G.jokers or context.pre_discard then
            self:create_card(context.pre_discard)
        end
    end
}

-- 70.
-- +10 Mult if hand is not your most played hand.
SMODS.Joker {
    name = "Monolith",
    key = "monolith",

    pos = {
        x = 2,
        y = 3,
    },
    config = {
        extra = {
            mult = 10,
        }
    },

    new_york = {
        compatible = true,
    },

    unlocked = true,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    cost = 5,
    rarity = 1,
    atlas = "Baliatro",

    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.mult}}
    end,

    calculate = function(self, card, context)
        if context.joker_main then
            local mph = BALIATRO.most_played_hand_times()
            if G.GAME.hands[context.scoring_name].played ~= mph then
                return {
                    mult = card.ability.extra.mult
                }
            end
        end
    end
}

-- 71. Sicilian Defence
-- +20 Mult if all cards in scored hand are plain
SMODS.Joker {
    name = "Sicilian Defence",
    key = "sicilian_defence",

    pos = {
        x = 0,
        y = 0,
    },
    config = {
        extra = {
            mult = 20,
        }
    },

    new_york = {
        compatible = true,
    },

    unlocked = true,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    cost = 5,
    rarity = 1,
    atlas = "Baliatro",

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = {key='baliatro_plain', set='Other'}
        return { vars = {card.ability.extra.mult}}
    end,

    calculate = function(self, card, context)
        if context.joker_main then
            for i, other in ipairs(context.scoring_hand) do
                if not BALIATRO.is_plain(other) then return end
            end
            return {
                mult = card.ability.extra.mult
            }
        end
    end
}

-- 72. Whale Joker
-- -$0 per hand played. Before hand is scored, a random, scored unenhanced card becomes a Microtransaction Card.
SMODS.Joker {
    name = "Whale Joker",
    key = "whale",

    pos = {
        x = 5,
        y = 3,
    },
    config = {
        extra = {
            cost = 0,
            inflation_grace = 2,
            inflation_odds = 2,
            epic = 1,
            rare = 5,
            uncommon = 10,
            common = 10,
        }
    },

    new_york = {
        compatible = false,
    },

    unlocked = true,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    cost = 6,
    rarity = 1,
    atlas = "Baliatro",

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = G.P_CENTERS.m_baliatro_mtx_common
        info_queue[#info_queue+1] = G.P_CENTERS.m_baliatro_mtx_uncommon
        info_queue[#info_queue+1] = G.P_CENTERS.m_baliatro_mtx_rare
        info_queue[#info_queue+1] = G.P_CENTERS.m_baliatro_mtx_epic
        return { vars = {card.ability.extra.cost}}
    end,

    calculate = function(self, card, context)
        if context.joker_main and card.ability.extra.cost > 0 then
            return {
                dollars = -card.ability.extra.cost
            }
        elseif context.before then
            local total_weight = card.ability.extra.common + card.ability.extra.uncommon + card.ability.extra.rare + card.ability.extra.epic
            local wt = total_weight * pseudorandom('whale')
            local targets = {}
            for _, cand in ipairs(context.scoring_hand) do
                if cand.ability.set == 'Default' then targets[#targets+1] = cand end
            end
            if #targets > 0 then
                local other_card = pseudorandom_element(targets, pseudoseed('whale'))

                if wt < card.ability.extra.common then
                    other_card:set_ability('m_baliatro_mtx_common')
                elseif wt < card.ability.extra.common + card.ability.extra.uncommon then
                    other_card:set_ability('m_baliatro_mtx_uncommon')
                elseif wt < card.ability.extra.common + card.ability.extra.uncommon + card.ability.extra.rare then
                    other_card:set_ability('m_baliatro_mtx_rare')
                else
                    other_card:set_ability('m_baliatro_mtx_epic')
                end
                return {
                    message = localize('k_upgrade_ex'),
                    message_card = other_card,
                }
            end
        elseif context.setting_blind then
            if card.ability.extra.inflation_grace > 0 then
                card.ability.extra.inflation_grace = card.ability.extra.inflation_grace - 1
            elseif pseudorandom('whale') < 1 / card.ability.extra.inflation_odds then
                card.ability.extra.cost = card.ability.extra.cost + 1
                return {
                    message = localize('k_baliatro_inflation_ex'),
                }
            end
        end
    end
}

-- 73.
-- After a hand is scored, remove Microtransaction enhancements from all scored cards and gain dollars based on tier values.
SMODS.Joker {
    name = "Vapor Marketplace",
    key = "vapor_marketplace",

    pos = {
        x = 0,
        y = 0,
    },
    config = {
        extra = {
            common = 3,
            uncommon = 5,
            rare = 10,
            epic = 20,
        }
    },

    new_york = {
        compatible = false,
    },

    unlocked = true,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    cost = 4,
    rarity = 2,
    atlas = "Baliatro",

    in_pool = function(self, args)
        for kk, vv in pairs(G.playing_cards) do
            if SMODS.has_enhancement(vv, 'm_baliatro_mtx_common') or SMODS.has_enhancement(vv, 'm_baliatro_mtx_uncommon') or SMODS.has_enhancement(vv, 'm_baliatro_mtx_rare') or SMODS.has_enhancement(vv, 'm_baliatro_mtx_epic') then
                return true
            end
        end
    end,

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = G.P_CENTERS.m_baliatro_mtx_common
        info_queue[#info_queue+1] = G.P_CENTERS.m_baliatro_mtx_uncommon
        info_queue[#info_queue+1] = G.P_CENTERS.m_baliatro_mtx_rare
        info_queue[#info_queue+1] = G.P_CENTERS.m_baliatro_mtx_epic
        return {vars = {}}
    end,

    calculate = function(self, card, context)
        if context.after and context.cardarea == G.jokers and not context.blueprint then
            local mtx_dollars = 0
            for _, cand in ipairs(context.scoring_hand) do
                if SMODS.has_enhancement(cand, 'm_baliatro_mtx_common') or SMODS.has_enhancement(cand, 'm_baliatro_mtx_uncommon') or SMODS.has_enhancement(cand, 'm_baliatro_mtx_rare') or SMODS.has_enhancement(cand, 'm_baliatro_mtx_epic') then
                    mtx_dollars = mtx_dollars + cand.ability.mtx_value
                    local target = cand

                    G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.05, func = function()
                        target:set_ability(G.P_CENTERS.c_base, nil, true)
                        return true
                    end}))
                end
            end
            return {
                dollars = mtx_dollars,
                message_card = card,
            }
        end
    end
}

-- 74.
-- -$4 when blind is selected. At end of round, some unenhanced cards in your deck may become Microtransaction cards.
SMODS.Joker {
    name = "Battle Pass",
    key = "battle_pass",

    pos = {
        x = 0,
        y = 0,
    },
    config = {
        extra = {
            cost = 4,
            odds = {1, 1.5, 2, 3, 4},
            inflation_grace = 3,
            inflation_odds = 6,
            common = 3,
            uncommon = 5,
            rare = 10,
            epic = 20,
        }
    },

    new_york = {
        compatible = false,
    },

    unlocked = true,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    cost = 1,
    rarity = 2,
    atlas = "Baliatro",

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = G.P_CENTERS.m_baliatro_mtx_common
        info_queue[#info_queue+1] = G.P_CENTERS.m_baliatro_mtx_uncommon
        info_queue[#info_queue+1] = G.P_CENTERS.m_baliatro_mtx_rare
        info_queue[#info_queue+1] = G.P_CENTERS.m_baliatro_mtx_epic
        return { vars = {card.ability.extra.cost}}
    end,

    calculate = function(self, card, context)
        if context.end_of_round and context.cardarea == G.jokers then
            local total_weight = card.ability.extra.common + card.ability.extra.uncommon + card.ability.extra.rare + card.ability.extra.epic
            local targets = {}
            for _, cand in ipairs(G.playing_cards) do
                if cand.ability.set == 'Default' then targets[#targets+1] = cand end
            end
            local odds_idx = 1
            local stop = false
            repeat
                local odds = #card.ability.extra.odds >= odds_idx and card.ability.extra.odds[odds_idx] or card.ability.extra.odds[#card.ability.extra.odds]
                odds_idx = odds_idx + 1
                if pseudorandom('bpass') <= 1 / odds then
                    local wt = total_weight * pseudorandom('bpass')
                    if #targets > 0 then
                        local other_card, other_key = pseudorandom_element(targets, pseudoseed('bpass'))
                        table.remove(targets, other_key)

                        if wt < card.ability.extra.common then
                            other_card:set_ability('m_baliatro_mtx_common')
                        elseif wt < card.ability.extra.common + card.ability.extra.uncommon then
                            other_card:set_ability('m_baliatro_mtx_uncommon')
                        elseif wt < card.ability.extra.common + card.ability.extra.uncommon + card.ability.extra.rare then
                            other_card:set_ability('m_baliatro_mtx_rare')
                        else
                            other_card:set_ability('m_baliatro_mtx_epic')
                        end
                    end
                else
                    stop = true -- technically could just break here
                end
            until stop
            return {
                message = localize('k_upgrade_ex'),
            }
        elseif context.setting_blind then
            if card.ability.extra.inflation_grace > 0 then
                card.ability.extra.inflation_grace = card.ability.extra.inflation_grace - 1
            elseif pseudorandom('battle_pass') < 1 / card.ability.extra.inflation_odds then
                card.ability.extra.cost = card.ability.extra.cost + 1
                return {
                    message = localize('k_baliatro_inflation_ex'),
                    dollars = -card.ability.extra.cost
                }
            end
            return {
                dollars = -card.ability.extra.cost
            }
        end
    end
}

-- 75.
-- Before scoring, permanently grant the leftmost scored card chips equal to the base chip value of all other scored cards. After scoring, non-Leftmost cards permanently lose chips equal to their base chip value.
SMODS.Joker {
    name = "All In",
    key = "all_in",

    pos = {
        x = 0,
        y = 0,
    },
    config = {
    },

    new_york = {
        compatible = false,
    },

    unlocked = true,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    cost = 4,
    rarity = 1,
    atlas = "Baliatro",

    calculate = function(self, card, context)
        if context.before and context.cardarea == G.jokers then
            local sum = 0
            for i, other in ipairs(context.scoring_hand) do
                if i ~= 1 then sum = sum + other.base.nominal end
            end

            if sum > 0 then
                context.scoring_hand[1].ability.perma_bonus = (context.scoring_hand[1].ability.perma_bonus or 0) + sum
                return {
                    message = localize('k_upgrade_ex'),
                    message_card = context.scoring_hand[1],
                }
            end
        elseif context.after and #context.scoring_hand > 1 then
            for i, other in ipairs(context.scoring_hand) do
                if i ~= 1 then other.ability.perma_bonus = (other.ability.perma_bonus or 0) - other.base.nominal end
            end

            return {
                message = localize('k_downgrade_ex'),
            }
        end
    end
}

-- 76. The Elephant
-- Retrigger the first Gold card held in hand. Devils played on Enhanced cards permanently add X1.05 Chips when held in hand to that card instead of enhancing it.
-- Uncommon
SMODS.Joker {
    name = "The Elephant",
    key = "elephant",
    config = {
        extra = {
            retriggers = 1,
            bonus = 0.05,

            overrides_consumeable = "c_devil",
            activated = false,
        },
    },
    pos = {
        x = 0,
        y = 0,
    },
    unlocked = true,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    cost = 5,
    rarity = 2,
    atlas = "Baliatro",

    new_york = {
        compatible = true,
        ignore_extra_fields = {}
    },

    on_already_enhanced = function(joker, other_card, used_tarot)
        other_card.ability.perma_h_x_chips = (other_card.ability.perma_h_x_chips or 1) + joker.ability.extra.bonus
    end,

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = G.P_CENTERS[card.ability.extra.overrides_consumeable]
        return { vars = {card.ability.extra.retriggers, card.ability.extra.bonus }}
    end,

    calculate = function(self, card, context)
        if context.blueprint then return end
        local scorer = context.blueprint_card or card
        if (context.before or context.end_of_round) and context.cardarea == G.jokers and not context.blueprint then
            card.ability.extra.activated = false
        elseif context.repetition and not context.repetition_only and not card.ability.extra.activated and SMODS.has_enhancement(context.other_card, 'm_gold') and context.cardarea == G.hand then
            card.ability.extra.activated = true
            return {
                message = localize('k_again_ex'),
                repetitions = card.ability.extra.retriggers,
                card = scorer
            }
        end
    end
}

-- 77.
-- X5 Mult. Loses X0.5 Mult after any hand with a scoring non-Plain card is scored.
-- Uncommon
SMODS.Joker {
    name = "Vanilla Beans",
    key = "vanilla_beans",
    config = {
        extra = {
            xmult = 5,
            lose_xmult = 0.5,
        },
    },
    pos = {
        x = 0,
        y = 0,
    },
    unlocked = true,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    cost = 5,
    rarity = 2,
    atlas = "Baliatro",

    new_york = {
        compatible = true,
        ignore_extra_fields = {}
    },

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = {key='baliatro_plain', set='Other'}
        return { vars = {card.ability.extra.xmult, card.ability.extra.lose_xmult }}
    end,

    calculate = function(self, card, context)
        if context.joker_main then
            return {
                xmult = card.ability.extra.xmult
            }
        elseif context.after and not context.blueprint then
            for _, other in ipairs(context.scoring_hand) do
                if not BALIATRO.is_plain(other) then
                    card.ability.extra.xmult = card.ability.extra.xmult - card.ability.extra.lose_xmult
                    if card.ability.extra.xmult > 1 then
                        return {
                            message = localize('k_downgrade_ex'),
                        }
                    else
                        G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.15, func = function()
                            card:start_dissolve()
                            return true
                        end}))

                        return {
                            message = localize('k_eaten_ex')
                        }
                    end
                end
            end
        end
    end
}

-- 78.
-- Saturated cards held in hand grant X1 Chips, and an additional X0.2 Chips for each plain card in scoring hand.
-- Rare
SMODS.Joker {
    name = "Blank Card",
    key = "blank_card",
    config = {
        extra = {
            xchips = 1,
            xchips_per_plain = 0.25,
            _xchips = 1,
        },
    },
    pos = {
        x = 9,
        y = 3,
    },
    unlocked = true,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    cost = 8,
    rarity = 3,
    atlas = "Baliatro",

    new_york = {
        compatible = true,
        ignore_extra_fields = {}
    },

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = {key='baliatro_plain', set='Other'}
        info_queue[#info_queue+1] = {key='baliatro_saturated', set='Other'}
        return { vars = {card.ability.extra.xchips, card.ability.extra.xchips_per_plain }}
    end,

    calculate = function(self, card, context)
        if context.before then
            card.ability.extra._xchips = card.ability.extra.xchips
            for i, other in ipairs(context.scoring_hand) do
                if BALIATRO.is_plain(other) then
                    card.ability.extra._xchips = card.ability.extra._xchips + card.ability.extra.xchips_per_plain
                end
            end
        elseif not context.end_of_round and context.individual and context.cardarea == G.hand and BALIATRO.is_saturated(context.other_card) and card.ability.extra._xchips ~= 1 then
            return {
                xchips = card.ability.extra._xchips
            }
        end
    end
}

-- 79.
-- Gain 3% of your total Chips as Mult.
-- Uncommon
SMODS.Joker {
    name = "Frequent Flyer Card",
    key = "frequent_flyer_card",
    config = {
        extra = {
            chips_as_mult = 0.03,
        },
    },
    pos = {
        x = 0,
        y = 4,
    },
    unlocked = true,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    cost = 6,
    rarity = 3,
    atlas = "Baliatro",

    new_york = {
        compatible = true,
        ignore_extra_fields = {}
    },

    loc_vars = function(self, info_queue, card)
        return { vars = {card.ability.extra.chips_as_mult * 100 }}
    end,

    calculate = function(self, card, context)
        if context.joker_main then
            return {
                baliatro_chips_as_mult = card.ability.extra.chips_as_mult
            }
        end
    end
}


return {
    name = "Baliatro Jokers",
}
