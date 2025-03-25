local gigo = G.init_game_object
G.init_game_object = function(self)
    local ret = gigo(self)
    ret.spec_planets = {}
    for k, v in pairs(G.P_CENTERS) do
        if v.set == "Planet" and v.config.target then
            --print("Creating spec_planet object for target %s", v.config.target)
            local spec_planet_stuff = {
                level = 1,
                v1 = v.config.v1,
                v2 = v.config.v2 or 0,
                c_v1 = v.config.initial_v1 or 0,
                c_v2 = v.config.initial_v2 or 0,
            }
            if v.config.spec_extra then
                for k, v in pairs(v.config.spec_extra) do
                    spec_planet_stuff[k] = v
                end
            end
            ret.spec_planets[v.config.target] = spec_planet_stuff
        end
    end
    ret.interest_basis_modifier = 0
    ret.current_round.booster_rerolls = 0
    ret.current_round.effigy_card = {rank = 'Ace', id = 14}
    ret.current_round.goal_evals = {}
    ret.mortgage_rate = 15
    ret.edition_rate = ret.edition_rate * 1.6
    ret.booster_cost_multiplier = 1
    ret.ranks_scored = {}
    ret.real_estate = 1.5
    ret.pack_upgrade_chance = 0
    ret.baliatro_pacts = {}
    ret.ante_goals = {}
    ret.pacts_cannot_appear = 0
    ret.audience_progress = 0
    ret.audience_progress_per_round = 9
    ret.discard_to_deck = 0
    ret.play_to_deck = 0

    for _, rank in pairs(SMODS.Ranks) do
        ret.ranks_scored[rank.key] = 0
    end
    return ret
end

local gsr = G.start_run
G.start_run = function(self, args)
    if BALIATRO.feature_flags.loot then
        self.loot = CardArea(0, 1.2, G.CARD_W, G.CARD_H, {
            card_limit = 12,
            highlight_limit = 0,
            card_w = G.CARD_W * 0.7,
            type = 'loot',
        })
    end
    local ret = gsr(self, args)
    local saveTable = args.savetext or nil
    G.jokers.config.highlighted_limit = 5
    if BALIATRO.feature_flags.loot then
        self.loot.T.x = self.jokers.T.x + self.jokers.T.w/2 + 0.3 + 15
        self.loot:hard_set_VT()
        if not saveTable then
            BALIATRO.generate_ante_goals()
        else
            G.GAME.blind_goals_dirty = true
        end
    end
    return ret
end

local gfer = G.FUNCS.evaluate_round
G.FUNCS.evaluate_round = function()
    local int = G.GAME.spec_planets['baliatro_interest']
    G.GAME.interest_amount = int.c_v1
    G.GAME.interest_cap = int.c_v2
    local ret = gfer()

    return ret
end


local gfsb = G.FUNCS.skip_booster
G.FUNCS.skip_booster = function(e)
    if SMODS.OPENED_BOOSTER then
        local center = SMODS.OPENED_BOOSTER.config.center
        if center and center.on_skip and type(center.on_skip) == 'function' then
            center:on_skip()
        end
    end
    gfsb(e)
end

BALIATRO.ranks_sorted = {}

