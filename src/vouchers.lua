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

return {
    name = "Baliatro Vouchers"
}