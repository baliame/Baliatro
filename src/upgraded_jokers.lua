SMODS.Atlas({key="BaliatroUp", path="BaliatroUpgraded.png", px = 71, py = 95, atlas_table="ASSET_ATLAS"}):register()

SMODS.Rarity {
    key = "upgraded",
    badge_colour = HEX('9700b1')
}

SMODS.Booster {
	key = "buffoon_upgraded_1",
    name = "Upgraded Buffoon Pack",
	kind = "BaliatroBuffoon",
	atlas = "BaliatroPacks",
	pos = { x = 3, y = 0 },
	config = { extra = 2, choose = 1 },
	cost = 12,
	order = 3,
	weight = 0.15,
	create_card = function(self, card)
		return create_card("Joker", G.pack_cards, nil, "baliatro_upgraded", true, true, nil, "upgraded_pack")
	end,
    ease_background_colour = function(self) ease_background_colour_blind(G.STATES.BUFFOON_PACK) end,
	loc_vars = BALIATRO.booster_pack_locvars,
	group_key = "k_baliatro_upgraded_buffoon_pack",
    set_ability = BALIATRO.booster_pack_set_ability,
}

-- 1. Jimbo
-- X3 Mult
SMODS.Joker {
    name = "Jimbo",
    key = "jimbo",
    config = {
        extra = {
            x_mult = 3,
        }
    },
    pos = {
        x = 1,
        y = 0,
    },
    unlocked = true,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    cost = 6,
    rarity = "baliatro_upgraded",
    atlas = "BaliatroUp",

    new_york = {
        compatible = true,
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.x_mult }}
    end,

    calculate = function(self, card, context)
        if context.joker_main then
            return {
                xmult = card.ability.extra.x_mult,
            }
        end
    end
}

-- 2. Moissanite
-- Played Cards with Diamond suit give X1.5 Mult when scored.
SMODS.Joker {
    name = "Moissanite",
    key = "moissanite",
    config = {
        extra = {
            x_mult = 1.5,
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
    cost = 6,
    rarity = "baliatro_upgraded",
    atlas = "BaliatroUp",

    new_york = {
        compatible = true,
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.x_mult }}
    end,

    calculate = function(self, card, context)
        if context.cardarea == G.play and context.individual and context.other_card and context.other_card:is_suit('Diamonds')  then
            return {
                xmult = card.ability.extra.x_mult,
            }
        end
    end
}

-- 3. Obsidian
-- Played Cards with Spade suit become Glass before scoring, overriding any other enhancement.
SMODS.Joker {
    name = "Obsidian",
    key = "obsidian",
    config = {
    },
    pos = {
        x = 3,
        y = 0,
    },
    unlocked = true,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    cost = 6,
    rarity = "baliatro_upgraded",
    atlas = "BaliatroUp",

    new_york = {
        compatible = false,
    },

    calculate = function(self, card, context)
        if context.cardarea == G.jokers and context.before and not context.blueprint then
            for i, scoring_card in ipairs(context.scoring_hand) do
                if not scoring_card.debuff and scoring_card:is_suit("Spades") then
                    scoring_card:set_ability(G.P_CENTERS["m_glass"])
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            scoring_card:juice_up()
                            return true
                        end
                    }))
                end
            end
        end
    end
}

-- 4. The Swing
-- X4 Mult if played hand contains a Two Pair
SMODS.Joker {
    name = "The Swing",
    key = "swing",
    config = {
        Xmult = 4,
        type = 'Two Pair'
    },
    pos = {
        x = 4,
        y = 0,
    },
    unlocked = true,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    cost = 8,
    rarity = "baliatro_upgraded",
    atlas = "BaliatroUp",

    new_york = {
        compatible = true,
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.Xmult, localize(card.ability.type, 'poker_hands') }}
    end,
}

-- 5. The Missing Half
-- X5 Mult if played hand contains 3 or fewer cards.
SMODS.Joker {
    name = "The Missing Half",
    key = "missing_half",
    config = {
        extra = {
            x_mult = 5,
            max_cards = 3,
        }
    },
    pos = {
        x = 5,
        y = 0,
    },
    pixel_size = {
        h = 47.5
    },
    unlocked = true,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    cost = 6,
    rarity = "baliatro_upgraded",
    atlas = "BaliatroUp",

    new_york = {
        compatible = true,
        ignore_extra_fields = {"max_cards"},
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.x_mult, card.ability.extra.max_cards }}
    end,

    calculate = function(self, card, context)
        if context.joker_main and #context.full_hand <= card.ability.extra.max_cards then
            return {
                xmult = card.ability.extra.x_mult,
            }
        end
    end,
}

