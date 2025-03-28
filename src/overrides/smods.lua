table.insert(SMODS.calculation_keys, "baliatro_transfer")
table.insert(SMODS.calculation_keys, "baliatro_chips_as_mult")

local scie = SMODS.calculate_individual_effect
SMODS.calculate_individual_effect = function(effect, scored_card, key, amount, from_edition)
    local ret = scie(effect, scored_card, key, amount, from_edition)

    if ret then return ret end

    if key == 'baliatro_transfer' then
        if mult > 1 then
            local t = math.min(amount, mult - 1)
            hand_chips = mod_chips(hand_chips + t)
            mult = mod_mult(mult - t)
            update_hand_text({delay = 0}, {chips = hand_chips, mult = mult})
            card_eval_status_text(scored_card, 'extra', nil, percent, nil, {
                message = localize{type="variable", key="a_baliatro_transfer", vars={t}},
                colour = G.C.CHIPS,
            })
        else
            card_eval_status_text(scored_card, 'extra', nil, percent, nil, {
                message = localize('baliatro_cannot_transfer'),
                colour = G.C.CHIPS,
            })
        end
        return true
    elseif key == 'baliatro_chips_as_mult' then
        local t = math.floor(hand_chips * amount)
        print('chips: ', hand_chips, 't: ', t)
        if t > 0 then
            mult = mod_mult(mult + t)
            update_hand_text({delay = 0}, {chips = hand_chips, mult = mult})
            card_eval_status_text(scored_card, 'mult', t, percent)
        end
        return true
    end
end

local shas = SMODS.has_any_suit

SMODS.has_any_suit = function (card)
    local any_suit = shas(card)
    if any_suit then return any_suit end
    for _, joker in ipairs(G.jokers.cards) do
        local center = joker.config.center
        if joker.ability.extra and type(joker.ability.extra) == 'table' and center.card_has_any_suit and type(center.card_has_any_suit) == 'function' and center:card_has_any_suit(joker, card) then
            return true
        end
    end
    return false
end

BALIATRO.booster_pack_locvars = function(self, info_queue, card)
    local cfg = (card and card.ability) or self.config
    local ret = {
        vars = { cfg.choose, cfg.extra },
        key = self.key:sub(1, -3),
    }
    --local callisto = G.GAME.spec_planets["baliatro_booster_pack_choices"]
    --ret.vars[1] = ret.vars[1] + math.floor(callisto.c_v1)
    --ret.vars[2] = ret.vars[2] + math.floor(callisto.c_v2)
    return ret
end

BALIATRO.booster_pack_set_ability = function(self, card, initial, delay_sprites)
    local callisto = G.GAME.spec_planets["baliatro_booster_pack_choices"]
    if not self.no_upgrade then
        card.ability.extra = card.ability.extra + math.floor(callisto.c_v2)
        card.ability.choose = card.ability.choose + math.floor(callisto.c_v1)
    end
end

SMODS.Booster.set_ability = BALIATRO.booster_pack_set_ability

SMODS.Booster:take_ownership_by_kind('Standard', {
    create_card = function(self, card, i)
        local _edition = poll_edition('standard_edition'..G.GAME.round_resets.ante, 3, true)
        local _seal = SMODS.poll_seal({mod = 10})
        return {set = (pseudorandom(pseudoseed('stdset'..G.GAME.round_resets.ante)) > 0.6) and "Enhanced" or "Base", edition = _edition, seal = _seal, area = G.pack_cards, skip_materialize = true, soulable = true, key_append = "sta"}
    end,

    loc_vars = BALIATRO.booster_pack_locvars,
    set_ability = BALIATRO.booster_pack_set_ability,
    create_UIBox = SMODS.Booster.create_UIBox,
}, true)

SMODS.Booster:take_ownership_by_kind('Arcana', {
    loc_vars = BALIATRO.booster_pack_locvars,
    set_ability = BALIATRO.booster_pack_set_ability,
    create_UIBox = SMODS.Booster.create_UIBox,
}, true)

SMODS.Booster:take_ownership_by_kind('Celestial', {
    loc_vars = BALIATRO.booster_pack_locvars,
    set_ability = BALIATRO.booster_pack_set_ability,
    create_UIBox = SMODS.Booster.create_UIBox,
}, true)

