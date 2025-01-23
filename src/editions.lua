function Card:is_foil()
    return self.edition and (self.edition.foil or self.edition.baliatro_faded_foil)
end

function Card:is_holographic()
    return self.edition and (self.edition.holo or self.edition.baliatro_faded_holo)
end

function Card:is_polychrome()
    return self.edition and (self.edition.polychrome or self.edition.baliatro_faded_polychrome)
end

SMODS.Edition:take_ownership('foil', {
    loc_vars = function(self)
        if G.GAME then
            local ed_level = G.GAME.spec_planets["baliatro_foil"]
            local chips = ed_level.c_v1

            return { vars = { chips } }
        end
        return { vars = { 50 } }
    end,

    calculate = function(self, card, context)
        if (context.cardarea == G.jokers and context.edition and context.pre_joker) or (context.cardarea == G.play and context.main_scoring)  then
            local ed_level = G.GAME.spec_planets["baliatro_foil"]
            return {
                chip_mod = ed_level.c_v1
            }
        end
    end,

    on_apply = function(card)
        if card.added_to_deck then
            G.GAME.spec_planets["baliatro_foil"].ever = true
        end
    end
}, true)

SMODS.Edition:take_ownership('holo', {
    loc_vars = function(self)
        if G.GAME then
            local ed_level = G.GAME.spec_planets["baliatro_holo"]
            local mult = ed_level.c_v1

            return { vars = { mult } }
        end
        return { vars = { 10 } }
    end,

    calculate = function(self, card, context)
        --print('calc holo edition %s', context)
        if (context.cardarea == G.jokers and context.edition and context.pre_joker) or (context.cardarea == G.play and context.main_scoring)  then
            local ed_level = G.GAME.spec_planets["baliatro_holo"]
            return {
                mult_mod = ed_level.c_v1
            }
        end
    end,

    on_apply = function(card)
        if card.added_to_deck then
            G.GAME.spec_planets["baliatro_holo"].ever = true
        end
    end
}, true)

SMODS.Edition:take_ownership('polychrome', {
    loc_vars = function(self)
        if G.GAME then
            local ed_level = G.GAME.spec_planets["baliatro_polychrome"]
            local mult = ed_level.c_v1

            return { vars = { mult } }
        end
        return { vars = { 1.5 } }
    end,

    calculate = function(self, card, context)
        if (context.cardarea == G.jokers and context.edition and context.pre_joker) or (context.cardarea == G.play and context.main_scoring)  then
            local ed_level = G.GAME.spec_planets["baliatro_polychrome"]
            local x_mult_mod = ed_level.c_v1
            local remult = ed_level.remult or 1

            return {
                x_mult_mod = x_mult_mod * remult
            }
        end
    end,

    on_apply = function(card)
        if card.added_to_deck then
            G.GAME.spec_planets["baliatro_polychrome"].ever = true
        end
    end
}, true)

SMODS.Shader {
    key = 'faded_foil',
    path = 'faded_foil.fs',
}

SMODS.Edition {
    name = "Faded Foil",
    key = "faded_foil",
    unlocked = true,
    in_shop = true,
    weight = 60,
    extra_cost = 1,
    apply_to_float = true,
    shader = "faded_foil",

    loc_vars = function(self)
        if G.GAME then
            local ed_level = G.GAME.spec_planets["baliatro_foil"]
            local chips = math.floor(ed_level.c_v1 / 5)

            return { vars = { chips } }
        end
        return { vars = { 10 } }
    end,

    calculate = function(self, card, context)
        if (context.cardarea == G.jokers and context.edition and context.pre_joker) or (context.cardarea == G.play and context.main_scoring)  then
            local ed_level = G.GAME.spec_planets["baliatro_foil"]
            return {
                chip_mod = ed_level.c_v1 / 5
            }
        end
    end,

    on_apply = function(card)
        if card.added_to_deck then
            G.GAME.spec_planets["baliatro_foil"].ever = true
        end
    end
}

SMODS.Shader {
    key = 'faded_holo',
    path = 'faded_holo.fs',
}

SMODS.Edition {
    name = "Faded Holo",
    key = "faded_holo",
    unlocked = true,
    in_shop = true,
    weight = 42,
    extra_cost = 1,
    apply_to_float = true,
    shader = "faded_holo",

    loc_vars = function(self)
        if G.GAME then
            local ed_level = G.GAME.spec_planets["baliatro_holo"]
            local mult = math.floor(ed_level.c_v1 / 5)

            return { vars = { mult } }
        end
        return { vars = { 2 } }
    end,

    calculate = function(self, card, context)
        --print('calc holo edition %s', context)
        if (context.cardarea == G.jokers and context.edition and context.pre_joker) or (context.cardarea == G.play and context.main_scoring)  then
            local ed_level = G.GAME.spec_planets["baliatro_holo"]
            return {
                mult_mod = ed_level.c_v1 / 5
            }
        end
    end,

    on_apply = function(card)
        if card.added_to_deck then
            G.GAME.spec_planets["baliatro_holo"].ever = true
        end
    end
}

SMODS.Shader {
    key = 'faded_polychrome',
    path = 'faded_polychrome.fs',
}

