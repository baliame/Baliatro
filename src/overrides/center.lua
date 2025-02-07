BALIATRO.JokerUpgrade = {
    ["j_joker"] = "j_baliatro_jimbo",
    ["j_greedy_joker"] = "j_baliatro_moissanite",
    ["j_lusty_joker"] = "j_bloodstone",
    ["j_wrathful_joker"] = "j_baliatro_obsidian",
    ["j_gluttenous_joker"] = "j_onyx_agate",
    ["j_jolly"] = "j_duo",
    ["j_zany"] = "j_trio",
    ["j_mad"] = "j_baliatro_swing",
    ["j_crazy"] = "j_order",
    ["j_droll"] = "j_tribe",
    ["j_sly"] = "j_duo",
    ["j_wily"] = "j_trio",
    ["j_clever"] = "j_baliatro_swing",
    ["j_devious"] = "j_order",
    ["j_crafty"] = "j_tribe",
    ["j_half"] = "j_baliatro_missing_half",
    ["j_credit_card"] = "j_baliatro_platinum_card",
    ["j_banner"] = "j_baliatro_crest",
    ["j_mystic_summit"] = "j_baliatro_glacier",
    ["j_8_ball"] = "j_baliatro_actually_magic_8_ball",
    ["j_raised_fist"] = "j_baliatro_union_joker",
    ["j_chaos"] = "j_baliatro_chaos_with_crown",
    ["j_scary_face"] = "j_sock_and_buskin",
    ["j_abstract"] = "j_baliatro_stencil_joker",
    ["j_delayed_grat"] = "j_to_the_moon",
    ["j_gros_michel"] = "j_cavendish",
    ["j_even_steven"] = "j_baliatro_multiple_of_two_lou",
    ["j_odd_todd"] = "j_baliatro_uneven_freeman",
    ["j_scholar"] = "j_baliatro_aceology_phd",
    ["j_business"] = "j_baliatro_bailout",
    ["j_supernova"] = "j_constellation",
    ["j_ride_the_bus"] = "j_baliatro_mind_the_gap",
    ["j_misprint"] = "j_baliatro_psinmitr",
    ["j_egg"] = "j_bootstraps",
    ["j_runner"] = "j_baliatro_marathon_runner",
    ["j_ice_cream"] = "j_stuntman",
    ["j_splash"] = "j_marble",
    ["j_blue_joker"] = "j_baliatro_indigo_joker",
    ["j_faceless_joker"] = "j_chicot",
    ["j_green_joker"] = "j_baliatro_turquoise_joker",
    ["j_superposition"] = "j_baliatro_actually_magic_8_ball",
    ["j_cavendish"] = "j_baliatro_goldfinger",
    ["j_red_card"] = "j_baliatro_black_card",
    ["j_square_joker"] = "j_baliatro_cube_joker",
    ["j_riff_raff"] = "j_baliatro_peanut_gallery",
    ["j_smiley"] = "j_idol",
    ["j_reserved_parking"] = "j_mime",
    ["j_hallucination"] = "j_baliatro_bad_trip",
    ["j_juggler"] = "j_troubadour",
    ["j_drunkard"] = "j_merry_andy",
    ["j_golden"] = "j_rocket",
    ["j_popcorn"] = "j_yorick",
    ["j_walkie_talkie"] = "j_invisible",
    ["j_photograph"] = "j_caino",
    ["j_ticket"] = "j_midas_mask",
    ["j_swashbuckler"] = "j_gift",
    ["j_hanging_chad"] = "j_baliatro_hanginger_chad",
    ["j_shoot_the_moon"] = "j_baron",
    ["j_fortune_teller"] = "j_baliatro_oracle",
}

