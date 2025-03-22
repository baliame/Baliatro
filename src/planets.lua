SMODS.Atlas({key="BaliatroPlanets", path="BaliatroPlanets.png", px = 71, py = 95, atlas_table="ASSET_ATLAS"})

SMODS.Booster:take_ownership('p_celestial_normal_1', {config = {extra = 4, choose = 1}}, true)
SMODS.Booster:take_ownership('p_celestial_normal_2', {config = {extra = 4, choose = 1}}, true)
SMODS.Booster:take_ownership('p_celestial_normal_3', {config = {extra = 4, choose = 1}}, true)
SMODS.Booster:take_ownership('p_celestial_normal_4', {config = {extra = 4, choose = 1}}, true)
SMODS.Booster:take_ownership('p_celestial_jumbo_1', {config = {extra = 6, choose = 1}}, true)
SMODS.Booster:take_ownership('p_celestial_jumbo_2', {config = {extra = 6, choose = 1}}, true)
SMODS.Booster:take_ownership('p_celestial_mega_1', {config = {extra = 6, choose = 2}}, true)
SMODS.Booster:take_ownership('p_celestial_mega_2', {config = {extra = 6, choose = 2}}, true)

SMODS.Consumable {
    set = 'Planet',
    key = 'luna',
    config = { target="baliatro_interest", v1 = 0.03, v2 = 2, initial_v1 = 1, initial_v2 = 25, moon = true},
    pos = {x = 1, y = 0 },
    atlas = 'BaliatroPlanets',
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = {key='baliatro_interest_cap', set='Other'}
        local target = card.ability.target
        local t = G.GAME.spec_planets[target]
        return {vars={
            t.level,
            localize(target),
            t.v1,
            t.v2,
        }}
    end,
    can_appear = function(self)
        -- artificially create scarcity over level 10
        local top = math.max(0, G.GAME.spec_planets['baliatro_interest'].level - 10)
        local bottom = math.max(1, G.GAME.spec_planets['baliatro_interest'].level - 8)
        return top == 0 or top / bottom < pseudorandom('luna_canappear')
    end,
    can_use = function(self, card)
        return true
    end,
    set_card_type_badge = function(self, card, badges)
        badges[1] = create_badge(localize('baliatro_planet_moon'), get_type_colour(self or card.config, card), nil, 1.2)
    end,
    use = function(self, card, area, copier)
        BALIATRO.use_special_planet(self.config.target, card, copier, 1)
    end,
    generate_ui = 0,
}

SMODS.Consumable {
    set = 'Planet',
    key = 'deimos',
    config = { softlock=true, target="baliatro_foil", v1 = 25, initial_v1 = 50, moon = true, spec_extra = {ever = false}},
    pos = {x = 2, y = 0 },
    atlas = 'BaliatroPlanets',
    loc_vars = function(self, info_queue, card)
        local target = card.ability.target
        local t = G.GAME.spec_planets[target]
        return {vars={
            t.level,
            localize(target),
            t.v1,
            t.v2,
        }}
    end,
    can_appear = function(self)
        return G.GAME.spec_planets['baliatro_foil'].ever
    end,
    can_use = function(self, card)
        return true
    end,
    set_card_type_badge = function(self, card, badges)
        badges[1] = create_badge(localize('baliatro_planet_moon'), get_type_colour(self or card.config, card), nil, 1.2)
    end,
    use = function(self, card, area, copier)
        BALIATRO.use_special_planet(self.config.target, card, copier, 1)
    end,
    generate_ui = 0,
}

SMODS.Consumable {
    set = 'Planet',
    key = 'phobos',
    config = { softlock=true, target="baliatro_holo", v1 = 5, initial_v1 = 10, moon = true, spec_extra = {ever = false}},
    pos = {x = 3, y = 0 },
    atlas = 'BaliatroPlanets',
    loc_vars = function(self, info_queue, card)
        local target = card.ability.target
        local t = G.GAME.spec_planets[target]
        return {vars={
            t.level,
            localize(target),
            t.v1,
            t.v2,
        }}
    end,
    can_appear = function(self)
        return G.GAME.spec_planets['baliatro_holo'].ever
    end,
    can_use = function(self, card)
        return true
    end,
    set_card_type_badge = function(self, card, badges)
        badges[1] = create_badge(localize('baliatro_planet_moon'), get_type_colour(self or card.config, card), nil, 1.2)
    end,
    use = function(self, card, area, copier)
        BALIATRO.use_special_planet(self.config.target, card, copier, 1)
    end,
    generate_ui = 0,
}

