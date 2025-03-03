BALIATRO.can_repeat_vouchers = function()
    if not G.jokers or not G.jokers.cards then return false end
    for _, joker in ipairs(G.jokers.cards) do
        if joker.ability.extra and type(joker.ability.extra) == 'table' and joker.ability.extra.grants_can_repeat_vouchers then
            return true
        end
    end
    return false
end

BALIATRO.any_voucher_available = function()
    for _, v in ipairs(G.GAME.current_round.shop_vouchers) do
        if v ~= nil then return true end
    end
    return false
end

--get_next_voucher_key = function(_from_tag)

return {
    name = "Baliatro Vouchers"
}