BALIATRO.LocVars = {
    ["j_mime"] = function(self, info_queue, card)
        return { vars = { card.ability.extra } }
    end,
    ["j_dusk"] = function(self, info_queue, card)
        return { vars = { card.ability.extra } }
    end,
    ["j_sock_and_buskin"] = function(self, info_queue, card)
        return { vars = { card.ability.extra } }
    end
}
BALIATRO.NewYorkIncompatible = {
    ["j_joker_stencil"] = true,
    ["j_four_fingers"] = true,
    ["j_credit_card"] = true,
    ["j_chaos_the_clown"] = true,
    ["j_pareidolia"] = true,
    ["j_dna"] = true,
    ["j_splash"] = true,
    ["j_sixth_sense"] = true,
    ["j_diet_cola"] = true,
    ["j_midas_mask"] = true,
    ["j_luchador"] = true,
    ["j_mr_bones"] = true,
    ["j_certificate"] = true,
    ["j_smeared_joker"] = true,
    ["j_showman"] = true,
    ["j_blueprint"] = true,
    ["j_brainstorm"] = true,
    ["j_oops"] = true,
    ["j_invisible_joker"] = true,
    ["j_cartomancer"] = true,
    ["j_astronomer"] = true,
    ["j_burnt"] = true,
    ["j_chicot"] = true,
    ["j_perkeo"] = true,
    ["j_superposition"] = true,
}

BALIATRO.NewYorkDivideExtraFields = {
    ["j_loyalty_card"] = {"every"},
    ["j_gros_michel"] = {"odds"},
    ["j_cavendish"] = {"odds"},
    ["j_bloodstone"] = {"odds"},
}
BALIATRO.NewYorkIgnoreExtraFields = {
    ["j_faceless_joker"] = {"faces"}
}
BALIATRO.NewYorkDivideExtraNumber = {
    ["j_8_ball"] = true,
    ["j_business_card"] = true,
    ["j_hallucination"] = true,
    ["j_space_joker"] = true,
}
BALIATRO.NewYorkOneMinusMultiplyExtraFields = {}

for key, center in pairs(G.P_CENTERS) do
    if center.set == "Joker" then
        if not center.new_york then
            center.new_york = {
                compatible = not BALIATRO.NewYorkIncompatible[key],
                divide_extra_fields = BALIATRO.NewYorkDivideExtraFields[key] or {},
                ignore_extra_fields = BALIATRO.NewYorkIgnoreExtraFields[key] or {},
                divide_extra_number = BALIATRO.NewYorkDivideExtraNumber[key] or false,
                one_minus_multiply_extra_fields = BALIATRO.NewYorkOneMinusMultiplyExtraFields[key] or {},
            }
        end
        if not center.upgrades_to then
            center.upgrades_to = BALIATRO.JokerUpgrade[key] or nil
        end
        -- if BALIATRO.LocVars[key] then
        --     center.loc_vars = BALIATRO.LocVars[key]
        -- end
    end
end

for k, v in pairs(BALIATRO.LocVars) do
    SMODS.Joker:take_ownership(k, {
        loc_vars = v
    }, true)
end

SMODS.Consumable:take_ownership('c_death', {
    can_use = function(self, card)
        local h = #G.hand.highlighted
        if h > card.ability.consumeable.max_highlighted or h < card.ability.consumeable.min_highlighted then return false end
        for _, card in ipairs(G.hand.highlighted) do
            if BALIATRO.is_immortal(card) then
                return false
            end
        end
        return true
    end
}, true)

SMODS.Consumable:take_ownership('c_cryptid', {
    can_use = function(self, card)
        local h = #G.hand.highlighted
        if h > card.ability.consumeable.max_highlighted or h == 0 then return false end
        for _, card in ipairs(G.hand.highlighted) do
            if BALIATRO.is_immortal(card) then
                return false
            end
        end
        return true
    end
}, true)

SMODS.Joker:take_ownership('j_dna', {
    calculate = function(self, card, context)
        if context.first_hand_drawn and not context.blueprint then
            local eval = function() return G.GAME.current_round.hands_played == 0 end
            juice_card_until(card, eval, true)
        elseif context.before and context.cardarea == G.jokers and not context.individual and G.GAME.current_round.hands_played == 0 and #context.full_hand == 1 and not BALIATRO.is_immortal(context.full_hand[1]) then
            G.playing_card = (G.playing_card and G.playing_card + 1) or 1
            local _card = copy_card(context.full_hand[1], nil, nil, G.playing_card)
            _card:add_to_deck()
            G.deck.config.card_limit = G.deck.config.card_limit + 1
            table.insert(G.playing_cards, _card)
            G.hand:emplace(_card)
            _card.states.visible = nil

            G.E_MANAGER:add_event(Event({
                func = function()
                    _card:start_materialize()
                    return true
                end
            }))
            return {
                message = localize('k_copied_ex'),
                colour = G.C.CHIPS,
                card = card,
                playing_cards_created = {true}
            }
        end
    end
}, true)

