SMODS.Atlas({key="BaliatroEnhance", path="BaliatroEnhance.png", px = 71, py = 95, atlas_table="ASSET_ATLAS"}):register()


SMODS.Enhancement:take_ownership('m_stone', {
    replace_base_card = true,
    loc_vars = function(self, info_queue, card)
        if card.base and card.base.value and card.base.suit then
            info_queue[#info_queue+1] = {key='baliatro_original_base', set='Other', vars={localize(card.base.value, 'ranks'), localize(card.base.suit, 'suits_plural'), colours={G.C.SUITS[card.base.suit]}}}
        end
        return {vars = {SMODS.signed((card.ability and card.ability.bonus) or self.config.bonus)}}
    end
}, true)

SMODS.Enhancement {
    key = 'resistant',
    atlas = 'BaliatroEnhance',
    pos = { x = 0, y = 0 },
    config = {
        mult = -2,
        cannot_be_debuffed = true,
        mult_gain = -0.1
    },
    weight = 2,

    loc_vars = function(self)
        return {vars = {self.config.mult, self.config.mult_gain}}
    end,

    calculate = function(self, card, context)
        if context.main_scoring and context.cardarea == G.play then
            card.ability.mult = card.ability.mult + card.ability.mult_gain
        end
    end,
}

SMODS.Enhancement {
    key = 'mtx_common',
    atlas = 'BaliatroEnhance',
    pos = { x = 1, y = 0 },
    config = {
        x_chips = 1.2,
        mtx_value = 3,
    },
    weight = 2,

    loc_vars = function(self)
        return {vars = {self.config.x_chips, self.config.mtx_value}}
    end,
}

SMODS.Enhancement {
    key = 'mtx_uncommon',
    atlas = 'BaliatroEnhance',
    pos = { x = 3, y = 0 },
    config = {
        p_dollars = -1,
        x_chips = 1.35,
        mtx_value = 5,
    },
    weight = 2,

    loc_vars = function(self)
        return {vars = {-self.config.p_dollars, self.config.x_chips, self.config.mtx_value}}
    end,
}

SMODS.Enhancement {
    key = 'mtx_rare',
    atlas = 'BaliatroEnhance',
    pos = { x = 4, y = 0 },
    config = {
        p_dollars = -1,
        x_chips = 1.5,
        mtx_value = 10,
    },
    weight = 2,

    loc_vars = function(self)
        return {vars = {-self.config.p_dollars, self.config.x_chips, self.config.mtx_value}}
    end,
}

SMODS.Enhancement {
    key = 'mtx_epic',
    atlas = 'BaliatroEnhance',
    pos = { x = 5, y = 0 },
    config = {
        p_dollars = -2,
        x_chips = 1.8,
        mtx_value = 20,
    },
    weight = 2,

    loc_vars = function(self)
        return {vars = {-self.config.p_dollars, self.config.x_chips, self.config.mtx_value}}
    end,
}
