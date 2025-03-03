SMODS.Rarity {
    key = "pact",
    badge_colour = HEX('993A03')
}

SMODS.Rarity {
    key = "punishment",
    badge_colour = HEX('993A03')
}

SMODS.Shader {
    key = 'pact',
    path = 'pact.fs',
}

SMODS.Sound {
    key = 'hellfire',
    path = 'hellfire.ogg'
}

BALIATRO.pact_excluded_blinds = {'bl_serpent', 'bl_wall', 'bl_final_vessel'}

function BALIATRO.pick_pact_blind(showdown, can_repeat)
    if not G.GAME or not G.GAME.baliatro_pacts then return nil end
    local valid = {}
    for key, blind in pairs(G.P_BLINDS) do
        if blind.boss and ((not blind.boss.showdown and not showdown) or (blind.boss.showdown and showdown)) then
            local invalid = false
            for _, exclusion in ipairs(BALIATRO.pact_excluded_blinds) do
                if exclusion == key then
                    invalid = true
                    break
                end
            end
            if not invalid then
                if not can_repeat then
                    for _, pact in ipairs(G.GAME.baliatro_pacts) do
                        if pact.blind == key then
                            invalid = true
                            break
                        end
                    end
                end

                if not invalid then
                    valid[#valid + 1] = key
                end
            end
        end
    end
    if #valid == 0 and showdown then
        return BALIATRO.pick_pact_blind(false, can_repeat)
    elseif #valid == 0 and not can_repeat then
        return BALIATRO.pick_pact_blind(showdown, true)
    elseif #valid == 0 then
        return 'bl_arm' -- I don't even know how we'd get here and I don't know if this would solve anything.
    end
    return pseudorandom_element(valid, pseudoseed('pact'))
end

function BALIATRO.apply_pact(pact)
    for _, ex_pact in ipairs(G.GAME.baliatro_pacts) do
        if ex_pact.blind == pact.blind then return end
    end
    G.GAME.baliatro_pacts[#G.GAME.baliatro_pacts + 1] = {blind = pact}
end


SMODS.Booster {
	key = "pact_1",
    name = "Audience with the Devil",
	kind = "BaliatroPact",
	atlas = "BaliatroPacks",
	pos = { x = 0, y = 1 },
	config = { extra = 3, choose = 1 },
	cost = 0,
	order = 3,
	weight = 0,
    no_shine = true,
    no_upgrade = true,
	create_card = function(self, card)
		return SMODS.create_card{
            set = "Joker",
            no_edition = true,
            area = G.pack_cards,
            rarity = "baliatro_pact",
            key_append = "pact_pack",
            stickers = {"eternal"},
        }
	end,
    ease_background_colour = function(self)
        ease_colour(G.C.DYN_UI.MAIN, mix_colours(G.C.SECONDARY_SET.Planet, G.C.BLACK, 0.9))
		ease_background_colour({ new_colour =  G.C.BLACK, special_colour = darken(G.C.BLACK, 0.2), contrast = 3 })
    end,
    particles = function(self)
        G.booster_pack_stars = Particles(1, 1, 0,0, {
            timer = 0.07,
            scale = 0.8,
            initialize = true,
            lifespan = 2,
            speed = 0.1,
            padding = -4,
            attach = G.ROOM_ATTACH,
            colours = {HEX('FF4B04'), HEX('FFD104'), HEX('C08E03')},
            fill = true
        })
    end,
    on_skip = function(self)
        local _card = SMODS.create_card{set = 'Joker', area = G.jokers, no_edition = true, skip_materialize = true, soulable = false, key = 'j_baliatro_punishment_devils_scorn', key_append = 'bpaud'}
        _card:add_to_deck()
        G.jokers:emplace(_card)
    end,
	loc_vars = BALIATRO.booster_pack_locvars,
	group_key = "k_baliatro_pact_pack",
    set_ability = BALIATRO.booster_pack_set_ability,

    in_pool = function(self)
        return false -- Never, ever create this through usual pool stuff.
    end
}


SMODS.Edition {
    name = "Pact",
    key = "pact",
    unlocked = true,
    in_shop = false,
    weight = 3,
    extra_cost = 0,
    apply_to_float = true,
    shader = "pact",
    config = {
        card_limit = 1,
    },
    sound = { sound = 'baliatro_hellfire', per=1.0, vol=0.8 },
    disable_base_shader = true,
    disable_shadow = true,

    loc_vars = function(self, info_queue, card)
        local force_unknown = false
        if (not card or not card.edition or not card.edition.pact) or (card.edition.unseen and not card.added_to_deck) then
            force_unknown = true
        end

        if not force_unknown  then
            info_queue[#info_queue+1] = G.P_BLINDS[card.edition.pact]
        end
        local blind = localize('k_baliatro_unknown')
        if card.edition.collection then
            if card.edition.unseen then
                blind = localize('k_baliatro_random_unseen_blind')
            elseif card.edition.showdown then
                blind = localize('k_baliatro_random_showdown_blind')
            else
                blind = localize('k_baliatro_random_blind')
            end
        elseif not force_unknown then
            blind = localize{type = 'name_text', set = 'Blind', key = card.edition.pact}
        end
        return { vars = {
            blind,
            (card and card.edition and card.edition.card_limit) or self.config.card_limit,
        }}
    end,

    on_apply = function(card)
        local pact = card.config.center.pact or {}
        if pact.unseen then card.edition.unseen = true end
        if pact.showdown then card.edition.showdown = true end
        if G.STAGE ~= G.STAGES.RUN then card.edition.collection = true end -- it's good enough to avoid a crash ig
        if G.STAGE ~= G.STAGES.RUN or not G.GAME.baliatro_pacts then return end
        card.edition.pact = BALIATRO.pick_pact_blind(pact.showdown, pact.can_repeat)
        card:set_eternal(true)
        if card.added_to_deck then BALIATRO.apply_pact(card.edition.pact) end
    end
}

-- Pact qualifiers:
-- Unseen: Blind is unknown until purchase.
-- Dangerous: Blind is showdown if possible.
-- Treacherous: Pact joker has a downside.
BALIATRO.pact_defs = {
    common = {
        skip = true,
        set_ability = function(self, card, initial, delay_sprites)
            if not card.ignore_base_shader then card.ignore_base_shader = {} end
            if not card.ignore_shadow then card.ignore_shadow = {} end
            if not card.edition then card:set_edition('e_baliatro_pact', true, not (G.GAME and G.GAME.baliatro_pacts)) end
        end,
    },
    -- Potential
    -- +1 Joker Slot
    -- Treachery: Destroy a random Joker (including Eternal) when selecting blind if you have no non-negative Common jokers.
    potential = {
        name = "Potential",
        config = {
            extra = {
                card_limit = 1,
            }
        },

        treacherous = {
            calculate = function(self, card, context)
                if not context.blueprint and context.setting_blind then
                    local have_common_joker = false
                    for i, joker in ipairs(G.jokers.cards) do
                        if not (joker.edition and joker.edition.negative) and (joker.config.center.rarity == 1 or joker.config.center.rarity == 'Common') then
                            have_common_joker = true
                            break
                        end
                    end

                    if not have_common_joker then
                        local targets = {}
                        for i, joker in ipairs(G.jokers.cards) do
                            if BALIATRO.manipulable(joker) then targets[#targets + 1] = joker end
                        end
                        if #targets then
                            local to_destroy = pseudorandom_element(targets, pseudoseed('potential'))

                            if to_destroy then
                                G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.3, func = function()
                                    to_destroy:start_dissolve(nil, nil)
                                    return true
                                end}))

                                return {
                                    message = localize('k_baliatro_destroyed_card_ex')
                                }
                            end
                        end
                    end
                end
            end,
        },

        add_to_deck = function(self, card, from_debuff)
            G.jokers.config.card_limit = G.jokers.config.card_limit + card.ability.extra.card_limit
        end,

        remove_from_deck = function(self, card, from_debuff)
            G.jokers.config.card_limit = G.jokers.config.card_limit - card.ability.extra.card_limit
        end,

        loc_vars = function(self, info_queue, card)
            return { vars = { card.ability.extra.card_limit }}
        end,
    },
    -- Might
    -- +8 Consumable Slots
    -- Treachery: Each empty consumable slot grants X0.25 Mult. Jokers appear in shop 4X as often.
    might = {
        name = "Might",
        config = {
            extra = {
                card_limit = 8,
            }
        },

        treacherous = {
            config = {
                extra = {
                    joker_rate = 4,
                    x_mult = 0.25,
                }
            },

            add_to_deck = function(self, card, from_debuff)
                G.GAME.joker_rate = G.GAME.joker_rate * card.ability.extra.joker_rate
            end,

            remove_from_deck = function(self, card, from_debuff)
                G.GAME.joker_rate = G.GAME.joker_rate / card.ability.extra.joker_rate
            end,

            calculate = function(self, card, context)
                if not context.blueprint and context.joker_main then
                    local empty_consumable_slots = G.consumeables.config.card_limit - (#G.consumeables.cards + G.GAME.consumeable_buffer)
                    return {
                        x_mult = card.ability.extra.x_mult ^ empty_consumable_slots,
                    }
                end
            end,

            loc_vars = function(self, info_queue, card)
                local empty_consumable_slots = G.consumeables and (G.consumeables.config.card_limit - #G.consumeables.cards) or 10
                return { vars = { card.ability.extra.card_limit, card.ability.extra.x_mult, card.ability.extra.joker_rate, card.ability.extra.x_mult ^ empty_consumable_slots}}
            end,
        },

        add_to_deck = function(self, card, from_debuff)
            G.consumeables.config.card_limit = G.consumeables.config.card_limit + card.ability.extra.card_limit
        end,

        remove_from_deck = function(self, card, from_debuff)
            G.consumeables.config.card_limit = G.consumeables.config.card_limit - card.ability.extra.card_limit
        end,

        loc_vars = function(self, info_queue, card)
            return { vars = { card.ability.extra.card_limit }}
        end,
    },
    -- Fingers
    -- +3 Hand Size
    -- Treachery: Cards return to your deck.
    fingers = {
        name = "Fingers",
        config = {
            extra = {
                hand_size = 3,
            }
        },

        treacherous = {
            add_to_deck = function(self, card, from_debuff)
                G.GAME.play_to_deck = (G.GAME.play_to_deck or 0) + 1
                G.GAME.discard_to_deck = (G.GAME.discard_to_deck or 0) + 1
            end,

            remove_from_deck = function(self, card, from_debuff)
                G.GAME.play_to_deck = (G.GAME.play_to_deck or 1) - 1
                G.GAME.discard_to_deck = (G.GAME.discard_to_deck or 1) - 1
            end,
        },

        add_to_deck = function(self, card, from_debuff)
            G.hand:change_size(card.ability.extra.hand_size)
        end,

        remove_from_deck = function(self, card, from_debuff)
            G.hand:change_size(-card.ability.extra.hand_size)
        end,

        loc_vars = function(self, info_queue, card)
            return { vars = { card.ability.extra.hand_size }}
        end,
    },
    -- Riches
    -- $20 at the end of the round.
    -- Treachery: $40, if you have at most $3.
    riches = {
        name = "Riches",
        config = {
            extra = {
                income = 20,
            }
        },

        treacherous = {
            config = {
                extra = {
                    income = 40,
                    le = 3,
                }
            },

            calc_dollar_bonus = function(self, card)
                if G.GAME.dollars <= card.ability.extra.le then
                    return card.ability.extra.income
                end
                return 0
            end,

            loc_vars = function(self, info_queue, card)
                return { vars = { card.ability.extra.income, card.ability.extra.le }}
            end,
        },

        calc_dollar_bonus = function(self, card)
            return card.ability.extra.income
        end,

        loc_vars = function(self, info_queue, card)
            return { vars = { card.ability.extra.income }}
        end,
    },
    -- Quality
    -- Higher rarities are more common.
    -- Treachery: Unpurchased non-Common Jokers are sometimes banned when rerolling the shop.
    quality = {
        name = "Quality",
        config = {
            extra = {
                rarity_shift = 2,
                pool_remove = 5,
            }
        },

        treacherous = {
            loc_vars = function(self, info_queue, card)
                info_queue[#info_queue+1] = {key='baliatro_ban', set='Other', append_banned_set='Joker'}
                return {vars={}}
            end,

            calculate = function(self, card, context)
                if not context.blueprint and context.card_rerolled_from_shop then
                    local o_card = context.other_card
                    if o_card.config.center then
                        local o_center = o_card.config.center
                        if o_center.set == 'Joker' and o_center.rarity ~= 1 and o_center.rarity ~= 'common' then
                            if pseudorandom('pact_qual') <= 1 / card.ability.extra.pool_remove then
                                G.GAME.banned_keys[o_center.key] = true
                                return {
                                    message = localize('k_baliatro_banned_ex'),
                                    message_card = card,
                                }
                            end
                        end
                    end
                end
            end,
        },

        add_to_deck = function(self, card, from_debuff)
            G.GAME.common_mod = (G.GAME.common_mod or 1) / card.ability.extra.rarity_shift
        end,

        remove_from_deck = function(self, card, from_debuff)
            G.GAME.common_mod = (G.GAME.common_mod or (1 / card.ability.extra.rarity_shift)) * card.ability.extra.rarity_shift
        end,
    },
    -- Fortune
    -- Triples all listed probabilities.
    -- Treachery: On average. Statistically. Over some indeterminate timeframe.
    fortune = {
        name = "Fortune",
        config = {
            extra = {
                orig_normal = 3,
                normal = 3,
            }
        },
        treacherous = {
            config = {
                extra = {
                    bias = 0,
                },
            },

            calculate = function(self, card, context)
                if context.blueprint then return end
                if context.after or context.post_discard or context.setting_blind or context.end_of_round or context.skipping_booster then
                    local bias = card.ability.extra.bias
                    local normal = math.min(math.max(pseudorandom("pact_fort") * card.ability.extra.orig_normal * 2 + bias, 0), card.ability.extra.orig_normal * 2)
                    local new_bias = (card.ability.extra.orig_normal - normal) / card.ability.extra.orig_normal
                    card.ability.extra.bias = card.ability.extra.bias + new_bias
                    self:remove_from_deck(card, false)
                    card.ability.extra.normal = normal
                    self:add_to_deck(card, false)
                end
            end,

            loc_vars = function(self, info_queue, card)
                return { vars = { card.ability.extra.orig_normal, card.ability.extra.normal }}
            end,
        },

        add_to_deck = function(self, card, from_debuff)
            card.ability.extra.prev_normal = G.GAME.probabilities.normal
            G.GAME.probabilities.normal = G.GAME.probabilities.normal * card.ability.extra.normal
        end,

        remove_from_deck = function(self, card, from_debuff)
            if not card.ability.extra.prev_normal then
                card.ability.extra.prev_normal = 1
            end
            G.GAME.probabilities.normal = card.ability.extra.prev_normal
        end,

        loc_vars = function(self, info_queue, card)
            return { vars = { card.ability.extra.normal }}
        end,
    }
}

-- 0. Devil's Scorn
--
SMODS.Joker {
    name = "Devil's Scorn",
    key = "punishment_devils_scorn",
    pos = {
        x = 0,
        y = 0,
    },
    unlocked = true,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = false,
    cost = 1,
    rarity = "baliatro_punishment",
    pact = {
        showdown = true,
    },
    atlas = "BaliatroUp",

    set_ability = BALIATRO.pact_defs.common.set_ability,

    add_to_deck = function(self, card, from_debuff)
        G.GAME.pacts_cannot_appear = (G.GAME.pacts_cannot_appear or 0) + 1
    end,

    remove_from_deck = function(self, card, from_debuff)
        G.GAME.pacts_cannot_appear = (G.GAME.pacts_cannot_appear or 1) - 1
    end,
}

function BALIATRO.wrap_joker_fun(fun1, fun2)
    if fun1 and fun2 then
        return function(self, ...)
            local ret1 = fun1(self, ...)
            local ret2 = fun2(self, ...)
            if ret1 and ret2 and type(ret1) == 'table' and type(ret2) == 'table' then
                BALIATRO.recursive_merge(ret1, ret2)
            elseif ret2 then
                return ret2
            elseif ret1 then
                return ret1
            else
                return nil
            end
        end
    elseif fun2 then
        return fun2
    elseif fun1 then
        return fun1
    else
        return nil
    end
end

function BALIATRO.pact_joker(def)
    SMODS.Joker {
        name = "Unseen " .. def.name,
        key = "pact_unseen_" .. def.base,
        config = def.config,
        atlas = (def.unseen and def.unseen.atlas) or def.atlas or 'BaliatroUp',
        pos = (def.unseen and def.unseen.pos) or def.pos or {x = 0, y = 0},
        unlocked = true,
        blueprint_compat = false,
        eternal_compat = false,
        perishable_compat = false,
        rarity = "baliatro_pact",
        pact = {
            unseen = true,
        },

        set_ability = BALIATRO.pact_defs.common.set_ability,
        loc_vars = def.unseen and def.unseen.loc_vars or def.loc_vars,
        calculate = def.unseen and def.unseen.calculate or def.calculate,

        add_to_deck = BALIATRO.wrap_joker_fun(def.add_to_deck, def.unseen and def.unseen.add_to_deck),
        remove_from_deck = BALIATRO.wrap_joker_fun(def.remove_from_deck, def.unseen and def.unseen.remove_from_deck),
        calc_dollar_bonus = BALIATRO.wrap_joker_fun(def.calc_dollar_bonus, def.unseen and def.unseen.calc_dollar_bonus),
    }

    local dangerous_config = {}
    BALIATRO.recursive_merge(dangerous_config, def.config)
    if def.dangerous and def.dangerous.config then
        BALIATRO.recursive_merge(dangerous_config, def.dangerous.config)
    end

    SMODS.Joker {
        name = "Dangerous " .. def.name,
        key = "pact_dangerous_" .. def.base,
        config = dangerous_config,
        atlas = (def.dangerous and def.dangerous.atlas) or def.atlas or 'BaliatroUp',
        pos = (def.dangerous and def.dangerous.pos) or def.pos or {x = 0, y = 0},
        unlocked = true,
        blueprint_compat = false,
        eternal_compat = false,
        perishable_compat = false,
        rarity = "baliatro_pact",
        pact = {
            showdown = true,
        },

        set_ability = BALIATRO.pact_defs.common.set_ability,
        loc_vars = def.dangerous and def.dangerous.loc_vars or def.loc_vars,
        calculate = def.dangerous and def.dangerous.calculate or def.calculate,

        add_to_deck = BALIATRO.wrap_joker_fun(def.add_to_deck, def.dangerous and def.dangerous.add_to_deck),
        remove_from_deck = BALIATRO.wrap_joker_fun(def.remove_from_deck, def.dangerous and def.dangerous.remove_from_deck),
        calc_dollar_bonus = BALIATRO.wrap_joker_fun(def.calc_dollar_bonus, def.dangerous and def.dangerous.calc_dollar_bonus),
    }

    local treacherous_config = {}
    BALIATRO.recursive_merge(treacherous_config, def.config)
    if def.treacherous and def.treacherous.config then
        BALIATRO.recursive_merge(treacherous_config, def.treacherous.config)
    end

    SMODS.Joker {
        name = "Treacherous " .. def.name,
        key = "pact_treacherous_" .. def.base,
        config = treacherous_config,
        atlas = (def.treacherous and def.treacherous.atlas) or def.atlas or 'BaliatroUp',
        pos = (def.treacherous and def.treacherous.pos) or def.pos or {x = 0, y = 0},
        unlocked = true,
        blueprint_compat = false,
        eternal_compat = false,
        perishable_compat = false,
        rarity = "baliatro_pact",
        pact = {
        },

        set_ability = BALIATRO.pact_defs.common.set_ability,
        loc_vars = def.treacherous and def.treacherous.loc_vars or def.loc_vars,
        calculate = def.treacherous and def.treacherous.calculate or def.calculate,

        add_to_deck = BALIATRO.wrap_joker_fun(def.add_to_deck, def.treacherous and def.treacherous.add_to_deck),
        remove_from_deck = BALIATRO.wrap_joker_fun(def.remove_from_deck, def.treacherous and def.treacherous.remove_from_deck),
        calc_dollar_bonus = BALIATRO.wrap_joker_fun(def.calc_dollar_bonus, def.treacherous and def.treacherous.calc_dollar_bonus),
    }
end

for k, def in pairs(BALIATRO.pact_defs) do
    if not def.skip then
        def.base = k
        BALIATRO.pact_joker(def)
    end
end

--
---- 6. Unseen Boon
---- Editionless cards in Standard packs sometimes gain Negative and Immortal.
--
---- 8. Unseen Power
---- Retrigger each adjacent Joker.
--
---- 14. Dangerous Boon
---- Editionless cards in Standard packs sometimes gain Negative and Immortal.

---- 16. Dangerous Power
---- Retrigger each adjacent Joker.
--
---- 22. Treacherous Boon
---- Editionless cards in Standard packs sometimes gain Negative and Immortal. Negative cards held in hand grant X0.25 Chips.
--
---- 24. Treacherous Power
-- Retrigger each Joker adjacent to a random Joker.
