SMODS.Atlas({key="BaliatroStickers", path="BaliatroStickers.png", px = 71, py = 95, atlas_table="ASSET_ATLAS"})

SMODS.Sticker {
    key = "mortgage",
    badge_colour = HEX 'b18f43',
    pos = { x = 1, y = 0 },
    atlas = "BaliatroStickers",
    order = 4,
    should_apply = false,
    rate = 0.0,
    hide_badge = false,
    default_compat = true,
    sets = {Joker = true},

    apply = function(self, card, val)
        card.ability[self.key] = nil
        if not card.ability.perishable then
            if val then
                card.ability[self.key] = 12
            else
                card.ability[self.key] = val
            end
        end
    end,

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = {key = "eternal", set = "Other"}
        return {vars = {G.GAME.mortgage_rate or 15, card.ability[self.key]}}
    end,

    calculate = function(self, card, context)
        if (context.setting_blind or context.skip_blind) and not context.blueprint and not context.individual then
            ease_dollars(-G.GAME.mortgage_rate, true)
            if G.GAME.dollars < G.GAME.bankrupt_at then
                card_eval_status_text(card, 'extra', nil, nil, nil, {instant = true, message = localize{type='variable', key='a_baliatro_bankrupt', vars = {-G.GAME.mortgage_rate}}})
                local _first_dissolve = nil
                G.E_MANAGER:add_event(Event({trigger = 'before', delay = 0.75, func = function()
                    for i, joker in ipairs(G.jokers.cards) do
                        if BALIATRO.manipulable(joker) then
                            joker:start_dissolve(nil, _first_dissolve)
                            _first_dissolve = true
                        end
                    end
                    return true
                end }))
            else
                card_eval_status_text(card, 'dollars', -G.GAME.mortgage_rate)
                card.ability[self.key] = card.ability[self.key] - 1
                if card.ability[self.key] == 0 then
                    self:apply(card, nil)
                end
            end
        end
    end
}

SMODS.Sticker {
    key = "immortal",
    badge_colour = HEX '706E6A',
    pos = { x = 2, y = 0 },
    atlas = "BaliatroStickers",
    order = 4,
    should_apply = false,
    rate = 0.0,
    hide_badge = false,
    default_compat = true,
    sets = {Joker = true},
}