SMODS.Booster:take_ownership_by_kind('Buffoon', {
    loc_vars = BALIATRO.booster_pack_locvars,
    set_ability = BALIATRO.booster_pack_set_ability,
    create_UIBox = SMODS.Booster.create_UIBox,
}, true)

SMODS.Booster:take_ownership_by_kind('Spectral', {
    loc_vars = BALIATRO.booster_pack_locvars,
    set_ability = BALIATRO.booster_pack_set_ability,
    create_UIBox = SMODS.Booster.create_UIBox,
}, true)

SMODS.Rarity:take_ownership('Common', {
    pools = {
        ["Joker"] = true,
        ["Postcard"] = true,
    },
})

SMODS.Rarity:take_ownership('Uncommon', {
    pools = {
        ["Joker"] = true,
        ["Postcard"] = true,
    },
})

SMODS.Rarity:take_ownership('Rare', {
    pools = {
        ["Joker"] = true,
        ["Postcard"] = true,
    },
})

SMODS.Rarity:take_ownership('Legendary', {
    pools = {
        ["Joker"] = true,
        ["Postcard"] = true,
    },
})

--local sbcu = SMODS.Booster.create_UIBox
--SMODS.Booster.update_pack = function(self)
--
--end

local scc = SMODS.calculate_context
SMODS.calculate_context = function(context, return_table)
    local ret = scc(context, return_table)
    if context.setting_blind then
        BALIATRO.setting_blind()
    end
    if context.pre_discard then
        local b = G.GAME.blind
        if b then
            b:pre_discard(context)
        end
    end
    if context.discard and context.other_card then
        context.other_card.ability.discarded_this_ante = true
        G.E_MANAGER:add_event(Event({
            trigger = 'immediate',
            func = function() G.GAME.blind:debuff_card(context.other_card); return true end
        }))
    end
    if context.end_of_round then
        BALIATRO.end_of_round()
    end
    if context.after then
        local b = G.GAME.blind
        if b then
            b:after_play(context)
        end
    end

    if BALIATRO.feature_flags.loot then
        BALIATRO.calculate_goal_context(context)
    end

    return ret
end

local scms = SMODS.calculate_main_scoring

SMODS.calculate_main_scoring = function(context, scoring_hand)
    local ret = scms(context, scoring_hand)
    if context.cardarea == G.play then
        for _, card in ipairs(scoring_hand or context.cardarea.cards) do
            card.ability.played_this_round = true
        end
    end
    return ret
end

SMODS.has_no_suit = function(card)
    local has_no_suit = false
    local has_any_suit = SMODS.has_any_suit(card)
    card.extra_enhancements = nil
    for k, _ in pairs(SMODS.get_enhancements(card)) do
        if k == 'm_stone' or G.P_CENTERS[k].no_suit then has_no_suit = true end
    end
    return has_no_suit and not has_any_suit
end

local sas = SMODS.always_scores
SMODS.always_scores = function(card)
    local ret = sas(card)
    for i, joker in ipairs(G.jokers.cards) do
        if not joker.debuff and joker.config.center.always_score_card and type(joker.config.center.always_score_card) == 'function' then
            ret = ret or joker.config.center:always_score_card(joker, card)
        end
    end
    return ret
end

SMODS.optional_features.cardareas.unscored = true

SMODS.DrawStep:take_ownership('card_type_shader', {
    func = function(self)
        if not self.config.center.no_shine then
            if (self.ability.set == 'Voucher' or self.config.center.demo) and (self.ability.name ~= 'Antimatter' or not (self.config.center.discovered or self.bypass_discovery_center)) then
                if self:should_draw_base_shader() then
                    self.children.center:draw_shader('voucher', nil, self.ARGS.send_to_shader)
                end
            end
            if (self.ability.set == 'Booster' or self.ability.set == 'Spectral') and self:should_draw_base_shader() then
                self.children.center:draw_shader('booster', nil, self.ARGS.send_to_shader)
            end
        end
    end,
}, true)

return {
    name = 'Baliatro SMODS Overrides'
}