SMODS.Joker:take_ownership('j_to_the_moon', {
    add_to_deck = function(self, card, from_debuff)
        G.GAME.spec_planets['baliatro_interest'].c_v1 = G.GAME.spec_planets['baliatro_interest'].c_v1 + card.ability.extra
    end,

    remove_from_deck = function(self, card, from_debuff)
        G.GAME.spec_planets['baliatro_interest'].c_v1 = G.GAME.spec_planets['baliatro_interest'].c_v1 - card.ability.extra
    end,
}, true)

SMODS.Consumable:take_ownership('c_fool', {
    use = function(self, card, area, copier)
        local used_tarot = copier or card
        G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
        if G.consumeables.config.card_limit > #G.consumeables.cards or (used_tarot.edition and used_tarot.edition.negative) then
            play_sound('timpani')
            local new_card = create_card('Tarot_Planet', G.consumeables, nil, nil, nil, nil, G.GAME.last_tarot_planet, 'fool')
            if used_tarot.edition and used_tarot.edition.negative then
                new_card:set_edition{negative = true}
            end
            new_card:add_to_deck()
            G.consumeables:emplace(new_card)
            used_tarot:juice_up(0.3, 0.5)
        end
        return true end }))
        delay(0.6)
    end,
}, true)

SMODS.Consumable:take_ownership('c_emperor', {
    use = function(self, card, area, copier)
        local used_tarot = copier or card
        for i = 1, math.min(card.ability.consumeable.tarots, G.consumeables.config.card_limit - #G.consumeables.cards) do
            G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
                if G.consumeables.config.card_limit > #G.consumeables.cards or (used_tarot.edition and used_tarot.edition.negative) then
                    play_sound('timpani')
                    local new_card = create_card('Tarot', G.consumeables, nil, nil, nil, nil, nil, 'emp')
                    if used_tarot.edition and used_tarot.edition.negative then
                        new_card:set_edition{negative = true}
                    end
                    new_card:add_to_deck()
                    G.consumeables:emplace(new_card)
                    used_tarot:juice_up(0.3, 0.5)
                end
                return true end }))
        end
        delay(0.6)
    end
})

SMODS.Consumable:take_ownership('c_high_priestess', {
    use = function(self, card, area, copier)
        local used_tarot = copier or card
        for i = 1, math.min(card.ability.consumeable.planets, G.consumeables.config.card_limit - #G.consumeables.cards) do
            G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
                if G.consumeables.config.card_limit > #G.consumeables.cards or (used_tarot.edition and used_tarot.edition.negative) then
                    play_sound('timpani')
                    local new_card = create_card('Planet', G.consumeables, nil, nil, nil, nil, nil, 'pri')
                    if used_tarot.edition and used_tarot.edition.negative then
                        new_card:set_edition{negative = true}
                    end
                    new_card:add_to_deck()
                    G.consumeables:emplace(new_card)
                    used_tarot:juice_up(0.3, 0.5)
                end
                return true end }))
        end
        delay(0.6)
    end
})

SMODS.Joker:take_ownership('j_midas_mask', {
    calculate = function(self, card, context)
        if context.before and context.cardarea == G.jokers then
            local faces = {}
            for k, v in ipairs(context.scoring_hand) do
                if v:is_face() then
                    faces[#faces+1] = v
                    if not SMODS.has_enhancement(v, 'm_gold') then
                        v:set_ability(G.P_CENTERS.m_gold, nil, true)
                        G.E_MANAGER:add_event(Event({
                            func = function()
                                v:juice_up()
                                return true
                            end
                        }))
                    end
                end
            end
            if #faces > 0 then
                return {
                    message = localize('k_gold'),
                    colour = G.C.MONEY,
                    card = context.blueprint_card or card
                }
            end
        end
    end
})

local bdc = Blind.debuff_card
Blind.debuff_card = function(self, card, from_blind)
    if card.ability.cannot_be_debuffed then card:set_debuff(false); return end
    bdc(self, card, from_blind)
end

return {
    name = 'Baliatro Center Overrides'
}
