SMODS.Atlas({key="BaliatroEnhance", path="BaliatroEnhance.png", px = 71, py = 95, atlas_table="ASSET_ATLAS"}):register()

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