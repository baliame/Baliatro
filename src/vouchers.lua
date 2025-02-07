SMODS.Voucher:take_ownership('v_seed_money', {
    config = {
        extra = 25,
    },
    loc_vars = function(self, info_queue, voucher)
        return {vars={voucher.ability.extra}}
    end,
    redeem = function(self, voucher)
        local int = G.GAME.spec_planets['baliatro_interest']
        int.c_v2 = int.c_v2 + voucher.ability.extra
    end
}, true)

SMODS.Voucher:take_ownership('v_money_tree', {
    config = {
        extra = 50,
    },
    loc_vars = function(self, info_queue, voucher)
        return {vars={voucher.ability.extra}}
    end,
    redeem = function(self, voucher)
        local int = G.GAME.spec_planets['baliatro_interest']
        int.c_v2 = int.c_v2 + voucher.ability.extra
    end
}, true)

SMODS.Voucher:take_ownership('v_hone', {
    config = {
        extra = 2,
    },
    loc_vars = function(self, info_queue, voucher)
        return {vars={voucher.ability.extra}}
    end,
    redeem = function(self, voucher)
        G.GAME.edition_rate = G.GAME.edition_rate * voucher.ability.extra
    end
}, true)

SMODS.Voucher:take_ownership('v_glow_up', {
    config = {
        extra = 2,
    },
    loc_vars = function(self, info_queue, voucher)
        return {vars={voucher.ability.extra}}
    end,
    redeem = function(self, voucher)
        G.GAME.edition_rate = G.GAME.edition_rate * voucher.ability.extra
    end
}, true)

SMODS.Voucher:take_ownership('v_clearance_sale', {
    redeem = function(self, voucher)
        G.GAME.discount_percent = math.min(G.GAME.discount_percent + voucher.ability.extra, 99)
        for k, v in pairs(G.I.CARD) do
            if v.set_cost then v:set_cost() end
        end
    end
}, true)

SMODS.Voucher:take_ownership('v_liquidation', {
    config = {extra = 25},
    redeem = function(self, voucher)
        G.GAME.discount_percent = math.min(G.GAME.discount_percent + voucher.ability.extra, 99)
        for k, v in pairs(G.I.CARD) do
            if v.set_cost then v:set_cost() end
        end
    end
}, true)

SMODS.Voucher:take_ownership('v_tarot_merchant', {
    config = {extra = 2, extra_disp = 2},
    redeem = function(self, voucher)
        G.GAME.tarot_rate = G.GAME.tarot_rate * voucher.ability.extra
    end
}, true)

SMODS.Voucher:take_ownership('v_tarot_tycoon', {
    config = {extra = 4, extra_disp = 4},
    redeem = function(self, voucher)
        G.GAME.tarot_rate = G.GAME.tarot_rate * voucher.ability.extra
    end
}, true)

SMODS.Voucher:take_ownership('v_planet_merchant', {
    config = {extra = 2, extra_disp = 2},
    redeem = function(self, voucher)
        G.GAME.planet_rate = G.GAME.planet_rate * voucher.ability.extra
    end
}, true)

SMODS.Voucher:take_ownership('v_planet_tycoon', {
    config = {extra = 4, extra_disp = 4},
    redeem = function(self, voucher)
        G.GAME.planet_rate = G.GAME.planet_rate * voucher.ability.extra
    end
}, true)

return {
    name = "Baliatro Vouchers"
}