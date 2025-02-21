SMODS.Atlas({key="BaliatroEnhance", path="BaliatroEnhance.png", px = 71, py = 95, atlas_table="ASSET_ATLAS"}):register()


SMODS.Enhancement:take_ownership('m_stone', {
    replace_base_card = true,
    loc_vars = function(self, info_queue, card)
        if card.base then
            info_queue[#info_queue+1] = {key='baliatro_original_base', set='Other', vars={localize(card.base.value, 'ranks'), localize(card.base.suit, 'suits_plural'), colours={G.C.SUITS[card.base.suit]}}}
        end
        return {vars = {(card.ability and card.ability.bonus) or self.config.bonus}}
    end
}, true)

SMODS.Enhancement {
    key = 'resistant',
    atlas = 'BaliatroEnhance',
    pos = { x = 0, y = 0 },
    config = {
        mult = -2,
        cannot_be_debuffed = true,
    },
    weight = 2,

    loc_vars = function(self)
        return {vars = {self.config.mult}}
    end,
}