SMODS.Edition {
    name = "Faded Polychrome",
    key = "faded_polychrome",
    unlocked = true,
    in_shop = true,
    weight = 10,
    extra_cost = 1,
    apply_to_float = true,
    shader = "faded_polychrome",

    loc_vars = function(self)
        if G.GAME then
            local ed_level = G.GAME.spec_planets["baliatro_polychrome"]
            local mult = ed_level.c_v1 / 5 + 0.8

            return { vars = { mult } }
        end
        return { vars = { 1.1 } }
    end,

    calculate = function(self, card, context)
        if (context.cardarea == G.jokers and context.edition and context.pre_joker) or (context.cardarea == G.play and context.main_scoring)  then
            local ed_level = G.GAME.spec_planets["baliatro_polychrome"]
            local x_mult_mod = ed_level.c_v1 / 5 + 0.8
            local remult = ed_level.remult or 1

            return {
                x_mult_mod = x_mult_mod * remult
            }
        end
    end,

    on_apply = function(card)
        if card.added_to_deck then
            G.GAME.spec_planets["baliatro_polychrome"].ever = true
        end
    end
}

SMODS.Shader {
    key = 'photographic',
    path = 'photographic.fs',
}

SMODS.Edition {
    name = "Photographic",
    key = "photographic",
    unlocked = true,
    in_shop = true,
    weight = 5,
    extra_cost = 5,
    apply_to_float = true,
    shader = "photographic",

    loc_vars = function(self)
        if G.GAME then
            local ed_level = G.GAME.spec_planets["baliatro_photographic"]
            local mult = ed_level.c_v1

            return { vars = { mult } }
        end
        return { vars = { 1.1 } }
    end,

    augment = function(self, card, context, o, t)
        if o and not context.blueprint then
            local ed_level = G.GAME.spec_planets["baliatro_photographic"]
            local mult = ed_level.c_v1

            local augmented = false
            local trigger_keys = {'chips', 'h_chips', 'chip_mod', 'mult', 'h_mult', 'mult_mod', 'x_mult', 'Xmult', 'xmult', 'x_mult_mod', 'Xmult_mod', 'p_dollars', 'dollars', 'h_dollars', 'level_up', 'repetitions'}        local valid = false
            local xmod_keys = {'x_mult', 'Xmult', 'xmult', 'x_mult_mod', 'Xmult_mod'}

            for i, key in ipairs(trigger_keys) do
                if o[key] then
                    o[key] = o[key] * mult
                    local is_xmult = false
                    for _, k2 in ipairs(xmod_keys) do
                        if k2 == key then
                            is_xmult = true
                            break
                        end
                    end
                    if not is_xmult then
                        o[key] = math.floor(o[key])
                    end
                    if o.message then
                        o.message = localize{type='variable', key='a_baliatro_augment_photographic', vars={o.message}}
                    else
                        o.message = localize('k_baliatro_augment_photographic')
                    end
                    augmented = true
                    break
                end
            end
        end
        return o, t
    end,

    on_apply = function(card)
        if card.added_to_deck then
            G.GAME.spec_planets["baliatro_photographic"].ever = true
        end
    end
}

SMODS.Shader {
    key = 'scenic',
    path = 'scenic.fs',
}

SMODS.Edition {
    name = "Scenic",
    key = "scenic",
    unlocked = true,
    in_shop = true,
    weight = 3,
    extra_cost = 5,
    apply_to_float = true,
    shader = "scenic",
    config = {
        extra = {
            chips = 0,
            add_chips = 5,
            increase = 1.04,
            reduction = 0.001,
        }
    },

    loc_vars = function(self, info_queue, card)
        local ed_level = G.GAME.spec_planets["baliatro_scenic"]
        local bonus_perc = ed_level.c_v1
        if not card or not card.edition or not card.edition.baliatro_scenic then
            return { vars = { self.config.extra.chips, self.config.extra.add_chips, (self.config.extra.increase - 1) * 100 + bonus_perc, self.config.extra.reduction * 100 } }
        end
        return { vars = { card.edition.extra.chips, card.edition.extra.add_chips, (card.edition.extra.increase - 1) * 100 + bonus_perc, card.edition.extra.reduction * 100 } }
    end,

    level_up_self = function(self, card, context)
        local ed_level = G.GAME.spec_planets["baliatro_scenic"]
        local bonus_perc = ed_level.c_v1 / 100
        local basis = card.edition.extra.add_chips
        local inc = card.edition.extra.increase + bonus_perc
        card.edition.extra.chips = card.edition.extra.chips + basis
        card.edition.extra.add_chips = math.max(1, basis * inc)
        card.edition.extra.increase = card.edition.extra.increase - card.edition.extra.reduction
        return basis
    end,

    augment = function(self, card, context, o, t)
        if context.check_enhancement or not(context.edition or context.individual or context.main_scoring or context.repetition) or not o then return o, t end
        local trigger_keys = {'chips', 'h_chips', 'chip_mod', 'mult', 'h_mult', 'mult_mod', 'x_mult', 'Xmult', 'xmult', 'x_mult_mod', 'Xmult_mod', 'p_dollars', 'dollars', 'h_dollars', 'level_up', 'repetitions'}        local valid = false
        for i, tk in ipairs(trigger_keys) do
            if o[tk] then
                valid = true
                break
            end
        end
        if not valid then return o, t end

        local basis = self:level_up_self(card, context)
        local msg = ""
        if o.message then msg = o.message end
        if basis > 0 then
            o.message = msg .. " " .. localize{type='variable', key='a_baliatro_beautify', vars={basis}}
        else
            o.message = msg .. " " .. localize{type='variable', key='a_baliatro_spoil', vars={basis}}
        end
        return o, t
    end,

    calculate = function(self, card, context)
        if (context.cardarea == G.jokers and context.edition and context.pre_joker) or (context.cardarea == G.play and context.main_scoring)  then
            return {
                chip_mod = card.edition.extra.chips
            }
        end
    end,

    on_apply = function(card)
        if card.added_to_deck then
            G.GAME.spec_planets["baliatro_scenic"].ever = true
        end
    end
}

return {
    name = "Baliatro Editions",
}