BALIATRO.get_sorted_ranks = function()
    if #BALIATRO.ranks_sorted > 0 then
        return BALIATRO.ranks_sorted
    end
    local buffer = {}
    local buf_key = nil
    local buf_value = nil
    local buf_max = nil
    local buf_max_key = nil
    local count = 0
    for k, v in pairs(SMODS.Ranks) do
        count = count + 1
        buffer[k] = v.sort_nominal
        if buf_max == nil or v.sort_nominal > buf_max then
            buf_max = v.sort_nominal
            buf_max_key = k
        end
        if buf_value == nil or v.sort_nominal < buf_value then
            buf_key = k
            buf_value = v.sort_nominal
        end
    end
    local buf2 = {buf_key}
    local cand = buf_max
    local cand_key = buf_max_key
    while #buf2 < count do
        for k, v in pairs(buffer) do
            if v < cand and v > buf_value then
                cand = v
                cand_key = k
            end
        end
        buf2[#buf2+1] = cand_key
        buf_value = cand
        cand = buf_max
        cand_key = buf_max_key
    end
    BALIATRO.ranks_sorted = buf2
    return BALIATRO.ranks_sorted
end

BALIATRO.rank_row = function(rank, times_scored, simple)
    local fmted = number_format(times_scored, 1000000)

    local bbox = {n=G.UIT.C, config={align = "cr", padding = 0.05, colour = G.C.BLACK,r = 0.1}, nodes={
        {n=G.UIT.C, config={align = "cr", padding = 0.01, r = 0.1, colour = G.C.CHIPS, minw = 1.1}, nodes={
            {n=G.UIT.T, config={text = fmted, scale = 0.45, colour = G.C.UI.TEXT_LIGHT}},
            {n=G.UIT.B, config={w = 0.08, h = 0.01}}
        }},
    }}
    return {n=G.UIT.R, config={align = "cl", padding = 0.05, r = 0.1, colour = darken(G.C.JOKER_GREY, 0.1), emboss = 0.05, hover = true, force_focus = true}, nodes={
        {n=G.UIT.C, config={align = "cl", padding = 0, minw = 5}, nodes={
            {n=G.UIT.C, config={align = "cl", minw = 5.5, maxw = 5.5}, nodes={
                {n=G.UIT.T, config={text = ' '..localize(rank, 'ranks'), scale = 0.45, colour = G.C.UI.TEXT_LIGHT, shadow = true}}
            }}
        }},
        bbox,
    }}
end

BALIATRO.moon_row = function(spec_planet, box_colour, v1_fmt, v1_post, v1_colour, show_v2, v2_fmt, v2_post, v2_colour, simple)
    local v1 = number_format(G.GAME.spec_planets[spec_planet].c_v1, 1000000)
    local v2 = number_format(G.GAME.spec_planets[spec_planet].c_v2, 1000000)
    if v1_fmt then v1 = localize{type='variable', key=v1_fmt, vars={v1}} end
    if v2_fmt then v2 = localize{type='variable', key=v2_fmt, vars={v2}} end
    local bbox = {n=G.UIT.C, config={align = "cr", padding = 0.05, colour = box_colour,r = 0.1}, nodes={
        {n=G.UIT.C, config={align = "cr", padding = 0.01, r = 0.1, colour = v1_colour, minw = 1.1}, nodes={
            {n=G.UIT.T, config={text = v1, scale = 0.45, colour = G.C.UI.TEXT_LIGHT}},
            {n=G.UIT.B, config={w = 0.08, h = 0.01}}
        }},
        {n=G.UIT.T, config={text = (v1_post and localize(v1_post)) or '', scale = 0.45, G.C.UI.TEXT_LIGHT, shadow = true}},
    }}
    if show_v2 then
        bbox.nodes[#bbox.nodes+1] = {n=G.UIT.C, config={align = "cl", padding = 0.01, r = 0.1, colour = v2_colour, minw = 1.1}, nodes={
            {n=G.UIT.B, config={w = 0.08,h = 0.01}},
            {n=G.UIT.T, config={text = (show_v2 and v2) or '', scale = 0.45, colour = G.C.UI.TEXT_LIGHT}},
        }}
        bbox.nodes[#bbox.nodes+1] = {n=G.UIT.T, config={text = (show_v2 and v2_post and localize(v2_post)) or '', scale = 0.45, G.C.UI.TEXT_LIGHT, shadow = true}}
    end
    return {n=G.UIT.R, config={align = "cl", padding = 0.05, r = 0.1, colour = darken(G.C.JOKER_GREY, 0.1), emboss = 0.05, hover = true, force_focus = true}, nodes={
        {n=G.UIT.C, config={align = "cl", padding = 0, minw = 5}, nodes={
            {n=G.UIT.C, config={align = "cm", padding = 0.01, r = 0.1, colour = G.C.HAND_LEVELS[math.min(7, G.GAME.spec_planets[spec_planet].level)], minw = 1.5, outline = 0.8, outline_colour = G.C.WHITE}, nodes={
                {n=G.UIT.T, config={text = localize('k_level_prefix')..G.GAME.spec_planets[spec_planet].level, scale = 0.5, colour = G.C.UI.TEXT_DARK}}
            }},
            {n=G.UIT.C, config={align = "cl", minw = 5.5, maxw = 5.5}, nodes={
                {n=G.UIT.T, config={text = ' '..localize(spec_planet), scale = 0.45, colour = G.C.UI.TEXT_LIGHT, shadow = true}}
            }}
        }},
        bbox,
    }}
end

BALIATRO.tab_ranks = function(simple)
    local jg = darken(G.C.JOKER_GREY, 0.1)
    local ranks = {}
    for _, k in ipairs(BALIATRO.get_sorted_ranks()) do
        ranks[#ranks+1] = BALIATRO.rank_row(k, G.GAME.ranks_scored[k], simple)
    end
    local ret = {n = G.UIT.ROOT, config = {align = "cm", colour = G.C.CLEAR}, nodes = {
        {n = G.UIT.R, config = {align = "cm", padding = 0.04}, nodes = ranks},
    }}
    return ret
end

BALIATRO.tab_moons = function(simple)
    local jg = darken(G.C.JOKER_GREY, 0.1)
    local moons = {
        BALIATRO.moon_row(
            'baliatro_interest',
            jg,
            'a_baliatro_dollar_per_5dollar',
            nil,
            jg,
            true,
            'a_baliatro_interest_cap',
            nil,
            jg,
            simple
        ),
        BALIATRO.moon_row(
            'baliatro_foil',
            G.C.BLACK,
            nil,
            nil,
            G.C.CHIPS,
            false,
            nil,
            nil,
            jg,
            simple
        ),
        BALIATRO.moon_row(
            'baliatro_holo',
            G.C.BLACK,
            nil,
            nil,
            G.C.MULT,
            false,
            nil,
            nil,
            jg,
            simple
        ),
        BALIATRO.moon_row(
            'baliatro_polychrome',
            G.C.BLACK,
            'a_baliatro_xmult',
            nil,
            G.C.MULT,
            false,
            nil,
            nil,
            jg,
            simple
        ),
        BALIATRO.moon_row(
            'baliatro_photographic',
            G.C.BLACK,
            'a_baliatro_xmult',
            nil,
            G.C.MULT,
            false,
            nil,
            nil,
            jg,
            simple
        ),
        BALIATRO.moon_row(
            'baliatro_scenic',
            G.C.BLACK,
            'a_baliatro_plus_percent',
            'b_baliatro_on_trigger',
            G.C.CHIPS,
            false,
            nil,
            nil,
            jg,
            simple
        ),
        BALIATRO.moon_row(
            'baliatro_booster_pack_choices',
            jg,
            'a_baliatro_pick_plus',
            nil,
            jg,
            true,
            'a_baliatro_out_of',
            nil,
            jg,
            simple
        ),
    }
    local ret = {n = G.UIT.ROOT, config = {align = "cm", colour = G.C.CLEAR}, nodes = {
        {n = G.UIT.R, config = {align = "cm", padding = 0.04}, nodes = moons},
    }}
    return ret
end

SMODS.Tab{
    key = 'moons',
    tab_dialog = 'baliatro_run_info',
    order = 23,
    func = function(self)
        return BALIATRO.tab_moons(false)
    end
}

SMODS.Tab{
    key = 'ranks',
    tab_dialog = 'baliatro_run_info',
    order = 27,
    func = function(self)
        return BALIATRO.tab_ranks(false)
    end
}

G.FUNCS.draw_from_play_to_discard = function(e)
    local play_count = #G.play.cards
    local it = 1

    local target = G.discard
    local shuffle_target = false
    if G.GAME.blind and G.GAME.blind:is_playing_to_deck() or (G.GAME.play_to_deck and G.GAME.play_to_deck > 0) then
        target = G.deck
        shuffle_target = true
    end

    for k, v in ipairs(G.play.cards) do
        if (not v.shattered) and (not v.destroyed) then
            draw_card(G.play, target, it*100/play_count,'down', false, v)
            it = it + 1
        end
    end
    if shuffle_target then target:shuffle('ptd'..G.GAME.round_resets.ante) end
end

local gfcd = G.FUNCS.can_discard
G.FUNCS.can_discard = function(e)
    local prevent_discard = false
    if #G.hand.highlighted > 0 then
        for i, card in ipairs(G.hand.highlighted) do
            if card.edition and card.edition.prevent_discard then
                prevent_discard = true
                break
            end
        end
    end
    if prevent_discard or G.GAME.current_round.discards_left <= 0 or #G.hand.highlighted <= 0 then
        e.config.colour = G.C.UI.BACKGROUND_INACTIVE
        e.config.button = nil
    else
        e.config.colour = G.C.RED
        e.config.button = 'discard_cards_from_highlighted'
    end
end

local cc = copy_card

-- Safeguard against copying immortal cards via other mods.
function copy_card(other, new_card, card_scale, playing_card, strip_edition, bypass_baliatro_immortal)
    local copy = cc(other, new_card, card_scale, playing_card, strip_edition)

    if not bypass_baliatro_immortal and BALIATRO.is_immortal(other) then
        if other.ability.set == 'Joker' then
            copy:set_perishable(true)
            copy.ability.perish_tally = 1
            copy:set_edition(nil, true, true)
        elseif other.ability.set == 'Default' or other.ability.set == 'Enhanced' then
            copy:set_edition(G.P_CENTERS['e_baliatro_ethereal'], true, true)
            if other.seal then
                copy:set_seal(nil)
            end
            if other.ability.set == 'Enhanced' then
                copy:set_ability(G.P_CENTERS.c_base)
            end
        elseif other.ability.consumeable then
            copy:set_edition(G.P_CENTERS['e_baliatro_ephemeral'], true, true)
        end
    end

    return copy
end

return {
    name = 'Baliatro Game Overrides'
}
