if BALIATRO.feature_flags.loot then

BALIATRO.LootPlaceholder = SMODS.Center:extend {
    discovered = false,
    pos = { x = 0, y = 0 },
    cost = 3,
    config = {},
    set = 'LootPlaceholder',
    atlas = 'Baliatro',
    class_prefix = 'lp',
    omit = true,
    generates = {
    },
    rarity = 1,
    weight = 5,
    required_params = {
        'key',
        'generates',
        'rarity',
        'weight',
    },

    pre_inject_class = function(self)
        BALIATRO.LootPlaceholderByRarity = {}
        BALIATRO.loot_total_weight = {}
        BALIATRO.loot_weights = {}
        BALIATRO.loot_weight_assignment = {}
    end,
    inject = function(self)
        if not BALIATRO.LootPlaceholderByRarity[self.rarity] then BALIATRO.LootPlaceholderByRarity[self.rarity] = {} end
        if not BALIATRO.loot_total_weight[self.rarity] then BALIATRO.loot_total_weight[self.rarity] = 0 end
        if not BALIATRO.loot_weights[self.rarity] then BALIATRO.loot_weights[self.rarity] = {} end
        if not BALIATRO.loot_weight_assignment[self.rarity] then BALIATRO.loot_weight_assignment[self.rarity] = {} end
        BALIATRO.LootPlaceholderByRarity[self.rarity][#BALIATRO.LootPlaceholderByRarity[self.rarity]+1] = self
        BALIATRO.loot_total_weight[self.rarity] = (BALIATRO.loot_total_weight[self.rarity] or 0) + self.weight
        BALIATRO.loot_weights[self.rarity][#BALIATRO.loot_weights[self.rarity]+1] = BALIATRO.loot_total_weight[self.rarity]
        BALIATRO.loot_weight_assignment[BALIATRO.loot_total_weight[self.rarity]] = self

        SMODS.Center.inject(self)
    end,
}

BALIATRO.LootPlaceholder {
    key = 'rare_joker',
    generates = {
        set = 'Joker',
        rarity = 3,
        amount = 1,
    },
    rarity = 3,
    weight = 5,
}

BALIATRO.LootPlaceholder {
    key = 'uncommon_joker',
    generates = {
        set = 'Joker',
        rarity = 2,
        amount = 1,
    },
    rarity = 2,
    weight = 5,
}

BALIATRO.LootPlaceholder {
    key = 'two_uncommon_jokers',
    generates = {
        set = 'Joker',
        rarity = 2,
        amount = 2,
    },
    rarity = 3,
    weight = 5,
}

BALIATRO.LootPlaceholder {
    key = 'small_dollars',
    generates = {
        min_dollars = 5,
        max_dollars = 10,
    },
    rarity = 1,
    weight = 5,
}

BALIATRO.LootPlaceholder {
    key = 'medium_dollars',
    generates = {
        min_dollars = 10,
        max_dollars = 20,
    },
    rarity = 2,
    weight = 5,
}

BALIATRO.LootPlaceholder {
    key = 'big_dollars',
    generates = {
        min_dollars = 20,
        max_dollars = 40,
    },
    rarity = 3,
    weight = 5,
}

BALIATRO.LootPlaceholder {
    key = 'foil_joker',
    generates = {
        set = 'Joker',
        edition = 'e_foil',
        amount = 1,
    },
    rarity = 1,
    weight = 5,
}

BALIATRO.LootPlaceholder {
    key = 'holo_joker',
    generates = {
        set = 'Joker',
        edition = 'e_holo',
        amount = 1,
    },
    rarity = 1,
    weight = 5,
}

BALIATRO.LootPlaceholder {
    key = 'polychrome_joker',
    generates = {
        set = 'Joker',
        edition = 'e_polychrome',
        amount = 1,
    },
    rarity = 2,
    weight = 5,
}

BALIATRO.LootPlaceholder {
    key = 'photographic_joker',
    generates = {
        set = 'Joker',
        edition = 'e_baliatro_photographic',
        amount = 1,
    },
    rarity = 2,
    weight = 5,
}

BALIATRO.LootPlaceholder {
    key = 'negative_joker',
    generates = {
        set = 'Joker',
        edition = 'e_negative',
        amount = 1,
    },
    rarity = 2,
    weight = 5,
}

BALIATRO.LootPlaceholder {
    key = 'negative_uncommon_joker',
    generates = {
        set = 'Joker',
        rarity = 2,
        edition = 'e_negative',
        amount = 1,
    },
    rarity = 3,
    weight = 2,
}

BALIATRO.LootPlaceholder {
    key = 'negative_rare_joker',
    generates = {
        set = 'Joker',
        rarity = 3,
        edition = 'e_negative',
        amount = 1,
    },
    rarity = 3,
    weight = 1,
}

BALIATRO.LootPlaceholder {
    key = 'legendary_joker',
    generates = {
        set = 'Joker',
        rarity = 4,
        amount = 1,
    },
    rarity = 3,
    weight = 1,
}

BALIATRO.LootPlaceholder {
    key = 'scenic_joker',
    generates = {
        set = 'Joker',
        edition = 'e_baliatro_scenic',
        amount = 1,
    },
    rarity = 1,
    weight = 5,
}

BALIATRO.LootPlaceholder {
    key = 'upgraded_joker',
    generates = {
        set = 'Joker',
        rarity = 'baliatro_upgraded',
        amount = 1,
    },
    rarity = 3,
    weight = 5,
}

BALIATRO.LootPlaceholder {
    key = 'four_tarot_cards',
    generates = {
        set = 'Tarot',
        amount = 4,
    },
    rarity = 1,
    weight = 5,
}

BALIATRO.LootPlaceholder {
    key = 'two_spectral_cards',
    generates = {
        set = 'Spectral',
        amount = 2,
    },
    rarity = 2,
    weight = 5,
}

BALIATRO.LootPlaceholder {
    key = 'postcard',
    generates = {
        set = 'Postcard',
        amount = 1,
    },
    rarity = 3,
    weight = 3,
}

BALIATRO.LootPlaceholder {
    key = 'voucher',
    generates = {
        set = 'Voucher',
        amount = 1,
    },
    rarity = 3,
    weight = 5,
}

BALIATRO.LootPlaceholder {
    key = 'six_playing_cards',
    generates = {
        set = 'Default',
        amount = 6,
    },
    rarity = 1,
    weight = 5,
}

BALIATRO.LootPlaceholder {
    key = 'two_saturated_playing_cards',
    generates = {
        set = 'Default',
        saturated = true,
        amount = 2,
    },
    rarity = 2,
    weight = 5,
}

BALIATRO.LootPlaceholder {
    key = 'four_planets',
    generates = {
        set = 'Planet',
        amount = 4,
    },
    rarity = 1,
    weight = 5,
}

BALIATRO.LootPlaceholder {
    key = 'four_mirrored_planets',
    generates = {
        set = 'Planet',
        mirrored = true,
        amount = 4,
    },
    rarity = 2,
    weight = 5,
}

BALIATRO.LootPlaceholder {
    key = 'four_negative_planets',
    generates = {
        set = 'Planet',
        amount = 4,
    },
    rarity = 3,
    weight = 5,
}

BALIATRO.LootPlaceholder {
    key = 'omen_globe',
    generates = {
        set = 'Voucher',
        key = 'v_omen_globe',
        amount = 1,
    },
    rarity = 3,
    weight = 5,
}

BALIATRO.Goals = {}
BALIATRO.Goal = SMODS.GameObject:extend {
    obj_table = BALIATRO.Goals,
    obj_buffer = {},
    class_prefix = 'goal',
    required_params = {
        'key',
        'rarity',
        'min_loot_rarity',
        'max_loot_rarity',
        'loot_amount',
    },
    chosen = false,
    -- func = function(self) end, -- -> table
    -- is_visible = function(self, args) end, -- -> bool

    set = "Goal",
    register = function(self)
        if self.registered then
            sendWarnMessage(('Detected duplicate register call on object %s'):format(self.key), self.set)
            return
        end
        BALIATRO.Goal.super.register(self)
    end,
    pre_inject_class = function(self)
        BALIATRO.GoalsByRarity = {}
    end,
    inject = function(self)
        if not BALIATRO.GoalsByRarity[self.rarity] then BALIATRO.GoalsByRarity[self.rarity] = {} end
        BALIATRO.GoalsByRarity[self.rarity][#BALIATRO.GoalsByRarity[self.rarity]+1] = self
    end,

    mark_complete = function(self, goal)
        goal.is_completed = true
    end,

    mark_failed = function(self, goal)
        goal.is_failed = true
    end,

    calculate = function(self, goal, context)
        if goal.hand then
            if context.before and context.scoring_name == goal.hand then
                local need = goal.count or 1
                goal.got = goal.got and (goal.got + 1) or 1
                if goal.got >= need then self:mark_complete(goal) end
            end
        elseif goal.has_hand then
            if context.before and next(context.poker_hands[goal.has_hand]) then
                local need = goal.count or 1
                goal.got = goal.got and (goal.got + 1) or 1
                if goal.got >= need then self:mark_complete(goal) end
            end
        elseif goal.fail_on_hand then
            if context.before and context.scoring_name == goal.hand then
                self:mark_failed(goal)
            end
        elseif goal.fail_on_has_hand then
            if context.before and next(context.poker_hands[goal.has_hand]) then
                self:mark_failed(goal)
            end
        elseif goal.fail_on_cards_gt then
            if context.before and #context.scoring_hand > goal.fail_on_cards_gt then
                self:mark_failed(goal)
            end
        elseif goal.score_percentage then
            if context.after then
                local scored = hand_chips * mult
                local scored_percentage = scored / G.GAME.blind.chips
                if scored_percentage >= goal.score_percentage then
                    self:mark_complete(goal)
                end
            end
        elseif goal.score_ranks then
            if context.individual and context.cardarea == G.play and not context.end_of_round then
                local need = goal.count or 1
                local rank = context.other_card.base.value
                if goal.score_ranks[rank] then
                    goal.got = goal.got and goal.got + 1 or 1
                    if goal.got >= need then self:mark_complete(goal) end
                end
            end
        elseif goal.score_suits then
            if context.individual and context.cardarea == G.play and not context.end_of_round then
                local need = goal.count or 1
                local pass = false
                for k, _ in pairs(goal.score_suits) do
                    if context.other_card:is_suit(k) then pass = true; break end
                end
                if pass then
                    goal.got = goal.got and goal.got + 1 or 1
                    if goal.got >= need then self:mark_complete(goal) end
                end
            end
        elseif goal.fail_on_ranks then
            if context.individual and context.cardarea == G.play and not context.end_of_round then
                local rank = context.other_card.base.value
                if goal.fail_on_ranks[rank] then self:mark_failed(goal) end
            end
        elseif goal.fail_on_suits then
            if context.individual and context.cardarea == G.play and not context.end_of_round then
                local fail = false
                for k, _ in pairs(goal.fail_on_suits) do
                    if context.other_card:is_suit(k) then fail = true; break end
                end
                if fail then self:mark_failed(goal) end
            end
        elseif goal.fail_on_discard then
            if context.pre_discard then self:mark_failed(goal) end
        elseif goal.fail_on_hands_played then
            if context.before and G.GAME.current_round.hands_played >= goal.fail_on_hands_played then self:mark_failed(goal) end
        elseif goal.hands_played then
            if context.before and G.GAME.current_round.hands_played >= goal.hands_played then self:mark_complete(goal) end
        end
    end,
}

BALIATRO.pick_loot = function(rarity, seed)
    local max = BALIATRO.loot_total_weight[rarity]
    if not max or max == 0 then return nil end
    local wtroll = pseudorandom(seed, 1, max)
    local wtindex = nil
    for idx, maxwt in ipairs(BALIATRO.loot_weights[rarity]) do
        if wtroll < maxwt then return BALIATRO.loot_weight_assignment[rarity][wtindex] end
    end
    return nil
end

BALIATRO.create_goal_config = function(goal_key)
    local goal = BALIATRO.Goals[goal_key]
    local goal_conf = goal.config and type(goal.config) == 'table' and copy_table(goal.config) or {}
    if goal.on_create and type(goal.on_create) == 'function' then goal:on_create(goal_conf) end
    return goal_conf
end

BALIATRO.create_goal = function(rarity, except, except_rewards)
    local pool = rarity and BALIATRO.GoalsByRarity[rarity] or BALIATRO.Goals
    local tries = 0
    local goal = nil
    repeat
        goal = pseudorandom_element(pool, pseudoseed('antegoal' .. G.GAME.round_resets.ante))
        if except[goal.key] then goal = nil end
    until tries > 50 or goal

    if not goal then return nil, {}, {} end

    local rewards = {}

    for i = 1, goal.loot_amount do
        local loot_rarity = goal.min_loot_rarity == goal.max_loot_rarity and goal.min_loot_rarity or pseudorandom('antegoal' .. G.GAME.round_resets.ante, goal.min_loot_rarity, goal.max_loot_rarity)
        local loot = BALIATRO.pick_loot(loot_rarity, pseudoseed('antegoal' .. G.GAME.round_resets.ante))
        rewards[#rewards+1] = loot.key
    end

    local goal_config = BALIATRO.create_goal_config(goal.key)

    return goal.key, goal_config, rewards
end

BALIATRO.generate_ante_goals = function()
    local m_rarity_budget = {4, 6, 8}
    local m_min_amount = {2, 3, 4}
    local m_goals = {nil, nil, nil}
    local m_goal_pool = {}
    local m_rewards = {nil, nil, nil}
    local m_configs = {nil, nil, nil}
    for i = 1, 3 do
        local rarity_budget = m_rarity_budget[i]
        local min_amount = m_min_amount[i]
        local goals = {}
        local rewards = {}
        local configs = {}
        while min_amount > 0 do
            local min_rarity = min_amount > 1 and 1 or rarity_budget
            local max_rarity = rarity_budget - (min_amount - 1)
            max_rarity = max_rarity > 5 and 5 or max_rarity
            local rarity = pseudorandom('antegoal' .. G.GAME.round_resets.ante, min_rarity, max_rarity)
            local goal, config, reward = BALIATRO.create_goal(rarity, m_goal_pool)
            min_amount = min_amount - 1
            rarity_budget = rarity_budget - rarity
            m_goal_pool[goal.key] = true
            goals[#goals+1] = goal
            rewards[#rewards+1] = reward
            configs[#configs+1] = config
        end
        m_goals[i] = goals
        m_rewards[i] = rewards
        m_configs[i] = configs
    end

    local ag = {}
    for i = 1, 3 do
        local bg = {}
        for j = 1, #m_goals[i] do
            bg[m_goals[i][j]] = {config = m_configs[i][j], reward = m_rewards[i][j]}
        end
        ag[i] = bg
    end
    G.GAME.ante_goals = ag
end

BALIATRO.Goal {
    key = 'play_two_flush',
    rarity = 2,
    min_loot_rarity = 1,
    max_loot_rarity = 2,
    loot_amount = 2,
    config = {
        hand = 'Flush',
        count = 2,
    },
}

BALIATRO.Goal {
    key = 'play_one_straight_flush',
    rarity = 4,
    min_loot_rarity = 2,
    max_loot_rarity = 3,
    loot_amount = 2,
    config = {
        hand = 'Straight Flush',
        count = 1,
    },
}

BALIATRO.Goal {
    key = 'play_one_four_of_a_kind',
    rarity = 4,
    min_loot_rarity = 2,
    max_loot_rarity = 3,
    loot_amount = 2,
    config = {
        has_hand = 'Four of a Kind',
        count = 1,
    },
}

BALIATRO.Goal {
    key = 'play_no_duplicates',
    rarity = 4,
    min_loot_rarity = 2,
    max_loot_rarity = 3,
    loot_amount = 2,
    config = {
        complete_if_not_failed = true,
        fail_has_hand = 'Pair',
        count = 1,
    },
}

BALIATRO.Goal {
    key = 'play_less_than_5',
    rarity = 3,
    min_loot_rarity = 1,
    max_loot_rarity = 3,
    loot_amount = 2,
    config = {
        complete_if_not_failed = true,
        fail_on_cards_gt = 4,
    },
}

BALIATRO.Goal {
    key = 'score_ten_hearts',
    rarity = 3,
    min_loot_rarity = 1,
    max_loot_rarity = 3,
    loot_amount = 2,
    config = {
        score_suits = {Hearts = true},
        count = 10,
    },
}

BALIATRO.Goal {
    key = 'score_ten_diamonds',
    rarity = 3,
    min_loot_rarity = 1,
    max_loot_rarity = 3,
    loot_amount = 2,
    config = {
        score_suits = {Diamonds = true},
        count = 10,
    },
}

BALIATRO.Goal {
    key = 'score_ten_spades',
    rarity = 3,
    min_loot_rarity = 1,
    max_loot_rarity = 3,
    loot_amount = 2,
    config = {
        score_suits = {Spades = true},
        count = 10,
    },
}

BALIATRO.Goal {
    key = 'score_ten_clubs',
    rarity = 3,
    min_loot_rarity = 1,
    max_loot_rarity = 3,
    loot_amount = 2,
    config = {
        score_suits = {Clubs = true},
        count = 10,
    },
}

BALIATRO.Goal {
    key = 'score_three_ranks_five_total',
    rarity = 2,
    min_loot_rarity = 1,
    max_loot_rarity = 3,
    loot_amount = 2,
    config = {
        count = 5,
    },

    on_create = function(self, goal)
        local els = BALIATRO.nrandom_elements(SMODS.Ranks, 3, pseudoseed("goal3r5"..G.GAME.round_resets.ante))
        goal.score_ranks = {}
        for el in ipairs(els) do goal.score_ranks[el[2]] = true end
    end,
}

BALIATRO.Goal {
    key = 'win_in_one_hand',
    rarity = 5,
    min_loot_rarity = 2,
    max_loot_rarity = 3,
    loot_amount = 2,
    config = {
        complete_if_not_failed = true,
        fail_on_hands_played = 2,
    },
}

BALIATRO.Goal {
    key = 'play_three_hands',
    rarity = 1,
    min_loot_rarity = 1,
    max_loot_rarity = 1,
    loot_amount = 3,
    config = {
        hands_played = 3,
    },
}

BALIATRO.Goal {
    key = 'score_at_least_three_quarters',
    rarity = 2,
    min_loot_rarity = 1,
    max_loot_rarity = 2,
    loot_amount = 2,
    config = {
        score_percentage = 0.75,
    },
}


BALIATRO.Goal {
    key = 'overscore_double',
    rarity = 4,
    min_loot_rarity = 2,
    max_loot_rarity = 3,
    loot_amount = 2,
    config = {
        score_percentage = 2,
    },
}

BALIATRO.Goal {
    key = 'overscore_ten_times',
    rarity = 5,
    min_loot_rarity = 3,
    max_loot_rarity = 3,
    loot_amount = 2,
    config = {
        score_percentage = 10,
    },
}

end
