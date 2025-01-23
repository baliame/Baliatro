table.insert(SMODS.calculation_keys, "transfer")

local scie = SMODS.calculate_individual_effect
SMODS.calculate_individual_effect = function(effect, scored_card, key, amount, from_edition)
    local ret = scie(effect, scored_card, key, amount, from_edition)

    if ret then return ret end

    if key == 'transfer' then
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
    end
end

BALIATRO.any_suit_jokers = {}

function BALIATRO.add_any_suit_joker(joker)
    table.insert(BALIATRO.any_suit_jokers, joker)
end

function BALIATRO.remove_any_suit_joker(joker)
    local idx = nil
    for i, other in ipairs(BALIATRO.any_suit_jokers) do
        if other == joker then idx = i; break end
    end
    if idx then
        table.remove(BALIATRO.any_suit_jokers, idx)
    end
end

local shas = SMODS.has_any_suit

SMODS.has_any_suit = function (card)
    local any_suit = shas(card)
    if any_suit then return any_suit end
    for _, joker in ipairs(BALIATRO.any_suit_jokers) do
        if joker.config.center:card_has_any_suit(joker, card) then
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
    card.ability.extra = card.ability.extra + math.floor(callisto.c_v2)
    card.ability.choose = card.ability.choose + math.floor(callisto.c_v1)
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

return {
    name = 'Baliatro SMODS Overrides'
}