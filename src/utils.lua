function BALIATRO.find_editionless_jokers()
    local eligible_editionless_jokers = {}
    for k, v in pairs(G.jokers.cards) do
        if v.ability.set == 'Joker' and (not v.edition) then
            table.insert(eligible_editionless_jokers, v)
        end
    end
    return eligible_editionless_jokers
end

function BALIATRO.find_destructible_jokers()
    local eligible_destructible_jokers = {}
    for k, v in pairs(G.jokers.cards) do
        if v.ability.set == 'Joker' and (not v.ability.eternal) and (not v.ability.baliatro_mortgage) then
            table.insert(eligible_destructible_jokers, v)
        end
    end
    return eligible_destructible_jokers
end

function BALIATRO.find_eternalable_jokers()
    local eligible_eternalable_jokers = {}
    for k, v in pairs(G.jokers.cards) do
        if v.ability.set == 'Joker' and v.config.center.eternal_compat and (not v.ability.eternal) and (not v.ability.baliatro_mortgage) and (not v.ability.perishable) then
            table.insert(eligible_eternalable_jokers, v)
        end
    end
    return eligible_eternalable_jokers
end

function BALIATRO.create_moon(area, key_append)
    local area = area or G.consumeables
    local _clean_pool = {}
    for k, v in pairs(G.P_CENTERS) do
        if v.set == "Planet" and v.config.moon then
            table.insert(_clean_pool, v)
        end
    end
    local elem = pseudorandom_element(_clean_pool, pseudoseed('moon'))
    if elem then
        return create_card("Planet", area, nil, nil, nil, nil, elem.key, key_append)
    end
    return nil
end

function BALIATRO.use_special_planet(target, card, copier, amount, immediate)
    local used_consumable = copier or card
    local sp = G.GAME.spec_planets[target]
    if not immediate then
        update_hand_text({sound = 'button', volume = 0.7, pitch = 0.8, delay = 0.3}, {handname=localize(target),chips = sp.c_v1, mult = sp.c_v2, level=sp.level})
        G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.2, func = function()
            play_sound('tarot1')
            if used_consumable then
                used_consumable:juice_up(0.8, 0.5)
            end
            G.TAROT_INTERRUPT_PULSE = true
            return true
        end }))
        update_hand_text({delay = 0}, {mult = '+'..sp.v2, StatusText = true})
        G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.9, func = function()
            play_sound('tarot1')
            if used_consumable then
                used_consumable:juice_up(0.8, 0.5)
            end
            return true
        end }))
        update_hand_text({delay = 0}, {chips = '+'..sp.v1, StatusText = true})
        G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.9, func = function()
            play_sound('tarot1')
            if used_consumable then
                used_consumable:juice_up(0.8, 0.5)
            end
            G.TAROT_INTERRUPT_PULSE = nil
            return true
        end }))
    end
    local old_level = sp.level
    sp.level = math.max(1, sp.level + amount)
    local diff = sp.level - old_level
    local old_cv1 = sp.c_v1
    local old_cv2 = sp.c_v2
    sp.c_v1 = sp.c_v1 + sp.v1 * diff
    sp.c_v2 = sp.c_v2 + sp.v2 * diff
    if target == 'baliatro_booster_pack_choices' then
        if G.shop_booster and G.shop_booster.cards then
            for _, booster in ipairs(G.shop_booster.cards) do
                booster.ability.choose = booster.ability.choose - math.floor(old_cv1) + math.floor(sp.c_v1)
                booster.ability.extra = booster.ability.extra - math.floor(old_cv2) + math.floor(sp.c_v2)
            end
        end
    elseif target == 'baliatro_interest' then
        G.GAME.mortgage_rate = G.GAME.mortgage_rate + sp.v2 * diff
    end
    if not immediate then
        update_hand_text({sound = 'button', volume = 0.7, pitch = 0.9, delay = 0}, {chips=sp.c_v1, mult=sp.c_v2, level=sp.level})
        delay(1.3)
        update_hand_text({sound = 'button', volume = 0.7, pitch = 1.1, delay = 0}, {mult = 0, chips = 0, handname = '', level = ''})
    end
end

function BALIATRO.tprint(tbl, indent, max_depth)
    if not max_depth then max_depth = 1 end
    print(BALIATRO.tprint_i(tbl, indent, max_depth))
end

function BALIATRO.tprint_i (tbl, indent, max_depth)
    if not tbl then return '<nil>' end
    if max_depth <= 0 then return tostring(tbl) .. " <too deep>" end
    if not indent then indent = 0 end
    local toprint = string.rep(" ", indent) .. "{\r\n"
    indent = indent + 2
    for k, v in pairs(tbl) do
        toprint = toprint .. string.rep(" ", indent)
        if (type(k) == "number") then
            toprint = toprint .. "[" .. k .. "] = "
        elseif (type(k) == "string") then
            toprint = toprint  .. k ..  "= "
        end
        if (type(v) == "number") then
            toprint = toprint .. v .. ",\r\n"
        elseif (type(v) == "string") then
            toprint = toprint .. "\"" .. v .. "\",\r\n"
        elseif (type(v) == "table") then
            local ret = BALIATRO.tprint_i(v, indent + 2, max_depth - 1)
        if ret then
            toprint = toprint .. ret .. ",\r\n"
        else
            toprint = toprint .. '<nil?>,\r\n'
        end
        else
            toprint = toprint .. "\"" .. tostring(v) .. "\",\r\n"
        end
    end
    toprint = toprint .. string.rep(" ", indent-2) .. "}"
    return toprint
