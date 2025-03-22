BALIATRO = {
    feature_flags = {
        loot = false
    }
}

function load_file(file)
    print("Loading file " .. file)
	local f, err = SMODS.load_file("src/" .. file)
	if err then
		error("Error loading file: " .. err)
        return nil
    end
    return f and f() or nil
end

-- Load UI library
load_file('ui/uibox.lua')
load_file('ui/tab_dialog.lua')
load_file('ui/tab.lua')

-- Load BALIATRO
load_file('utils.lua')

-- Load base overrides
load_file('overrides/game.lua')
load_file('overrides/card.lua')
load_file('overrides/center.lua')
load_file('overrides/smods.lua')
load_file('overrides/voucher.lua')
load_file('overrides/blind.lua')

-- Load whatever in whatever order
load_file('loot.lua')
load_file('stickers.lua')
load_file('editions.lua')
load_file('planets.lua')
load_file('jokers.lua')
load_file('upgraded_jokers.lua')
load_file('postcards.lua')
load_file('spectral.lua')
load_file('tarot.lua')
load_file('vouchers.lua')
load_file('blinds.lua')
load_file('enhancement.lua')
load_file('pacts.lua')

SMODS.current_mod.reset_game_globals = BALIATRO.reset_game_globals
SMODS.current_mod.set_ability_reset_keys = function()
    return {'discarded_this_ante', 'played_this_round', 'discarded_this_round', 'cannot_be_debuffed'}
end

return {
    name = "BALIATRO",
}
