SMODS.Blind.default_get_loc_debuff_text = function(self)
    local loc_target = localize{type='raw_descriptions', set='Blind', key=self.key, vars = {}}
    local ret = ''
    if loc_target then
        for k, v in ipairs(loc_target) do
            ret = ret..v..(k <= #loc_target and ' ' or '')
        end
    end
    return ret
end

SMODS.Blind.get_loc_debuff_text = SMODS.Blind.default_get_loc_debuff_text

SMODS.Blind:take_ownership('bl_hook', {
    press_play = function(self)
        G.E_MANAGER:add_event(Event({ func = function()
            local any_selected = nil
            local _cards = {}
            for k, v in ipairs(G.hand.cards) do
                _cards[#_cards+1] = v
            end
            for i = 1, 2 do
                if G.hand.cards[i] then
                    local selected_card, card_key = pseudorandom_element(_cards, pseudoseed('hook'))
                    G.hand:add_to_highlighted(selected_card, true)
                    table.remove(_cards, card_key)
                    any_selected = true
                    play_sound('card1', 1)
                end
            end
            if any_selected then G.FUNCS.discard_cards_from_highlighted(nil, true) end
        return true end }))
        G.GAME.blind.triggered = true
        delay(0.7)
        return true
    end
}, true)

SMODS.Blind:take_ownership('bl_ox', {
    loc_vars = function(self)
        return {vars = {localize(G.GAME.current_round.most_played_poker_hand, 'poker_hands')}}
    end,

    debuff_hand = function(self, cards, hand, handname, check)
        G.GAME.blind.triggered = false
        if handname == G.GAME.current_round.most_played_poker_hand then
            G.GAME.blind.triggered = true
            if not check then
                ease_dollars(-G.GAME.dollars, true)
                G.GAME.blind:wiggle()
            end
        end
    end
}, true)

SMODS.Blind:take_ownership('bl_house', {
    disable = function(self)
        BALIATRO.flip_all_face_up()
    end,

    stay_flipped = function(self, area, card)
        return area == G.hand and G.GAME.current_round.hands_played == 0 and G.GAME.current_round.discards_used == 0
    end
}, true)

SMODS.Blind:take_ownership('bl_wall', {
    disable = function(self)
        G.GAME.blind.chips = G.GAME.blind.chips / 2
        G.GAME.blind.chip_text = number_format(G.GAME.blind.chips)
    end,
}, true)

SMODS.Blind:take_ownership('bl_wheel', {
    config = {
        flip_odds = 7,
    },

    get_loc_debuff_text = function(self)
        return G.GAME.probabilities.normal .. self:default_get_loc_debuff_text()
    end,

    disable = function(self)
        BALIATRO.flip_all_face_up()
    end,

    stay_flipped = function(self, area, card)
        return area == G.hand and pseudorandom(pseudoseed('wheel')) < G.GAME.probabilities.normal / self.config.flip_odds
    end
}, true)

SMODS.Blind:take_ownership('bl_arm', {
    debuff_hand = function(self, cards, hand, handname, check)
        G.GAME.blind.triggered = false
        if G.GAME.hands[handname].level > 1 then
            G.GAME.blind.triggered = true
            if not check then
                level_up_hand(G.GAME.blind.children.animatedSprite, handname, nil, -1)
                G.GAME.blind:wiggle()
            end
        end
    end
}, true)

SMODS.Blind:take_ownership('bl_fish', {
    set_blind = function(self)
        G.GAME.blind.bl_fish = {prepped = nil}
    end,

    disable = function(self)
        BALIATRO.flip_all_face_up()
    end,

    press_play = function(self)
        G.GAME.blind.bl_fish = {prepped = true}
    end,

    stay_flipped = function(self, area, card)
        return area == G.hand and G.GAME.blind.bl_fish and G.GAME.blind.bl_fish.prepped
    end,

    drawn_to_hand = function(self)
        G.GAME.blind.bl_fish = {prepped = nil}
    end
}, true)

SMODS.Blind:take_ownership('bl_water', {
    disable = function(self)
        ease_discard(G.GAME.blind.bl_water.discards_sub)
    end,

    set_blind = function(self)
        G.GAME.blind.bl_water = {discards_sub = G.GAME.current_round.discards_left}
        ease_discard(-G.GAME.blind.bl_water.discards_sub)
    end
}, true)

SMODS.Blind:take_ownership('bl_manacle', {
    config = {hand_size = 1},

    loc_vars = function(self)
        return {vars = {self.config.hand_size or 1} }
    end,

    collection_loc_vars = function(self)
        return {vars = {self.config.hand_size or 1} }
    end,

    set_blind = function(self)
        G.hand:change_size(-self.config.hand_size)
    end,

    defeat = function(self)
        G.hand:change_size(self.config.hand_size)
    end,

    disable = function(self)
        G.hand:change_size(self.config.hand_size)
    end,
}, true)

SMODS.Blind:take_ownership('bl_eye', {
    set_blind = function(self)
        local hands = {}
        for _, hand in pairs(SMODS.PokerHands) do
            hands[hand.key] = false
        end
        G.GAME.blind.bl_eye = {hands = hands}
    end,

    debuff_hand = function(self, cards, hand, handname, check)
        if G.GAME.blind.bl_eye.hands[handname] then
            G.GAME.blind.triggered = true
            return true
        end
    end,
}, true)

SMODS.Blind:take_ownership('bl_mouth', {
    set_blind = function(self)
        G.GAME.blind.bl_mouth = {only_hand = false}
    end,

    get_loc_debuff_text = function(self)
        local ret = self:default_get_loc_debuff_text()
        if G.GAME.blind.bl_mouth and G.GAME.blind.bl_mouth.only_hand then
            ret = ret ..' ['..localize(G.GAME.blind.bl_mouth.only_hand, 'poker_hands')..']'
        end
        return ret
    end,

    debuff_hand = function(self, cards, hand, handname, check)
        if G.GAME.blind.bl_mouth and G.GAME.blind.bl_mouth.only_hand and G.GAME.blind.bl_mouth.only_hand ~= handname then
            G.GAME.blind.triggered = true
            return true
        end
        if not check then G.GAME.blind.bl_mouth = {only_hand = handname} end
    end
}, true)


SMODS.Blind:take_ownership('bl_pillar', {
    recalc_debuff = function(self, card, from_blind)
        return card.area ~= G.jokers and card.ability.played_this_ante
    end
}, true)

SMODS.Blind:take_ownership('bl_needle', {
    set_blind = function(self)
        G.GAME.blind.bl_needle = {hands_sub = G.GAME.round_resets.hands - 1}
        ease_hands_played(-G.GAME.blind.bl_needle.hands_sub)
    end,

    disable = function(self)
        ease_hands_played(G.GAME.blind.bl_needle.hands_sub)
    end
}, true)

SMODS.Blind:take_ownership('bl_tooth', {
    press_play = function(self)
        G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.2, func = function()
            for i = 1, #G.play.cards do
                G.E_MANAGER:add_event(Event({func = function() G.play.cards[i]:juice_up(); return true end }))
                ease_dollars(-1)
                delay(0.23)
            end
            return true
        end }))
        G.GAME.blind.triggered = true
        return true
    end
}, true)

