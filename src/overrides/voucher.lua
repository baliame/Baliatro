BALIATRO.claim_round_voucher = function(card)
    if card.shop_voucher and card.shop_voucher > 0 then
        G.GAME.current_round.shop_vouchers[card.shop_voucher] = nil
    end
end

BALIATRO.reset_round_voucher = function()
    if G.SETTINGS.tutorial_progress and G.SETTINGS.tutorial_progress.forced_voucher then
        G.GAME.current_round.shop_vouchers = {G.SETTINGS.tutorial_progress.forced_voucher}
        return
    end
    local ret = {get_next_voucher_key()}
    for i = 2, G.GAME.voucher_limit do
        local redo = false
        repeat
            local cand = get_next_voucher_key()
            local attempts = 0
            for j = 1, i - 1 do
                if ret[j] == cand and not BALIATRO.can_repeat_vouchers() then
                    redo = true
                    attempts = attempts + 1
                    break
                end
            end
            if not redo then ret[#ret + 1] = cand end
            if attempts > 50 then redo = false end
        until not redo
    end
    G.GAME.current_round.shop_vouchers = ret
end

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