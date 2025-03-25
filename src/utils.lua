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
        if v.ability.set == 'Joker' and BALIATRO.manipulable(v) and (not v.ability.eternal) and (not v.ability.baliatro_mortgage) then
            table.insert(eligible_destructible_jokers, v)
        end
    end
    return eligible_destructible_jokers
end

function BALIATRO.find_eternalable_jokers()
    local eligible_eternalable_jokers = {}
    for k, v in pairs(G.jokers.cards) do
        if v.ability.set == 'Joker' and BALIATRO.manipulable(v) and v.config.center.eternal_compat and (not v.ability.eternal) and (not v.ability.baliatro_mortgage) and (not v.ability.perishable) then
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
                if not booster.config.center.no_upgrade then
                    booster.ability.choose = booster.ability.choose - math.floor(old_cv1) + math.floor(sp.c_v1)
                    booster.ability.extra = booster.ability.extra - math.floor(old_cv2) + math.floor(sp.c_v2)
                end
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
    if args and (args.exclude_least_played or args.exclude_most_played) then
        for k, v in pairs(G.GAME.hands) do
            if v.visible then
                if most == -1 or v.played > most then most = v.played end
                if least == -1 or v.played < least then least = v.played end
                end
        end
    end
    local ret = {}
    for k, v in pairs(G.GAME.hands) do
        if v.visible and (v.played < most or not args or not args.exclude_most_played) and (v.played > least or not args or not args.exclude_least_played) and (not args or args.exclude_key ~= k) then
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
        if not BALIATRO.is_immortal(card) then
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
            if not new_center.eternal_compat and joker.ability.eternal then
                joker:set_eternal(false)
            end
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


function BALIATRO.least_scored_rank_scores()
    local ret = -1
    for k, v in pairs(G.GAME.ranks_scored) do
        if ret == -1 or v < ret then ret = v end
    end
    return ret
end

function BALIATRO.most_scored_rank_scores()
    local ret = -1
    for k, v in pairs(G.GAME.ranks_scored) do
        if ret == -1 or v > ret then ret = v end
    end
    return ret
end

function BALIATRO.least_played_hand_times()
    local ret = -1
    for k, v in pairs(G.GAME.hands) do
        if ret == -1 or v.played < ret then ret = v.played end
    end
    return ret
end

function BALIATRO.most_played_hand_times()
    local ret = -1
    for k, v in pairs(G.GAME.hands) do
        if ret == -1 or v.played > ret then ret = v.played end
    end
    return ret
end


