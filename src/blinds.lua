SMODS.Atlas({key="BaliatroBlinds", path="BaliatroBlinds.png", px = 34, py = 34, atlas_table="ANIMATION_ATLAS", frames=21}):register()

BALIATRO.suit_debuff = function(self, card, from_blind)
    local suit = self.debuff.suit
    if not suit then return false end
    if SMODS.has_any_suit(card) then
        for k, joker in ipairs(G.jokers.cards) do
            if not joker.debuff and joker.ability.extra and type(joker.ability.extra) == 'table' and joker.ability.extra.protect_wild then
                return false
            end
        end
    end
    if card:is_suit(suit, true) then return true end
    return false
end

SMODS.Blind:take_ownership('bl_club', {
    recalc_debuff = BALIATRO.suit_debuff,
}, true)

SMODS.Blind:take_ownership('bl_head', {
    recalc_debuff = BALIATRO.suit_debuff,
}, true)

SMODS.Blind:take_ownership('bl_window', {
    recalc_debuff = BALIATRO.suit_debuff,
}, true)

SMODS.Blind:take_ownership('bl_goad', {
    recalc_debuff = BALIATRO.suit_debuff,
}, true)

-- Lesser Blinds
-- 1. The Wizard
-- Must play less than 5 cards.
SMODS.Blind {
    key = 'wizard',
    atlas = 'BaliatroBlinds',
    pos = {x = 0, y = 0},
    boss = {
        min = 1,
        max = 10,
    },
    boss_colour = HEX('05386B'),
    mult = 2,
    dollars = 5,
    debuff = {
        h_size_le = 4,
    },
}

-- 2. The Steel
-- Hands have -1 to base Mult for each time they were previously played.
SMODS.Blind {
    key = 'steel',
    atlas = 'BaliatroBlinds',
    pos = {x = 0, y = 1},
    boss = {
        min = 3,
        max = 10,
    },
    boss_colour = HEX('696b6b'),
    mult = 2,
    dollars = 5,
    modify_hand = function(self, cards, poker_hands, text, mult, hand_chips)
        local text,disp_text,poker_hands,scoring_hand,non_loc_disp_text = G.FUNCS.get_poker_hand_info(cards)
        local played = G.GAME.hands[text].played
        local ret_mult = mult - played
        return ret_mult, hand_chips, ret_mult ~= played
    end,
}


-- 3. The Kingpin
-- Your most scored Rank is debuffed.
SMODS.Blind {
    key = 'kingpin',
    atlas = 'BaliatroBlinds',
    pos = {x = 0, y = 2},
    boss = {
        min = 1,
        max = 10,
    },
    boss_colour = HEX('929292'),
    mult = 2,
    dollars = 5,

    recalc_debuff = function(self, card, from_blind)
        local sc = BALIATRO.most_scored_rank_scores()
        local cv = card.base.value
        if G.GAME.ranks_scored[cv] == sc then
            return true
        end
        return false
    end,

    after_play = function(self)
        for k, card in ipairs(G.playing_cards) do
            G.GAME.blind:debuff_card(card)
        end
    end
}

-- 4. The Rail
-- Your cards previously not played this Ante are debuffed.
SMODS.Blind {
    key = 'rail',
    atlas = 'BaliatroBlinds',
    pos = {x = 0, y = 3},
    boss = {
        min = 2,
        max = 10,
    },
    boss_colour = HEX('494034'),
    mult = 2,
    dollars = 5,

    recalc_debuff = function(self, card, from_blind)
        return card.ability.set ~= "Joker" and (card.ability.played_this_ante == nil or not card.ability.played_this_ante)
    end,
}


-- 5. The Cashier
-- Increasingly larger based on your dollars.

-- 6. The Junkie
-- Cards previously discarded this Ante are debuffed.
SMODS.Blind {
    key = 'junkie',
    atlas = 'BaliatroBlinds',
    pos = {x = 0, y = 4},
    boss = {
        min = 2,
        max = 10,
    },
    boss_colour = HEX('8B1969'),
    mult = 2,
    dollars = 5,

    recalc_debuff = function(self, card, from_blind)
        return card.ability.discarded_this_ante
    end,
}

-- 7. The Muscle
-- 1 in 3 chance to randomize the rank of each scored card.
SMODS.Blind {
    key = 'muscle',
    atlas = 'BaliatroBlinds',
    pos = {x = 0, y = 5},
    boss = {
        min = 3,
        max = 10,
    },
    boss_colour = HEX('580303'),
    mult = 2,
    dollars = 5,
    vars = {1},

    loc_vars = function(self)
        return {vars = {(G.GAME and G.GAME.probabilities.normal) or 1} }
    end,

    after_play = function(self)
        for k, card in ipairs(G.play.cards) do
            if pseudorandom('muscle') < G.GAME.probabilities.normal / 3 then
                G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.15, func = function()
                    card:flip()
                    play_sound('card1', 1)
                    card:juice_up(0.3, 0.3)
                    return true
                end }))
                G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.25, func = function()
                    local new_rank = pseudorandom_element(SMODS.Ranks, pseudoseed('muscle'))
                    SMODS.change_base(card, nil, new_rank.key)
                    card:flip()
                    play_sound('tarot2', 1, 0.6)
                    return true
                end }))
            end
        end
    end
}

