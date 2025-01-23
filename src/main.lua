BALIATRO = {}

function load_file(file)
    print("Loading file " .. file)
	local f, err = SMODS.load_file("src/" .. file)
	if err then
		error("Error loading file: " .. err)
        return nil
    end
    return f()
end

-- Load base overrides
load_file('overrides/game.lua')
load_file('overrides/card.lua')
load_file('overrides/center.lua')
load_file('overrides/smods.lua')
load_file('overrides/voucher.lua')

-- Load BALIATRO
load_file('utils.lua')

-- Load whatever in whatever order
load_file('stickers.lua')
load_file('editions.lua')
load_file('planets.lua')
load_file('jokers.lua')
load_file('upgraded_jokers.lua')
load_file('postcards.lua')
load_file('spectral.lua')
load_file('tarot.lua')
load_file('vouchers.lua')

SMODS.current_mod.reset_game_globals = BALIATRO.reset_game_globals

return {
    name = "BALIATRO",
}