SMODS.Blind:take_ownership('bl_flint', {
    modify_hand = function(self, cards, poker_hands, text, mult, hand_chips)
        G.GAME.blind.triggered = true
        return math.max(math.floor(mult*0.5 + 0.5), 1), math.max(math.floor(hand_chips*0.5 + 0.5), 0), true
    end
}, true)

SMODS.Blind:take_ownership('bl_mark', {
    disable = function(self)
        BALIATRO.flip_all_face_up()
    end,

    stay_flipped = function(self, area, card)
        return area == G.hand and card:is_face(true)
    end
}, true)

SMODS.Blind:take_ownership('bl_plant', {}, true)
SMODS.Blind:take_ownership('bl_psychic', {}, true)
SMODS.Blind:take_ownership('bl_window', {}, true)
SMODS.Blind:take_ownership('bl_goad', {}, true)
SMODS.Blind:take_ownership('bl_club', {}, true)
SMODS.Blind:take_ownership('bl_head', {}, true)

SMODS.Blind:take_ownership('bl_final_acorn', {
    disable = function(self)
        G.jokers:flip_all_face_up()
    end,

    set_blind = function(self)
        if #G.jokers.cards > 0 then
            G.jokers:unhighlight_all()
            for k, v in ipairs(G.jokers.cards) do
                v:flip()
            end
            if #G.jokers.cards > 1 then
                G.E_MANAGER:add_event(Event({ trigger = 'after', delay = 0.2, func = function()
                    G.E_MANAGER:add_event(Event({ func = function() G.jokers:shuffle('aajk'); play_sound('cardSlide1', 0.85);return true end }))
                    delay(0.15)
                    G.E_MANAGER:add_event(Event({ func = function() G.jokers:shuffle('aajk'); play_sound('cardSlide1', 1.15);return true end }))
                    delay(0.15)
                    G.E_MANAGER:add_event(Event({ func = function() G.jokers:shuffle('aajk'); play_sound('cardSlide1', 1);return true end }))
                    delay(0.5)
                return true end }))
            end
        end
    end,
}, true)

