SMODS.Atlas({key="Baliatro", path="Baliatro.png", px = 71, py = 95, atlas_table="ASSET_ATLAS"}):register()

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
        elseif context.end_of_round and not context.blueprint and card.ability.extra.activated and not context.repetition and not context.individual then
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
-- Remove Edition (except Negative) from played scoring cards. For each Edition type removed in a hand, upgrade that Edition by 1 level.
-- Uncommon
SMODS.Joker {
    name = "Sharpening Stone",
    key = "sharpening_stone",
    pos = {
        x = 0,
        y = 0,
    },
    config = {
        extra = {
            upgrade_amount = 1,
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
        return {vars = {card.ability.extra.upgrade_amount}}
    end,

    calculate = function(self, card, context)
        if context.cardarea == G.jokers and context.before and not context.blueprint then
            local editions = {}
            for i = 1, #context.scoring_hand do
                local scored_card = context.scoring_hand[i]
                if scored_card.edition and not scored_card.edition.negative and not scored_card.sharpened then
                    local ed = scored_card.edition.type
                    if ed:find("faded_") then
                        ed = ed:gsub("faded_", "")
                    end
                    editions[ed] = true
                    scored_card.sharpened = true
                    scored_card:set_edition(nil, true, true)
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            scored_card:juice_up()
                            scored_card.sharpened = nil
                            return true
                        end
                    }))
                end
            end

            for k, v in pairs(editions) do
                local up_ed = "baliatro_"..k
                BALIATRO.use_special_planet(up_ed, nil, nil, card.ability.extra.upgrade_amount)
            end
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
        x = 0,
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
                transfer = card.ability.extra.transfer
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
        x = 0,
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
        x = 0,
        y = 0,
    },
    config = {
        extra = {
            activated = false,
            can_activate = true,
            created_type = "Tarot",
            created_card = "c_baliatro_ace_of_wands",
            amount = 1,
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
    },

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = G.P_CENTERS[card.ability.extra.created_card]
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
                G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                G.E_MANAGER:add_event(Event({
                    trigger = 'before',
                    delay = 0.0,
                    func = (function()
                        for j = 1, created_amt do
                            local card = create_card(card.ability.extra.created_type, G.consumeables, nil, nil, nil, nil, card.ability.extra.created_card, "meditation")
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
        x = 0,
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
        x = 0,
        y = 0,
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
-- Editionless Wild Cards gain Immortal and Polychrome when scored. 1 in 3 chance to destroy each scoring Wild Card.
-- Uncommon

-- 10.
-- If scored hand contains at least 3 different Editions, apply X3 Mult each time an Edition is first scored.
-- (Joker has +X0.25 per level of Foil, Holographic, or Polychrome)
-- Rare

-- 11.
-- Photographic Edition triggers twice.
-- Rare

-- 12.
-- Gain $10 if discarded hand is Straight Flush. Lose $1 otherwise. (Hand changes each time you discard)
-- Common
SMODS.Joker {
    name = "Slot Machine",
    key = "slot_machine",
    pos = {
        x = 0,
        y = 0,
    },
    config = {
        extra = {
            dollars = 10,
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
-- Ethereal: Sticker. Ethereal cards cannot be discarded, are destroyed after a hand is scored or any card is discarded, and grant +1 Hand Size while held.
-- Common

-- 14.
-- When the Blind is selected, add a random playing card to your hand. Add Polychrome (15%), Holographic (25%), or Foil to this card. 2 in 3 chance to add a Faded variant instead.
-- Common
SMODS.Joker {
    name = "Gacha Joker",
    key = "gacha",
    pos = {
        x = 0,
        y = 0,
    },
    config = {
        extra = {
            base = 3,
            odds = 4,
            poly_roll = 0.1,
            holo_roll = 0.35,
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
        return {vars = {card.ability.extra.poly_roll * 100, (card.ability.extra.holo_roll - card.ability.extra.poly_roll) * 100, card.ability.extra.base, card.ability.extra.odds}}
    end,

    calculate = function(self, card, context)
        if context.first_hand_drawn then
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
                if context.blueprint_card then context.blueprint_card:juice_up() else card:juice_up() end
                return true
            end }))
            playing_card_joker_effects({true})
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
        x = 0,
        y = 0,
    },
    config = {
        extra = {
            mult = 0,
            mult_per_x_dollar = 1,
            x = 1,
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
        x = 0,
        y = 0,
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
    cost = 5,
    rarity = 1,
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
        elseif context.cardarea == BALIATRO.unscored_cardarea and context.destroy_card == card.ability.extra.destroyed then
            card.ability.extra.destroyed = nil
            return true
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
        y = 0,
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
            end
            return {
                card = card,
                message = localize("k_baliatro_converted_card_ex"),
            }
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
            if #eligible_target and #eligible then
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
-- If scored hand is Four of a Kind, +4 Mult and gain $ equal to half the sell value of all of your jokers (up to $20, once per round)
-- Common
SMODS.Joker {
    name = "Tempered Joker",
    key = "tempered_joker",
    pos = {
        x = 0,
        y = 0,
    },
    config = {
        extra = {
            mult = 4,
            max = 20,
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
            money = math.min(card.ability.extra.max, math.floor(money / 2))
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
            return {
                message = localize{type='variable',key='a_mult',vars={card.ability.extra.mult}},
                mult_mod = card.ability.extra.mult
            }
        elseif context.after and context.cardarea == G.jokers and card.ability.extra.activated then
            card.ability.extra.can_activate = false
            card.ability.extra.stop_juicing = true
            card.ability.extra.activated = false
            local money = self:calculate_value(card)
            if money > 0 then
                return {
                    dollars = money,
                }
            end
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
        x = 0,
        y = 0,
    },
    config = {
        extra = {
            dollars = 3,
            lose = 6,
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
        elseif context.cardarea == G.play and context.individual then
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
        x = 0,
        y = 0,
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
                        message = localize{type = 'variable', key = 'a_xmult', vars = {card.ability.extra.xmult}},
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
        info_queue[#info_queue+1] = G.P_CENTERS["e_negative"]
        return {vars={}}
    end,

    calculate = function(self, card, context)
        if context.using_consumeable and not (context.consumeable.edition and context.consumeable.edition.negative) and not (context.consumeable.config.center.hidden or context.consumeable.config.center.rarity == 4) and not context.blueprint then
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
        G.GAME.voucher_limit = G.GAME.voucher_limit + 1
    end,

    remove_from_deck = function(self, card, from_debuff)
        G.GAME.voucher_limit = G.GAME.voucher_limit - 1
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
-- All 7s count as Wild Cards.
-- Common
SMODS.Joker {
    name = "Sinful Joker",
    key = "sinful_joker",
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
    cost = 4,
    rarity = 1,
    atlas = "Baliatro",

    new_york = {
        compatible = false,
    },

    add_to_deck = function(self, card, from_debuff)
        BALIATRO.add_any_suit_joker(card)
    end,

    remove_from_deck = function(self, card, from_debuff)
        BALIATRO.remove_any_suit_joker(card)
    end,

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
                message = localize{type = 'variable', key = 'a_xmult', vars = {card.ability.extra.xmult}},
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
-- Retrigger scoring Aces five times total. Retriggers are split evenly between all scoring cards of that rank. Rank changes each round (idol logic)
-- Rare
SMODS.Joker {
    name = "The Effigy",
    key = "effigy",
    config = {
        extra = {
            retriggers = 5,
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
        return { vars = {card.ability.extra.retriggers, localize(G.GAME.current_round.effigy_card.rank, 'ranks')}}
    end,

    calculate = function(self, card, context)
        local scorer = context.blueprint_card or card
        if context.before and context.cardarea == G.jokers and not context.blueprint then
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
                        local upcoming = BALIATRO.round(rem / cards)
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
        if context.cardarea == G.play and context.individual then
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
            for i, other_joker in ipairs(G.GAME.jokers) do
                if other_joker ~= card and other_joker.config.center.rarity ~= 1 and other_joker.config.center.rarity ~= "common" then
                    active = false
                end
            end
            if active then
                return {
                    xmult = card.ability.extra.xmult,
                    message = localize{type = 'variable', key = 'a_xmult', vars = {card.ability.extra.xmult}},
                }
            end
        end
    end
}

-- 43.
-- X1 Mult. Gain X0.125 Mult if hand played is Pair. Lose X0.125 Mult if hand played is High Card. Hands change each hand played. Gaining hand cannot be your most played hand and losing hand cannot be your least played hand.
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
            gain = 0.125,
            lose = 0.125,
            gain_hand = "Pair",
            lose_hand = "High Card"
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
        local except_least = BALIATRO.filter_visible_hands{exclude_least_played = true}
        local except_most = BALIATRO.filter_visible_hands{exclude_most_played = true}
        if #except_least == 0 then except_least = all end
        if #except_most == 0 then except_most = all end

        card.ability.extra.gain_hand = pseudorandom_element(except_most, pseudoseed('scales'))
        card.ability.extra.lose_hand = card.ability.extra.gain_hand
        local att = 0
        while card.ability.extra.gain_hand == card.ability.extra.lose_hand do
            att = att + 1
            if att > 5 then
                except_least = all
            end
            card.ability.extra.lose_hand = pseudorandom_element(except_least, pseudoseed('scales'))
        end
        return {
            message = localize('k_reset'),
            card = card,
        }
    end,

    set_ability = function(self, card, initial, delay_sprites)
        self:setab(card)
    end,

    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.xmult, card.ability.extra.gain, card.ability.extra.gain_hand, card.ability.extra.lose, card.ability.extra.lose_hand}}
    end,

    calculate = function(self, card, context)
        if context.before and not context.blueprint then
            if context.scoring_name == card.ability.extra.gain_hand then
                card.ability.extra.xmult = card.ability.extra.xmult + card.ability.extra.gain
                return {
                    message = localize('k_upgrade_ex'),
                    card = card,
                }
            elseif context.scoring_name == card.ability.extra.lose_hand then
                card.ability.extra.xmult = card.ability.extra.xmult - card.ability.extra.lose
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

return {
    name = "Baliatro Jokers",
}