-- 8. The Proud
-- 1 in 2 chance to randomize the suit of each scored card.
SMODS.Blind {
    key = 'proud',
    atlas = 'BaliatroBlinds',
    pos = {x = 0, y = 6},
    boss = {
        min = 2,
        max = 10,
    },
    boss_colour = HEX('EB5BF8'),
    mult = 2,
    dollars = 5,

    vars = {1},

    loc_vars = function(self)
        return {vars = {(G.GAME and G.GAME.probabilities.normal) or 1} }
    end,

    after_play = function(self)
        for k, card in ipairs(G.play.cards) do
            if pseudorandom('proud') < G.GAME.probabilities.normal / 2 then
                G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.15, func = function()
                    card:flip()
                    play_sound('card1', 1)
                    card:juice_up(0.3, 0.3)
                    return true
                end }))
                G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.25, func = function()
                    local new_suit = pseudorandom_element(SMODS.Suits, pseudoseed('proud'))
                    SMODS.change_base(card, new_suit.key)
                    card:flip()
                    play_sound('tarot2', 1, 0.6)
                    return true
                end }))
            end
        end
    end
}

-- 9. The Ascetic
-- Cards with an Edition are debuffed.
SMODS.Blind {
    key = 'ascetic',
    atlas = 'BaliatroBlinds',
    pos = {x = 0, y = 7},
    boss = {
        min = 2,
        max = 10,
    },
    boss_colour = HEX('05055B'),
    mult = 2,
    dollars = 5,

    recalc_debuff = function(self, card, from_blind)
        if card.edition and card.ability.set ~= 'Joker' then return true else return false end
    end,

    in_pool = function(self)
        if G.playing_cards then
            for k, card in ipairs(G.playing_cards) do
                if card.edition then return true end
            end
        end
        return false
    end
}

-- 10. The Diplomat
-- Cards with a Seal are debuffed.
SMODS.Blind {
    key = 'diplomat',
    atlas = 'BaliatroBlinds',
    pos = {x = 0, y = 8},
    boss = {
        min = 2,
        max = 10,
    },
    boss_colour = HEX('3908C0'),
    mult = 2,
    dollars = 5,

    recalc_debuff = function(self, card, from_blind)
        if card.seal then return true else return false end
    end,

    in_pool = function(self)
        if G.playing_cards then
            for k, card in ipairs(G.playing_cards) do
                if card.seal then return true end
            end
        end
        return false
    end
}

-- 11. The Count
-- Numeric cards are debuffed.
SMODS.Blind {
    key = 'count',
    atlas = 'BaliatroBlinds',
    pos = {x = 0, y = 9},
    boss = {
        min = 4,
        max = 10,
    },
    boss_colour = HEX('770808'),
    mult = 2,
    dollars = 5,

    recalc_debuff = function(self, card, from_blind)
        if card.base then
            return card.base.value == (card.base.nominal .. '')
        end
        return false
    end,
}

-- 12. The Line
-- Cards after each discard are drawn face down.
SMODS.Blind {
    key = 'line',
    atlas = 'BaliatroBlinds',
    pos = {x = 0, y = 10},
    boss = {
        min = 4,
        max = 10,
    },
    boss_colour = HEX('997D01'),
    mult = 2,
    dollars = 5,

    pre_discard = function(self, context)
        G.GAME.blind.flip = false
    end,

    set_blind = function(self)
        G.GAME.blind.flip = false
    end,

    press_play = function(self)
        G.GAME.blind.flip = true
    end,

    stay_flipped = function(self, area, card)
        if G.GAME.current_round.hands_played == 0 and G.GAME.current_round.discards_used == 0 then
            return false
        end
        if area == G.hand then
            return not G.GAME.blind.flip
        end
        return false
    end,
}

-- Greater Blinds
-- 1. Saffron Shell
-- All cards return to your deck. Cards already discarded or played are debuffed.
SMODS.Blind {
    key = 'saffron_shell',
    atlas = 'BaliatroBlinds',
    pos = {x = 0, y = 11},
    boss = {
        showdown = true,
        min = 8,
        max = 10,
    },
    play_to_deck = true,
    discard_to_deck = true,
    boss_colour = HEX('F1C338'),
    mult = 2,
    dollars = 8,

    recalc_debuff = function(self, card, from_blind)
        return card.ability.played_this_round or card.ability.discarded_this_round
    end,

    after_play = function(self)
        for k, card in ipairs(G.playing_cards) do
            G.GAME.blind:debuff_card(card)
        end
    end,

    after_discard = function(self)
        for k, card in ipairs(G.playing_cards) do
            G.GAME.blind:debuff_card(card)
        end
    end,

}

-- 2. Bark Umbrella
-- Played cards are destroyed after scoring.
--SMODS.Blind {
--    key = 'saffron_shell',
--    boss = {
--        showdown = true,
--        min = 8,
--        max = 10,
--    },
--    play_to_deck = true,
--    discard_to_deck = true,
--    boss_colour = HEX('F1C338'),
--    mult = 2,
--    dollars = 5,
--
--    recalc_debuff = function(self, card, from_blind)
--        return card.played_this_round or card.discarded_this_round
--    end,
--
--    after_play = function(self)
--        for k, card in ipairs(G.playing_cards) do
--            G.GAME.blind:debuff_card(card)
--        end
--    end
--}

-- 3. Turquoise Ladder
-- Cards remaining in hand after each play or discard become debuffed.
SMODS.Blind {
    key = 'turquoise_ladder',
    atlas = 'BaliatroBlinds',
    pos = {x = 0, y = 12},
    boss = {
        showdown = true,
        min = 8,
        max = 10,
    },
    boss_colour = HEX('32B1A4'),
    mult = 2,
    dollars = 8,

    recalc_debuff = function(self, card, from_blind)
        return card.played_this_round
    end,

    after_discard = function(self)
        for k, card in ipairs(G.hand) do
            card.ability.played_this_round = true
            G.GAME.blind:debuff_card(card)
        end
    end,

    after_play = function(self)
        for k, card in ipairs(G.hand) do
            card.ability.played_this_round = true
            G.GAME.blind:debuff_card(card)
        end
    end
}