-- 6. Platinum Card
-- Go up to -$50 in debt. Earn Interest as if you have $50 more than you actually have.
SMODS.Joker {
    name = "Platinum Card",
    key = "platinum_card",
    config = {
        extra = {
            debt_amount = 50,
            interest_basis = 50,
        }
    },
    pos = {
        x = 6,
        y = 0,
    },
    unlocked = true,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    cost = 6,
    rarity = "baliatro_upgraded",
    atlas = "BaliatroUp",

    new_york = {
        compatible = false,
    },

    add_to_deck = function(self, card, from_debuff)
        G.GAME.bankrupt_at = G.GAME.bankrupt_at - card.ability.extra.debt_amount
        G.GAME.interest_basis_modifier = G.GAME.interest_basis_modifier + card.ability.extra.interest_basis
    end,

    remove_from_deck = function(self, card, from_debuff)
        G.GAME.bankrupt_at = G.GAME.bankrupt_at + card.ability.extra.debt_amount
        G.GAME.interest_basis_modifier = G.GAME.interest_basis_modifier - card.ability.extra.interest_basis
    end,

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.debt_amount, card.ability.extra.interest_basis }}
    end
}

-- 7. Crest
-- X1.5 Mult for each remaining discard (stacks multiplicatively, currently will give X mult)
SMODS.Joker {
    name = "Crest",
    key = "crest",
    config = {
        extra = {
            x_mult = 1.5,
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
    rarity = "baliatro_upgraded",
    atlas = "BaliatroUp",

    new_york = {
        compatible = true
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.x_mult, card.ability.extra.x_mult ^ G.GAME.current_round.discards_left }}
    end,

    calculate = function(self, card, context)
        if context.joker_main and G.GAME.current_round.discards_left > 0 then
            local mult = card.ability.extra.x_mult ^ G.GAME.current_round.discards_left
            return {
                xmult = mult,
            }
        end
    end
}

-- 8. Glacier
-- X4 Mult when 0 discards remaining
SMODS.Joker {
    name = "Glacier",
    key = "glacier",
    config = {
        extra = {
            x_mult = 4,
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
    cost = 6,
    rarity = "baliatro_upgraded",
    atlas = "BaliatroUp",

    new_york = {
        compatible = true
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.x_mult }}
    end,

    calculate = function(self, card, context)
        if context.joker_main and G.GAME.current_round.discards_left == 0 then
            local mult = card.ability.extra.x_mult
            return {
                xmult = mult,
            }
        end
    end
}

-- 9. Actually Magic 8 Ball
-- 1 in 4 chance for each played 8 to create a Negative Tarot, Planet, Spectral or Postcard when scored
SMODS.Joker {
    name = "Actually Magic 8 Ball",
    key = "actually_magic_8_ball",
    config = {
        extra = {
            odds = 4,
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
    rarity = "baliatro_upgraded",
    atlas = "BaliatroUp",

    new_york = {
        compatible = true,
        divide_extra_fields = {"odds"},
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { (G.GAME and G.GAME.probabilities.normal or 1), card.ability.extra.odds }}
    end,

    calculate = function(self, card, context)
        if context.cardarea == G.play and context.individual and context.other_card and context.other_card:get_id() == 8 then
            if pseudorandom('8ball') < G.GAME.probabilities.normal / card.ability.extra.odds then
                local card_type = 'Planet'
                local colour = G.C.SECONDARY_SET.PLANET
                local plus_string = 'k_plus_planet'
                if pseudorandom('8ball') < 0.25 then
                    if pseudorandom('8ball') < 0.1 then
                        --card_type = 'Postcard'
                        card_type = 'Postcard'
                        colour = G.C.SECONDARY_SET.SPECTRAL
                        plus_string = 'baliatro_plus_postcard'
                    else
                        card_type = 'Spectral'
                        colour = G.C.SECONDARY_SET.SPECTRAL
                        plus_string = 'k_plus_spectral'
                    end
                else
                    if pseudorandom('8ball') < 0.5 then
                        card_type = 'Planet'
                        colour = G.C.SECONDARY_SET.PLANET
                        plus_string = 'k_plus_planet'
                    else
                        card_type = 'Tarot'
                        colour = G.C.SECONDARY_SET.TAROT
                        plus_string = 'k_plus_tarot'
                    end
                end

                return {
                    extra = {focus = card, message = localize(plus_string), func = function()
                        G.E_MANAGER:add_event(Event({
                            trigger = 'before',
                            delay = 0.0,
                            func = (function()
                                    local l_card = create_card(card_type,G.consumeables, nil, nil, nil, nil, nil, '8ba')
                                    l_card:set_edition({negative = true}, true)
                                    l_card:add_to_deck()
                                    G.consumeables:emplace(l_card)
                                    G.GAME.consumeable_buffer = 0
                                return true
                            end)}))
                    end},
                    colour = colour,
                    card = context.blueprint_card or card
                }
            end
        end
    end
}

-- 10. psinMitr
-- X0.2-10 Mult. The top card of your deck is X of X.
SMODS.Joker {
    name = "psinMitr",
    key = "psinmitr",
    config = {
        extra = {
            min = 0.2,
            max = 10,
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
    cost = 6,
    rarity = "baliatro_upgraded",
    atlas = "BaliatroUp",

    new_york = {
        compatible = true,
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.min, card.ability.extra.max, (G.deck and G.deck.cards[1] and G.deck.cards[1].value) or "Unknown", (G.deck and G.deck.cards[1] and G.deck.cards[1].base.suit) or "Unknown"}}
    end,

    calculate = function(self, card, context)
        if context.joker_main then
            local mult = pseudorandom('psinMitr', card.ability.extra.min, card.ability.extra.max)
            return {
                xmult = mult,
            }
        end
    end
}

-- 11. Union Joker
-- X0.5 times the rank of lowest ranked card held in hand
SMODS.Joker {
    name = "Union Joker",
    key = "union_joker",
    config = {
        extra = {
            x_mult_per_rank = 0.5,
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
    cost = 6,
    rarity = "baliatro_upgraded",
    atlas = "BaliatroUp",

    new_york = {
        compatible = true
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.x_mult_per_rank }}
    end,

    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.hand and not context.end_of_round then
            local temp_Mult, temp_ID = 15, 15
            local raised_card = nil
            for i=1, #G.hand.cards do
                if temp_ID >= G.hand.cards[i].base.id and not SMODS.has_no_rank(G.hand.cards[i]) then
                    temp_Mult = G.hand.cards[i].base.nominal
                    temp_ID = G.hand.cards[i].base.id
                    raised_card = G.hand.cards[i]
                end
            end
            if raised_card == context.other_card and temp_Mult > 0 then
                if context.other_card.debuff then
                    return {
                        message = localize('k_debuffed'),
                        colour = G.C.RED,
                        card = context.other_card,
                    }
                else
                    local mult = card.ability.extra.x_mult_per_rank*temp_Mult
                    return {
                        xmult = mult,
                        card = context.other_card,
                    }
                end
            end
        end
    end
}

-- 12. Chaos with Crown
-- 3 free Reroll(s) per shop. 1 Reroll(s) each shop also rerolls unopened booster packs.
SMODS.Joker {
    name = "Chaos with Crown",
    key = "chaos_with_crown",
    config = {
        extra = {
            free_rerolls = 3,
            booster_rerolls = 1,
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
    rarity = "baliatro_upgraded",
    atlas = "BaliatroUp",

    new_york = {
        compatible = false,
    },

    add_to_deck = function(self, card, from_debuff)
        G.GAME.current_round.free_rerolls = G.GAME.current_round.free_rerolls + card.ability.extra.free_rerolls
        G.GAME.current_round.booster_rerolls = G.GAME.current_round.booster_rerolls + card.ability.extra.booster_rerolls
        calculate_reroll_cost(true)
    end,

    remove_from_deck = function(self, card, from_debuff)
        G.GAME.current_round.free_rerolls = math.max(G.GAME.current_round.free_rerolls - card.ability.extra.free_rerolls, 0)
        G.GAME.current_round.booster_rerolls = math.max(G.GAME.current_round.booster_rerolls - card.ability.extra.booster_rerolls, 0)
        calculate_reroll_cost(true)
    end,

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.free_rerolls, card.ability.extra.booster_rerolls }}
    end,
}

-- 13. Stencil Joker
-- X1 Mult for each Joker card (Stencil Joker included) (Currently X1 Mult)
SMODS.Joker {
    name = "Stencil Joker",
    key = "stencil_joker",
    config = {
        extra = {
            x_mult_per_joker = 1,
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
    cost = 6,
    rarity = "baliatro_upgraded",
    atlas = "BaliatroUp",

    new_york = {
        compatible = true,
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.x_mult_per_joker, card.ability.extra.x_mult_per_joker * (G.jokers and #G.jokers.cards or 1)}}
    end,

    calculate = function(self, card, context)
        if context.joker_main then
            local mult = card.ability.extra.x_mult_per_joker * #G.jokers.cards
            return {
                xmult = mult,
            }
        end
    end
}

-- 14. Goldfinger
-- X12 Mult. 1 in 5000 chance this card is destroyed at the end of round.
SMODS.Joker {
    name = "Goldfinger",
    key = "goldfinger",
    config = {
        extra = {
            x_mult = 12,
            odds = 5000,
        }
    },
    pos = {
        x = 0,
        y = 0,
    },
    unlocked = true,
    blueprint_compat = true,
    eternal_compat = false,
    perishable_compat = true,
    cost = 6,
    rarity = "baliatro_upgraded",
    atlas = "BaliatroUp",

    new_york = {
        compatible = true,
        divide_extra_fields = {"odds"}
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.x_mult, (G.GAME and G.GAME.probabilities.normal) or 1, card.ability.extra.odds }}
    end,

    calculate = function(self, card, context)
        if context.joker_main then
            local mult = card.ability.extra.x_mult
            return {
                xmult = mult,
            }
        end

        if context.end_of_round and not context.repetition and context.game_over == false and not context.blueprint then
            -- Another pseudorandom thing, randomly generates a decimal between 0 and 1, so effectively a random percentage.
            if pseudorandom('goldfinger') < G.GAME.probabilities.normal / card.ability.extra.odds then
                -- This part plays the animation.
                G.E_MANAGER:add_event(Event({
                    func = function()
                        play_sound('tarot1')
                        card.T.r = -0.2
                        card:juice_up(0.3, 0.4)
                        card.states.drag.is = true
                        card.children.center.pinch.x = true
                        G.E_MANAGER:add_event(Event({
                            trigger = 'after',
                            delay = 0.3,
                            blockable = false,
                            func = function()
                            G.jokers:remove_card(card)
                            card:remove()
                            card = nil
                            return true;
                            end
                        }))
                        return true
                    end
                }))
                return {
                    message = localize('k_extinct_ex')
                }
                else
                return {
                    message = localize('k_safe_ex')
                }
            end
          end
    end
}

-- 15. Mind the Gap
-- +X0.3 Mult for each consecutive hand played without a scoring face card (Currently has X1 Mult)
SMODS.Joker {
    name = "Mind The Gap",
    key = "mind_the_gap",
    config = {
        extra = {
            x_mult_per_hand = 0.3,
            x_mult = 1,
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
    cost = 6,
    rarity = "baliatro_upgraded",
    atlas = "BaliatroUp",

    new_york = {
        compatible = true
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.x_mult_per_hand, card.ability.extra.x_mult }}
    end,

    calculate = function(self, card, context)
        if context.cardarea == G.jokers and context.before and not context.blueprint then
            for i, scored_card in ipairs(context.scoring_hand) do
                if scored_card:is_face() then
                    if card.ability.extra.x_mult ~= 1 then
                        card.ability.extra.x_mult = 1
                        return {
                            card = context.blueprint_card or card,
                            message = localize('k_reset')
                        }
                    end
                end
            end
            card.ability.extra.x_mult = card.ability.extra.x_mult + card.ability.extra.x_mult_per_hand
            return {
                card = context.blueprint_card or card,
                message = localize('k_upgrade_ex')
            }
        elseif context.cardarea == G.jokers and context.joker_main then
            local mult = card.ability.extra.x_mult
            if mult ~= 1 then
                return {
                    xmult = mult,
                }
            end
        end
    end
}

-- 16. Turquoise Joker
-- +X0.2 Mult when a hand is played. -X0.4 when a hand is discarded. (Currently has X1 Mult)
SMODS.Joker {
    name = "Turquoise Joker",
    key = "turquoise_joker",
    config = {
        extra = {
            x_mult_per_play = 0.2,
            x_mult_per_discard = 0.4,
            x_mult = 1,
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
    cost = 6,
    rarity = "baliatro_upgraded",
    atlas = "BaliatroUp",

    new_york = {
        compatible = true
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.x_mult_per_play, card.ability.extra.x_mult_per_discard, card.ability.extra.x_mult }}
    end,

    calculate = function(self, card, context)
        if context.cardarea == G.jokers and context.before and not context.blueprint then
            card.ability.extra.x_mult = card.ability.extra.x_mult + card.ability.extra.x_mult_per_play
            return {
                card = context.blueprint_card or card,
                message = localize('k_upgrade_ex')
            }
        elseif context.pre_discard and not context.blueprint then
            card.ability.extra.x_mult = math.max(card.ability.extra.x_mult - card.ability.extra.x_mult_per_discard, 1)
            return {
                card = context.blueprint_card or card,
                message = localize('k_downgrade_ex')
            }
        elseif context.cardarea == G.jokers and context.joker_main then
            local mult = card.ability.extra.x_mult
            if mult ~= 1 then
                return {
                    xmult = mult,
                }
            end
        end
    end
}

-- 17. Black Card
-- +X0.25 Mult when skipping a Booster Pack (Currently has X1 Mult)
SMODS.Joker {
    name = "Black Card",
    key = "black_card",
    config = {
        extra = {
            x_mult_per_skip = 0.25,
            x_mult = 1,
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
    cost = 6,
    rarity = "baliatro_upgraded",
    atlas = "BaliatroUp",

    new_york = {
        compatible = true,
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.x_mult_per_skip, card.ability.extra.x_mult }}
    end,

    calculate = function(self, card, context)
        if context.skipping_booster and not context.blueprint then
            card.ability.extra.x_mult = card.ability.extra.x_mult + card.ability.extra.x_mult_per_skip
            return {
                card = context.blueprint_card or card,
                message = localize('k_upgrade_ex')
            }
        elseif context.cardarea == G.jokers and context.joker_main then
            local mult = card.ability.extra.x_mult
            if mult ~= 1 then
                return {
                    xmult = mult,
                }
            end
        end
    end
}

-- 18. Cube Joker
-- This Joker gains Chips equal to each scored card's Chips, excluding those granted by Edition, if played hand has exactly 4 cards. (Currently has 0 chips)
SMODS.Joker {
    name = "Cube Joker",
    key = "cube_joker",
    config = {
        extra = {
            chips = 0
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
    cost = 6,
    rarity = "baliatro_upgraded",
    atlas = "BaliatroUp",

    new_york = {
        compatible = false,
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.chips }}
    end,

    calculate = function(self, card, context)
        if context.cardarea == G.play and context.individual and not context.blueprint and #context.scoring_hand == 4 then
            card.ability.extra.chips = card.ability.extra.chips + context.other_card:get_chip_bonus()
            return {
                extra = {message = localize('k_upgrade_ex'), colour = G.C.CHIPS},
                colour = G.C.CHIPS,
                card = context.blueprint_card or card,
            }
        elseif context.joker_main then
            local chips = card.ability.extra.chips
            if chips > 0 then
                return {
                    chips = chips,
                    colour = G.C.CHIPS,
                }
            end
        end
    end
}

-- 19. Peanut Gallery
-- When Blind is selected, if you have 6 or less jokers, create 2 Negative Common jokers.
SMODS.Joker {
    name = "Peanut Gallery",
    key = "peanut_gallery",
    config = {
        extra = {
            created = 2,
            maximum = 6
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
    rarity = "baliatro_upgraded",
    atlas = "BaliatroUp",

    new_york = {
        compatible = true,
        ignore_extra_fields = {"maximum"},
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.maximum, card.ability.extra.created }}
    end,

    calculate = function(self, card, context)
        if context.setting_blind and not context.blueprint_card and not context.blueprint and not card.getting_sliced then
            local jokers_to_create = math.max(0, math.min(2, card.ability.extra.maximum - (#G.jokers.cards + G.GAME.joker_buffer)))
            G.GAME.joker_buffer = G.GAME.joker_buffer + jokers_to_create
            G.E_MANAGER:add_event(Event({
                func = function()
                    for i = 1, jokers_to_create do
                        local card = create_card('Joker', G.jokers, nil, 0.01, nil, nil, nil, 'rif')
                        card:set_edition({negative = true}, true)
                        card:add_to_deck()
                        G.jokers:emplace(card)
                        card:start_materialize()
                        G.GAME.joker_buffer = 0
                    end
                    return true
            end}))
            card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('k_plus_joker'), colour = G.C.BLUE})
            return nil, true
        end
    end
}

-- 20. Hanginger Chad
-- Retrigger first played card used in scoring 4 additional times.
SMODS.Joker {
    name = "Hanginger Chad",
    key = "hanginger_chad",
    config = {
        extra = {
            repeats = 4
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
    cost = 6,
    rarity = "baliatro_upgraded",
    atlas = "BaliatroUp",

    new_york = {
        compatible = true,
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.repeats }}
    end,

    calculate = function(self, card, context)
        if context.cardarea == G.play and context.repetition and not context.repetition_only and context.other_card == context.scoring_hand[1] then
            return {
                message = localize('k_again_ex'),
                repetitions = card.ability.extra.repeats,
                card = context.blueprint_card or card
            }
        end
    end
}

-- 21. Aceology PhD
-- The first Ace scored in each hand grants Mult equal to 1 time(s) its Chips value and X4 Mult.
SMODS.Joker {
    name = "Aceology PhD",
    key = "aceology_phd",
    config = {
        extra = {
            xmult = 4,
            chips_mult = 1,
            target = nil
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
    cost = 6,
    rarity = "baliatro_upgraded",
    atlas = "BaliatroUp",

    new_york = {
        compatible = true,
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.xmult, card.ability.extra.chips_mult }}
    end,

    calculate = function(self, card, context)
        if context.before and context.cardarea == G.jokers and not context.blueprint then
            card.ability.extra.target = nil
            for i, scored_card in ipairs(context.scoring_hand) do
                if scored_card:get_id() == 14 then
                    card.ability.extra.target = scored_card
                    return
                end
            end
        elseif context.cardarea == G.play and context.individual then
            if card.ability.extra.target and context.other_card == card.ability.extra.target then
                return {
                    mult = context.other_card:get_chip_bonus() * card.ability.extra.chips_mult,
                    xmult = card.ability.extra.xmult,
                    card = context.blueprint_card or card,
                }
            end
        end
    end
}

-- 22. Marathon Runner
-- Create a number by concatenating the 2 lowest, single-digit ranks in the scoring hand. Gains that many chips if played hand is a Straight. Uses the 3 lowest instead if hand is a Straight Flush. Cards whose rank is not a single digit are not used. (example: 7 6 5 4 3 = gain 34 chips) (currently has 0 chips)
SMODS.Joker {
    name = "Marathon Runner",
    key = "marathon_runner",
    config = {
        extra = {
            chips = 0
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
    cost = 6,
    rarity = "baliatro_upgraded",
    atlas = "BaliatroUp",

    new_york = {
        compatible = false,
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.chips}}
    end,

    calculate = function(self, card, context)
        if context.before and context.cardarea == G.jokers and not context.blueprint then
            if context.scoring_name == 'Straight' or context.scoring_name == 'Straight Flush' or context.scoring_name == 'Royal Flush' then
                local digits = 3
                local current = 100
                if context.scoring_name == 'Straight' then
                    digits = 2
                    current = 10
                end
                local digit_list = {0, 0, 0, 0, 0}
                for i = 1, #context.scoring_hand do
                    local scoring_card = context.scoring_hand[i]
                    local card_id = scoring_card:get_id()
                    if card_id < 10 then
                        for j = 1, #digit_list do
                            if digit_list[j] == 0 then
                                digit_list[j] = card_id
                                break
                            elseif digit_list[j] > card_id then
                                for k = #digit_list, j+1, -1 do
                                    digit_list[k] = digit_list[k-1]
                                end
                                digit_list[j] = card_id
                                break
                            end
                        end
                    end
                end
                local result = 0
                for i = 1, digits do
                    result = result + digit_list[i] * current
                    current = current / 10
                end
                if result > 0 then
                    card.ability.extra.chips = card.ability.extra.chips + result
                    return {
                        message = localize { type = 'variable', key = 'a_chips', vars = { result }},
                        colour = G.C.CHIPS,
                    }
                end
            end
        elseif context.joker_main then
            return {
                chips = card.ability.extra.chips,
            }
        end
    end
}

-- 23. Indigo Joker
-- X0.1 Mult for each reamining card in deck. Cannot grant less than X1.
SMODS.Joker {
    name = "Indigo Joker",
    key = "indigo_joker",
    config = {
        extra = {
            x_mult_per_card = 0.1,
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
    cost = 6,
    rarity = "baliatro_upgraded",
    atlas = "BaliatroUp",

    new_york = {
        compatible = true,
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.x_mult_per_card, math.max(1, (G.deck and G.deck.cards and #G.deck.cards or 1) * card.ability.extra.x_mult_per_card) }}
    end,

    calculate = function(self, card, context)
        if context.joker_main then
            local mult = #G.deck.cards * card.ability.extra.x_mult_per_card
            if mult > 1 then
                return {
                    xmult = mult,
                }
            end
        end
    end
}

-- 24. Bad Trip
-- 1 in 3 chance to create a Negative Tarot, Planet, Spectral or Postcard when any Booster Pack is opened
SMODS.Joker {
    name = "Bad Trip",
    key = "bad_trip",
    config = {
        extra = {
            odds = 3,
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
    rarity = "baliatro_upgraded",
    atlas = "BaliatroUp",

    new_york = {
        compatible = true,
        divide_extra_fields = {"odds"},
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { (G.GAME and G.GAME.probabilities.normal or 1), card.ability.extra.odds }}
    end,

    calculate = function(self, card, context)
        if context.open_booster then
            if pseudorandom('halu'..G.GAME.round_resets.ante) < G.GAME.probabilities.normal / card.ability.extra.odds then
                local card_type = 'Planet'
                local colour = G.C.SECONDARY_SET.PLANET
                local plus_string = 'k_plus_planet'
                if pseudorandom('8ball') < 0.25 then
                    if pseudorandom('8ball') < 0.1 then
                        --card_type = 'Postcard'
                        card_type = 'Postcard'
                        colour = G.C.SECONDARY_SET.SPECTRAL
                        plus_string = 'baliatro_plus_postcard'
                    else
                        card_type = 'Spectral'
                        colour = G.C.SECONDARY_SET.SPECTRAL
                        plus_string = 'k_plus_spectral'
                    end
                else
                    if pseudorandom('8ball') < 0.5 then
                        card_type = 'Planet'
                        colour = G.C.SECONDARY_SET.PLANET
                        plus_string = 'k_plus_planet'
                    else
                        card_type = 'Tarot'
                        colour = G.C.SECONDARY_SET.TAROT
                        plus_string = 'k_plus_tarot'
                    end
                end

                return {
                    extra = {focus = card, message = localize(plus_string), func = function()
                        G.E_MANAGER:add_event(Event({
                            trigger = 'before',
                            delay = 0.0,
                            func = (function()
                                    local l_card = create_card(card_type,G.consumeables, nil, nil, nil, nil, nil, '8ba')
                                    l_card:set_edition({negative = true}, true)
                                    l_card:add_to_deck()
                                    G.consumeables:emplace(l_card)
                                    G.GAME.consumeable_buffer = 0
                                return true
                            end)}))
                    end},
                    colour = colour,
                    card = context.blueprint_card or card
                }
            end
        end
    end
}

-- 25. Bailout
-- Played face cards give $2 and Mult equal to your 1 time(s) money when scored.
SMODS.Joker {
    name = "Bailout",
    key = "bailout",
    config = {
        extra = {
            dollars = 2,
            dollar_mult = 1,
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
    cost = 6,
    rarity = "baliatro_upgraded",
    atlas = "BaliatroUp",

    new_york = {
        compatible = true,
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.dollars, card.ability.extra.dollar_mult }}
    end,

    calculate = function(self, card, context)
        if context.cardarea == G.play and context.individual and context.other_card:is_face() then
            return {
                dollars = card.ability.extra.dollars,
                mult = card.ability.extra.dollars + math.max(G.GAME.dollars, 0) * card.ability.extra.dollar_mult,
                card = context.blueprint_card or card,
            }
        end
    end
}

-- 26. Oracle
-- +X0.1 Mult per Tarot card used this run. (Currently X1 Mult)
SMODS.Joker {
    name = "Oracle",
    key = "oracle",
    config = {
        extra = {
            x_mult_per_tarot = 0.1,
        }
    },
    pos = {
        x = 0,
        y = 0,
    },
    unlocked = true,
    blueprint_compat = true,
    eternal_compat = false,
    perishable_compat = true,
    cost = 6,
    rarity = "baliatro_upgraded",
    atlas = "BaliatroUp",

    new_york = {
        compatible = true,
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.x_mult_per_tarot, 1 + ((G.GAME.consumeable_usage_total and G.GAME.consumeable_usage_total.tarot) or 0) * card.ability.extra.x_mult_per_tarot}}
    end,

    calculate = function(self, card, context)
        if context.joker_main then
            local mult = 1 + ((G.GAME.consumeable_usage_total and G.GAME.consumeable_usage_total.tarot) or 0) * card.ability.extra.x_mult_per_tarot
            return {
                xmult = mult,
            }
        end

        if context.using_consumeable and not context.blueprint and (context.consumeable.ability.set == "Tarot") then
            G.E_MANAGER:add_event(Event({func = function()
                local mult = 1 + ((G.GAME.consumeable_usage_total and G.GAME.consumeable_usage_total.tarot) or 0) * card.ability.extra.x_mult_per_tarot
                card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize{type='variable',key='a_xmult',vars={mult}}})
                return true
            end}))
        end
    end
}

-- 27. Uneven Freeman
-- Played cards with odd rank gain +31 Chips when scored.
SMODS.Joker {
    name = "Uneven Freeman",
    key = "uneven_freeman",
    config = {
        extra = {
            chips = 31,
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
    cost = 6,
    rarity = "baliatro_upgraded",
    atlas = "BaliatroUp",

    new_york = {
        compatible = true,
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.chips }}
    end,

    calculate = function(self, card, context)
        if context.cardarea == G.play and context.individual then
            if (context.other_card:get_id() <= 10 and context.other_card:get_id() >= 0 and context.other_card:get_id()%2 == 1) or context.other_card.get_id() == 14 then
                context.other_card.ability.perma_bonus = context.other_card.ability.perma_bonus or 0
                context.other_card.ability.perma_bonus = context.other_card.ability.perma_bonus + card.ability.extra.chips
                return {
                    extra = {message = localize('k_upgrade_ex'), colour = G.C.CHIPS},
                    colour = G.C.CHIPS,
                    card = context.blueprint_card or card
                }
            end
        end
    end
}

-- 28. Multiple of Two Lou
-- Played cards with even rank gain +4 Mult when scored.
SMODS.Joker {
    name = "Multiple of Two Lou",
    key = "multiple_of_two_lou",
    config = {
        extra = {
            mult = 4,
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
    cost = 6,
    rarity = "baliatro_upgraded",
    atlas = "BaliatroUp",

    new_york = {
        compatible = true,
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.mult }}
    end,

    calculate = function(self, card, context)
        if context.cardarea == G.play and context.individual then
            if context.other_card:get_id() <= 10 and context.other_card:get_id() >= 0 and context.other_card:get_id()%2 == 0 then
                context.other_card.ability.perma_mult = context.other_card.ability.perma_mult or 0
                context.other_card.ability.perma_mult = context.other_card.ability.perma_mult + card.ability.extra.mult
                return {
                    extra = {message = localize('k_upgrade_ex'), colour = G.C.MULT},
                    colour = G.C.MULT,
                    card = context.blueprint_card or card
                }
            end
        end
    end
}