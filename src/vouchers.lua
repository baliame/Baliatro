SMODS.Atlas({key="BaliatroVoucher", path="BaliatroVoucher.png", px = 71, py = 95, atlas_table="ASSET_ATLAS"}):register()

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

BALIATRO.buffoon_create_card = function(self, card)
    if G.GAME.pack_upgrade_chance > 0 then
        local _pool, _pool_key = get_current_pool('Joker', nil, nil, 'buf')
        local center = pseudorandom_element(_pool, pseudoseed(_pool_key))
        local it = 1
        while center == 'UNAVAILABLE' do
            it = it + 1
            center = pseudorandom_element(_pool, pseudoseed(_pool_key..'_resample'..it))
        end

        center = G.P_CENTERS[center]
        if center.upgrades_to and pseudorandom(_pool_key..'_upgrade') < G.GAME.pack_upgrade_chance then
            center = G.P_CENTERS[center.upgrades_to]
        end
        return create_card("Joker", G.pack_cards, nil, nil, true, true, center.key, 'buf')
    else
        return create_card("Joker", G.pack_cards, nil, nil, true, true, nil, 'buf')
    end
end

SMODS.Booster:take_ownership('p_buffoon_normal_1', {
    create_card = BALIATRO.buffoon_create_card
}, true)

SMODS.Booster:take_ownership('p_buffoon_normal_2', {
    create_card = BALIATRO.buffoon_create_card
}, true)

SMODS.Booster:take_ownership('p_buffoon_jumbo_1', {
    create_card = BALIATRO.buffoon_create_card
}, true)

SMODS.Booster:take_ownership('p_buffoon_mega_1', {
    create_card = BALIATRO.buffoon_create_card
}, true)

SMODS.Voucher {
    key = 'specialty_store',
    config = {extra = 1},
    atlas = 'BaliatroVoucher',
    cost = 10,
    pos = {x = 1, y = 0},

    loc_vars = function(self, info_queue, voucher)
        return {vars={voucher.ability.extra}}
    end,

    redeem = function(self, voucher)
        G.GAME.shop_booster_packs = G.GAME.shop_booster_packs + voucher.ability.extra
        for i = 1, voucher.ability.extra do
            local new_pack = get_pack('shop_pack').key
            local j = #G.GAME.current_round.used_packs+1
            G.GAME.current_round.used_packs[j] = new_pack
            local card = Card(G.shop_booster.T.x + G.shop_booster.T.w/2,
                G.shop_booster.T.y, G.CARD_W*1.27, G.CARD_H*1.27, G.P_CARDS.empty, G.P_CENTERS[new_pack], {bypass_discovery_center = true, bypass_discovery_ui = true})
            create_shop_card_ui(card, 'Booster', G.shop_booster)
            card.ability.booster_pos = j
            card:start_materialize()
            G.shop_booster:emplace(card)
        end
    end
}
SMODS.Voucher {
    key = 'premium_selection',
    config = {extra = 0.15},
    atlas = 'BaliatroVoucher',
    pos = {x = 1, y = 1},
    cost = 10,
    requires = {"v_baliatro_specialty_store"},

    loc_vars = function(self, info_queue, voucher)
        return {vars={voucher.ability.extra * 100}}
    end,

    redeem = function(self, voucher)
        G.GAME.pack_upgrade_chance = G.GAME.pack_upgrade_chance + voucher.ability.extra
    end
}


return {
    name = "Baliatro Vouchers"
}