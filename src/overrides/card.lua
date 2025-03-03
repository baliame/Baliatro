local csc = Card.set_cost
Card.set_cost = function(self)
    csc(self)
    if self.ability.baliatro_mortgage then
        self.cost = 0
        self.sell_cost = 0
        self.sell_cost_label = self.facing == 'back' and '?' or self.sell_cost
    end
end

local ccj = Card.calculate_joker
Card.calculate_joker = function(self, context)
    local o, t = ccj(self, context)
    if self.edition and not context.check_enhancement and not context.main_scoring and not context.blueprint and not context.blueprint_card then
        local edition = G.P_CENTERS[self.edition.key]
        if edition.augment and type(edition.augment) == 'function' then
            local aug_o, aug_t = edition:augment(self, context, o, t)
            return aug_o or o, aug_t or t
        end
    end
    return o, t
end

local ccsc = Card.can_sell_card
Card.can_sell_card = function(self, context)
    return ccsc(self, context) and not self.ability.baliatro_mortgage
end

function Card:clear_perishable()
    self.ability.perishable = nil
    self.ability.perishable_tally = nil
end

function Card:set_immortal(_immortal)
    SMODS.Stickers['baliatro_immortal']:apply(self, _immortal)
end

function Card:set_ethereal(_ethereal)
    self.ability.baliatro_ethereal = nil
    if not self.ability.perishable then
        self.ability.baliatro_ethereal = _ethereal
    end
end

function Card:set_mortgage(_mortgage)
    SMODS.Stickers['baliatro_mortgage']:apply(self, _mortgage)
end

local csa = Card.set_ability
Card.set_ability = function(self, center, initial, delay_sprites)
    if not initial and center and center.set == 'Joker' and (center.discovered or self.bypass_discovery_center) then
        local old_center = self.config.center
        if old_center and (old_center.name == 'Half Joker' or old_center.name == 'Photograph' or old_center.name == 'Square Joker' or old_center.name == 'Wee Joker' or (old_center.display_size and (old_center.display_size.w or old_center.display_size.h)) or (old_center.pixel_size and (old_center.pixel_size.w or old_center.pixel_size.h))) then
            self.T.w = G.CARD_W
            self.T.h = G.CARD_H
        end
    end
    if center and center.set_size and type(center.set_size) == "function" then
        center:set_size(self, initial, delay_sprites)
    end
    return csa(self, center, initial, delay_sprites)
end


--local cgcm = Card.get_chip_mult
--Card.get_chip_mult = function (self)
--    local mult = cgcm(self)
--    local pm = (self.ability and self.ability.perma_mult) or 0
--    return mult + pm
--end
--
--local cgpd = Card.get_p_dollars
--
--Card.get_p_dollars = function (self)
--    local dollars = cgpd(self)
--    local pd = (self.ability and self.ability.perma_dollars) or 0
--    return dollars + pd
--end
--
--local cgcxm = Card.get_chip_x_mult
--
--Card.get_chip_x_mult = function (self, context)
--    local xmult = cgcxm(self, context)
--    local perma_xmult = (self.ability and self.ability.perma_xmult) or 0
--    if perma_xmult == 0 then
--        return xmult
--    end
--    if xmult == 0 then
--        return perma_xmult + 1
--    end
--    return xmult * (perma_xmult + 1)
--end

local catd = Card.add_to_deck
Card.add_to_deck = function (self, from_debuff)
    local ret = catd(self, from_debuff)
    if self.edition then
        if self.edition.key == 'e_foil' or self.edition.key == 'e_baliatro_faded_foil' then
            G.GAME.spec_planets['baliatro_foil'].ever =  true
        elseif self.edition.key == 'e_holo' or self.edition.key == 'e_baliatro_faded_holo' then
            G.GAME.spec_planets['baliatro_holo'].ever =  true
        elseif self.edition.key == 'e_polychrome' or self.edition.key == 'e_baliatro_faded_polychrome' then
            G.GAME.spec_planets['baliatro_polychrome'].ever =  true
        elseif self.edition.key == 'e_baliatro_photographic' then
            G.GAME.spec_planets['baliatro_photographic'].ever =  true
        elseif self.edition.key == 'e_baliatro_scenic' then
            G.GAME.spec_planets['baliatro_scenic'].ever =  true
        elseif self.edition.key == 'e_baliatro_pact' then
            BALIATRO.apply_pact(self.edition.pact)
        end
    end
end


return {
    name = 'Baliatro Card Overrides'
}