SMODS.Blind:take_ownership('bl_final_leaf', {
    set_blind = function(self)
        G.GAME.blind.bl_final_leaf = {debuffing = true}
    end,

    disable = function(self)
        G.GAME.blind.bl_final_leaf = {debuffing = false}
    end,

    joker_sold = function(self, card)
        G.E_MANAGER:add_event(Event({trigger = 'immediate',func = function()
            G.GAME.blind.bl_final_leaf.debuffing = false
            for _, card in ipairs(G.playing_cards) do
                G.GAME.blind:debuff_card(card, true)
            end
            return true
        end}))
    end,

    recalc_debuff = function(self, card, from_blind)
        return card.area ~= G.jokers and G.GAME.blind.bl_final_leaf.debuffing
    end
})

SMODS.Blind:take_ownership('bl_final_vessel', {
    disable = function(self)
        G.GAME.blind.chips = G.GAME.blind.chips / 3
        G.GAME.blind.chip_text = number_format(G.GAME.blind.chips)
    end,
}, true)

SMODS.Blind:take_ownership('bl_final_heart', {
    set_blind = function(self)
        G.GAME.blind.bl_final_heart = {prepped = nil}
    end,

    defeat = function(self)
        for _, v in ipairs(G.jokers.cards) do
            v.ability.crimson_heart_chosen = nil
        end
    end,

    disable = function(self)
        for _, v in ipairs(G.jokers.cards) do
            v.ability.crimson_heart_chosen = nil
        end
    end,

    press_play = function(self)
        if G.jokers.cards[1] then
            G.GAME.blind.triggered = true
            G.GAME.blind.bl_final_heart = {prepped = true}
        end
    end,

    recalc_debuff = function(self, card, from_blind)
        return card.area == G.jokers and card.ability.crimson_heart_chosen
    end,

    drawn_to_hand = function(self)
        if G.GAME.blind.bl_final_heart.prepped and #G.jokers.cards > 0 then
            local prev_chosen_set = {}
            local fallback_jokers = {}
            local jokers = {}
            for i = 1, #G.jokers.cards do
                if G.jokers.cards[i].ability.crimson_heart_chosen then
                    prev_chosen_set[G.jokers.cards[i]] = true
                    G.jokers.cards[i].ability.crimson_heart_chosen = nil
                    if G.jokers.cards[i].debuff then SMODS.recalc_debuff(G.jokers.cards[i]) end
                end
            end
            for i = 1, #G.jokers.cards do
                if not G.jokers.cards[i].debuff and BALIATRO.manipulable(G.jokers.cards[i]) then
                    if not prev_chosen_set[G.jokers.cards[i]] then
                        jokers[#jokers+1] = G.jokers.cards[i]
                    end
                    table.insert(fallback_jokers, G.jokers.cards[i])
                end
            end
            if #jokers == 0 then jokers = fallback_jokers end
            if #jokers == 0 then G.GAME.blind.bl_final_heart.prepped = false; return end
            local _card = pseudorandom_element(jokers, pseudoseed('crimson_heart'))
            if _card then
                _card.ability.crimson_heart_chosen = true
                SMODS.recalc_debuff(_card)
                _card:juice_up()
                G.GAME.blind:wiggle()
            end
        end
        G.GAME.blind.bl_final_heart.prepped = false
    end
}, true)

SMODS.Blind:take_ownership('bl_final_bell', {
    disable = function(self)
        for k, v in ipairs(G.playing_cards) do
            v.ability.forced_selection = nil
        end
    end,

    drawn_to_hand = function(self)
        local any_forced = nil
        for k, v in ipairs(G.hand.cards) do
            if v.ability.forced_selection then
                any_forced = true
            end
        end
        if not any_forced then
            G.hand:unhighlight_all()
            local forced_card = pseudorandom_element(G.hand.cards, pseudoseed('cerulean_bell'))
            forced_card.ability.forced_selection = true
            G.hand:add_to_highlighted(forced_card)
        end
    end
}, true)


local bsb = Blind.set_blind

Blind.set_blind = function(self, blind, reset, silent)
    bsb(self, blind, reset, silent)
    if not G.GAME.blind.in_blind then return end
    for _, pact in ipairs(G.GAME.baliatro_pacts or {}) do
        if not pact.disabled then
            local c_blind = pact.blind
            local p_blind = G.P_BLINDS[c_blind]
            if p_blind then
                if not reset then
                    G.GAME.blind.mult = G.GAME.blind.mult * p_blind.mult
                    if p_blind.set_blind and type(p_blind.set_blind) == 'function' then
                        p_blind:set_blind()
                    end
                    if p_blind.recalc_debuff and type(p_blind.recalc_debuff) == 'function' then
                        for _, card in ipairs(G.jokers.cards) do
                            if not card.debuff then
                                if p_blind:recalc_debuff(card, false) then
                                    card:set_debuff(true)
                                end
                            end
                        end
                    elseif p_blind.debuff_card and type(p_blind.debuff_card) == 'function' then
                        for _, card in ipairs(G.jokers.cards) do
                            if not card.debuff then
                                if p_blind:recalc_debuff(card, false) then
                                    card:set_debuff(true)
                                end
                            end
                        end
                    end
                end
                if p_blind.recalc_debuff and type(p_blind.recalc_debuff) == 'function' then
                    for _, card in ipairs(G.playing_cards) do
                        if not card.debuff then
                            if p_blind:recalc_debuff(card, false) then
                                card:set_debuff(true)
                            end
                        end
                    end
                elseif p_blind.debuff_card and type(p_blind.debuff_card) == 'function' then
                    for _, card in ipairs(G.playing_cards) do
                        if not card.debuff then
                            if p_blind:recalc_debuff(card, false) then
                                card:set_debuff(true)
                            end
                        end
                    end
                end
            end
        end
    end
end

function BALIATRO.pre_pact()
    BALIATRO.blind_trigger_before_pact = G.GAME.blind and G.GAME.blind.triggered
end

function BALIATRO.post_pact()
    G.GAME.blind.triggered = BALIATRO.blind_trigger_before_pact
end

local bdc = Blind.debuff_card

Blind.debuff_card = function(self, card, from_blind)
    if card.ability.cannot_be_debuffed then card:set_debuff(false); return end
    bdc(self, card, from_blind)
    if card.debuff then return end
    BALIATRO.pre_pact()
    local debuffed = false

    for _, pact in ipairs(G.GAME.baliatro_pacts or {}) do
        if not pact.disabled then
            local c_blind = pact.blind
            local p_blind = G.P_BLINDS[c_blind]
            if p_blind then
                if p_blind.recalc_debuff and type(p_blind.recalc_debuff) == 'function' then
                    debuffed = debuffed or p_blind:recalc_debuff(card, from_blind)
                elseif p_blind.debuff_card and type(p_blind.debuff_card) == 'function' then
                    sendWarnMessage(("Blind object %s has debuff_card function, recalc_debuff is preferred"):format(c_blind), p_blind.set)
                    debuffed = debuffed or p_blind:debuff_card(card, from_blind)
                end
                if card.area ~= G.jokers then
                    debuffed = debuffed or (p_blind.debuff.suit and card:is_suit(p_blind.debuff.suit, true))
                    debuffed = debuffed or (p_blind.debuff.is_face == 'face' and card:is_face(true))
                    debuffed = debuffed or (p_blind.debuff.value and p_blind.debuff.value == card.base.value)
                    debuffed = debuffed or (p_blind.debuff.nominal and p_blind.debuff.nominal == card.base.nominal)
                end
                if debuffed then break end
            end
        end
    end
    card:set_debuff(debuffed)
    if card.debuffed then card.debuffed_by_blind = false end
    BALIATRO.post_pact()
end


local bsf = Blind.stay_flipped

Blind.stay_flipped = function(self, area, card)
    local flipped = bsf(self, area, card)
    if not G.GAME.blind.in_blind or flipped then return flipped end
    BALIATRO.pre_pact()
    local debuffed = false

    for _, pact in ipairs(G.GAME.baliatro_pacts or {}) do
        if not pact.disabled then
            local c_blind = pact.blind
            local p_blind = G.P_BLINDS[c_blind]
            if p_blind then
                if p_blind.stay_flipped and type(p_blind.stay_flipped) == 'function' then
                    flipped = flipped or p_blind:stay_flipped(area, card)
                end
                if flipped then break end
            end
        end
    end
    BALIATRO.post_pact()
    return flipped
end


local bdh = Blind.debuff_hand

Blind.debuff_hand = function(self, cards, hand, handname, check)
    local debuffed = bdh(self, cards, hand, handname, check)
    if not G.GAME.blind.in_blind or debuffed then
        G.GAME.blind.loc_debuff_text = G.GAME.blind:get_loc_debuff_text()
        return debuffed
    end
    BALIATRO.pre_pact()

    for _, pact in ipairs(G.GAME.baliatro_pacts or {}) do
        if not pact.disabled then
            local c_blind = pact.blind
            local p_blind = G.P_BLINDS[c_blind]
            if p_blind then
                if p_blind.debuff then
                    debuffed = debuffed or (p_blind.debuff.hand and next(hand[p_blind.debuff.hand]))
                    debuffed = debuffed or (p_blind.debuff.h_size_ge and #cards < p_blind.debuff.h_size_ge)
                    debuffed = debuffed or (p_blind.debuff.h_size_le and #cards > p_blind.debuff.h_size_le)
                end
                if p_blind.debuff_hand and type(p_blind.debuff_hand) == 'function' then
                    debuffed = debuffed or p_blind:debuff_hand(cards, hand, handname, check)
                end
                if debuffed then
                    if p_blind.get_loc_debuff_text and type(p_blind.get_loc_debuff_text) == 'function' then
                        G.GAME.blind.loc_debuff_text = p_blind:get_loc_debuff_text()
                    end
                    break
                end
            end
        end
    end
    BALIATRO.post_pact()
    if not debuffed then
        G.GAME.blind.loc_debuff_text = G.GAME.blind:get_loc_debuff_text()
    end
    return debuffed
end

local bmh = Blind.modify_hand

Blind.modify_hand = function(self, cards, poker_hands, text, mult, hand_chips)
    local m, hc, modified = bmh(self, cards, poker_hands, text, mult, hand_chips)
    if not G.GAME.blind.in_blind then return m, hc, modified end
    if not modified then hc = hand_chips; m = mult end
    BALIATRO.pre_pact()

    for _, pact in ipairs(G.GAME.baliatro_pacts or {}) do
        if not pact.disabled then
            local c_blind = pact.blind
            local p_blind = G.P_BLINDS[c_blind]
            if p_blind then
                if p_blind.modify_hand and type(p_blind.modify_hand) == 'function' then
                    local tm, thc, tmod = p_blind:modify_hand(cards, poker_hands, text, m, hc)
                    if tmod then hc = thc; m = tm; modified = tmod end
                end
            end
        end
    end
    BALIATRO.post_pact()
    return m, hc, modified
end

local bpp = Blind.press_play

Blind.press_play = function(self)
    bpp(self)
    if not G.GAME.blind.in_blind then return end
    BALIATRO.pre_pact()

    for _, pact in ipairs(G.GAME.baliatro_pacts or {}) do
        if not pact.disabled then
            local c_blind = pact.blind
            local p_blind = G.P_BLINDS[c_blind]
            if p_blind then
                if p_blind.press_play and type(p_blind.press_play) == 'function' then
                    p_blind:press_play()
                end
            end
        end
    end
    BALIATRO.post_pact()
end

local bdth = Blind.drawn_to_hand

Blind.drawn_to_hand = function(self)
    bdth(self)
    if not G.GAME.blind.in_blind then return end
    BALIATRO.pre_pact()

    for _, pact in ipairs(G.GAME.baliatro_pacts or {}) do
        if not pact.disabled then
            local c_blind = pact.blind
            local p_blind = G.P_BLINDS[c_blind]
            if p_blind then
                if p_blind.drawn_to_hand and type(p_blind.drawn_to_hand) == 'function' then
                    p_blind:drawn_to_hand()
                end
            end
        end
    end
    BALIATRO.post_pact()
end

Blind.get_loc_debuff_text = function(self)
    return G.GAME.blind.loc_debuff_text
end

Blind.after_play = function(self, context)
    local obj = self.config.blind
    if obj and obj.after_play and type(obj.after_play) == 'function' then
        obj:after_play(context)
    end


    BALIATRO.pre_pact()
    for _, pact in ipairs(G.GAME.baliatro_pacts or {}) do
        if not pact.disabled then
            local c_blind = pact.blind
            local p_blind = G.P_BLINDS[c_blind]
            if p_blind then
                if p_blind.after_play and type(p_blind.after_play) == 'function' then
                    p_blind:after_play(context)
                end
            end
        end
    end
    BALIATRO.post_pact()
end

Blind.pre_discard = function(self, context)
    local obj = self.config.blind
    if obj and obj.pre_discard and type(obj.pre_discard) == 'function' then
        obj:pre_discard(context)
    end


    BALIATRO.pre_pact()
    for _, pact in ipairs(G.GAME.baliatro_pacts or {}) do
        if not pact.disabled then
            local c_blind = pact.blind
            local p_blind = G.P_BLINDS[c_blind]
            if p_blind then
                if p_blind.pre_discard and type(p_blind.pre_discard) == 'function' then
                    p_blind:pre_discard(context)
                end
            end
        end
    end
    BALIATRO.post_pact()
end

Blind.after_discard = function(self, cards)
    local obj = self.config.blind
    if obj and obj.after_discard and type(obj.after_discard) == 'function' then
        obj:after_discard(cards)
    end

    BALIATRO.pre_pact()
    for _, pact in ipairs(G.GAME.baliatro_pacts or {}) do
        if not pact.disabled then
            local c_blind = pact.blind
            local p_blind = G.P_BLINDS[c_blind]
            if p_blind then
                if p_blind.after_discard and type(p_blind.after_discard) == 'function' then
                    p_blind:after_discard(cards)
                end
            end
        end
    end
    BALIATRO.post_pact()
end

Blind.is_playing_to_deck = function(self)
    local obj = self.config.blind
    if obj and obj.play_to_deck then
        return true
    end

    for _, pact in ipairs(G.GAME.baliatro_pacts or {}) do
        if not pact.disabled then
            local c_blind = pact.blind
            local p_blind = G.P_BLINDS[c_blind]
            if p_blind and p_blind.play_to_deck then return true end
        end
    end
    return false
end

Blind.is_discarding_to_deck = function(self)
    local obj = self.config.blind
    if obj and obj.discard_to_deck then
        return true
    end

    for _, pact in ipairs(G.GAME.baliatro_pacts or {}) do
        if not pact.disabled then
            local c_blind = pact.blind
            local p_blind = G.P_BLINDS[c_blind]
            if p_blind and p_blind.discard_to_deck then return true end
        end
    end
    return false
end

return {
    name = 'Baliatro Blind Overrides'
}
