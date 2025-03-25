return {
    descriptions = {
        Back={},
        Goal={
            goal_baliatro_play_two_two_pair = {
                name = 'Play 2 Two Pair',
                text = {
                    'Play a hand containing a',
                    '{C:green}#2#{} {C:attention}#1#{} time(s)'
                }
            },
            goal_baliatro_play_two_flush = {
                name = 'Play 2 Flush',
                text = {
                    'Play a {C:green}#2#{} {C:attention}#1#{} time(s)'
                }
            },
            goal_baliatro_play_one_straight_flush = {
                name = 'Play 1 Straight Flush',
                text = {
                    'Play a {C:green}#2#{} {C:attention}#1#{} time(s)'
                }
            },

            goal_baliatro_play_one_four_of_a_kind = {
                name = 'Play 1 Four of a Kind',
                text = {
                    'Play a hand containing a',
                    '{C:green}#2#{} {C:attention}#1#{} time(s)'
                }
            },
            goal_baliatro_play_no_triplicates = {
                name = 'Play no triplicates',
                text = {
                    'Play no hand containing',
                    'any {C:green}#1#{}'
                }
            },

            goal_baliatro_play_no_duplicates = {
                name = 'Play no duplicates',
                text = {
                    'Play no hand containing',
                    'any {C:green}#1#{}'
                }
            },

            goal_baliatro_play_less_than_five = {
                name = 'Play less than five cards',
                text = {
                    'Play no hand containing',
                    'more than {C:attention}#1#{} cards'
                }
            },

            goal_baliatro_score_ten_hearts = {
                name = 'Score ten hearts',
                text = {
                    'Score {V:1}#2#{} suit cards',
                    'at least {C:attention}#1#{} time(s)'
                }
            },

            goal_baliatro_score_ten_diamonds = {
                name = 'Score ten diamonds',
                text = {
                    'Score {V:1}#2#{} suit cards',
                    'at least {C:attention}#1#{} time(s)'
                }
            },

            goal_baliatro_score_ten_spades = {
                name = 'Score ten spades',
                text = {
                    'Score {V:1}#2#{} suit cards',
                    'at least {C:attention}#1#{} time(s)'
                }
            },

            goal_baliatro_score_ten_clubs = {
                name = 'Score ten clubs',
                text = {
                    'Score {V:1}#2#{} suit cards',
                    'at least {C:attention}#1#{} time(s)'
                }
            },

            goal_baliatro_score_two_suits_fourteen_total = {
                name = 'Score two suits fourteen times',
                text = {
                    'Score {V:1}#2#{} or {V:2}#3#{} suit',
                    'cards at least {C:attention}#1#{} time(s)'
                }
            },

            goal_baliatro_score_three_ranks_five_total = {
                name = 'Score three ranks five times',
                text = {
                    'Score {C:attention}#2#{}, {C:attention}#3#{} or {C:attention}#4#{} rank',
                    'cards at least {C:attention}#1#{} time(s)'
                }
            },

            goal_baliatro_play_none_of_three_ranks = {
                name = 'Play none of three ranks',
                text = {
                    'Score no {C:attention}#1#{}, {C:attention}#2#{} or {C:attention}#3#{}',
                    'rank cards this round'
                }
            },

            goal_baliatro_play_none_of_suit = {
                name = 'Play none of suit',
                text = {
                    'Score no {V:1}#1#{}',
                    'suit cards this round'
                }
            },

            goal_baliatro_play_none_of_two_suits = {
                name = 'Play none of two suits',
                text = {
                    'Score no {V:1}#1#{} or {V:2}#2#{}',
                    'suit cards this round'
                }
            },

            goal_baliatro_win_in_one_hand = {
                name = 'Win in one hand',
                text = {
                    'Play at most {C:attention}#1#{} hand',
                }
            },

            goal_baliatro_play_three_hands = {
                name = 'Play three hands',
                text = {
                    'Play at least {C:attention}#1#{} hands',
                }
            },

            goal_baliatro_play_two_different_hands = {
                name = 'Play two different hands',
                text = {
                    'Play at least {C:attention}#1#{}',
                    'different hand(s)',
                }
            },

            goal_baliatro_play_one_hand_type = {
                name = 'Play one hand type',
                text = {
                    'Play no more than {C:attention}#1#{}',
                    'different hand(s)',
                }
            },

            goal_baliatro_score_at_least_three_quarters = {
                name = 'Score at least 75% in one hand',
                text = {
                    'Play a hand scoring at least',
                    '{C:attention}#1#%{} of Blind requirement',
                }
            },

            goal_baliatro_overscore_double = {
                name = 'Score at least 200% in one hand',
                text = {
                    'Play a hand scoring at least',
                    '{C:attention}#1#%{} of Blind requirement',
                }
            },

            goal_baliatro_overscore_ten_times = {
                name = 'Score at least 1000% in one hand',
                text = {
                    'Play a hand scoring at least',
                    '{C:attention}#1#%{} of Blind requirement',
                }
            },
        },
        Blind={
            bl_baliatro_wizard = {
                name = 'The Wizard',
                text = {
                    'Must play less',
                    'than 5 cards',
                }
            },
            bl_baliatro_steel = {
                name = 'The Steel',
                text = {
                    'Hands have -1 base',
                    'Mult for each time',
                    'they have been played',
                }
            },
            bl_baliatro_kingpin = {
                name = 'The Kingpin',
                text = {
                    'Your most scored Rank',
                    'is debuffed',
                }
            },
            bl_baliatro_rail = {
                name = 'The Rail',
                text = {
                    'Cards previously',
                    'not played this Ante',
                    'are debuffed'
                }
            },
            bl_baliatro_junkie = {
                name = 'The Junkie',
                text = {
                    'Cards previously discarded',
                    'this Ante are debuffed',
                },
            },
            bl_baliatro_muscle = {
                name = 'The Muscle',
                text = {
                    '#1# in 3 chance to randomize',
                    'the rank of each scored card.',
                },
            },
            bl_baliatro_proud = {
                name = 'The Proud',
                text = {
                    '#1# in 2 chance to randomize',
                    'the suit of each scored card.',
                },
            },
            bl_baliatro_ascetic = {
                name = 'The Ascetic',
                text = {
                    'Cards with Edition',
                    'are debuffed.',
                },
            },
            bl_baliatro_diplomat = {
                name = 'The Diplomat',
                text = {
                    'Cards with a Seal',
                    'are debuffed.',
                },
            },
            bl_baliatro_count = {
                name = 'The Count',
                text = {
                    'Numeric cards (except Aces)',
                    'are debuffed.',
                },
            },
            bl_baliatro_line = {
                name = 'The Line',
                text = {
                    'Cards after each',
                    'discard are drawn',
                    'face down.',
                },
            },
            bl_baliatro_saffron_shell = {
                name = 'Saffron Shell',
                text = {
                    'All cards return to your',
                    'deck. Returning cards',
                    'are debuffed.',
                },
            },
            bl_baliatro_turquoise_ladder = {
                name = 'Turquoise Ladder',
                text = {
                    'Cards remaining in hand',
                    'after each play or discard',
                    'become debuffed.',
                },
            },

            bl_manacle={
                name="The Manacle",
                text={
                    "-#1# Hand Size",
                },
            },
        },
        Edition={
            e_baliatro_photographic = {
                name = "Photographic",
                text = {
                    "{X:chips,C:white}X#1#{} Chips each time",
                    "this card scores or causes a",
                    "card to score {C:chips}Chips{}, {C:mult}Mult{} or {C:money}${}"
                }
            },
            e_baliatro_scenic = {
                name = "Scenic",
                text = {
                    "{C:attention}+#1#{} {C:chips}Chips{}. Add {C:attention}+#2#{} {C:chips}Chips{} to this each time",
                    "the card with this edition triggers,",
                    "increase the added amount by {C:attention}#3#%{}, and",
                    "subtract {C:attention}#4#%{} from the next increase.",
                }
            },
            e_baliatro_faded_foil = {
                name = "Faded Foil",
                text = {
                    "{C:chips}+#1#{} Chips",
                }
            },

            e_baliatro_haunted = {
                name = "Haunted",
                text = {
                    "Create #1# random {C:dark_edition}Ephemeral{} {C:tarot}Tarot{},",
                    "{C:spectral}Spectral{}, {C:planet}Planet{} or {C:attention}Postcard{}",
                    "{C:green}#2# in #3#{} chance to {C:red}destroy{} this card.",
                    "Affected card is considered {C:attention}Immortal{}.",
                    "When {C:attention}Blind{} is selected, transfer",
                    "this to another editionless card in full deck.",
                    "Leaves {C:dark_edition}Ectoplasmic{} behind.",
                }
            },
            e_baliatro_ectoplasmic = {
                name = "Ectoplasmic",
                text = {
                    "{X:mult,C:white}X#1#{} Mult",
                    "Removed after hand with this",
                    "card is scored.",
                }
            },
            e_baliatro_ethereal = {
                name = "Ethereal",
                text = {
                    "Cannot be {C:red}discarded{}.",
                    "Destroyed after any hand is played",
                    "or after any card is discarded.",
                }
            },
            e_baliatro_ephemeral = {
                name = "Ephemeral",
                text = {
                    "{C:dark_edition}+#1#{} consumable slot",
                    "Cannot be copied by {C:attention}Puck{}",
                    "Destroyed after #2# rounds if unused",
                    "{C:inactive}(#3# rounds remaining){}",
                }
            },
            e_baliatro_faded_holo = {
                name = "Faded Holographic",
                text = {
                    "{C:mult}+#1#{} Mult",
                }
            },
            e_baliatro_faded_polychrome = {
                name = "Faded Polychrome",
                text = {
                    "{X:mult,C:white}X#1#{} Mult",
                }
            },
            e_baliatro_pact = {
                name = "Pact",
                text = {
                    "{s:1.2,C:red}Price of Power{}",
                    "{s:0.7,C:red}The unannulable terms of this deal are the following{}",
                    "{C:dark_edition}+#2# Joker slot(s){}",
                    "Cannot be destroyed or debuffed.",
                    "Always applies the effect of a Blind",
                    "Applies: {C:attention}#1#{}",
                }
            },
        },
        Enhanced={
            m_baliatro_resistant = {
                name = 'Resistant Card',
                text = {
                    'Permanently gains',
                    '{C:mult}#1#{} Mult when scored.',
                    'Cannot be {C:red}debuffed{}',
                },
            },
            m_baliatro_mtx_common = {
                name = 'MTX Card',
                text = {
                    'Free tier MTX.',
                    '{X:chips,C:white}X#1#{} Chips',
                    '{C:attention}Value:{} {C:money}$#2#{}',
                },
            },
            m_baliatro_mtx_uncommon = {
                name = 'MTX Card',
                text = {
                    '{C:green}Uncommon{} tier MTX.',
                    '{X:chips,C:white}X#2#{} Chips',
                    '{C:money}-$#1#{} when scored',
                    '{C:attention}Value:{} {C:money}$#3#{}',
                },
            },
            m_baliatro_mtx_rare = {
                name = 'MTX Card',
                text = {
                    '{C:blue}Rare{} tier MTX.',
                    '{X:chips,C:white}X#2#{} Chips',
                    '{C:money}-$#1#{} when scored',
                    '{C:attention}Value:{} {C:money}$#3#{}',
                },
            },
            m_baliatro_mtx_epic = {
                name = 'MTX Card',
                text = {
                    '{C:tarot}Epic{} tier MTX.',
                    '{X:chips,C:white}X#2#{} Chips',
                    '{C:money}-$#1#{} when scored',
                    '{C:attention}Value:{} {C:money}$#3#{}',
                },
            },
        },
        Joker={
            j_mime={
                text={
                    "Retrigger all",
                    "card {C:attention}held in",
                    "{C:attention}hand{} abilities",
                    "{C:attention}#1#{} time(s)",
                },
            },
            j_sock_and_buskin={
                name="Sock and Buskin",
                text={
                    "Retrigger all",
                    "played {C:attention}face{} cards",
                    "{C:attention}#1#{} time(s)",
                },
                unlock={
                    "Play a total of",
                    "{C:attention,E:1}#1#{} face cards",
                    "{C:inactive}(#2#)",
                },
            },
            j_hack={
                name="Hack",
                text={
                    "Retrigger",
                    "each played",
                    "{C:attention}2{}, {C:attention}3{}, {C:attention}4{}, or {C:attention}5{}",
                    "{C:attention}#1#{} time(s)",
                },
            },
            j_baliatro_redulti = {
                ['name'] = 'Red Ulti',
                ['text'] = {
                    [1] = 'If in the {C:attention}final hand{} of the round,',
                    [2] = 'the only card scored is a {C:red}7 of Hearts{}',
                    [3] = 'then destroy it and this joker',
                    [4] = 'and win the blind'
                }
            },
            j_baliatro_eigenstate = {
                name = 'Eigenstate',
                text = {
                    'If played hand contains a {C:attention}Straight{}',
                    'and at least one {C:dark_edition}Edition{} card,',
                    'create a random {C:planet}Moon{} and an',
                    '{C:tarot}Ace of Wands{}',
                    '{C:inactive}(once per round, must have space){}'
                }
            },
            j_baliatro_sharpening_stone = {
                name = 'Sharpening Stone',
                text = {
                    '{C:mult}+#2#{} Mult. Remove any upgradable',
                    '{C:dark_edition}Edition{} from scored playing cards.',
                    'For each {C:dark_edition}Edition{} type removed in a hand,',
                    'upgrade that edition by {C:attention}#1#{} level.',
                    'Gains {C:mult}+#3#{} Mult per edition removed.'
                }
            },
            j_baliatro_pumpjack = {
                ['name'] = 'Pumpjack',
                ['text'] = {
                    [1] = 'Transfer up to #1# {C:mult}Mult{} to {C:chips}Chips{} when',
                    [2] = 'a played {C:dark_edition}Foil{} card is scored.',
                    [3] = 'Each repeat within the same hand is {X:mult,C:white}X#2#{}',
                    [4] = 'higher than the previous one.',
                    [5] = '{C:inactive}(at least 1 {C:mult}Mult{C:inactive} will remain){}',
                    [6] = '{C:inactive}(gains +#3# transfer and +X#4# multiplier per level of {C:attention}Foil{C:inactive}){}',
                }
            },
            j_baliatro_golden_mirror = {
                ['name'] = 'Golden Mirror',
                ['text'] = {
                    '{C:green}#1# in #2#{} chance to gain {C:money}$#4#{}',
                    ' when a {C:dark_edition}Holographic{} card is discarded.',
                    '{C:green}#1# in #3#{} add {C:dark_edition}Holographic{} to cards',
                    'discarded with another {C:dark_edition}Holographic{} card',
                    '{C:inactive}(card has +{C:money}$1{C:inactive} per #5# levels of Holographic){}',
                }
            },
            j_baliatro_meditation = {
                ['name'] = 'Meditation',
                ['text'] = {
                    [1] = "The first time each Blind you play",
                    [2] = "your {C:attention}least played hand{},",
                    [3] = "create 1 {C:spectral}Aura{} or {C:tarot}Ace of Wands{}.",
                }
            },
            j_baliatro_battery = {
                ['name'] = 'Battery',
                ['text'] = {
                    [1] = "Retrigger each {C:attention}scoring card{}",
                    [2] = "for each {C:green}unscoring card{} played.",
                    [3] = "Recharge #1# repeats, when 5 {C:attention}scoring cards{} are played",
                    [4] = "{C:inactive}(#2#/#3# repeats remaining, destroyed if this hits 0){}"
                }
            },
            j_baliatro_parade = {
                ['name'] = 'Parade',
                ['text'] = {
                    [1] = "{C:attention}Polychrome{} bonus increases by {C:mult}#1#%{} for that",
                    [2] = "hand only each time a {C:attention}Wild Card{} is scored.",
                }
            },
            j_baliatro_slot_machine = {
                ['name'] = 'Slot Machine',
                ['text'] = {
                    "Gain {C:money}$#1#{} if discarded",
                    "hand is {C:attention}#2#.{}",
                    "Otherwise, lose {C:money}$#3#{}.",
                    "{C:inactive}(Hand changes each time you discard){}"
                }
            },
            j_baliatro_undertaker = {
                ['name'] = 'Undertaker',
                ['text'] = {
                    "If any discarded hand only contains",
                    "one card, add {C:attention}#1#{} {C:dark_edition}Ethereal{}",
                    "copies of that card to your hand.",
                    "{C:inactive}(Ethereal overwrites existing edition){}",
                }
            },
            j_baliatro_gacha = {
                ['name'] = 'Gacha Joker',
                ['text'] = {
                    "When {C:attention}Blind{} is selected, add a ",
                    "random {C:red}playing card{} to your hand.",
                    "Add {C:dark_edition}Polychrome{} ({C:attention}#1#%{}), {C:dark_edition}Holographic{} ({C:attention}#2#%{})",
                    "or {C:dark_edition}Foil{} to this card. {C:green}#3# in #4# chance{}",
                    "to add a {C:dark_edition}Faded{} variant instead.",
                    "{C:mult}+#5#{} Mult when an {C:dark_edition}Edition{} card is scored."
                },
            },
            j_baliatro_daytrader = {
                ['name'] = 'Daytrader',
                ['text'] = {
                    "At the end of round,",
                    "gain {C:mult}+#1#{} Mult per {C:money}$#2#{}",
                    "of interest gained.",
                    "{C:inactive}(Currently has {C:mult}+#3#{C:inactive} Mult){}",
                },
            },
            j_baliatro_gallows_humour = {
                name = 'Gallows Humour',
                text = {
                    '{C:mult}+#1#{} Mult.',
                    'If scored hand is {C:attention}Pair{}, destroy a played,',
                    'unscored card. Gains {C:mult}+#2#{} Mult on trigger.',
                    'Add a random playing card of the deck at end',
                    'of round if this effect did not trigger.',
                    '{C:inactive}(Once per round){}',
                },
            },
            j_baliatro_killing_joke = {
                name = 'Killing Joke',
                text = {
                    '{C:mult}+#1#{} Mult.',
                    'If scored hand is {C:attention}Three of a Kind{}, convert',
                    'a random unscored card to an {C:attention}Immortal{} copy',
                    'of a random scored card. Gain {C:mult}+#2#{} Mult on trigger.',
                    '{C:inactive}(Once per round){}',
                },
            },
            j_baliatro_tempered_joker = {
                name = 'Tempered Joker',
                text = {
                    'If scored hand is {C:attention}Four of a Kind{}, gain',
                    '{C:money}dollars{} equal to the sell value of all',
                    'your jokers up to {C:money}$#2#{}, rounded down.',
                    '{C:mult}+#1#{} Mult when this triggers.',
                    '{C:inactive}(Once per round){}',
                    '{C:inactive}(Currently {C:money}$#3#{C:inactive}){}',
                },
            },
            j_baliatro_tax_collector = {
                name = 'Tax Collector',
                text = {
                    'Lose {C:money}$#2#{} per {C:blue}hand{} played.',
                    'Gain {C:money}$#1#{} when each suit is scored',
                    'for the first time in played hand.',
                    'A single card only counts as one suit.',
                },
            },
            j_baliatro_display_case = {
                name = 'Display Case',
                text = {
                    '{X:mult,C:white}X#1#{} Mult if played hand',
                    'contains any {C:dark_edition}Edition{} card.',
                },
            },
            j_baliatro_sinful_joker = {
                name = 'Sinful Joker',
                text = {
                    'All {C:attention}7{}s count as {C:dark_edition}Wild{} Cards.',
                    '{C:dark_edition}Wild{} cards cannot be debuffed by',
                    'The {C:clubs}Club{}, The {C:diamonds}Window{}, The {C:spades}Goad{}',
                    'or The {C:hearts}Head{}',
                },
            },
            j_baliatro_bibimbap = {
                name = 'Bibimbap',
                text = {
                    '{X:mult,C:white}X#1#{} Mult',
                    '-{X:mult,C:white}X#2#{} Mult, when you {C:attention}reroll{} the shop.',
                },
            },
            j_baliatro_effigy = {
                name = 'Effigy',
                text = {
                    'Retrigger scoring {C:attention}#2#{}',
                    'rank cards {C:attention}#1#{} times total.',
                    'This card may only retrigger each',
                    'played card up to {C:attention}#3#{} times.',
                    'Retriggers are split evenly between',
                    'all scoring cards of that rank.',
                    '{s:0.7}Rank changes each round, influenced by cards in deck{}',
                },
            },
            j_baliatro_chef_joker = {
                name = 'Chef Joker',
                text = {
                    'Scoring {C:chips}Bonus{} cards gain {C:chips}+#1#{} extra Chips when scored',
                    'Scoring {C:mult}Mult{} cards gain {C:mult}+#2#{} extra Mult when scored',
                    'Scoring {C:money}Gold{} cards gain {C:money}+$#3#{} extra dollars when scored',
                },
            },
            j_baliatro_landlord = {
                name = 'Landlord',
                text = {
                    '{X:mult,C:white}X#1#{} Mult if all other',
                    'Jokers are {C:chips}Common{}.',
                },
            },
            j_baliatro_scales = {
                name = 'Scales',
                text = {
                    '{X:mult,C:white}X#1#{} Mult. Hands change after each hand played.',
                    'Gain {X:mult,C:white}X#2#{} Mult if played hand is {C:attention}#3#{}',
                    'Otherwise, lose {X:mult,C:white}X#4#{} Mult.',
                    '{C:inactive}Gaining hand cannot be your most played hand{}',
                },
            },
            j_baliatro_puck = {
                name = 'Puck',
                text = {
                    'When any non-negative, non-ephemeral consumable',
                    'is played, create a {C:dark_edition}negative{} copy.',
                    'Does not work on legendary consumables:',
                    '{C:spectral}Soul{}, {C:spectral}Transcendence{}, {C:planet}Black Hole{}, {C:spectral}New York{}',
                },
            },
            j_baliatro_el_primo = {
                name = 'El Primo',
                text = {
                    'Vouchers can appear multiple times.',
                    'The shop has {C:attention}+#1#{} Voucher slot.',
                    '{C:inactive}Changes in voucher slot count activate{}',
                    '{C:inactive}after defeating a boss blind.{}'
                },
            },
            j_baliatro_fools_gambit = {
                name = "Fool's Gambit",
                text = {
                    'Editionless {C:dark_edition}Wild{} Cards gain {C:dark_edition}Polychrome{}',
                    'when scored. {C:green}#1# in #2# chance{} for added',
                    '{C:dark_edition}Polychrome{} not to be faded.',
                    '{C:red}Double{} the required scored for current ',
                    '{C:attention}Blind{} for each {C:dark_edition}Polychrome{} card in scoring hand.',
                },
            },
            j_baliatro_sevenfold_avenger = {
                name = "Sevenfold Avenger",
                text = {
                    'Every {C:dark_edition}7th{} time a {C:attention}7{}',
                    'is scored within a hand, {C:red}divide{} the',
                    'score required to beat current {C:attention}Blind{}',
                    'by {C:attention}7{}.',
                },
            },
            j_baliatro_triple_trouble = {
                name = "Triple Trouble",
                text = {
                    'The {C:dark_edition}3rd{} scored card each hand',
                    'grants {X:mult,C:white}X#1#{} Mult when scored.',
                    'If scored hand is {C:attention}Three of a Kind{}',
                    'and {C:dark_edition}3rd{} scoring card is not your',
                    'most scored {C:attention}Rank{}, this gains {X:mult,C:white}+X#2#{} Mult.'
                },
            },
            j_baliatro_appraiser_joker = {
                name = "Appraiser Joker",
                text = {
                    'Scoring cards grant {C:chips}Chips{}',
                    'equal to {C:attention}#1#{} times',
                    'the number of times their',
                    '{C:attention}Rank{} has been scored.',
                },
            },
            j_baliatro_favourite = {
                name = "The Favourite",
                text = {
                    '{X:mult,C:white}X#1#{} Mult if scored hand',
                    'contains your most scored {C:attention}Rank{}.',
                },
            },
            j_baliatro_straight_of_jokers = {
                name = "Straight of Jokers",
                text = {
                    'In the {C:dark_edition}Nth{} hand played each round,',
                    'retrigger the {C:dark_edition}Nth{} scoring card {C:dark_edition}N{} times.',
                    '{C:inactive}(in the next hand played, retrigger the card{}',
                    '{C:inactive}in position {C:attention}#1#{C:inactive}, {C:attention}#1#{C:inactive} time(s)){}',
                },
            },
            j_baliatro_jokers_of_a_kind = {
                name = "Jokers of a Kind",
                text = {
                    '{X:mult,C:white}X#1#{} Mult if the {C:dark_edition}Nth{} hand',
                    'played this round has {C:dark_edition}N{} scoring cards.',
                    '{C:inactive}(have {C:attention}#2#{C:inactive} scoring card(s) in the',
                    '{C:inactive}next played hand to trigger this joker){}',
                },
            },
            j_baliatro_hadron_collider = {
                name = "Hadron Collider",
                text = {
                    '{X:mult,C:white}X#1#{} Mult.',
                    'Gains {X:mult,C:white}+X#2#{} Mult if played hand',
                    'is the {C:attention}most played hand{} and',
                    'contains the {C:attention}least scored rank{}',
                    'or the {C:attention}least played hand{} and',
                    'contains the {C:attention}most scored rank{}',
                },
            },
            j_baliatro_katamari_joker = {
                name = "Katamari Joker",
                text = {
                    '{C:mult}+#1#{} Mult.',
                    'Gains {C:mult}+#2#{} Mult, when a card with',
                    'the most scored rank is scored.',
                },
            },
            j_baliatro_romeo = {
                name = "Romeo",
                text = {
                    'Scored {C:dark_edition}Wild Cards{} grant',
                    '{C:mult}+#1#{} Mult. Create {C:attention}#2#{} {C:tarot}Lovers{}',
                    'if scored contains a {C:attention}Flush{}',
                    'Gain {C:mult}-#3#{} Mult when a {C:tarot}Lovers{} is used.',
                },
            },
            j_baliatro_bodybuilder = {
                name = "Bodybuilder",
                text = {
                    '{C:mult}+#3#{} Mult',
                    'All scored cards have',
                    'a {C:green}#1# in #2# chance{}',
                    'to become one rank',
                    'higher when scored.',
                },
            },
            j_baliatro_tug_of_war = {
                name = "Tug of War",
                text = {
                    'If there are less cards in {C:attention}play{} than in {C:attention}hand{},',
                    'retrigger all scoring cards {C:attention}#1#{} times.',
                    'If there are less cards in {C:attention}hand{} than in {C:attention}play{},',
                    'retrigger all held in hand cards {C:attention}#1#{} times.',
                },
            },
            j_baliatro_bishop = {
                name = "The Bishop",
                text = {
                    'Retrigger the first scoring {C:chips}Bonus{} card',
                    '{C:attention}#1#{} time(s). If sum of ranks of scored',
                    'cards is {C:green}#2# to #3#{}, create {C:attention}#4#{} {C:tarot}Hierophant{}',
                    '{C:tarot}Hierophant{} played on any {C:attention}Enhanced{} card instead',
                    'permanently adds {C:chips}+#5#{} Chips to that card.',
                },
            },
            j_baliatro_queen = {
                name = "The Queen",
                text = {
                    'Retrigger the first scoring {C:mult}Mult{} card',
                    '{C:attention}#1#{} time(s). If sum of ranks of scored',
                    'cards is {C:green}#2# to #3#{}, create {C:attention}#4#{} {C:tarot}Empress{}',
                    '{C:tarot}Empress{} played on any {C:attention}Enhanced{} card instead',
                    'permanently adds {C:mult}+#5#{} Mult to that card.',
                },
            },
            j_baliatro_knight = {
                name = "The Knight",
                text = {
                    'Retrigger the first scoring {C:money}Lucky{} card',
                    '{C:attention}#1#{} time(s). If hand contains 5 scoring',
                    'cards and no enhancements, create {C:attention}#2#{} {C:tarot}Magician{}',
                    '{C:tarot}Magician{} played on any {C:attention}Enhanced{} card instead',
                    'permanently adds {C:money}+$#3#{} to that card.',
                },
            },
            j_baliatro_rook = {
                name = "The Rook",
                text = {
                    'Retrigger the first scoring {C:tarot}Stone{} card',
                    '{C:attention}#1#{} time(s). {C:tarot}Stone{} cards have all suits.',
                    'If hand contains a {C:attention}Flush{}, create {C:attention}#2#{} {C:tarot}Tower{}',
                    '{C:tarot}Tower{} played on any {C:attention}Enhanced{} card instead',
                    'permanently adds {X:mult,C:white}+X#3#{} to that card.',
                },
            },
            j_baliatro_pawn = {
                name = "The Pawn",
                text = {
                    'Retrigger all {C:tarot}Resistant{} cards {C:attention}#1#{} time(s).',
                    'If a hand triggers the boss ability,',
                    'create {C:attention}#2#{} {C:tarot}Ace of Pentacles{}.',
                },
            },
            j_baliatro_en_passant = {
                name = "En Passant",
                text = {
                    'Before scoring, remove the {C:attention}Enhancement{}',
                    'from the first scoring {C:attention}Enhanced{} card and',
                    'give it to the two adjacent scoring cards,',
                    'then remove the {C:attention}Seal{} from the first',
                    'scoring {C:attention}Sealed{} card and give it to',
                    'the two adjacent scoring cards.',
                    '{C:inactive}(does not remove enhancement or seal if pointless){}'
                },
            },
            j_baliatro_one_e_four = {
                name = "1. e4",
                text = {
                    'If no {C:red}discards{} have been used and',
                    'the first hand of the round is five scoring,',
                    '{C:attention}plain{} cards, create {C:attention}#1#{} random',
                    '{C:spectral}Spectral{} card. {C:green}#2# in #3#{} chance to',
                    'create a {C:attention}Postcard{} instead.',
                },
            },
            j_baliatro_one_e_five = {
                name = "1. ... e5",
                text = {
                    'If no {C:red}discards{} have been used and',
                    'the second hand of the round is five scoring,',
                    '{C:attention}plain{} cards, create {C:attention}#1#{} random',
                    '{C:tarot}Tarot{} cards.',
                },
            },
            j_baliatro_real_estate = {
                name = "Real Estate",
                text = {
                    "{X:mult,C:white}X#1#{} Mult. All current and",
                    "future copies of this Joker",
                    "gain {X:mult,C:white}+X#2#{} Mult each time",
                    "this Joker is sold.",
                },
            },
            j_baliatro_sandbag = {
                name = "Sandbag",
                text = {
                    "{X:mult,C:white}X#1#{} Mult.",
                    "{C:attention}+#2#{} hands per round.",
                },
            },

            j_baliatro_lesser_demon = {
                name = "Lesser Demon",
                text = {
                    "If played hand is {C:attention}Three of a Kind{}",
                    "of {C:attention}6{}, and has no other cards",
                    "create {C:attention}#1#{} {C:tarot}Devil{}. {C:money}Gold cards{} held",
                    "in hand grant {C:mult}+#2#{} Mult."
                },
            },
            j_baliatro_afterimage = {
                name = "Afterimage",
                text = {
                    "If {C:attention}first hand of round{} contains only one",
                    "card, destroy it. If a card was destroyed this",
                    "way in current round, after each {C:red}discard{} or",
                    "{C:blue}hand played{}, add an {C:dark_edition}Ethereal{} copy of it to hand",
                    "{s:0.8,C:inactive}#1#{}"
                },
            },
            j_baliatro_echo = {
                name = "Echo",
                text = {
                    "{C:attention}+#1#{} Hand Size",
                    "After each {C:red}discard{} or {C:blue}hand{}",
                    "played, add a random {C:dark_edition}Ethereal{}",
                    "playing card to your hand.",
                },
            },
            j_baliatro_monolith = {
                name = "Monolith",
                text = {
                    "{C:mult}+#1#{} Mult if",
                    "hand played is not",
                    "your {C:attention}most played hand{}",
                },
            },
            j_baliatro_sicilian_defence = {
                name = "Sicilian Defence",
                text = {
                    "{C:mult}+#1#{} Mult if",
                    "all cards in scored",
                    "hand are {C:attention}plain{}",
                },
            },
            j_baliatro_whale = {
                name = "Whale Joker",
                text = {
                    "{C:money}-$#1#{} each hand played.",
                    "After hand is scored, a",
                    "random scoring unenhanced card",
                    "becomes a {C:attention}MTX{} Card."
                },
            },
            j_baliatro_vapor_marketplace = {
                name = "Vapor Marketplace",
                text = {
                    "After hand is scored, remove",
                    "{C:attention}MTX{} enhancements",
                    "from all scored cards and gain",
                    "dollars based on their value."
                },
            },
            j_baliatro_battle_pass = {
                name = "Battle Pass",
                text = {
                    "{C:money}-$#1#{} when {C:attention}Blind{} is selected.",
                    "At the end of round, some unenhanced",
                    "cards in deck may become",
                    "{C:attention}MTX{} cards."
                },
            },
            j_baliatro_all_in = {
                name = "All In",
                text = {
                    "Before scoring, permanently grant the {C:attention}leftmost{}",
                    "scored card {C:chips}chips{} equal to the {C:chips}base chip value{}",
                    "of all other scored cards. After scoring,",
                    "{C:attention}non-leftmost{} cards permanently lose {C:chips}chips{}",
                    "equal to their {C:chips}base chip value{}.",
                },
            },
            j_baliatro_elephant = {
                name = "The Elephant",
                text = {
                    'Retrigger the first {C:attention}Gold{} card held in hand',
                    '{C:tarot}Devil{} played on any {C:attention}Enhanced{} card instead',
                    'permanently adds {X:chips,C:white}+X#2#{} Chips when held in',
                    'hand to that card.',
                },
            },
            j_baliatro_vanilla_beans = {
                name = "Vanilla Beans",
                text = {
                    '{X:mult,C:white}X#1#{} Mult. Loses {X:mult,C:white}X#2#{} Mult after any',
                    'hand with a scoring non-{C:attention}Plain{} card',
                    'is scored.',
                },
            },
            j_baliatro_blank_card = {
                name = "Blank Card",
                text = {
                    '{C:attention}Saturated{} cards held in hand grant',
                    '{X:chips,C:white}X#1#{} Chips, and an additional {X:chips,C:white}X#2#{} Chips',
                    'for each {C:attention}Plain{} card in scoring hand.',
                },
            },
            j_baliatro_frequent_flyer_card = {
                name = "Frequent Flyer Card",
                text = {
                    'Gain {C:chips}#1#%{} of your',
                    'total Chips as Mult.',
                },
            },
            -- upgraded jokers
            j_baliatro_jimbo = {
                name = "Jimbo",
                text = {
                    "{X:mult,C:white}X#1#{} Mult"
                }
            },
            j_baliatro_moissanite = {
                name = "Moissanite",
                text = {
                    "Played cards with {C:diamonds}Diamond{} suit",
                    "give {X:mult,C:white}X#1#{} {C:mult}Mult{} when scored",
                }
            },
            j_baliatro_obsidian = {
                name = "Obsidian",
                text = {
                    "Played cards with {C:spades}Spade{} suit",
                    "become {C:attention}Glass{} before scoring,",
                    "overriding any other enhancement.",
                }
            },

            j_baliatro_labradorite = {
                name = "Labradorite",
                text = {
                    "Played cards with {C:clubs}Clubs{} suit",
                    "gain {X:mult,C:white}+X#1#{} when scored.",
                }
            },

            j_baliatro_swing = {
                name = "The Swing",
                text = {
                    "{X:mult,C:white}X#1#{} {C:mult}Mult{} if played hand",
                    "contains a {C:attention}Two Pair{}",
                }
            },
            j_baliatro_missing_half = {
                name = "The Missing Half",
                text = {
                    "{X:mult,C:white}X#1#{} {C:mult}Mult{} if played hand",
                    "contains {C:attention}#2#{} or fewer cards",
                }
            },
            j_baliatro_platinum_card = {
                name = "Platinum Card",
                text = {
                    "Go up to {C:red}-$#1#{} in debt.",
                    "Earn {C:attention}Interest{} as if you have",
                    "{C:money}$#2#{} more than you actually have."
                }
            },
            j_baliatro_crest = {
                name = "Crest",
                text = {
                    "{X:mult,C:white}X#1#{} {C:mult}Mult{} for each",
                    "remaining discard",
                    "{C:inactive}(stacks multiplicatively){}",
                    "{C:inactive}(currently will give {X:mult,C:inactive}X#2#{C:mult} Mult{C:inactive}){}"
                }
            },
            j_baliatro_glacier = {
                name = "Glacier",
                text = {
                    "{X:mult,C:white}X#1#{} {C:mult}Mult{} when",
                    "0 {C:red}discards{} remaining",
                }
            },
            j_baliatro_actually_magic_8_ball = {
                name = "Actually Magic 8 Ball",
                text = {
                    "{C:green}#1# in #2# chance{} for each played",
                    "{C:attention}8{} to create a {C:attention}Negative{}",
                    "{C:tarot}Tarot{}, {C:planet}Planet{}, {C:spectral}Spectral{}, or",
                    "{C:attention}Postcard{} when scored",
                },
            },
            j_baliatro_psinmitr = {
                name = "psinMitr",
                text = {
                    "{X:mult,C:white}X#1#-#2#{} {C:mult}Mult{} randomly",
                },
            },
            j_baliatro_union_joker = {
                name = "Union Joker",
                text = {
                    "{X:mult,C:white}X#1#{} {C:mult}Mult{} times the rank of lowest",
                    "ranked card held in hand",
                    "{C:inactive}(example: {C:red}4{C:inactive} would give {X:mult,C:inactive}X2{C:mult} Mult{C:inactive}){}"
                }
            },
            j_baliatro_chaos_with_crown = {
                name = "Chaos with Crown",
                text = {
                    "{C:attention}#1#{} free {C:attention}Reroll{} per shop.",
                    "{C:attention}#2#{} {C:attention}Reroll{} each shop also rerolls",
                    "unopened {C:attention}Booster Packs{}.",
                }
            },
            j_baliatro_stencil_joker = {
                name = "Stencil Joker",
                text = {
                    "{X:mult,C:white}X#1#{} {C:mult}Mult{} for each Joker card",
                    "{C:inactive}(Stencil Joker included){}",
                    "{C:inactive}(Currently {X:mult,C:inactive}X#2#{C:mult} Mult{C:inactive}){}"
                },
            },
            j_baliatro_goldfinger = {
                name = "Goldfinger",
                text = {
                    "{X:mult,C:white}X#1#{} {C:mult}Mult{}",
                    "{C:green}#2# in #3# chance{} this card",
                    "is destroyed at the end of round",
                }
            },
            j_baliatro_mind_the_gap = {
                name = "Mind The Gap",
                text = {
                    "{X:mult,C:white}+X#1#{} {C:mult}Mult{} for each consecutive",
                    "hand played without a scoring face card",
                    "{C:inactive}(Currently has {X:mult,C:inactive}X#2#{C:mult} Mult{C:inactive}){}"
                }
            },
            j_baliatro_turquoise_joker = {
                name = "Turquoise Joker",
                text = {
                    "{X:mult,C:white}+X#1#{} {C:mult}Mult{} when a hand is played",
                    "{X:mult,C:white}-X#2#{} {C:mult}Mult{} when a hand is discarded",
                    "{C:inactive}(Currently has {X:mult,C:inactive}X#3#{C:mult} Mult{C:inactive}){}"
                }
            },
            j_baliatro_black_card = {
                name = "Black Card",
                text = {
                    "{X:mult,C:white}+X#1#{} {C:mult}Mult{} when skipping",
                    "a {C:attention}Booster Pack{}",
                    "{C:inactive}(Currently has {X:mult,C:inactive}X#2#{C:mult} Mult{C:inactive}){}"
                }
            },
            j_baliatro_cube_joker = {
                name = "Cube Joker",
                text = {
                    "This Joker gains {C:chips}Chips{} equal",
                    "to each scored card's {C:chips}Chips{}",
                    "excluding those granted by Edition,",
                    "if played hand has exactly 4 Cards.",
                    "{C:inactive}(Currently has {C:attention}#1#{C:chips} Chips{C:inactive}){}"
                }
            },
            j_baliatro_peanut_gallery = {
                name = "Peanut Gallery",
                text = {
                    "When {C:attention}Blind{} is selected,",
                    "if you have {C:attention}#1#{} or less Jokers,",
                    "create #2# {C:attention}Negative{} {C:blue}Common{} jokers.",
                }
            },
            j_baliatro_hanginger_chad = {
                name = "Hanginger Chad",
                text = {
                    "{C:attention}Retrigger{} first played card used",
                    "in scoring {C:attention}#1#{} additional times.",
                }
            },
            j_baliatro_aceology_phd = {
                name = "Aceology PhD",
                text = {
                    "The first {C:attention}Ace{} scored in each hand",
                    "grants {C:mult}Mult{} equal to {C:attention}#2# time(s){}",
                    "its {C:chips}Chips{} value and {X:mult,C:white}X#1#{} Mult",
                },
            },
            j_baliatro_marathon_runner = {
                name = "Marathon Runner",
                text = {
                    "Create a number by concatenating the 2 lowest, single-digit",
                    "ranks in the scoring hand. Gain that many {C:chips}Chips{} if",
                    "played hand is a {C:attention}Straight{}. Uses the 3 lowest",
                    "instead if hand is a {C:attention}Straight Flush{}.",
                    "{C:inactive}(Only cards with single digit ranks are counted){}",
                    "{C:inactive}(Currently has {C:attention}#1#{C:chips} Chips{C:inactive}){}"
                }
            },
            j_baliatro_indigo_joker = {
                name = "Indigo Joker",
                text = {
                    "{X:mult,C:white}X#1#{} {C:mult}Mult{} for each card",
                    "remaining in deck.",
                    "Cannot grant less than {X:mult,C:white}X1{}",
                    "{C:inactive}(Currently grants {X:mult,C:inactive}X#2#{C:mult} Mult{C:inactive}){}"
                }
            },
            j_baliatro_bad_trip = {
                name = "Bad Trip",
                text = {
                    "{C:green}#1# in #2# chance{} to create a {C:attention}Negative{}",
                    "{C:tarot}Tarot{}, {C:planet}Planet{}, {C:spectral}Spectral{} or {C:attention}Postcard{},",
                    "when any {C:attention}Booster Pack{} is opened",
                },
            },
            j_baliatro_bailout = {
                name = "Bailout",
                text = {
                    "Played {C:attention}Face{} cards give {C:money}$#1#{} and",
                    "{C:mult}Mult{} equal to {C:attention}#2# time(s){}",
                    "your {C:money}dollars{} when scored.",
                },
            },
            j_baliatro_oracle = {
                name = "Oracle",
                text = {
                    "{X:mult,C:white}+X#1#{} {C:mult}Mult{} per {C:attention}Tarot{}",
                    "card used this run.",
                    "{C:inactive}(Currently {X:mult,C:inactive}X#2#{C:mult} Mult{C:inactive}){}",
                },
            },
            j_baliatro_uneven_freeman = {
                name = "Uneven Freeman",
                text = {
                    "Played cards with {C:attention}odd rank{}",
                    "permanently gain {C:chips}+#1#{} Chips",
                    "when scored.",
                },
            },
            j_baliatro_multiple_of_two_lou = {
                name = "Multiple of Two Lou",
                text = {
                    "Played cards with {C:attention}even rank{}",
                    "permanently gain {C:mult}+#1#{} Mult",
                    "when scored.",
                },
            },
            j_baliatro_senior_appraiser_joker = {
                name = "Senior Appraiser Joker",
                text = {
                    "Scoring cards grant {C:mult}Mult{}",
                    "equal to {C:attention}#1#{} time(s)",
                    "the number of times their {C:attention}Rank{}",
                    "has been scored.",
                },
            },
            j_baliatro_king_of_all_cosmos = {
                name = "King of All Cosmos",
                text = {
                    "{X:mult,C:white}X#1#{} Mult. Gain {X:mult,C:white}+X#2#{} Mult,",
                    "when a card with the most",
                    "scored {C:attention}Rank{} is scored.",
                },
            },
            j_baliatro_splatter = {
                name = "Splatter",
                text = {
                    "Every {C:attention}played card{}",
                    "and the leftmost {C:attention}#1#{} cards",
                    "held in hand count in scoring.",
                    "{C:inactive}Multiple copies of this effect{}",
                    "{C:inactive}increase the number of cards used{}",
                },
            },
            j_baliatro_il_vaticano = {
                name = "Il Vaticano",
                text = {
                    'Before scoring, remove the {C:attention}Seal{} ',
                    'from the first scoring {C:attention}Sealed{} card',
                    'and give it to the two adjacent scoring cards,',
                    'then remove the {C:dark_edition}Edition{} from the first',
                    'scoring non-{C:attention}Immortal{} {C:dark_edition}Edition{} card and give',
                    'it to the two adjacent scoring cards.',
                    '{C:inactive}(does not remove edition or seal if pointless){}'
                },
            },
            -- Pacts and Punishment
            j_baliatro_punishment_devils_scorn = {
                name = "The Devil's Scorn",
                text = {
                    "{s:1.2,C:red}Hell Hath Fury{}",
                    "{C:dark_edition}Audience with the Devil cannot appear{}",
                    "{s:0.8,C:red}You didn't believe punishment was avoidable, did you?{}"
                },
            },
            j_baliatro_pact_unseen_potential = {
                name = "Unseen Potential",
                text = {
                    "{s:1.2,C:red}Deal with the Devil{}",
                    "{C:dark_edition}+#1# Joker slot(s){}",
                },
            },
            j_baliatro_pact_dangerous_potential = {
                name = "Dangerous Potential",
                text = {
                    "{s:1.2,C:red}Deal with the Devil{}",
                    "{C:dark_edition}+#1# Joker slot(s){}",
                },
            },
            j_baliatro_pact_treacherous_potential = {
                name = "Treacherous Potential",
                text = {
                    "{s:1.2,C:red}Deal with the Devil{}",
                    "{C:dark_edition}+#1# Joker slot(s){}",
                    "{s:0.7,C:red}Destroy a random Joker (including Eternal) when selecting{}",
                    "{s:0.7,C:red}a Blind if you have no non-negative Common jokers.{}",
                },
            },
            j_baliatro_pact_unseen_might = {
                name = "Unseen Might",
                text = {
                    "{s:1.2,C:red}Deal with the Devil{}",
                    "{C:dark_edition}+#1# Consumable slot(s){}",
                },
            },
            j_baliatro_pact_dangerous_might = {
                name = "Dangerous Might",
                text = {
                    "{s:1.2,C:red}Deal with the Devil{}",
                    "{C:dark_edition}+#1# Consumable slot(s){}",
                },
            },
            j_baliatro_pact_treacherous_might = {
                name = "Treacherous Might",
                text = {
                    "{s:1.2,C:red}Deal with the Devil{}",
                    "{C:dark_edition}+#1# Consumable slot(s){}",
                    "{s:0.7,C:red}Each empty consumable slot grants {s:0.7,X:mult,C:white}X#2#{s:0.7,C:red} Mult{}",
                    "{s:0.7,C:red}Jokers appear in the shop {s:0.7,X:green,C:white}X#3#{s:0.7,C:red} more often.{}",
                },
            },
            j_baliatro_pact_unseen_fingers = {
                name = "Unseen Fingers",
                text = {
                    "{s:1.2,C:red}Deal with the Devil{}",
                    "{C:dark_edition}+#1# hand size{}",
                },
            },
            j_baliatro_pact_dangerous_fingers = {
                name = "Dangerous Fingers",
                text = {
                    "{s:1.2,C:red}Deal with the Devil{}",
                    "{C:dark_edition}+#1# hand size{}",
                },
            },
            j_baliatro_pact_treacherous_fingers = {
                name = "Treacherous Fingers",
                text = {
                    "{s:1.2,C:red}Deal with the Devil{}",
                    "{C:dark_edition}+#1# hand size{}",
                    "{s:0.7,C:red}Played and discarded cards return to your deck.{}",
                },
            },
            j_baliatro_pact_unseen_riches = {
                name = "Unseen Riches",
                text = {
                    "{s:1.2,C:red}Deal with the Devil{}",
                    "{C:dark_edition}Gain {C:money}$#1#{C:dark_edition} at end of round{}",
                },
            },
            j_baliatro_pact_dangerous_riches = {
                name = "Dangerous Riches",
                text = {
                    "{s:1.2,C:red}Deal with the Devil{}",
                    "{C:dark_edition}Gain {C:money}$#1#{C:dark_edition} at end of round{}",
                },
            },
            j_baliatro_pact_treacherous_riches = {
                name = "Treacherous Riches",
                text = {
                    "{s:1.2,C:red}Deal with the Devil{}",
                    "{C:dark_edition}Gain {C:money}$#1#{C:dark_edition} at end of round{}",
                    "{s:0.7,C:red}But only when you have at most {s:0.7,C:money}$#2#{}",
                },
            },
            j_baliatro_pact_unseen_quality = {
                name = "Unseen Quality",
                text = {
                    "{s:1.2,C:red}Deal with the Devil{}",
                    "{C:dark_edition}Cards have a higher likelyhood{}",
                    "{C:dark_edition}to be of less frequent rarities{}",
                },
            },
            j_baliatro_pact_dangerous_quality = {
                name = "Dangerous Quality",
                text = {
                    "{s:1.2,C:red}Deal with the Devil{}",
                    "{C:dark_edition}Cards have a higher likelyhood{}",
                    "{C:dark_edition}to be of less frequent rarities{}",
                },
            },
            j_baliatro_pact_treacherous_quality = {
                name = "Treacherous Quality",
                text = {
                    "{s:1.2,C:red}Deal with the Devil{}",
                    "{C:dark_edition}Cards have a higher likelyhood{}",
                    "{C:dark_edition}to be of less frequent rarities{}",
                    "{s:0.7,C:red}Unpurchased non-Common Jokers sometimes{}",
                    "{s:0.7,C:red}become banned when rerolling the shop.{}",
                },
            },
            j_baliatro_pact_unseen_fortune = {
                name = "Unseen Fortune",
                text = {
                    "{s:1.2,C:red}Deal with the Devil{}",
                    "{X:green,C:white}X#1#{C:dark_edition} to all listed probabilities{}",
                },
            },
            j_baliatro_pact_dangerous_fortune = {
                name = "Dangerous Fortune",
                text = {
                    "{s:1.2,C:red}Deal with the Devil{}",
                    "{X:green,C:white}X#1#{C:dark_edition} to all listed probabilities{}",
                },
            },
            j_baliatro_pact_treacherous_fortune = {
                name = "Treacherous Fortune",
                text = {
                    "{s:1.2,C:red}Deal with the Devil{}",
                    "{X:green,C:white}X#1#{C:dark_edition} to all listed probabilities{}",
                    "{s:0.7,C:red}On average. Statistically. Over some indeterminate timeframe.{}",
                },
            },
            j_baliatro_pact_unseen_plenty = {
                name = "Unseen Plenty",
                text = {
                    "{s:1.2,C:red}Deal with the Devil{}",
                    "{C:dark_edition}Create a copy of any non-legendary Tarot,{}",
                    "{C:dark_edition}Planet or Spectral card used in a Booster Pack.{}",
                    "{C:inactive}(must have room){}"
                },
            },
            j_baliatro_pact_dangerous_plenty = {
                name = "Dangerous Plenty",
                text = {
                    "{s:1.2,C:red}Deal with the Devil{}",
                    "{C:dark_edition}Create a copy of any non-legendary Tarot,{}",
                    "{C:dark_edition}Planet or Spectral card used in a Booster Pack.{}",
                    "{C:inactive}(must have room){}"
                },
            },
            j_baliatro_pact_treacherous_plenty = {
                name = "Treacherous Plenty",
                text = {
                    "{s:1.2,C:red}Deal with the Devil{}",
                    "{C:dark_edition}Create a copy of any non-legendary Tarot,{}",
                    "{C:dark_edition}Planet or Spectral card used in a Booster Pack.{}",
                    "{C:inactive}(must have room){}",
                    "{s:0.7,C:red}X#1# to the base cost of all Booster Packs.{}",
                },
            },
            j_baliatro_pact_unseen_craftmanship = {
                name = "Unseen Craftmanship",
                text = {
                    "{s:1.2,C:red}Deal with the Devil{}",
                    "{C:green}#1# in #2# chance{C:dark_edition} for upgradable Jokers in{}",
                    "{C:dark_edition}shop to be sold already upgraded.{}",
                },
            },
            j_baliatro_pact_dangerous_craftmanship = {
                name = "Dangerous Craftmanship",
                text = {
                    "{s:1.2,C:red}Deal with the Devil{}",
                    "{C:green}#1# in #2# chance{C:dark_edition} for upgradable Jokers in{}",
                    "{C:dark_edition}shop to be sold already upgraded.{}",
                },
            },
            j_baliatro_pact_treacherous_craftmanship = {
                name = "Treacherous Craftmanship",
                text = {
                    "{s:1.2,C:red}Deal with the Devil{}",
                    "{C:green}#1# in #2# chance{C:dark_edition} for upgradable Jokers in{}",
                    "{C:dark_edition}shop to be sold already upgraded.{}",
                    "{s:0.7,C:red}#1# in #3# chance for any card in shop to become Wheel of Fortune{}",
                },
            },
            -- Override jokers
            j_to_the_moon={
                name="To the Moon",
                text={
                    "{C:money}+$#1#{} {C:attention}interest{} per $5 held",
                },
            },
        },
        Loot={
            c_baliatro_money = {
                name = "Money",
                text = {
                    "Grants {C:money}$#1#{} when used.",
                }
            },
        },
        LootPlaceholder={
            lp_baliatro_two_common_joker = {
                name = "Two Common Jokers",
                text = {
                    "Grants {C:attention}2{} {C:blue}Common{}",
                    "Jokers when claimed.",
                }
            },
            lp_baliatro_four_common_joker = {
                name = "Four Common Jokers",
                text = {
                    "Grants {C:attention}4{} {C:blue}Common{}",
                    "Jokers when claimed.",
                }
            },
            lp_baliatro_six_common_joker = {
                name = "Six Common Jokers",
                text = {
                    "Grants {C:attention}6{} {C:blue}Common{}",
                    "Jokers when claimed.",
                }
            },
            lp_baliatro_negative_common_joker = {
                name = "Negative Common Joker",
                text = {
                    "Grants {C:attention}1{} {C:dark_edition}Negative{}",
                    "{C:blue}Common{} Joker when claimed.",
                }
            },
            lp_baliatro_eternal_rare_joker = {
                name = "Eternal Rare Joker",
                text = {
                    "Grants {C:attention}1{} {C:attention}Eternal{}",
                    "{C:red}Rare{} Joker when claimed."
                }
            },
            lp_baliatro_rare_joker = {
                name = "Rare Joker",
                text = {
                    "Grants {C:attention}1{} {C:red}Rare{}",
                    "Joker when claimed."
                }
            },
            lp_baliatro_uncommon_joker = {
                name = "Uncommon Joker",
                text = {
                    "Grants {C:attention}1{} {C:green}Uncommon{}",
                    "Joker when claimed."
                }
            },
            lp_baliatro_two_uncommon_jokers = {
                name = "Two Uncommon Jokers",
                text = {
                    "Grants {C:attention}2{} {C:green}Uncommon{}",
                    "Jokers when claimed."
                }
            },
            lp_baliatro_small_dollars = {
                name = "Lump of Coins",
                text = {
                    "Grants {C:money}$5-$10{}",
                    "when claimed."
                }
            },
            lp_baliatro_medium_dollars = {
                name = "Bag of Coins",
                text = {
                    "Grants {C:money}$10-$20{}",
                    "when claimed."
                }
            },
            lp_baliatro_big_dollars = {
                name = "Stack of Bills",
                text = {
                    "Grants {C:money}$20-$40{}",
                    "when claimed."
                }
            },
            lp_baliatro_foil_joker = {
                name = "Foil Joker",
                text = {
                    "Grants {C:attention}1{} {C:dark_edition}Foil{}",
                    "Joker when claimed."
                }
            },
            lp_baliatro_holo_joker = {
                name = "Holographic Joker",
                text = {
                    "Grants {C:attention}1{} {C:dark_edition}Holographic{}",
                    "Joker when claimed."
                }
            },
            lp_baliatro_polychrome_joker = {
                name = "Polychrome Joker",
                text = {
                    "Grants {C:attention}1{} {C:dark_edition}Polychrome{}",
                    "Joker when claimed."
                }
            },
            lp_baliatro_photographic_joker = {
                name = "Photographic Joker",
                text = {
                    "Grants {C:attention}1{} {C:dark_edition}Photographic{}",
                    "Joker when claimed."
                }
            },
            lp_baliatro_scenic_joker = {
                name = "Scenic Joker",
                text = {
                    "Grants {C:attention}1{} {C:dark_edition}Scenic{}",
                    "Joker when claimed."
                }
            },
            lp_baliatro_negative_uncommon_joker = {
                name = "Negative Uncommon Joker",
                text = {
                    "Grants {C:attention}1{} {C:dark_edition}Negative{}",
                    "{C:green}Uncommon{} Joker when claimed."
                }
            },
            lp_baliatro_negative_rare_joker = {
                name = "Negative Rare Joker",
                text = {
                    "Grants {C:attention}1{} {C:dark_edition}Negative{}",
                    "{C:red}Rare{} Joker when claimed."
                }
            },
            lp_baliatro_legendary_joker = {
                name = "Legendary Joker",
                text = {
                    "Grants {C:attention}1{} {C:legendary}Legendary{}",
                    "Joker when claimed."
                }
            },
            lp_baliatro_upgraded_joker = {
                name = "Upgraded Joker",
                text = {
                    "Grants {C:attention}1{} {C:purple}Upgraded{}",
                    "Joker when claimed."
                }
            },
            lp_baliatro_four_tarot_cards = {
                name = "Four Tarot Cards",
                text = {
                    "Grants {C:attention}4{} {C:tarot}Tarot{}",
                    "cards when claimed."
                }
            },
            lp_baliatro_two_spectral_cards = {
                name = "Two Spectral Cards",
                text = {
                    "Grants {C:attention}2{} {C:spectral}Spectral{}",
                    "cards when claimed."
                }
            },
            lp_baliatro_postcard = {
                name = "Postcard",
                text = {
                    "Grants {C:attention}1{} {C:attention}Postcard{}",
                    "when claimed."
                }
            },
            lp_baliatro_voucher = {
                name = "Voucher",
                text = {
                    "Grants {C:attention}1{} {C:attention}Voucher{}",
                    "when claimed."
                }
            },
            lp_baliatro_six_playing_cards = {
                name = "Six Playing Cards",
                text = {
                    "Grants {C:attention}6{} playing",
                    "cards when claimed."
                }
            },
            lp_baliatro_two_saturated_playing_cards = {
                name = "Two Saturated Playing Cards",
                text = {
                    "Grants {C:attention}2{} {C:attention}Saturated{}",
                    "playing cards when claimed."
                }
            },
            lp_baliatro_four_planets = {
                name = "Four Planets",
                text = {
                    "Grants {C:attention}4{} {C:planet}Planet{}",
                    "cards when claimed."
                }
            },
            lp_baliatro_four_mirrored_planets = {
                name = "Four Identical Planets",
                text = {
                    "Grants {C:attention}4{} copies",
                    "of a {C:planet}Planet{} card",
                    "when claimed."
                }
            },
            lp_baliatro_four_negative_planets = {
                name = "Four Negative Planets",
                text = {
                    "Grants {C:attention}4{} {C:dark_edition}Negative{}",
                    "{C:planet}Planet{} cards when claimed."
                }
            },
            lp_baliatro_crystal_ball = {
                name = "Crystal Ball",
                text = {
                    "Grants {C:attention}1{} {C:purple}Crystal Ball{}",
                    "{C:attention}Voucher{} when claimed."
                }
            },
        },
        Other={
            undiscovered_postcard = {
                name = "Not Discovered",
                text = {
                    "Purchase or use",
                    "this Postcard in",
                    "an unseeded run to",
                    "learn what it does.",
                }
            },
            undiscovered_baliatro_postcard = {
                name = "Not Discovered",
                text = {
                    "Purchase or use",
                    "this Postcard in",
                    "an unseeded run to",
                    "learn what it does.",
                }
            },
            baliatro_mortgage = {
                name = "Mortgage",
                text = {
                    "Cannot be sold while Mortgaged.",
                    "When a blind is selected or skipped, lose {C:money}$#1#{}",
                    "If you go into debt, destroy all jokers,",
                    "including {C:attention}Eternal{} and {C:attention}Mortgage{}.",
                    "After 12 payments, remove {C:attention}Mortgage{}",
                    "{C:inactive}({C:attention}#2#{C:inactive} payments remaining){}"
                },
            },
            baliatro_interest_cap = {
                name = "Interest Cap",
                text = {
                    "The maximum amount of dollars held",
                    "for which {C:attention}Interest{} is calculated.",
                },
            },
            baliatro_ban = {
                name = "Ban",
                text = {
                    "A {C:attention}Banned{} card cannot appear",
                    "randomly in shop or through any creation effect.",
                    "Banned cards may still be created by targeted effects.",
                    "{C:red}Currently banned Jokers:{}"
                },
            },
            baliatro_unbound = {
                name = "Unbound",
                text = {
                    "Duplicates of this card",
                    "can always appear.",
                },
            },
            baliatro_immortal = {
                name = "Immortal",
                text = {
                    "Cannot be the target of {C:tarot}Death{},",
                    "{C:spectral}Cryptid{}, or any Joker-based",
                    "card duplication effects."
                },
            },
            baliatro_upgradable = {
                name = "Upgradable",
                text = {
                    "Upgrades to {C:attention}#1#{}"
                }
            },
            baliatro_plain = {
                name = "Plain",
                text = {
                    "Cards with no {C:dark_edition}Edition{}, {C:attention}Seal{},",
                    "or {C:blue}Enhancement{} are considered",
                    "plain. {C:red}Debuffed{} cards are plain."
                },
            },
            baliatro_saturated = {
                name = "Saturated",
                text = {
                    "Cards with an {C:dark_edition}Edition{}, {C:attention}Seal{},",
                    "and {C:blue}Enhancement{} are considered",
                    "saturated. {C:red}Debuffed{} cards are never saturated."
                },
            },
            baliatro_original_base = {
                name = "Obscured Card",
                text = {
                    "This card was originally",
                    "{C:attention}#1#{} of {V:1}#2#{}"
                }
            },
            p_baliatro_postcard_normal = {
                group_name = "Postcard Pack",
                name = "Postcard Pack",
                text = {
                    "Choose {C:attention}#1#{} of up to",
                    "{C:attention}#2#{} {C:money}Postcards{}",
                }
            },
            p_baliatro_postcard_jumbo = {
                group_name = "Postcard Pack",
                name = "Jumbo Postcard Pack",
                text = {
                    "Choose {C:attention}#1#{} of up to",
                    "{C:attention}#2#{} {C:money}Postcards{}",
                }
            },
            p_baliatro_buffoon_upgraded = {
                group_name = "Buffoon Pack",
                name = "Upgraded Buffoon Pack",
                text = {
                    "Choose {C:attention}#1#{} of up to",
                    "{C:attention}#2#{} {C:joker}Upgraded Jokers{}",
                }
            },
            p_baliatro_pact = {
                group_name = "Audience with the Devil",
                name = "Audience with the Devil",
                text = {
                    "{s:1.2,C:red}Choose a Deal with the Devil",
                    "Gain an audience and pick {C:attention}#1#{} of up to {C:attention}#2#{} {C:joker}Pacts{}.",
                    "{s:0.8,C:red}Once audience is gained, it would be very unwise to refuse.{}"
                }
            },
            p_baliatro_loot_pack = {
                group_name = "Loot Pack",
                name = "Loot Pack",
                text = {
                    "Why are you",
                    "able to see",
                    "this text?"
                }
            },
        },
        Postcard={
            c_baliatro_tokyo = {
                name = "Tokyo",
                text = {
                    "Fill your empty Joker slots with",
                    "{C:dark_edition}Photographic{} {C:attention}Rental{} {C:attention}Ramen{}",
                },
            },
            c_baliatro_boston = {
                name = "Boston",
                text = {
                    "Add {C:dark_edition}Photographic{} to a random Joker.",
                    "If you have no editionless Jokers",
                    "create a random Photographic Joker.",
                    "{C:inactive}(must have room){}",
                }
            },
            c_baliatro_nice = {
                name = "Nice",
                text = {
                    "Add {C:dark_edition}Scenic{} to a random Joker.",
                    "If you have no editionless Jokers",
                    "create a random Scenic Joker.",
                    "{C:inactive}(must have room){}",
                }
            },
            c_baliatro_new_york = {
                name = "New York",
                text = {
                    "{C:red}Double{} most numeric values on a compatible Joker.",
                    "Cannot apply to {C:attention}Mortgage{} Jokers.",
                    "Remove {C:attention}Eternal{} from the Joker",
                    "Apply {C:attention}Mortgage{} to Joker."
                }
            },
            c_baliatro_budapest = {
                name = "Budapest",
                text = {
                    "{C:red}Destroy{} a random Joker.",
                    "{C:blue}Create a copy{} of a random Joker.",
                    "Apply an {C:attention}Eternal{} sticker to a compatible Joker.",
                }
            },
            c_baliatro_mecca = {
                name = "Mecca",
                text = {
                    "Create a random {C:red}Mortgage{} {C:attention}Legendary{} Joker",
                    "{C:inactive}(must have room){}"
                },
            },
            c_baliatro_moscow = {
                name = "Moscow",
                text = {
                    "Create {C:attention}#1#{} random {C:attention}Negative{} {C:blue}Common{} {C:money}Rental{} jokers."
                }
            },
            c_baliatro_amsterdam = {
                name = "Amsterdam",
                text = {
                    "Add {C:attention}Polychrome{} to all Jokers.",
                    "Permanently lose #1# {C:blue}Hand{} and #2# {C:red}Discard{} per round.",
                },
            },
            c_baliatro_detroit = {
                name = "Detroit",
                text = {
                    "{C:attention}-#1#{} to {C:blue}Ante{}.",
                    "Create #2# {C:attention}Negative{} {C:red}Mortgage{} {C:attention}Burglar{}.",
                    "Ante cannot go below 0 when using this card.",
                    "{C:inactive}(cannot be used if you have a Mortgage joker){}",
                },
            },
            c_baliatro_las_vegas = {
                name = "Las Vegas",
                text = {
                    "Create a {C:attention}Transcendence{}, {C:spectral}Soul{}, {C:planet}Black Hole{},",
                    "or {C:attention}Eternal{} {C:dark_edition}Foil{} Obelisk.",
                    "Ignores slot limits.",
                    "Lose half your {C:money}dollars{}."
                }
            },
            c_baliatro_monte_carlo = {
                name = "Monte Carlo",
                text = {
                    "Randomly gain one of the following",
                    "options {C:green}#1#{} times, then lose {C:red}#2#{} times:",
                    "{C:attention}#3#{} Hand Size, {C:attention}#4#{} {C:red}Discard(s){}, #5#{} {C:blue}Hand(s){},",
                    "{C:attention}#6#{} Consumable Slot(s), {C:attention}#7#{} {C:attention}Booster Pack{} Slots,",
                    "{C:attention}#8#{} {C:money}Interest{} level(s), {C:attention}#9#{} level(s) to {C:attention}all Hands{}",
                }
            },
            c_baliatro_london = {
                name = "London",
                text = {
                    "Upgrade up to {C:attention}#1#{} compatible {C:blue}Common{} Jokers.",
                    "Lose {C:money}$#4#{}. Upgraded Jokers lose {C:attention}Perishable{},",
                    "but retain all other stickers and edition.",
                    "{C:green}#2# in #3#{} chance to apply {C:attention}Perishable{}",
                    "to the upgraded Joker if it is {C:attention}Negative{}."
                },
            },
            c_baliatro_munich = {
                name = "Munich",
                text = {
                    "Remove Perishable and Negative from a random Perishable Joker.",
                    "If you have no Perishable Jokers,",
                    "gain {C:attention}+#2#{} Consumable Slot instead.",
                },
            },
            c_baliatro_paris = {
                name = "Paris",
                text = {
                    "Each card in your current deck has a",
                    "{C:green}#1# in #2# chance{} to gain a random enhancement",
                    "{C:green}#1# in #3# chance{} to gain a random seal",
                    "and {C:green}#1# in #4# chance{} to gain a random edition.",
                    "Cards that gain at least two of these or {C:dark_edition}Negative{} also gain {C:attention}Immortal{}.",
                    "{C:inactive}(cannot override existing enhancements, seals and editions){}"
                },
            },
            c_baliatro_cairo = {
                name = "Cairo",
                text = {
                    "Apply {C:attention}Eternal{} to up to",
                    "{c:attention}#1#{} selected non-{C:attention}Perishable{} Joker.",
                    "Create {C:attention}#2#{} {C:spectral}Ankh{} if you have room",
                },
            },
            c_baliatro_copenhagen = {
                name = "Copenhagen",
                text = {
                    "Set the number of times each hand was played to double",
                    "the number of times your most played hand was played.",
                    "Set the number of times each rank was scored to double",
                    "the number of times your most scored rank was scored."
                },
            },
            c_baliatro_singapore = {
                name = 'Singapore',
                text = {
                    'Increase the {C:attention}rank{} of all cards',
                    'in your deck by one. Fill your',
                    'empty consumeable slots with {C:tarot}Strength{}.',
                }
            },
            c_baliatro_kyoto = {
                name = 'Kyoto',
                text = {
                    'Apply {C:dark_edition}Haunted{} to {C:attention}#1#{}',
                    'random cards in your deck.',
                }
            }
        },
        Planet={
            c_baliatro_luna={
                name="Luna",
                text={
                    "{S:0.8}({S:0.8,V:1}lvl.#1#{S:0.8}){} Level up",
                    "{C:attention}#2#{}",
                    "{C:money}+$#3#{} interest per $5 held",
                    "{C:money}+$#4#{} to interest cap",
                    "{C:red}+$#4#{} to mortgage payments",
                    "{C:inactive}(cents cannot be cashed out){}"
                },
            },
            c_baliatro_deimos = {
                name="Deimos",
                text={
                    "{S:0.8}({S:0.8,V:1}lvl.#1#{S:0.8}){} Level up",
                    "{C:attention}#2#{}",
                    "{C:chips}+#3#{} Chips",
                },
            },
            c_baliatro_phobos = {
                name="Phobos",
                text={
                    "{S:0.8}({S:0.8,V:1}lvl.#1#{S:0.8}){} Level up",
                    "{C:attention}#2#{}",
                    "{C:mult}+#3#{} Mult",
                },
            },
            c_baliatro_io = {
                name="Io",
                text={
                    "{S:0.8}({S:0.8,V:1}lvl.#1#{S:0.8}){} Level up",
                    "{C:attention}#2#{}",
                    "{X:mult,C:white}+X#3#{} Mult",
                },
            },
            c_baliatro_europa = {
                name="Europa",
                text={
                    "{S:0.8}({S:0.8,V:1}lvl.#1#{S:0.8}){} Level up",
                    "{C:attention}#2#{}",
                    "{X:chips,C:white}+X#3#{} Chips",
                },
            },
            c_baliatro_ganymede = {
                name="Ganymede",
                text={
                    "{S:0.8}({S:0.8,V:1}lvl.#1#{S:0.8}){} Level up",
                    "{C:attention}#2#{}",
                    "{X:chips,C:white}+#3#%{} increase to Chips",
                    "{C:inactive}(existing reductions continue to apply){}"
                },
            },
            c_baliatro_callisto = {
                name="Callisto",
                text={
                    "{S:0.8}({S:0.8,V:1}lvl.#1#{S:0.8}){} Level up",
                    "{C:attention}#2#{}",
                    "{X:money}+#3#{} Booster Pack extra selections",
                    "{X:money}+#4#{} Booster Pack extra choices",
                    "{C:inactive}(select selection out of choice cards, rounded down){}",
                },
            },
        },
        Spectral={
            c_baliatro_transcendence = {
                name="Transcendence",
                text={
                    "Apply {C:attention}Negative{} and {C:attention}Immortal{} to",
                    "up to {C:attention}#1#{} selected {C:blue}playing cards{}",
                },
            },
        },
        Stake={},
        Tag={},
        Tarot={
            c_baliatro_ace_of_wands = {
                name = "Ace of Wands",
                text = {
                    "Add {C:dark_edition}Faded Foil{}, {C:dark_edition}Faded Holographic{},",
                    "or {C:dark_edition}Faded Polychrome{} effect to",
                    "up to {C:attention}#1#{} selected card in hand",
                }
            },
            c_baliatro_ace_of_pentacles = {
                name = "Ace of Pentacles",
                text = {
                    "Convert up to {C:attention}#1#{}",
                    "cards to {C:red}Resistant{}",
                }
            },
            c_baliatro_ace_of_cups = {
                name = "Ace of Cups",
                text = {
                    "Remove {C:attention}Enhancement{}, {C:attention}Seal{}, and",
                    "{C:dark_edition}Edition{} from up to {C:attention}#1#{} card(s).",
                    "It gains {C:chips}+#2#{} Chips and {C:mult}+#3#{} Mult",
                    "for each of these removed. If",
                    "it was already {C:attention}Plain{}, destroy",
                    "it instead."
                }
            },
            c_baliatro_king_of_swords = {
                name = "King of Swords",
                text = {
                    "Add a random {C:attention}Enhancement{},",
                    "{C:attention}Seal{} and {C:dark_edition}Edition{} to up to",
                    "{C:attention}#1#{} card. Replaces existing",
                    "effects. Cards that gain",
                    "a hand size {C:dark_edition}Edition{} also",
                    "gain {C:attention}Immortal{}."
                }
            },
            c_fool={
                name="The Fool",
                text={
                    "Creates the last",
                    "{C:tarot}Tarot{} or {C:planet}Planet{} card",
                    "used during this run",
                    "Created cards inherit {C:dark_edition}Edition{}",
                    "{s:0.8,C:tarot}The Fool{s:0.8} excluded",
                },
            },
            c_emperor={
                name="The Emperor",
                text={
                    "Creates up to {C:attention}#1#",
                    "random {C:tarot}Tarot{} cards",
                    "Created cards inherit {C:dark_edition}Edition{}",
                    "{C:inactive}(Must have room)",
                },
            },
            c_high_priestess={
                name="The High Priestess",
                text={
                    "Creates up to {C:attention}#1#",
                    "random {C:planet}Planet{} cards",
                    "Created cards inherit {C:dark_edition}Edition{}",
                    "{C:inactive}(Must have room)",
                },
            },
        },
        Voucher={
            v_seed_money={
                name="Seed Money",
                text={
                    "+{C:money}$#1#{} to interest cap",
                },
            },
            v_money_tree={
                name="Money Tree",
                text={
                    "+{C:money}$#1#{} to interest cap",
                },
            },

            v_clearance_sale={
                name="Clearance Sale",
                text={
                    "All cards and packs in",
                    "shop are +{C:attention}#1#%{} off",
                },
            },

            v_liquidation={
                name="Liquidation",
                text={
                    "All cards and packs in",
                    "shop are +{C:attention}#1#%{} off",
                },
                unlock={
                    "Redeem at least",
                    "{C:attention}#1#{C:voucher} Voucher{} cards",
                    "in one run",
                },
            },

            v_baliatro_specialty_store={
                name="Specialty Store",
                text={
                    "{C:attention}+#1#{} Booster Pack",
                    "slot in shop",
                },
            },

            v_baliatro_premium_selection={
                name="Premium Selection",
                text={
                    "Each upgradable Joker in",
                    "Buffoon Packs has a {C:attention}#1#%{}",
                    "chance to be {C:dark_edition}Upgraded{} instead",
                },
            },
        },
    },
    misc = {
        achievement_descriptions={},
        achievement_names={},
        blind_states={},
        challenge_names={},
        collabs={},
        dictionary={
            b_baliatro_discard_unwanted_loot = "Discard selected loot",
            b_baliatro_moons = "Moons",
            b_baliatro_ranks = "Ranks",
            b_baliatro_loot = "Loot",
            b_baliatro_take = 'Take',
            baliatro_ulti = "Ulti!",
            baliatro_planet_moon = "Moon",
            baliatro_interest = "Interest",
            baliatro_foil = "Foil",
            baliatro_holo = "Holographic",
            baliatro_polychrome = "Polychrome",
            baliatro_photographic = "Photographic",
            baliatro_scenic = "Scenic",
            baliatro_booster_pack_choices = "Booster Packs",
            baliatro_plus_aura="+1 Aura",
            baliatro_depleted="Depleted!",
            baliatro_parade="Parade!",
            baliatro_cannot_transfer="Cannot transfer!",
            baliatro_postcard="Postcard",
            baliatro_loot="Loot",
            k_baliatro_postcard="Postcard",
            k_baliatro_loot="Loot",
            k_baliatro_unknown="Unknown",
            k_baliatro_inflation_ex = "Inflation!",
            k_baliatro_en_passant_ex = "En Passant!",
            k_postcard="Postcard",
            b_baliatro_postcard_cards="Postcards",
            b_postcard_cards="Postcards",
            k_baliatro_upgraded="Upgraded",
            k_baliatro_pact="Pact",
            baliatro_plus_postcard="+1 Postcard",
            k_downgrade_ex="Downgrade!",
            k_baliatro_destroyed_ex="Destroyed!",
            baliatro_mortgage = "Mortgage",
            k_baliatro_postcard_pack = "Postcard Pack",
            k_baliatro_loot_pack = "Loot Pack",
            k_baliatro_upgraded_buffoon_pack = "Upgraded Buffoon Pack",
            k_baliatro_pact_pack = "Audience with the Devil",
            k_baliatro_banned_ex = "Banned!",
            k_baliatro_no_banned_cards_ex = "No banned cards!",
            k_baliatro_destroyed_card_ex="Destroyed card!",
            k_baliatro_converted_card_ex="Converted card!",
            k_baliatro_plus_card_ex="+1 Card!",
            k_baliatro_augment_photographic = "Snapped!",
            b_baliatro_interest_per_5 = ' $/$5',
            b_baliatro_interest_cap = ' cap',
            b_baliatro_chips = 'Chips',
            b_baliatro_mult = 'Mult',
            b_baliatro_xmult = 'XMult',
            b_baliatro_chips_gain = '% +Chips',
            b_baliatro_booster_pack_selections = ' extra out of ',
            b_baliatro_booster_pack_choices = ' picks',
            b_baliatro_on_trigger = ' on trigger',
            k_baliatro_hand_ex="Hand!",
            k_baliatro_play_ex="Play!",
            k_baliatro_expired_ex="Expired!",
            k_baliatro_afterimage_ready="Ready to remember a card",
            k_baliatro_afterimage_no_card="No card remembered this round",
            k_baliatro_remembered_ex="Remembered!",
            k_baliatro_remembrance_ex="Remembrance!",
            k_baliatro_random_unseen_blind = "<random blind hidden before selection>",
            k_baliatro_random_showdown_blind = "<random showdown blind>",
            k_baliatro_random_blind = "<random non-showdown blind>",
            k_baliatro_saturated = 'Saturated',
            k_baliatro_non_plain = 'Non-Plain',
            k_baliatro_playing_card = 'Playing card',
            k_baliatro_completed_ex = 'Completed!',
            k_baliatro_failed_ex = 'Failed!',
            k_baliatro_autocompletes_ex = 'Automatically completes',
            k_baliatro_rewards_colon = 'Rewards:',
            k_baliatro_progress_colon = 'Progress:',
            k_baliatro_skip_to_claim_loot = "Skip any blind to claim accumulated loot",
            k_baliatro_no_loot_to_claim = "No loot currently accumulated",
            k_baliatro_select_loot_to_discard = "Select loot to discard any undesired",
            k_baliatro_overflow = "Loot bag full!",
            k_baliatro_identical = "Identical",
            k_baliatro_lootplaceholder = "Loot",
        },
        high_scores={},
        labels={
            baliatro_photographic = "Photographic",
            baliatro_scenic = "Scenic",
            baliatro_mortgage = "Mortgage",
            baliatro_immortal = "Immortal",
            baliatro_ban = "Ban",
            upgradable = "Upgradable",
            baliatro_faded_foil = "Faded Foil",
            baliatro_haunted = "Haunted",
            baliatro_ectoplasmic = "Ectoplasmic",
            baliatro_ethereal = "Ethereal",
            baliatro_ephemeral = "Ephemeral",
            baliatro_faded_holo = "Faded Holographic",
            baliatro_faded_polychrome = "Faded Polychrome",
            baliatro_pact = "Pact",
            baliatro_lootplaceholder = "Loot",
            baliatro_loot = "Loot",
        },
        poker_hand_descriptions={},
        poker_hands={},
        quips={},
        ranks={},
        suits_plural={},
        suits_singular={},
        tutorial={},
        v_dictionary={
            a_baliatro_multiply_blind = "#1#X to pass Blind",
            a_baliatro_money = "+$#1#",
            a_baliatro_cooking_money = "Seasoned! +$#1#",
            a_baliatro_cooking_chips = "Seasoned! +#1# Chips",
            a_baliatro_cooking_mult = "Seasoned! +#1# Mult",
            a_baliatro_transfer = "Transfer #1# to Chips",
            a_baliatro_plus_consumable_slots = "+#1# Consumable Slots",
            a_baliatro_minus_consumable_slots = "-#1# Consumable Slots",
            a_baliatro_minus_joker_slots = "-#1# Joker Slots",
            a_baliatro_beautify = "Beautified! +#1# Chips",
            a_baliatro_spoil = "Spoiled! #1# Chips",
            a_baliatro_augment_photographic = "Snapped! #1#",
            a_baliatro_bankrupt = "Bankrupt! -$#1#",
            a_baliatro_drained = "Drained! -#1# repeats",
            a_baliatro_monte_carlo_hand_size = "#1# Hand Size",
            a_baliatro_monte_carlo_discards = "#1# Discards",
            a_baliatro_monte_carlo_hands = "#1# Hands",
            a_baliatro_monte_carlo_consumable_slots = "#1# Consumable Slots",
            a_baliatro_monte_carlo_booster_pack_slots = "#1# Booster Pack Slots",
            a_baliatro_monte_carlo_interest_levels = "#1# Interest Levels",
            a_baliatro_monte_carlo_all_hand_levels = "#1# All Hand Levels",
            a_baliatro_dollar_per_5dollar = '$#1# / $5 held',
            a_baliatro_interest_cap = 'based on $#1#',
            a_baliatro_xmult = 'X#1#',
            a_baliatro_plus_percent = '+#1#%',
            a_baliatro_pick_plus = 'pick +#1# ',
            a_baliatro_out_of = 'out of +#1#',
            a_divide_by_ex = 'Divide by +#1#!',
            a_baliatro_afterimage_remembered = "Remembering a #1# of #2#",
            a_baliatro_x_base = '#1#X Base',
            a_baliatro_progress_perc = 'Progress: #1#%',
        },
        v_text={},
    },
}
