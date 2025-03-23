if BALIATRO.feature_flags.loot then
SMODS.Atlas({key="BaliatroObjectiveIcons", path="BaliatroObjectiveIcons.png", px = 32, py = 32, atlas_table="ASSET_ATLAS"})

BALIATRO.LootPlaceholder = SMODS.Center:extend {
    discovered = false,
    pos = { x = 0, y = 0 },
    cost = 3,
    config = {},
    set = 'LootPlaceholder',
    atlas = 'baliatro_Baliatro',
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
        BALIATRO.loot_weight_assignment[self.rarity][BALIATRO.loot_total_weight[self.rarity]] = self

        SMODS.Center.inject(self)
    end,
    describe_generates = function(self)
        local description = {}

        if self.generates.set then
            if self.generates.eternal then
                description[#description+1] = localize{type='name_text', set='Other', key='eternal'}
            end
            if self.generates.immortal then
                description[#description+1] = localize{type='name_text', set='Other', key='baliatro_immortal'}
            end
            if self.generates.saturated then
                description[#description+1] = localize('k_baliatro_saturated')
            end
            if self.generates.nonplain then
                description[#description+1] = localize('k_baliatro_non_plain')
            end
            if self.generates.rarity then
                local vanilla_rarities = {[1] = 'common', [2] = 'uncommon', [3] = 'rare', [4] = 'legendary'}
                description[#description+1] = vanilla_rarities[self.generates.rarity] and localize('k_'..vanilla_rarities[self.generates.rarity]) or localize('k_'..self.generates.rarity)
            end
            if self.generates.edition then
                description[#description+1] = localize{type='name_text', set='Edition', key=self.generates.edition}
            end

            description[#description+1] = localize(self.generates.set == 'Default' and 'k_baliatro_playing_card' or 'k_' .. self.generates.set:lower())
            return table.concat(description, ' ')
        elseif self.generates.min_dollars and self.generates.max_dollars then
            return '$' .. self.generates.min_dollars .. '-$' .. self.generates.max_dollars
        end
        return 'ERROR'
    end
}

-- 2 common jokers, rarity = 1
BALIATRO.LootPlaceholder {
    key = 'two_common_joker',
    generates = {
        set = 'Joker',
        rarity = 1,
        amount = 2,
    },
    rarity = 1,
    weight = 5,
}

-- 4 common jokers, rarity = 2
BALIATRO.LootPlaceholder {
    key = 'four_common_joker',
    generates = {
        set = 'Joker',
        rarity = 1,
        amount = 4,
    },
    rarity = 2,
    weight = 5,
}

-- 6 common jokers, rarity = 3
BALIATRO.LootPlaceholder {
    key = 'six_common_joker',
    generates = {
        set = 'Joker',
        rarity = 1,
        amount = 6,
    },
    rarity = 3,
    weight = 5,
}

-- 1 negative common joker, rarity = 2
BALIATRO.LootPlaceholder {
    key = 'negative_common_joker',
    generates = {
        set = 'Joker',
        rarity = 1,
        edition = 'e_negative',
        amount = 1,
    },
    rarity = 2,
    weight = 5,
}

-- 1 eternal rare joker, rarity = 2
BALIATRO.LootPlaceholder {
    key = 'eternal_rare_joker',
    generates = {
        set = 'Joker',
        rarity = 3,
        eternal = true,
        amount = 1,
    },
    rarity = 2,
    weight = 5,
}

-- 1 rare joker, rarity = 3

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

-- 1 uncommon joker, rarity = 2

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

-- 2 uncommon jokers, rarity = 3
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

-- 5-10 dollars, rarity = 1
BALIATRO.LootPlaceholder {
    key = 'small_dollars',
    generates = {
        min_dollars = 5,
        max_dollars = 10,
    },
    rarity = 1,
    weight = 5,
}

-- 10-20 dollars, rarity = 2
BALIATRO.LootPlaceholder {
    key = 'medium_dollars',
    generates = {
        min_dollars = 10,
        max_dollars = 20,
    },
    rarity = 2,
    weight = 5,
}

-- 20-40 dollars, rarity = 3
BALIATRO.LootPlaceholder {
    key = 'big_dollars',
    generates = {
        min_dollars = 20,
        max_dollars = 40,
    },
    rarity = 3,
    weight = 5,
}

-- 1 foil joker, rarity = 1
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

-- 1 holographic joker, rarity = 1
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

-- 1 polychrome joker, rarity = 2
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

-- 1 photographic joker, rarity = 2
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

-- 1 negative joker, rarity = 3
BALIATRO.LootPlaceholder {
    key = 'negative_joker',
    generates = {
        set = 'Joker',
        edition = 'e_negative',
        amount = 1,
    },
    rarity = 3,
    weight = 5,
}

-- 1 negative uncommon joker, rarity = 3
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

-- 1 negative rare joker, rarity = 3
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

-- 1 legendary joker, rarity = 3
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

-- 1 scenic joker, rarity = 1
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

-- 1 upgraded joker, rarity = 3
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

-- 4 tarot, rarity = 1
BALIATRO.LootPlaceholder {
    key = 'four_tarot_cards',
    generates = {
        set = 'Tarot',
        amount = 4,
    },
    rarity = 1,
    weight = 5,
}

-- 2 spectral, rarity = 2
BALIATRO.LootPlaceholder {
    key = 'two_spectral_cards',
    generates = {
        set = 'Spectral',
        amount = 2,
    },
    rarity = 2,
    weight = 5,
}

-- 1 postcard, rarity = 3
BALIATRO.LootPlaceholder {
    key = 'postcard',
    generates = {
        set = 'Postcard',
        amount = 1,
    },
    rarity = 3,
    weight = 3,
}

-- 1 voucher, rarity = 3
BALIATRO.LootPlaceholder {
    key = 'voucher',
    generates = {
        set = 'Voucher',
        amount = 1,
    },
    rarity = 3,
    weight = 5,
}

-- 6 playing cards, rarity = 1
BALIATRO.LootPlaceholder {
    key = 'six_playing_cards',
    generates = {
        set = 'Default',
        amount = 6,
    },
    rarity = 1,
    weight = 5,
}

-- 2 saturated playing cards, rarity = 2
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

-- 4 planets, rarity = 1
BALIATRO.LootPlaceholder {
    key = 'four_planets',
    generates = {
        set = 'Planet',
        amount = 4,
    },
    rarity = 1,
    weight = 5,
}

-- 4 mirrored planets, rarity = 2
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

-- 4 negative planets, rarity = 3
BALIATRO.LootPlaceholder {
    key = 'four_negative_planets',
    generates = {
        set = 'Planet',
        amount = 4,
    },
    rarity = 3,
    weight = 5,
}

-- 1 crystal ball, rarity = 3
BALIATRO.LootPlaceholder {
    key = 'crystal_ball',
    generates = {
        set = 'Voucher',
        key = 'v_crystal_ball',
        amount = 1,
    },
    rarity = 3,
    weight = 5,
}

BALIATRO.Goals = {}

-- Goal class definition
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
                goal.progress = math.min(1, goal.got / need)
            end
        elseif goal.has_hand then
            if context.before and next(context.poker_hands[goal.has_hand]) then
                local need = goal.count or 1
                goal.got = goal.got and (goal.got + 1) or 1
                if goal.got >= need then self:mark_complete(goal) end
                goal.progress = math.min(1, goal.got / need)
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
                goal.got = goal.got or 0
                if goal.score_ranks[rank] then
                    goal.got = goal.got + 1
                    if goal.got >= need then self:mark_complete(goal) end
                end
                goal.progress = math.min(1, goal.got / need)
            end
        elseif goal.score_suits then
            if context.individual and context.cardarea == G.play and not context.end_of_round then
                local need = goal.count or 1
                local pass = false
                goal.got = goal.got or 0
                for k, _ in pairs(goal.score_suits) do
                    if context.other_card:is_suit(k) then pass = true; break end
                end
                if pass then
                    goal.got = goal.got + 1
                    if goal.got >= need then self:mark_complete(goal) end
                end
                goal.progress = math.min(1, goal.got / need)
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
            if context.before then
                if G.GAME.current_round.hands_played + 1 >= goal.hands_played then self:mark_complete(goal) end
                goal.progress = math.min(1, (G.GAME.current_round.hands_played + 1) / goal.hands_played)
            end
        elseif goal.different_hands_played then
            if context.before then
                goal._different_hands_played[context.scoring_name] = true
                local k = 0
                for _, __ in pairs(goal._different_hands_played) do k = k + 1 end
                if k >= goal.different_hands_played then self:mark_complete(goal) end
                goal.progress = math.min(1, k / goal.different_hands_played)
            end
        elseif goal.fail_on_different_hands_played then
            if context.before then
                goal._different_hands_played[context.scoring_name] = true
                local k = 0
                for _, __ in pairs(goal._different_hands_played) do k = k + 1 end
                if k >= goal.fail_on_different_hands_played then self:mark_failed(goal) end
            end
        end
    end,
}

local cuibhb = create_UIBox_HUD_blind
-- Override: create blind HUD UIBox
create_UIBox_HUD_blind = function()
    local ret = cuibhb()
    local container = ret.nodes
    container[#container+1] = {n=G.UIT.R, config={id='HUD_blind_goals', align="cm", minh = 0.4, func = 'HUD_blind_goals'}, nodes = {}}
    return ret
end

-- Failed cache function
BALIATRO.objective_cached_sprite = function(pos)
    local idx = pos.y * 8 + pos.x
    local _size = 0.4
    return Sprite(0, 0, _size, _size, G.ASSET_ATLAS['baliatro_BaliatroObjectiveIcons'], pos)
    --if not BALIATRO.objective_sprite_cache[idx] then
    --    BALIATRO.objective_sprite_cache[idx] = Sprite(0, 0, _size, _size, G.ASSET_ATLAS['baliatro_BaliatroObjectiveIcons'], pos)
    --end
    --return BALIATRO.objective_sprite_cache[idx]
end

-- Calculates pos on the objective sprite atlas based on progress and completion status
BALIATRO.calc_objective_sprite_pos = function(conf)
    if conf.is_completed then return {x = 0, y = 2} end
    if conf.is_failed then return {x = 1, y = 2} end
    if not conf.progress then return {x = 0, y = 0} end
    if conf.progress >= 1 then return {x = 7, y = 1} end
    if conf.progress <= 0 then return {x = 0, y = 0} end

    local progress_denom = {0, 0.0625, 0.1, 0.125, 0.2, 0.25, 0.33, 0.4, 0.5, 0.6, 0.6667, 0.75, 0.8, 0.9, 0.9375, 1}
    for idx, denom in ipairs(progress_denom) do
        if conf.progress <= denom then
            local prog_idx = idx - 1
            local x = prog_idx % 8
            local y = math.floor(prog_idx / 8)
            return {x = x, y = y}
        end
    end
    return {x = 0, y = 0} -- failsafe
end

-- Callback function to update completion status on tooltip
BALIATRO.completed_indicator = function(config, e)
    if config.is_completed then
        e.children[1].config.text = localize('k_baliatro_completed_ex')
        e.children[1].config.colour = G.C.PALE_GREEN
    elseif config.is_failed then
        e.children[1].config.text = localize('k_baliatro_failed_ex')
        e.children[1].config.colour = G.C.RED
    elseif config.complete_if_not_failed then
        e.children[1].config.text = localize('k_baliatro_autocompletes_ex')
        e.children[1].config.colour = G.C.IMPORTANT
    end
    e.UIBox:recalculate(true)
end

-- Generates contents for goal tooltips
BALIATRO.goal_tooltip_filler = function(args)
    local goal_key, rewards, config = args[1], args[2], args[3]
    local goal = BALIATRO.Goals[goal_key]


    local progression_scale = 0.35
    local label_scale = 0.35
    local reward_scale = 0.3
    local desc_nodes = {}
    local reward_nodes = {
        {n = G.UIT.R, config={align="cm"}, nodes={
            {n = G.UIT.T, config={text = localize('k_baliatro_rewards_colon'), scale = label_scale, colour = G.C.BLACK}}
        }},
    }

    for i, reward_key in ipairs(rewards) do
        local reward = G.P_CENTERS[reward_key]
        local current_nodes = {}
        if reward.generates.amount then
            current_nodes[#current_nodes + 1] = {n = G.UIT.T, config={text = reward.generates.amount .. "x ", scale = reward_scale, colour = G.C.BLACK}}
        end
        current_nodes[#current_nodes + 1] = {n = G.UIT.T, config={text = reward:describe_generates(), scale = reward_scale, colour = G.C.IMPORTANT}}
        local current = {n = G.UIT.R, config={align="cr"}, nodes=current_nodes}
        reward_nodes[#reward_nodes+1] = current
    end

    local loc_target = {set='Goal', type='descriptions', key=goal_key, vars={}, nodes=desc_nodes}
    if goal.loc_vars and type(goal.loc_vars) == 'function' then
        local res = goal:loc_vars(config) or {}
        loc_target.vars = res.vars or loc_target.vars
        loc_target.key = res.key or loc_target.key
    end

    localize(loc_target)
    local main_rows = {}
    for _, row in ipairs(desc_nodes) do
        main_rows[#main_rows+1] = {n = G.UIT.R, config={align="cm"}, nodes=row}
    end
    main_rows[#main_rows+1] = {n=G.UIT.R, config={align="cm", minh=0.2}, nodes = {}}
    main_rows[#main_rows+1] = {n=G.UIT.R, config={align="cm", padding = 0.03, colour=darken(G.C.JOKER_GREY, 0.2), func='HUD_' .. goal_key .. '_completed_indicator'}, nodes = {
        {n = G.UIT.T, config={text = "", scale = progression_scale, colour = G.C.BLACK}}
    }}
    main_rows[#main_rows+1] = {n=G.UIT.R, config={align="cm", minh=0.2}, nodes = {}}
    main_rows[#main_rows+1] = {n=G.UIT.R, config={align="cm"}, nodes = {
        {n=G.UIT.C, config={align="tm"}, nodes=reward_nodes},
    }}
    local root = {n=G.UIT.R, config={align = "cm", padding = 0.03, emboss=0.03, colour=G.C.JOKER_GREY}, nodes = {
        {n=G.UIT.C, config={align="cm"}, nodes=main_rows}
    }}
    return root
end

-- Callback function to update goal sprites
BALIATRO.goal_sprite_updater = function(config, e)
    if e.config.last_progress_drawn ~= -1 and config.is_completed or config.is_failed then
        e.config.last_progress_drawn = -1
        e.config.object = BALIATRO.objective_cached_sprite(BALIATRO.calc_objective_sprite_pos(config))
    end
    if e.config.last_progress_drawn == -1 then return end
    if e.config.last_progress_drawn == config.progress then return end
    e.config.last_progress_drawn = config.progress
    e.config.object = BALIATRO.objective_cached_sprite(BALIATRO.calc_objective_sprite_pos(config))
end

-- HUD function to generate contents of blind goals indicator on top left blind HUD
G.FUNCS.HUD_blind_goals = function(e)
    if G.GAME.blind_goals_dirty and G.GAME.blind_idx then
        for _, child in ipairs(e.children) do
            child:remove()
        end
        e.children = {}
        if G.GAME.blind.in_blind then
            for goal_key, goal_data in pairs(G.GAME.ante_goals[G.GAME.blind_idx]) do
                local conf = goal_data.config

                local goal_sprite = BALIATRO.objective_cached_sprite(BALIATRO.calc_objective_sprite_pos(conf))
                G.FUNCS['HUD_' .. goal_key .. '_completed_indicator'] = function(e) BALIATRO.completed_indicator(conf, e) end
                G.FUNCS['HUD_' .. goal_key .. '_update_sprite'] = function(e) BALIATRO.goal_sprite_updater(conf, e) end

                local tooltip = {title = "Goal", filler = {func = BALIATRO.goal_tooltip_filler, args = {goal_key, goal_data.reward, conf}}}--
                local node_def = {n=G.UIT.C, config={align='cm', on_demand_tooltip = tooltip}, nodes={{n = G.UIT.O, config = {object = goal_sprite, last_progress_drawn = goal_data.config.progress, func = 'HUD_' .. goal_key .. '_update_sprite'}}}}
                e.UIBox:set_parent_child(node_def, e)
            end
        end
        G.GAME.blind_goals_dirty = false
        e.UIBox:recalculate(true)
    end
    --BALIATRO.update_goal_progresses(e)
    --
end

-- Generate a loot of a given rarity
BALIATRO.pick_loot = function(rarity, seed)
    --print('picking loot of rarity ' .. rarity)
    local max = BALIATRO.loot_total_weight[rarity]
    --print('max weight: ' .. max)
    if not max or max == 0 then return nil end
    local wtroll = pseudorandom(seed, 1, max)
    --print('rolled weight: ' .. wtroll)
    for idx, maxwt in ipairs(BALIATRO.loot_weights[rarity]) do
        if wtroll < maxwt then
            --print('found higher weight: ' .. maxwt)
            --print('assignment: ' .. (BALIATRO.loot_weight_assignment[rarity][maxwt] and BALIATRO.loot_weight_assignment[rarity][maxwt].key or 'nil'))
            return BALIATRO.loot_weight_assignment[rarity][maxwt]
        end
    end
    --print('found no higher weight')
    return nil
end

-- Initialize a goal configuration object for a goal
BALIATRO.create_goal_config = function(goal_key)
    local goal = BALIATRO.Goals[goal_key]
    local goal_conf = goal.config and type(goal.config) == 'table' and copy_table(goal.config) or {}
    goal_conf.progress = goal.config.complete_if_not_failed and 1 or 0
    if goal.on_create and type(goal.on_create) == 'function' then goal:on_create(goal_conf) end
    return goal_conf
end

-- Create a goal of a specific rarity.
BALIATRO.create_goal = function(rarity, except, except_rewards)
    except = except or {}
    local pool = rarity and BALIATRO.GoalsByRarity[rarity] or BALIATRO.Goals
    --print('creating new goal of rarity', rarity)
    local tries = 0
    local goal = nil
    repeat
        goal = pseudorandom_element(pool, pseudoseed('antegoal' .. G.GAME.round_resets.ante))
        --print('create goal picked goal: ', goal and goal.key or nil)
        if except[goal.key] then
            --print('create goal picked goal on exception list')
            goal = nil
        end
        tries = tries + 1
    until tries > 50 or goal

    if not goal then
        --print('could not pick goal')
        return nil, {}, {}
    end

    local rewards = {}

    for i = 1, goal.loot_amount do
        local loot_rarity = goal.min_loot_rarity == goal.max_loot_rarity and goal.min_loot_rarity or pseudorandom('antegoal' .. G.GAME.round_resets.ante, goal.min_loot_rarity, goal.max_loot_rarity)
        local loot = BALIATRO.pick_loot(loot_rarity, pseudoseed('antegoal' .. G.GAME.round_resets.ante))
        if loot then rewards[#rewards+1] = loot.key end
    end

    local goal_config = BALIATRO.create_goal_config(goal.key)

    return goal.key, goal_config, rewards
end

-- Add a round evaluation row indicating the status of a goal.
function BALIATRO.add_round_eval_goal(goal, completed, pitch)
    local width = G.round_eval.T.w - 0.51
    total_cashout_rows = (total_cashout_rows or 0) + 1
    if total_cashout_rows > 7 then
        return
    end
    local scale = 0.9

    if not G.round_eval.divider_added then
        G.E_MANAGER:add_event(Event({
            trigger = 'after',delay = 0.25,
            func = function()
                local spacer = {n=G.UIT.R, config={align = "cm", minw = width}, nodes={
                    {n=G.UIT.O, config={object = DynaText({string = {'......................................'}, colours = {G.C.WHITE},shadow = true, float = true, y_offset = -30, scale = 0.45, spacing = 13.5, font = G.LANGUAGES['en-us'].font, pop_in = 0})}}
                }}
                G.round_eval:add_child(spacer,G.round_eval:get_UIE_by_ID('bonus_round_eval'))
                return true
            end
        }))
        delay(0.6)
        G.round_eval.divider_added = true
    end

    delay(0.2)

    G.E_MANAGER:add_event(Event({
        trigger = 'before',delay = 0.5,
        func = function()
            --Add the far left text and context first:
            local left_text = {}
            table.insert(left_text, {n=G.UIT.O, config={object = DynaText({string = localize{type = 'name_text', set = "Goal", key = goal}, colours = {G.C.FILTER}, shadow = true, pop_in = 0, scale = 0.6*scale, silent = true})}})
            local full_row = {n=G.UIT.R, config={align = "cm", minw = 5}, nodes={
                {n=G.UIT.C, config={padding = 0.05, minw = width*0.55, minh = 0.61, align = "cl"}, nodes=left_text},
                {n=G.UIT.C, config={padding = 0.05,minw = width*0.45, align = "cr"}, nodes={{n=G.UIT.C, config={align = "cm", id = 'goal_'..goal},nodes={}}}}
            }}

            G.round_eval:add_child(full_row,G.round_eval:get_UIE_by_ID('bonus_round_eval'))
            play_sound('cancel', pitch or 1)
            play_sound('highlight1',( 1.5*pitch) or 1, 0.2)
            return true
        end
    }))
    local dollar_row = 0
    G.E_MANAGER:add_event(Event({
        trigger = 'before',delay = 0.38,
        func = function()
            G.round_eval:add_child(
                    {n=G.UIT.R, config={align = "cm", id = 'dollar_row_'..(dollar_row+1)..'_'..goal}, nodes={
                        {n=G.UIT.O, config={object = DynaText({string = {localize(completed and 'k_baliatro_completed_ex' or 'k_baliatro_failed_ex')}, colours = {completed and G.C.GREEN or G.C.RED}, shadow = true, pop_in = 0, scale = 0.5, float = true})}}
                    }},
                    G.round_eval:get_UIE_by_ID('goal_'..goal))

            play_sound(completed and 'multhit2' or 'multhit1', 0.9+0.2*math.random(), 0.7)
            return true
        end
    }))
end

-- Generate the goals for a new ante.
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
            if goal then
                m_goal_pool[goal] = true
                goals[#goals+1] = goal
                rewards[#rewards+1] = reward
                configs[#configs+1] = config
            end
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

-- Evaluate the goals at the end of a round and grant rewards.
BALIATRO.evaluate_round_goals = function()
    G.GAME.current_round.goal_evals = {}
    for goal_key, goal_data in pairs(G.GAME.ante_goals[G.GAME.blind_idx]) do
        local conf = goal_data.config
        local success = false
        if conf.is_completed or (conf.complete_if_not_failed and not conf.is_failed) then success = true end

        G.GAME.current_round.goal_evals[goal_key] = success

        if success then
            for _, loot in ipairs(goal_data.reward) do
            local card = SMODS.create_card{area = G.loot, set = "LootPlaceholder", key = loot, discover = true, bypass_discovery_center = true, skip_materialize = true, key_append = "loot"}
            G.loot:emplace(card)
            end
        end
    end
end

-- Helper function for loc_vars of score_suits goals.
BALIATRO.goal_suit_score_helper = function(self, goal)
    local vars = {goal.count}
    local colours = {}
    for k, _ in pairs(goal.score_suits) do
        vars[#vars+1] = localize(k, 'suits_plural')
        colours[#colours+1] = G.C.SUITS[k]
    end

    vars.colours = colours
    return {vars = vars}
end

-- Helper function for loc_vars of fail_on_suits goals.
BALIATRO.goal_no_suit_score_helper = function(self, goal)
    local vars = {}
    local colours = {}
    for k, _ in pairs(goal.fail_on_suits) do
        vars[#vars+1] = localize(k, 'suits_plural')
        colours[#colours+1] = G.C.SUITS[k]
    end

    vars.colours = colours
    return {vars = vars}
end


-- Helper function for loc_vars of score_ranks goals.
BALIATRO.goal_rank_score_helper = function(self, goal)
    local vars = {goal.count}
    for k, _ in pairs(goal.score_ranks) do
        vars[#vars+1] = localize(k, 'ranks')
    end

    return {vars = vars}
end


-- Helper function for loc_vars of fail_on_ranks goals.
BALIATRO.goal_no_rank_score_helper = function(self, goal)
    local vars = {goal.count}
    for k, _ in pairs(goal.fail_on_ranks) do
        vars[#vars+1] = localize(k, 'ranks')
    end

    return {vars = vars}
end


-- Play 2x containing Two Pair, rarity 2, reward: 2x(1-2)
BALIATRO.Goal {
    key = 'play_two_two_pair',
    rarity = 2,
    min_loot_rarity = 1,
    max_loot_rarity = 2,
    loot_amount = 2,
    config = {
        has_hand = 'Two Pair',
        count = 2,
    },
    loc_vars = function(self, goal)
        return {vars = {goal.count, goal.hand}}
    end
}

-- Play 2x exactly Flush, rarity 2, reward: 2x(1-2)
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
    loc_vars = function(self, goal)
        return {vars = {goal.count, goal.hand}}
    end
}

-- Play 1x exactly Straight Flush, rarity 4, reward: 2x(2-3)
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

    loc_vars = function(self, goal)
        return {vars = {goal.count, goal.hand}}
    end
}

-- Play 1x containing Four of a Kind, rarity 4, reward: 2x(2-3)
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

    loc_vars = function(self, goal)
        return {vars = {goal.count, goal.has_hand}}
    end
}

-- Fail on containing Three of a Kind, rarity 2, reward: 2x(1-2)
BALIATRO.Goal {
    key = 'play_no_triplicates',
    rarity = 2,
    min_loot_rarity = 1,
    max_loot_rarity = 2,
    loot_amount = 2,
    config = {
        complete_if_not_failed = true,
        fail_has_hand = 'Three of a Kind',
    },

    loc_vars = function(self, goal)
        return {vars = {goal.fail_has_hand}}
    end
}

-- Fail on containing Pair, rarity 4, reward: 2x(2-3)
BALIATRO.Goal {
    key = 'play_no_duplicates',
    rarity = 4,
    min_loot_rarity = 2,
    max_loot_rarity = 3,
    loot_amount = 2,
    config = {
        complete_if_not_failed = true,
        fail_has_hand = 'Pair',
    },

    loc_vars = function(self, goal)
        return {vars = {goal.fail_has_hand}}
    end
}

-- Fail on 5 scoring cards, rarity 3, reward: 2x(1-3)
BALIATRO.Goal {
    key = 'play_less_than_five',
    rarity = 3,
    min_loot_rarity = 1,
    max_loot_rarity = 3,
    loot_amount = 2,
    config = {
        complete_if_not_failed = true,
        fail_on_cards_gt = 4,
    },

    loc_vars = function(self, goal)
        return {vars = {goal.fail_on_cards_gt}}
    end
}

-- Score 10x Hearts, rarity 3, reward: 2x(1-3)
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

    loc_vars = BALIATRO.goal_suit_score_helper,
}

-- Score 10x Diamonds, rarity 3, reward: 2x(1-3)
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

    loc_vars = BALIATRO.goal_suit_score_helper,
}

-- Score 10x Spades, rarity 3, reward: 2x(1-3)
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

    loc_vars = BALIATRO.goal_suit_score_helper,
}

-- Score 10x Clubs, rarity 3, reward: 2x(1-3)
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

    loc_vars = BALIATRO.goal_suit_score_helper,
}

-- Score 14x out of 2 suits, rarity 4, reward: 2x(2-3)
BALIATRO.Goal {
    key = 'score_two_suits_fourteen_total',
    rarity = 4,
    min_loot_rarity = 2,
    max_loot_rarity = 3,
    loot_amount = 2,
    config = {
        count = 14,
    },

    on_create = function(self, goal)
        local els = BALIATRO.nrandom_elements(SMODS.Suits, 2, pseudoseed("goal2s14"..G.GAME.round_resets.ante))
        goal.score_suits = {}
        for _, el in ipairs(els) do goal.score_suits[el[2]] = true end
    end,

    loc_vars = BALIATRO.goal_suit_score_helper,
}

-- Score 5x out of 3 ranks, rarity 2, reward: 2x(1-2)
BALIATRO.Goal {
    key = 'score_three_ranks_five_total',
    rarity = 2,
    min_loot_rarity = 1,
    max_loot_rarity = 2,
    loot_amount = 2,
    config = {
        count = 5,
    },

    on_create = function(self, goal)
        local els = BALIATRO.nrandom_elements(SMODS.Ranks, 3, pseudoseed("goal3r5"..G.GAME.round_resets.ante))
        goal.score_ranks = {}
        for _, el in ipairs(els) do goal.score_ranks[el[2]] = true end
    end,

    loc_vars = BALIATRO.goal_rank_score_helper,
}

-- Fail on scoring any of 3 ranks, rarity 1, reward: 2x(1-1)
BALIATRO.Goal {
    key = 'play_none_of_three_ranks',
    rarity = 1,
    min_loot_rarity = 1,
    max_loot_rarity = 1,
    loot_amount = 2,
    config = {
        complete_if_not_failed = true,
    },

    on_create = function(self, goal)
        local els = BALIATRO.nrandom_elements(SMODS.Ranks, 3, pseudoseed("goal3nr"..G.GAME.round_resets.ante))
        goal.fail_on_ranks = {}
        for _, el in ipairs(els) do goal.fail_on_ranks[el[2]] = true end
    end,

    loc_vars = BALIATRO.goal_no_rank_score_helper,
}

-- Fail on scoring a suit, rarity 1, reward: 2x(1-1)
BALIATRO.Goal {
    key = 'play_none_of_suit',
    rarity = 1,
    min_loot_rarity = 1,
    max_loot_rarity = 1,
    loot_amount = 2,
    config = {
        complete_if_not_failed = true,
    },

    on_create = function(self, goal)
        local els = BALIATRO.nrandom_elements(SMODS.Suits, 1, pseudoseed("goal1ns"..G.GAME.round_resets.ante))
        goal.fail_on_suits = {}
        for _, el in ipairs(els) do goal.fail_on_suits[el[2]] = true end
    end,

    loc_vars = BALIATRO.goal_no_suit_score_helper,
}

-- Fail on scoring any of 2 suits, rarity 2, reward: 2x(1-2)
BALIATRO.Goal {
    key = 'play_none_of_two_suits',
    rarity = 2,
    min_loot_rarity = 1,
    max_loot_rarity = 2,
    loot_amount = 2,
    config = {
        complete_if_not_failed = true,
    },

    on_create = function(self, goal)
        local els = BALIATRO.nrandom_elements(SMODS.Suits, 2, pseudoseed("goal2ns"..G.GAME.round_resets.ante))
        goal.fail_on_suits = {}
        for _, el in ipairs(els) do goal.fail_on_suits[el[2]] = true end
    end,

    loc_vars = BALIATRO.goal_no_suit_score_helper,
}

-- Win in 1 hand, rarity 5, reward: 2x(3-3)
BALIATRO.Goal {
    key = 'win_in_one_hand',
    rarity = 5,
    min_loot_rarity = 3,
    max_loot_rarity = 3,
    loot_amount = 1,
    config = {
        complete_if_not_failed = true,
        fail_on_hands_played = 2,
    },

    loc_vars = function(self, goal)
        return {vars = {goal.fail_on_hands_played - 1}}
    end
}

-- Play 3 hands, rarity 1, reward: 2x(1-2)
BALIATRO.Goal {
    key = 'play_three_hands',
    rarity = 1,
    min_loot_rarity = 1,
    max_loot_rarity = 2,
    loot_amount = 2,
    config = {
        hands_played = 3,
    },

    loc_vars = function(self, goal)
        return {vars = {goal.hands_played}}
    end
}

-- Play 2 different hands, rarity 1, reward: 2x(1-1)
BALIATRO.Goal {
    key = 'play_two_different_hands',
    rarity = 1,
    min_loot_rarity = 1,
    max_loot_rarity = 1,
    loot_amount = 2,
    config = {
        different_hands_played = 2,
    },

    on_create = function(self, goal)
        goal._different_hands_played = {}
    end,

    loc_vars = function(self, goal)
        return {vars = {goal.different_hands_played}}
    end
}

-- Play 1 hand type, rarity 1, reward: 3x(1-1)
BALIATRO.Goal {
    key = 'play_one_hand_type',
    rarity = 1,
    min_loot_rarity = 1,
    max_loot_rarity = 1,
    loot_amount = 3,
    config = {
        complete_if_not_failed = true,
        fail_on_different_hands_played = 2,
    },

    on_create = function(self, goal)
        goal._different_hands_played = {}
    end,

    loc_vars = function(self, goal)
        return {vars = {goal.fail_on_different_hands_played - 1}}
    end
}

-- 75% of blind goal in one hand, rarity 2, reward: 2x(1-2)
BALIATRO.Goal {
    key = 'score_at_least_three_quarters',
    rarity = 2,
    min_loot_rarity = 1,
    max_loot_rarity = 2,
    loot_amount = 2,
    config = {
        score_percentage = 0.75,
    },

    loc_vars = function(self, goal)
        return {vars = {goal.score_percentage * 100}}
    end
}


-- 200% of blind goal in one hand, rarity 4, reward: 2x(2-3)
BALIATRO.Goal {
    key = 'overscore_double',
    rarity = 4,
    min_loot_rarity = 2,
    max_loot_rarity = 3,
    loot_amount = 2,
    config = {
        score_percentage = 2,
    },

    loc_vars = function(self, goal)
        return {vars = {goal.score_percentage * 100}}
    end
}

-- 1000% of blind goal in one hand, rarity 5, reward: 2x(3-3)
BALIATRO.Goal {
    key = 'overscore_ten_times',
    rarity = 5,
    min_loot_rarity = 3,
    max_loot_rarity = 3,
    loot_amount = 2,
    config = {
        score_percentage = 10,
    },

    loc_vars = function(self, goal)
        return {vars = {goal.score_percentage * 100}}
    end
}

end