end

function BALIATRO.in_array(elem, arr)
    for i, v in ipairs(arr) do
        if elem == v then return true end
    end
    return false
end

function BALIATRO.unscored(context)
    local ret = {}
    for i, elem in ipairs(context.full_hand) do
        if not BALIATRO.in_array(elem, context.scoring_hand) then
            table.insert(ret, elem)
        end
    end
    return ret
end

BALIATRO.unscored_cardarea = {}
function BALIATRO.get_unscored_cardarea(context)
    local ret = {}
    for i, elem in ipairs(context.full_hand) do
        if not BALIATRO.in_array(elem, context.scoring_hand) then
            table.insert(ret, elem)
        end
    end
    BALIATRO.unscored_cardarea.cards = ret
    return BALIATRO.unscored_cardarea
end

function BALIATRO.clear_unscored_cardarea()
    BALIATRO.unscored_cardarea.cards = {}
end

function BALIATRO.collect_visible_hands()
    local ret = {}
    for k, v in pairs(G.GAME.hands) do
        if v.visible then table.insert(ret, k) end
    end
    return ret
end

function BALIATRO.filter_visible_hands(args)
    local most = -1
    local least = -1
    for k, v in pairs(G.GAME.hands) do
        if v.visible then
            if most == -1 or v.played > most then most = v.played end
            if least == -1 or v.played < least then least = v.played end
            end
    end
    local ret = {}
    for k, v in pairs(G.GAME.hands) do
        if v.visible and (v.played < most or (args and not args.exclude_most_played) or not args) and (v.played > least or (args and not args.exclude_least_played) or not args) then
            table.insert(ret, k)
        end
    end
    return ret
end


function BALIATRO.collect_perishables()
    local ret = {}
    for _, joker in ipairs(G.jokers.cards) do
        if joker.ability.perishable then table.insert(ret, joker) end
    end
    return ret
end

function BALIATRO.filter_immortal(cards)
    local ret = {}
    for _, card in ipairs(cards) do
        if not card.ability.baliatro_immortal then
            table.insert(ret, card)
        end
    end
    return ret
end

function BALIATRO.upgrade_joker(joker, apply_perish)
    local center = joker.config.center
    if center.upgrades_to then
        local new_center = G.P_CENTERS[center.upgrades_to]
        if not new_center then
            error(center.key .. ' upgrades to unknown joker ' .. center.upgrades_to)
        end
        G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.15, func = function()
            joker:flip()
            play_sound('card1', 1)
            joker:juice_up(0.3, 0.3)
            return true
        end }))
        G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.15, func = function()
            joker:set_ability(new_center)
            joker:clear_perishable()
            joker:set_debuff()
            if apply_perish then
                joker:set_perishable(true)
            end
            joker:flip()
            play_sound('tarot2', 1, 0.6)
            joker:juice_up(0.3, 0.3)
            return true
         end }))
    end
end

function BALIATRO.calculate_interest_amount(dollars)
    if dollars == nil then dollars = G.GAME.dollars end
    return math.floor(math.min(dollars + G.GAME.interest_basis_modifier, G.GAME.interest_cap) / (5 / (G.GAME.interest_amount)))
end

function BALIATRO.calculate_interest_maximum()
    return math.floor(G.GAME.interest_cap / (5 / (G.GAME.interest_amount)))
end

function BALIATRO.fc(card)
    if card.ability.set == "Default" or card.ability.set == "Base" or card.ability.set == "Enhanced" then
        return card.base.value .. ' of ' .. card.base.suit
    end
    return card.ability.name
end

function BALIATRO.reset_effigy_card()
    G.GAME.current_round.effigy_card.rank = 'Ace'
    G.GAME.current_round.effigy_card.id = 14
    local valid_effigy_cards = {}
    for k, v in ipairs(G.playing_cards) do
        if v.ability.effect ~= 'Stone Card' then
            if not SMODS.has_no_rank(v) then
                valid_effigy_cards[#valid_effigy_cards+1] = v
            end
        end
    end
    if valid_effigy_cards[1] then
        local effigy_card = pseudorandom_element(valid_effigy_cards, pseudoseed('effigy'..G.GAME.round_resets.ante))
        G.GAME.current_round.effigy_card.rank = effigy_card.base.value
        G.GAME.current_round.effigy_card.id = effigy_card.base.id
    end
end

function BALIATRO.reset_game_globals()
    BALIATRO.reset_effigy_card()
end

function BALIATRO.round(x)
    local sign = 1
    if x < 0 then
        sign = -1
        x = -x
    end
    local fract = x - math.floor(x)
    if fract < 0.5 then
        return sign * math.floor(x)
    else
        return sign * math.ceil(x)
    end
end

function BALIATRO.tally_edition(ed)
    local ret = 0
    for i, card in ipairs(G.playing_cards) do
        if card.edition and (card.edition[ed] or card.edition.key == ed) then ret = ret + 1 end
    end
    return ret
end


return {
    name = "Baliatro Utils",
}