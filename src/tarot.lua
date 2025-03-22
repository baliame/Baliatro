SMODS.Consumable {
    object_type = "Consumable",
    set = "Tarot",
    key = "ace_of_wands",
    pos = { x = 2, y = 0 },
    cost = 4,
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

SMODS.Consumable {
    object_type = "Consumable",
    set = "Tarot",
    key = "ace_of_pentacles",
    pos = { x = 3, y = 0 },
    cost = 4,
    atlas = "BaliatroSpectral",
    config = {
        max_highlighted = 2,
        min_highlighted = 1,
        mod_conv = 'm_baliatro_resistant',
    },

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = G.P_CENTERS[self.config.mod_conv]
        return {vars={(card and card.ability.consumeable.max_highlighted) or self.config.max_highlighted}}
    end,

    use = function(self, card, area, copier)
        local targets = {}
        for _, target in ipairs(G.hand.highlighted) do
            targets[#targets+1] = target
        end
        BALIATRO.mod_conv_use(self, card, area, copier)
        for _, target in ipairs(G.hand.highlighted) do
            G.GAME.blind:debuff_card(target)
        end
    end
}

SMODS.Consumable {
    object_type = "Consumable",
    set = "Tarot",
    key = "ace_of_cups",
    pos = { x = 5, y = 0 },
    cost = 4,
    atlas = "BaliatroSpectral",
    rarity = 4,
    hidden = true,
    soul_rate = 0.03,
    soul_set = "Tarot",
    config = {
        max_highlighted = 2,
        min_highlighted = 1,
        chip_gain = 30,
        mult_gain = 3,
    },

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = {key='baliatro_plain', set='Other'}
        return {vars={(card and card.ability.consumeable.max_highlighted) or self.config.max_highlighted, (card and card.ability.consumeable.chip_gain) or self.config.chip_gain, (card and card.ability.consumeable.mult_gain) or self.config.mult_gain}}
    end,

    use = function(self, card, area, copier)
        local used_tarot = copier or card
        local destroyed_cards = {}

        for i, other in ipairs(G.hand.highlighted) do
            local count = 0

            if other.ability.set == 'Enhanced' then count = count + 1; other:set_ability(G.P_CENTERS.c_base, nil, true) end
            if other.seal then count = count + 1; other:set_seal(nil) end
            if other.edition then count = count + 1; other:set_edition(nil, true, true) end
            if count > 0 then
                other.ability.perma_bonus = other.ability.perma_bonus + (count * card.ability.consumeable.chip_gain)
                other.ability.perma_mult = other.ability.perma_mult + (count * card.ability.consumeable.mult_gain)
            else
                destroyed_cards[#destroyed_cards+1] = other
            end
        end

        G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.2, func = function()
            for i, other in ipairs(destroyed_cards) do
                if SMODS.shatters(other) then
                    other:shatter()
                else
                    other:start_dissolve(nil, i == #G.hand.highlighted)
                end
            end
            return true
        end }))

        used_tarot:juice_up()
    end
}

SMODS.Consumable {
    object_type = "Consumable",
    set = "Tarot",
    key = "king_of_swords",
    pos = { x = 4, y = 0 },
    cost = 8,
    atlas = "BaliatroSpectral",
    rarity = 4,
    hidden = true,
    soul_rate = 0.03,
    soul_set = "Tarot",
    config = {
        max_highlighted = 1,
        min_highlighted = 1,
    },

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = {key='baliatro_immortal', set='Other'}
        return {vars={(card and card.ability.consumeable.max_highlighted) or self.config.max_highlighted}}
    end,

    use = function(self, card, area, copier)
        local used_tarot = copier or card
        for _, target in ipairs(G.hand.highlighted) do
            local _enh = SMODS.poll_enhancement({guaranteed = true})
            local _seal = SMODS.poll_seal({guaranteed = true})
            local _ed = poll_edition('kos', nil, nil, true)
            if _ed:find("baliatro_faded_") then
                _ed = _ed:gsub("baliatro_faded_", "")
            end
            target:set_ability(G.P_CENTERS[_enh])
            target:set_seal(_seal)
            target:set_edition(_ed)
            if target.edition.config and target.edition.config.card_limit then
                target:set_immortal(true)
            end
            G.GAME.blind:debuff_card(target)
        end

        used_tarot:juice_up()
    end
}

BALIATRO.mod_conv_or_cb = function(joker, card, area, copier)
    local used_tarot = copier or card
    if card.ability.consumeable.mod_conv then
        G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
            play_sound('tarot1')
            used_tarot:juice_up(0.3, 0.5)
            return true
        end }))
        for i = 1, #G.hand.highlighted do
            local percent = 1.15 - (i-0.999)/(#G.hand.highlighted-0.998)*0.3
            local oc = G.hand.highlighted[i]
            G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.15, func = function()
                oc:flip()
                play_sound('card1', percent)
                oc:juice_up(0.3, 0.3)
                return true
            end }))
        end
        delay(0.2)
        for i = 1, #G.hand.highlighted do
            local oc = G.hand.highlighted[i]
            G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.1, func = function()
                if joker and oc.ability.set == 'Enhanced' then
                    local center = joker.config.center
                    if joker.ability and joker.ability.extra and center.on_already_enhanced and type(center.on_already_enhanced) == 'function' then
                        center.on_already_enhanced(joker, oc, used_tarot)
                    end
                else
                    oc:set_ability(G.P_CENTERS[card.ability.consumeable.mod_conv])
                end
                return true
            end}))
        end

        for i = 1, #G.hand.highlighted do
            local percent = 0.85 + (i-0.999)/(#G.hand.highlighted-0.998)*0.3
            local oc = G.hand.highlighted[i]
            G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.15, func = function()
                oc:flip()
                play_sound('tarot2', percent, 0.6)
                oc:juice_up(0.3, 0.3)
                return true
            end }))
        end
        G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.2,func = function() G.hand:unhighlight_all(); return true end }))
        delay(0.5)
    end
end


BALIATRO.mod_conv_use = function(self, card, area, copier)
    local key = card.config.center.key
    local affecting_joker = nil
    for i, joker in ipairs(G.jokers.cards) do
        if not joker.debuff then
            if joker.ability.extra and type(joker.ability.extra) == 'table' and joker.ability.extra.overrides_consumeable == key then
                affecting_joker = joker
                break
            end
        end
    end
    BALIATRO.mod_conv_or_cb(affecting_joker, card, area, copier)
end

SMODS.Consumable:take_ownership('c_heirophant', {
    use = BALIATRO.mod_conv_use,
}, true)

SMODS.Consumable:take_ownership('c_empress', {
    use = BALIATRO.mod_conv_use,
}, true)

SMODS.Consumable:take_ownership('c_tower', {
    use = BALIATRO.mod_conv_use,
}, true)

SMODS.Consumable:take_ownership('c_magician', {
    use = BALIATRO.mod_conv_use,
}, true)

return {
    name = "Baliatro Tarot",
}
