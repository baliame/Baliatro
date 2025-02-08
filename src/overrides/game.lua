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
    ret.mortgage_rate = 20
    ret.shop_booster_packs = 2
    ret.edition_rate = 1.6
    ret.voucher_limit = 1
    ret.current_round.shop_vouchers = {}
    ret.ranks_scored = {}
    ret.real_estate = 1.5
    for _, rank in pairs(SMODS.Ranks) do
        ret.ranks_scored[rank.key] = 0
    end
    return ret
end

local gsr = G.start_run
G.start_run = function(self, args)
    local ret = gsr(self, args)
    G.jokers.config.highlighted_limit = 5
    return ret
end

local gfer = G.FUNCS.evaluate_round
G.FUNCS.evaluate_round = function()
    local int = G.GAME.spec_planets['baliatro_interest']
    G.GAME.interest_amount = int.c_v1
    G.GAME.interest_cap = int.c_v2
    return gfer()
end

BALIATRO.cond = {
    type = {
        gamevar = function(var)
            return G.GAME[var]
        end
    },
    operator = {
        gt = function(a, b)
            return a > b
        end,
        ge = function(a, b)
            return a >= b
        end,
        lt = function(a, b)
            return a < b
        end,
        le = function(a, b)
            return a <= b
        end,
        eq = function(a, b)
            return a == b
        end,
        ne = function(a, b)
            return a ~= b
        end,
    }
}

BALIATRO.meta = function(class)
    local mt = {
        __call = function(self, args)
            local ret = {}
            for k, v in pairs(class) do
                ret[k] = v
            end
            ret:init(args)
            return ret
        end
    }
    setmetatable(class, mt)
    return class
end

BALIATRO.tabgroup = BALIATRO.meta{
    init = function(self, tabdefs)
        self.tabdefs = {}
        for _, tab in ipairs(tabdefs) do
            self.tabdefs[#self.tabdefs+1] = BALIATRO.tabdef(tab)
        end
    end,

    render = function(self)
        local out = {}
        for _, tabdef in ipairs(self.tabdefs) do
            if tabdef:can_show() then
                out[#out + 1] = tabdef:render()
            end
        end
        return out
    end,
}

BALIATRO.tabdef = BALIATRO.meta{
    init = function(self, args)
        self.label = args.label
        self.chosen = args.chosen or false
        self.tab_definition_function = args.tab_definition_function
        self.condition = args.condition
    end,

    render = function(self)
        return {
            label = localize(self.label),
            chosen = self.chosen,
            tab_definition_function = self.tab_definition_function,
        }
    end,

    can_show = function(self)
        if not self.condition then return true end
        local a = BALIATRO.cond.type[self.condition.type](self.condition.variable)
        local b = self.condition.value
        return BALIATRO.cond.operator[self.condition.operator](a, b)
    end,
}

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

BALIATRO.ui = {
    run_info = BALIATRO.tabgroup{
        {
            label = 'b_poker_hands',
            chosen = true,
            tab_definition_function = create_UIBox_current_hands,
        },
        {
            label = 'b_blinds',
            tab_definition_function = G.UIDEF.current_blinds,
        },
        {
            label = 'b_vouchers',
            tab_definition_function = G.UIDEF.used_vouchers,
        },
        {
            label = 'b_baliatro_moons',
            tab_definition_function = BALIATRO.tab_moons,
        },
        {
            label = 'b_baliatro_ranks',
            tab_definition_function = BALIATRO.tab_ranks,
        },
        {
            condition = {type = "gamevar", variable = "stake", operator = "gt", value = 1},
            label = 'b_stake',
            tab_definition_function = G.UIDEF.current_stake,
        },
    }
}

local guri = G.UIDEF.run_info
function G.UIDEF.run_info()
    return create_UIBox_generic_options({contents ={create_tabs(
      {
        tabs = BALIATRO.ui.run_info:render(),
        tab_h = 8,
        snap_to_nav = true
    })}})
  end


G.FUNCS.draw_from_play_to_discard = function(e)
    local play_count = #G.play.cards
    local it = 1

    local target = G.discard
    local shuffle_target = false
    if G.GAME.blind and G.GAME.blind.in_blind and G.GAME.blind.config and G.GAME.blind.config.blind and G.GAME.blind.config.blind.play_to_deck then
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

return {
    name = 'Baliatro Game Overrides'
}