function BALIATRO.guided_create_card(amt, set, card, pseudo)
    local created_amt = math.min(G.consumeables.config.card_limit - (#G.consumeables.cards + G.GAME.consumeable_buffer), amt)
    if created_amt > 0 then
        G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + created_amt
        G.E_MANAGER:add_event(Event({trigger = 'before', delay = 0.0, func = (function()
            for j = 1, created_amt do
                local card = create_card(set, G.consumeables, nil, nil, nil, nil, card, pseudo)
                card:add_to_deck()
                G.consumeables:emplace(card)
                G.GAME.consumeable_buffer = 0
            end
            return true
        end)}))
    end
end

function BALIATRO.rank_sum(context)
    local sum = 0
    for _, oc in ipairs(context.scoring_hand) do
        if not oc.debuff and not SMODS.has_no_rank(oc) then
            sum = sum + oc.base.nominal
        end
    end
    return sum
end

function BALIATRO.simple_neg_consumable(seed)
    local card_type = 'Planet'
    local colour = G.C.SECONDARY_SET.PLANET
    local plus_string = 'k_plus_planet'
    if pseudorandom(seed) < 0.2 then
        if pseudorandom(seed) < 0.1 then
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
        if pseudorandom(seed) < 0.5 then
            card_type = 'Planet'
            colour = G.C.SECONDARY_SET.PLANET
            plus_string = 'k_plus_planet'
        else
            card_type = 'Tarot'
            colour = G.C.SECONDARY_SET.TAROT
            plus_string = 'k_plus_tarot'
        end
    end
    return card_type, colour, plus_string
end

function BALIATRO.extra_create_card(amt, negative, card, plus_string, card_type, seed, edition)
    local created_amt = amt
    if not negative then
        created_amt = math.min(amt, G.consumeables.config.card_limit - (#G.consumeables.cards + G.GAME.consumeable_buffer))
        G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + created_amt
    end

    return {focus = card, message = localize(plus_string), func = function()
        G.E_MANAGER:add_event(Event({
            trigger = 'before',
            delay = 0.0,
            func = (function()
                for i = 1, created_amt do
                    local l_card = create_card(card_type,G.consumeables, nil, nil, nil, nil, nil, seed)
                    if edition then
                        l_card:set_edition(edition, true)
                    elseif negative then
                        l_card:set_edition({negative = true}, true)
                    end
                    l_card:add_to_deck()
                    G.consumeables:emplace(l_card)
                end
                G.GAME.consumeable_buffer = 0
                return true
            end)}))
    end}
end

function BALIATRO.collect_haunted()
    local ret = {}
    for i, card in ipairs(G.playing_cards) do
        if card.edition and card.edition.key == 'e_baliatro_haunted' then
            ret[#ret+1] = card
        end
    end
    return ret
end

function BALIATRO.collect_ethereal()
    local ret = {}
    for i, card in ipairs(G.playing_cards) do
        if card.edition and card.edition.key == 'e_baliatro_ethereal' then
            ret[#ret+1] = card
        end
    end
    return ret
end

function BALIATRO.collect_haunted_targets(amt)
    local candidates = {}
    for i, card in ipairs(G.playing_cards) do
        if not card.edition then
            candidates[#candidates+1] = card
        end
    end
    local ret = {}
    while #ret < amt and #candidates > 0 do
        local card, idx = pseudorandom_element(candidates, pseudoseed('haunted_t'))
        ret[#ret+1] = card
        table.remove(candidates, idx)
    end
    return ret
end

function BALIATRO.end_of_round()
    local ethereal = BALIATRO.collect_ethereal()
    for i, card in ipairs(ethereal) do
        card:remove_from_deck()
        card:start_dissolve(nil, true, nil, true)
    end

    for i, card in ipairs(G.consumeables.cards) do
        if card.edition and card.edition.key == 'e_baliatro_ephemeral' then
            card.edition.extra.ttl = card.edition.extra.ttl - 1
            if card.edition.extra.ttl <= 0 then
                card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('k_baliatro_expired_ex')})
                G.E_MANAGER:add_event(Event({trigger='after', delay=0.1, blockable=true, func=function()
                    card:remove_from_deck()
                    card:start_dissolve(nil, true, nil, true)
                    return true
                end}))
            else
                card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize{type='variable', key='a_remaining', vars={card.edition.extra.ttl}}})
            end
        end
    end

    for i, card in ipairs(G.playing_cards) do
        card.ability.played_this_round = nil
        card.ability.discarded_this_round = nil
    end

    G.GAME.audience_progress = (G.GAME.audience_progress or 0) + 1 / (G.GAME.audience_progress_per_round) + 0.001
end

function BALIATRO.calculate_goal_context(context)
    if not G.GAME.goal_trackers then return end
    for goal_key, goal_data in pairs(G.GAME.goal_trackers) do
        if not goal_data.config.is_completed and not goal_data.config.is_failed then
            local goal = BALIATRO.Goals[goal_key]
            goal:calculate(goal_data.config, context)
        end
    end
end

function BALIATRO.setting_blind()


    local haunted = BALIATRO.collect_haunted()
    if #haunted > 0 then
        local transfers = BALIATRO.collect_haunted_targets(#haunted)
        for i, card in ipairs(haunted) do
            card:set_edition('e_baliatro_ectoplasmic', true, true)
        end
        for i, card in ipairs(transfers) do
            card:set_edition('e_baliatro_haunted', true, true)
        end
    end

    if BALIATRO.feature_flags.loot then
        if G.GAME.round_resets.blind == G.P_BLINDS.bl_small then
            G.GAME.blind_idx = 1
        elseif G.GAME.round_resets.blind == G.P_BLINDS.bl_big then
            G.GAME.blind_idx = 2
        else
            G.GAME.blind_idx = 3
        end

        G.GAME.goal_trackers = {}
        for goal_key, goal_data in pairs(G.GAME.ante_goals[G.GAME.blind_idx]) do
            local goal = BALIATRO.Goals[goal_key]
            G.GAME.goal_trackers[goal_key] = goal_data
        end
        G.GAME.blind_goals_dirty = true
    end
end

function BALIATRO.collect_hand_unhighlighted()
    local ret = {}
    for i, hand_card in ipairs(G.hand.cards) do
        local skip = false
        for j, highlight_card in ipairs(G.hand.highlighted) do
            if hand_card == highlight_card then skip = true; break; end
        end
        if not skip then ret[#ret+1] = hand_card end
    end
    return ret
end

function BALIATRO.is_immortal(card)
    return card.ability.baliatro_immortal or (card.edition and card.edition.is_immortal)
end

function BALIATRO.is_plain(card)
    return card.debuff or (card.ability.set ~= 'Enhanced' and not card.seal and not card.edition)
end

function BALIATRO.is_saturated(card)
    return not card.debuff and card.ability.set == 'Enhanced' and card.seal and card.edition
end

function BALIATRO.skeleton_card(card)
    local ret = {
        T = card.T,
        ability = card.ability,
        base = card.base,
        config = {
            center = card.config.center.key,
            card = card.config.card,
            card_key = card.config.card_key,
        },
        debuff = card.debuff,
        params = card.params,
        pinned = card.pinned,
        seal = card.seal,
        edition = nil
    }
    if card.edition then
        local ed_key = card.edition.key:sub(3)
        ret.edition = {[ed_key] = true}
    end
    return ret
end

function BALIATRO.ethereal_copy(card, discarding, destination)
    if not destination then destination = G.hand end
    local _card = copy_card(card, nil, nil, G.playing_card)
    _card:set_edition('e_baliatro_ethereal')
    if discarding then
        _card.edition.created_on_discard = G.GAME.current_round.discards_used
    end
    _card:add_to_deck()
    G.deck.config.card_limit = G.deck.config.card_limit + 1
    table.insert(G.playing_cards, _card)
    destination:emplace(_card)
    _card.states.visible = nil

    G.E_MANAGER:add_event(Event({
        func = function()
            _card:start_materialize()
            return true
        end
    }))

    return _card
end

function CardArea:flip_all_face_up()
    for i, card in ipairs(self.cards) do
        if card.facing == 'back' then
            card:flip()
            card.ability.wheel_flipped = nil
        end

    end
end

function BALIATRO.flip_all_face_up()
    G.hand:flip_all_face_up()
    for i, card in ipairs(G.playing_cards) do
        card.ability.wheel_flipped = nil
    end
end

function BALIATRO.manipulable(joker)
    return joker.config.center.rarity ~= 'baliatro_pact' and (not joker.edition or joker.edition.key ~= 'e_baliatro_pact')
end

---BALIATRO.suit_debuff = function(self, card, from_blind)
---    local suit = self.debuff.suit
---    if not suit then return false end
---    if SMODS.has_any_suit(card) then
---        for k, joker in ipairs(G.jokers.cards) do
---            if not joker.debuff and joker.ability.extra and type(joker.ability.extra) == 'table' and joker.ability.extra.protect_wild then
---                return false
---            end
---        end
---    end
---    if card:is_suit(suit, true) then return true end
---    return false
---end

BALIATRO.Images = {}

BALIATRO.Image = SMODS.GameObject:extend {
    obj_table = BALIATRO.Images,
    obj_buffer = {},
    required_params = {
        'key',
        'path',
    },
    set = 'Image',

    register = function(self)
        if self.registered then
            sendWarnMessage(('Detected duplicate register call on object %s'):format(self.key), self.set)
            return
        end
        self.name = self.key
        BALIATRO.Image.super.register(self)
    end,

    inject = function(self)
        local file_path = self.path
        self.full_path = (self.mod and self.mod.path or SMODS.path) ..
            'assets/images/' .. file_path
        local file_data = assert(NFS.newFileData(self.full_path),
            ('Failed to collect file data for Image %s'):format(self.key))
        self.image_data = assert(love.image.newImageData(file_data),
            ('Failed to initialize image data for Image %s'):format(self.key))
        self.image = love.graphics.newImage(self.image_data,
            { mipmaps = true, dpiscale = G.SETTINGS.GRAPHICS.texture_scaling })
        local mipmap_level = SMODS.config.graphics_mipmap_level_options[SMODS.config.graphics_mipmap_level]
        if not self.disable_mipmap and mipmap_level and mipmap_level > 0 then
            self.image:setMipmapFilter('linear', mipmap_level)
        end
    end,
}

function BALIATRO.recursive_merge(target, source)
    for k, v in pairs(source) do
        if type(v) == 'table' then
            if not target[k] or type(target[k]) ~= 'table' then
                target[k] = {}
            end
            BALIATRO.recursive_merge(target[k], v)
        else
            target[k] = v
        end
    end
end

function BALIATRO.generate_ban_set(set, t)
    local myset = {}
    if G.GAME and G.GAME.banned_keys then
        for key, _ in pairs(G.GAME.banned_keys) do
            local center = G.P_CENTERS[key]
            if center and center.set and center.set == set then
                myset[#myset+1] = key
            end
        end
    end

    local per_row = 1
    local scale = 0.3

    if #myset >= 21 then
        per_row = 6
        scale = 0.20
    elseif #myset >= 17 then
        per_row = 5
        scale = 0.22
    elseif #myset >= 13 then
        per_row = 4
        scale = 0.22
    elseif #myset >= 9 then
        per_row = 3
        scale = 0.25
    elseif #myset >= 5 then
        per_row = 2
        scale = 0.28
    end

    if #myset > 0 then
        local rcount = 0
        local row = {}
        for _, key in ipairs(myset) do
            local center_name = localize{type='name_text', set=set, key=key}
            if rcount > 0 then
                row[#row+1] = {n=G.UIT.T, config={text=', ', scale=scale, colour=G.C.UI.TEXT_DARK}}
            end
            row[#row+1] = {n=G.UIT.T, config={text=center_name, scale=scale, colour=G.C.IMPORTANT}}
            rcount = rcount + 1
            if per_row <= rcount then
                t[#t+1] = row
                row = {}
                rcount = 0
            end
        end
        if rcount > 0 then
            t[#t+1] = row
        end
    else
        t[#t+1] = {
            {n=G.UIT.T, config={text=localize('k_baliatro_no_banned_cards_ex'), scale=scale, colour=G.C.PALE_GREEN}}
        }
    end
end

function BALIATRO.flip_set_ability(other_card, ability, affector)
    G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.15, func = function()
        other_card:flip()
        play_sound('card1', 1)
        if affector then
            affector:juice_up(0.3, 0.3)
        end
        return true
    end }))
    G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.25, func = function()
        other_card:set_ability(ability)
        other_card:flip()
        play_sound('tarot2', 1, 0.6)
        return true
    end }))
end

function BALIATRO.calculate_card_upgrade(context, card)
    local wof = false
    local upg = false
    local center = card.config.center

    for _, joker in ipairs(G.jokers.cards) do
        local ev = eval_card(joker, context)
        if ev and ev.jokers then
            if ev.jokers.make_bad then wof = true end
            if ev.jokers.upgrade then upg = true end
        end
    end
    if wof then
        card:set_ability(G.P_CENTERS['c_wheel_of_fortune'])
        card.ability.eternal = nil
        card.ability.perishable = nil
        card.ability.rental = nil
        for k, v in ipairs(SMODS.Sticker.obj_buffer) do
            local sticker = SMODS.Stickers[v]
            if sticker.should_apply and type(sticker.should_apply) == 'function' and not sticker:should_apply(card, center, card.area) then
                sticker:apply(card, false)
            end
        end
        card:set_edition(nil)
    elseif upg and center.set == 'Joker' and center.upgrades_to then
        card:set_ability(G.P_CENTERS[center.upgrades_to])
    end
end

function BALIATRO.nrandom_elements(t, n, seed)
    local _t = {}
    local tc = 0
    for k, v in pairs(t) do _t[k] = v; tc = tc + 1 end
    local ret = {}
    repeat
        local iseed = pseudoseed(seed)
        local _v, _k = pseudorandom_element(_t, iseed)
        if _v then
            ret[#ret+1] = {_v, _k}
            _t[_k] = nil
            tc = tc + 1
        end
    until not _v or #ret >= n or tc <= 0
    return ret
end
return {
    name = "Baliatro Utils",
}