SMODS.Consumable {
    set = 'Planet',
    key = 'io',
    config = { softlock=true, target="baliatro_polychrome", v1 = 0.02, initial_v1 = 1.5, moon = true, spec_extra = { remult = 1, ever = false }},
    pos = {x = 4, y = 0 },
    atlas = 'BaliatroPlanets',
    loc_vars = function(self, info_queue, card)
        local target = card.ability.target
        local t = G.GAME.spec_planets[target]
        return {vars={
            t.level,
            localize(target),
            t.v1,
            t.v2,
        }}
    end,
    can_appear = function(self)
        if not G.GAME.spec_planets['baliatro_polychrome'].ever then return false end
        local top = math.max(0, G.GAME.spec_planets['baliatro_polychrome'].level - 20)
        local bottom = math.max(1, G.GAME.spec_planets['baliatro_polychrome'].level - 18)
        return top == 0 or top / bottom < pseudorandom('io_canappear')
    end,
    can_use = function(self, card)
        return true
    end,
    set_card_type_badge = function(self, card, badges)
        badges[1] = create_badge(localize('baliatro_planet_moon'), get_type_colour(self or card.config, card), nil, 1.2)
    end,
    use = function(self, card, area, copier)
        BALIATRO.use_special_planet(self.config.target, card, copier, 1)
    end,
    generate_ui = 0,
}

SMODS.Consumable {
    set = 'Planet',
    key = 'europa',
    config = { softlock=true, target="baliatro_photographic", v1 = 0.05, initial_v1 = 1.1, moon = true, spec_extra = {ever = false}},
    pos = {x = 5, y = 0 },
    atlas = 'BaliatroPlanets',
    loc_vars = function(self, info_queue, card)
        local target = card.ability.target
        local t = G.GAME.spec_planets[target]
        return {vars={
            t.level,
            localize(target),
            t.v1,
            t.v2,
        }}
    end,
    can_appear = function(self)
        if not G.GAME.spec_planets['baliatro_photographic'].ever then return false end
        local top = math.max(0, G.GAME.spec_planets['baliatro_photographic'].level - 10)
        local bottom = math.max(1, G.GAME.spec_planets['baliatro_photographic'].level - 8)
        return top == 0 or top / bottom < pseudorandom('io_canappear')
    end,
    can_use = function(self, card)
        return true
    end,
    set_card_type_badge = function(self, card, badges)
        badges[1] = create_badge(localize('baliatro_planet_moon'), get_type_colour(self or card.config, card), nil, 1.2)
    end,
    use = function(self, card, area, copier)
        BALIATRO.use_special_planet(self.config.target, card, copier, 1)
    end,
    generate_ui = 0,
}

SMODS.Consumable {
    set = 'Planet',
    key = 'ganymede',
    config = { softlock=true, target="baliatro_scenic", v1 = 0.3, initial_v1 = 0, moon = true, spec_extra = {ever = false}},
    pos = {x = 6, y = 0 },
    atlas = 'BaliatroPlanets',
    loc_vars = function(self, info_queue, card)
        local target = card.ability.target
        local t = G.GAME.spec_planets[target]
        return {vars={
            t.level,
            localize(target),
            t.v1,
            t.v2,
        }}
    end,
    can_appear = function(self)
        return G.GAME.spec_planets['baliatro_scenic'].ever
    end,
    can_use = function(self, card)
        return true
    end,
    set_card_type_badge = function(self, card, badges)
        badges[1] = create_badge(localize('baliatro_planet_moon'), get_type_colour(self or card.config, card), nil, 1.2)
    end,
    use = function(self, card, area, copier)
        BALIATRO.use_special_planet(self.config.target, card, copier, 1)
    end,
    generate_ui = 0,
}

SMODS.Consumable {
    set = 'Planet',
    key = 'callisto',
    config = { target="baliatro_booster_pack_choices", v1 = 0.2, initial_v1 = 0, v2 = 0.1, initial_v2 = 0, moon = true},
    pos = {x = 7, y = 0 },
    atlas = 'BaliatroPlanets',
    loc_vars = function(self, info_queue, card)
        local target = card.ability.target
        local t = G.GAME.spec_planets[target]
        return {vars={
            t.level,
            localize(target),
            t.v1,
            t.v2,
        }}
    end,
    can_appear = function(self)
        -- artificially create scarcity over level 20
        local top = math.max(0, G.GAME.spec_planets['baliatro_booster_pack_choices'].level - 20)
        local bottom = math.max(1, G.GAME.spec_planets['baliatro_booster_pack_choices'].level - 18)
        return top == 0 or top / bottom < pseudorandom('call_canappear')
    end,
    can_use = function(self, card)
        return true
    end,
    set_card_type_badge = function(self, card, badges)
        badges[1] = create_badge(localize('baliatro_planet_moon'), get_type_colour(self or card.config, card), nil, 1.2)
    end,
    use = function(self, card, area, copier)
        BALIATRO.use_special_planet(self.config.target, card, copier, 1)
    end,
    generate_ui = 0,
}

return {
    name = "Baliatro Planets",
}
