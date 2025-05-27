--- STEAMODDED HEADER
--- MOD_NAME: DistantRemnants
--- MOD_ID: DISTANTREMNANTS
--- MOD_AUTHOR: [DistantRemnants]
--- MOD_DESCRIPTION: New jokers and inside jokes.
--- PREFIX: drx1
---------------------------------------------
-------------MOD CODE------------------------
SMODS.Atlas {
    key = 'Jokers',
    path = 'Jokers.png',
    px = 71,
    py = 95
}

SMODS.Atlas {
    key = 'modicon',
    path = 'Icon.png',
    px = 32,
    py = 32,
}

-- Talisman crash
to_big = to_big or function(x) return x end

-- Get ID
local getidref = Card.get_id
function Card:get_id()
    local id = getidref(self)
    local suit = self.base.suit

    if id == nil then
        id = 13
    end

    if next(SMODS.find_card('j_drx1_dauphine')) and (suit == 'Diamonds' or SMODS.has_enhancement(self, 'm_wild')) then
        if id <= 12 or id == 14 then
            id = 13
        end
    end

    return id
end

-- Get Face
local isfaceref = Card.is_face
function Card:is_face(from_boss)
    if self.debuff and not from_boss then return end
    local suit = self.base.suit
    if next(SMODS.find_card('j_drx1_dauphine')) and (suit == 'Diamonds' or SMODS.has_enhancement(self, 'm_wild')) or next(find_joker("Pareidolia")) then
        return true
    end
	return isfaceref(self, from_boss)
end

--The Menu Please G
SMODS.Joker {
    key = 'menu',
    atlas = 'Jokers',
    pos = {
        x = 0,
        y = 4
    },
    blueprint_compat = true,
    perishable_compat = false,
    eternal_compat = true,
    rarity = 1,
    cost = 4,
    config = {
        extra = {
            chips = 0,
        }
    },

    loc_vars = function(self, info_queue, card)
        return {
            vars = {card.ability.extra.chips}
        }
    end,

    calculate = function(self, card, context)

        if context.remove_playing_cards and not context.blueprint then
            local totalchip = 0
            local destroyed = {}
            for k, v in ipairs(context.removed) do
                if not v.debuff then
                    destroyed[#destroyed+1] = v
                    local lostchip = v:get_chip_bonus()

                    if v.edition and v.edition.foil then
                        lostchip = lostchip + 50
                    end

                    totalchip = totalchip + (lostchip*2)
                end
            end

            if totalchip > 0 then
                card.ability.extra.chips = card.ability.extra.chips + totalchip
                card_eval_status_text(card, 'extra', nil, nil, nil, { message = localize('k_upgrade_ex'), colour = G.C.CHIPS})
            end
        end

        if context.joker_main then
            return{
                chips = card.ability.extra.chips
            }
        end

    end
}

--Eglantine G
SMODS.Joker {
    key = 'eglantine',
    atlas = 'Jokers',
    pos = {
        x = 3,
        y = 4
    },
    blueprint_compat = true,
    perishable_compat = true,
    eternal_compat = true,
    rarity = 1,
    cost = 5,
    config = {
        extra = {
            xmult = 2,
            shop = 1,
        }
    },

    add_to_deck = function(self, card, from_debuff)
        card_eval_status_text(card, 'extra', nil, nil, nil, {message = 'Vive la Commune!', colour = G.C.MULT})
        G.E_MANAGER:add_event(Event({func = function()
            change_shop_size(-card.ability.extra.shop)
        return true end }))
    end,

    remove_from_deck = function(self, card, from_debuff)
        card_eval_status_text(card, 'extra', nil, nil, nil, {message = 'Bourgeois!', colour = G.C.MULT})
        G.E_MANAGER:add_event(Event({func = function()
            change_shop_size(card.ability.extra.shop)
        return true end }))
    end,

    loc_vars = function(self, info_queue, card)
        return {
            vars = {card.ability.extra.xmult, card.ability.extra.shop}
        }
    end,

    calculate = function(self, card, context)

        if context.joker_main then
            return{
                xmult = card.ability.extra.xmult
            }
        end
        
    end
}

--Great Wall of China R
SMODS.Joker {
    key = 'great_wall',
    atlas = 'Jokers',
    pos = {
        x = 0,
        y = 3
    },
    blueprint_compat = true,
    perishable_compat = true,
    eternal_compat = true,
    rarity = 1,
    cost = 4,
    enhancement_gate = 'm_stone',
    config = {
        extra = {
            stones = 3,
        }
    },

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = G.P_CENTERS.m_stone
        local stone_tally = 0
        for k, v in pairs(G.playing_cards or {}) do
            if SMODS.has_enhancement(v, 'm_stone') then stone_tally = stone_tally + 1 end
        end
        return {
            vars = {card.ability.extra.stones, math.floor(stone_tally/card.ability.extra.stones)}
        }
    end,

    calculate = function(self, card, context)

        if context.setting_blind then
            local stone_tally = 0
            for k, v in pairs(G.playing_cards or {}) do
                if SMODS.has_enhancement(v, 'm_stone') then stone_tally = stone_tally + 1 end
            end
            if stone_tally >= card.ability.extra.stones then
                G.E_MANAGER:add_event(Event({func = function()
                    ease_hands_played(math.floor(stone_tally/card.ability.extra.stones))
                    card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = "Gong!", colour = G.C.BLUE})
                return true end }))
            end
        end
    end
}

--A Bucket and a Spade R
SMODS.Joker {
    key = 'bucket_spade',
    atlas = 'Jokers',
    pos = {
        x = 1,
        y = 3
    },
    blueprint_compat = true,
    perishable_compat = false,
    eternal_compat = true,
    rarity = 1,
    cost = 2,
    config = {
        extra = {
            multmod = 2,
            lose = 1,
            mult = 0
        }
    },

    loc_vars = function(self, info_queue, card)
        return {
            vars = {card.ability.extra.multmod, card.ability.extra.lose, card.ability.extra.mult}
        }
    end,

    calculate = function(self, card, context)

        if not context.blueprint and context.before and context.cardarea == G.jokers then
            local _spade = 0
            for i = 1, #context.scoring_hand do
                if (context.scoring_hand[i]:is_suit('Spades', true)
                or (context.scoring_hand[i].ability
                and context.scoring_hand[i].ability.name == 'Wild Card'))
                and _spade == 0 then
                    _spade = _spade + 1
                end
            end

            if _spade >= 1 then
                card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.multmod
                ease_dollars(-card.ability.extra.lose)
                card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('k_upgrade_ex'), colour = G.C.FILTER})
            end

        end

        if context.joker_main and card.ability.extra.mult > 0 then
            return {
                mult = card.ability.extra.mult
            }
        end

    end
}

--Off with their heads! R
SMODS.Joker {
    key = 'off_head',
    atlas = 'Jokers',
    pos = {
        x = 6,
        y = 4
    },
    blueprint_compat = false,
    perishable_compat = true,
    eternal_compat = true,
    rarity = 1,
    cost = 4,
    config = {
        extra = {
            Queen = 0
        }
    },

    loc_vars = function(self, info_queue, card)
        return { vars = {card.ability.extra.Queen}
        }
    end,

    calculate = function(self, card, context)

        if not context.blueprint then
            if context.before then
                local HQ = false
                card.ability.extra.Queen = 0

                for i = 1, #context.scoring_hand do
                    if context.scoring_hand[i]:get_id() == 12
                    and context.scoring_hand[i]:is_suit("Hearts") then
                        HQ = true
                        card.ability.extra.Queen = 1
                        break
                    end
                end
                if HQ == true then
                    for i = 1, #context.scoring_hand do
                        if context.scoring_hand[i]:get_id() ~= 12
                        or not context.scoring_hand[i]:is_suit("Hearts") then
                            context.scoring_hand[i].off_with_his_head = true
                        end
                    end
                end
            end
            if context.destroying_card
            and context.destroying_card.off_with_his_head == true
            then
                if card.ability.extra.Queen == 1 then
                    card_eval_status_text(card, 'extra', nil, nil, nil, {message = "Off with their heads!", colour = G.C.SUITS.Hearts})
                card.ability.extra.Queen = 0
                end
                return { remove = true }
            end
        end
    end
}

--Safe Password R
SMODS.Joker {
    key = 'password',
    atlas = 'Jokers',
    pos = {
        x = 2,
        y = 3
    },
    blueprint_compat = true,
    perishable_compat = true,
    eternal_compat = true,
    rarity = 1,
    cost = 4,
    config = {
        extra = {
            draw = 4,
            flag = 0
        }
    },

    loc_vars = function(self, info_queue, card)
        return {
            vars = {card.ability.extra.draw, card.ability.extra.flag}
        }
    end,

    calculate = function(self, card, context)

        if context.cardarea == G.jokers then

            if context.before and not context.blueprint then
                card.ability.extra.flag = 0
                if next(context.poker_hands['Straight']) then
                    card.ability.extra.flag = 1
                end
            end

            if context.pre_discard then
                card.ability.extra.flag = 0
            end

            if card.ability.extra.flag == 1 and context.hand_space then
                card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = localize('k_safe_ex'), colour = G.C.CHIPS})
                for i=1, card.ability.extra.draw do
                    draw_card(G.deck,G.hand, i*100/(card.ability.extra.draw), 'up', true)
                end
                --card.ability.extra.flag = 0
            end

            if context.end_of_round then
                card.ability.extra.flag = 0
            end
        end
    end
}

--Slipstream R
SMODS.Joker {
    key = 'slipstream',
    atlas = 'Jokers',
    pos = {
        x = 3,
        y = 3
    },
    blueprint_compat = false,
    perishable_compat = true,
    eternal_compat = true,
    rarity = 2,
    cost = 6,
    config = {
        extra = {
        }
    },

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = G.P_CENTERS.m_glass
        return {
            
        }
    end,

    calculate = function(self, card, context)

        if context.before
        and (next(context.poker_hands['Straight']) or next(context.poker_hands['Straight Flush']))
        and not context.blueprint then
            context.scoring_hand[1]:set_ability(G.P_CENTERS.m_glass, nil, true)
            card_eval_status_text(card, 'extra', nil, nil, nil, {message = "Risk it!", colour = G.C.BLUE})
            G.E_MANAGER:add_event(Event({
                func = function()
                    context.scoring_hand[1]:juice_up()
                    return true
                end
            }))
        end
    end
}

--Mismatched Socks / Diane R
SMODS.Joker {
    key = 'mismatched',
    atlas = 'Jokers',
    pos = {
        x = 5,
        y = 3
    },
    blueprint_compat = true,
    perishable_compat = true,
    eternal_compat = true,
    rarity = 2,
    cost = 5,
    config = {
        extra = {
            odds = 3,
        }
    },

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = G.P_TAGS.tag_double
        return {
            vars = {'' .. (G.GAME and G.GAME.probabilities.normal or 1),
            card.ability.extra.odds,
            localize{type = 'name_text', set = 'Tag', key = 'tag_double', nodes = {}}}
        }
    end,

    calculate = function(self, card, context)

        if context.cardarea == G.jokers then
            if context.joker_main
            and context.scoring_name == "Two Pair"
            and (pseudorandom('rage') < G.GAME.probabilities.normal / card.ability.extra.odds) then
                card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, { message = 'Rage!', colour = G.C.MULT })
                G.E_MANAGER:add_event(Event({
                    func = (function()
                        add_tag(Tag('tag_double'))
                        play_sound('generic1', 0.9 + math.random()*0.1, 0.8)
                        play_sound('holo1', 1.2 + math.random()*0.1, 0.4)
                        return true
                    end)
                }))
            end
        end

    end
}

-- Detection de tag
local oldtagyep = Tag.yep
function Tag:yep(message, _colour, func)
    G.GAME.vdr_tag_used = G.GAME.vdr_tag_used or 0
    G.GAME.vdr_tag_used = G.GAME.vdr_tag_used + 1
    SMODS.calculate_context({vdr_tag_used = G.GAME.vdr_tag_used})
    return oldtagyep(self, message, _colour, func)
end

--Hang Tag R
SMODS.Joker {
    key = 'hang_tag',
    atlas = 'Jokers',
    pos = {
        x = 1,
        y = 4
    },
    blueprint_compat = true,
    perishable_compat = true,
    eternal_compat = true,
    rarity = 2,
    cost = 5,
    config = {
        extra = {
            chipsmod = 40
        }
    },

    loc_vars = function(self, info_queue, card)
        local vdr_tag_used = G.GAME.vdr_tag_used or 0
        return {
            vars = {card.ability.extra.chipsmod, vdr_tag_used * card.ability.extra.chipsmod}
        }
    end,

    calculate = function(self, card, context)

        local vdr_tag_used = G.GAME.vdr_tag_used or 0
        
        if context.vdr_tag_used and not context.blueprint then
            card_eval_status_text(card, 'extra', nil, nil, nil, { message = localize('k_upgrade_ex'), colour = G.C.CHIPS})
        end

        if context.joker_main then
            return{
                chips = vdr_tag_used * card.ability.extra.chipsmod
            }
        end
    end
}

-- Ingsoc R
SMODS.Joker {
    key = 'ingsoc',
    atlas = 'Jokers',
    pos = {
        x = 2,
        y = 4
    },
    blueprint_compat = true,
    perishable_compat = true,
    eternal_compat = true,
    rarity = 2,
    cost = 5,
    config = {
        extra = {
            odds = 2,
            ef = 0
        }
    },
    loc_vars = function(self, info_queue, card)
        return {
            vars = {'' .. (G.GAME and G.GAME.probabilities.normal or 1),
            card.ability.extra.odds, card.ability.extra.ef}
        }
    end,
    calculate = function(self, card, context)
        
        card.ability.extra.ef = card.ability.extra.ef or 0

        if context.cardarea == G.play and not context.blueprint then
            if context.individual
            and (context.other_card:get_id() == 4
            or context.other_card:get_id() == 8)
            and (pseudorandom('orwell') < G.GAME.probabilities.normal / card.ability.extra.odds) then
                card.ability.extra.ef = card.ability.extra.ef + 1
                return {
                    extra = {focus = card, message = 'Work!', colour = G.C.MULT},
                }
            end
        end
        
        if context.repetition and context.cardarea == G.hand then
            if (next(context.card_effects[1]) or #context.card_effects > 1) and card.ability.extra.ef > 0 then
                return {
                    message = localize('k_again_ex'),
                    repetitions = card.ability.extra.ef,
                    message_card = context.blueprint_card or card
                }
            end
        end

        if context.hand_drawn or context.end_of_round then
            card.ability.extra.ef = 0
        end
    end
}

-- Hydra R
SMODS.Joker {
    key = 'hydra',
    atlas = 'Jokers',
    pos = {
        x = 0,
        y = 5
    },
    blueprint_compat = true,
    perishable_compat = true,
    eternal_compat = true,
    rarity = 2,
    cost = 5,
    config = {
        extra = {
            size = 4,
            mult = 1.2,
            flag = 0
        }
    },
    loc_vars = function(self, info_queue, card)
        return {
            vars = {card.ability.extra.size, card.ability.extra.mult, card.ability.extra.flag}
        }
    end,
    calculate = function(self, card, context)

        if context.before and not context.blueprint then
            card.ability.extra.flag = 0
            if #context.full_hand >= card.ability.extra.size then
                card.ability.extra.flag = 1
            end
        end

        if context.individual and context.cardarea == G.hand and card.ability.extra.flag == 1 and not context.end_of_round then
            if context.other_card.debuff then
                return {
                    message = localize('k_debuffed'),
                    colour = G.C.RED,
                }
            else
                return {
                    x_mult = card.ability.extra.mult,
                    message_card = context.blueprint_card or card,
                }
            end
        end        
    end
}

-- Consumerism R
SMODS.Joker {
    key = 'consumerism',
    atlas = 'Jokers',
    pos = {
        x = 1,
        y = 5
    },
    blueprint_compat = true,
    perishable_compat = false,
    eternal_compat = true,
    rarity = 2,
    cost = 7,
    config = {
        extra = {
            mult = 0,
            multmod = 3,
            money = 4,
        }
    },
    loc_vars = function(self, info_queue, card)
        return {
            vars = {card.ability.extra.mult, card.ability.extra.multmod, card.ability.extra.money}
        }
    end,
    calculate = function(self, card, context)

        if context.setting_blind and not context.blueprint then
            if to_big(G.GAME.dollars) <= to_big(card.ability.extra.money) then
                card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.multmod
                return {
                    message = 'Buy buy buy!',
                    colour = G.C.MULT,
                    message_card = card,
                }
            end
        end
            
        if context.individual
        and context.cardarea == G.play
        and context.other_card.config.center ~= G.P_CENTERS.c_base then
            return{
                mult = card.ability.extra.mult,
                message_card = context.other_card,
            }
        end
    end
}

--Metamorphosis G
SMODS.Joker {
    key = 'metamorphosis',
    atlas = 'Jokers',
    pos = {
        x = 4,
        y = 3
    },
    blueprint_compat = true,
    perishable_compat = true,
    eternal_compat = true,
    rarity = 2,
    cost = 6,
    config = {
        extra = {
            hands = 1,
            xmultmod = 1.25,
            xmult = 1
        }
    },

    loc_vars = function(self, info_queue, card)
        return {
            vars = {card.ability.extra.hands, card.ability.extra.xmultmod, card.ability.extra.xmult}
        }
    end,

    calculate = function(self, card, context)

        if context.setting_blind and not context.blueprint then
            return {
                func = function()
                    G.E_MANAGER:add_event(Event({
                        trigger = 'after',
                        delay = 0.1,
                        func = function()
                            card_eval_status_text(card, 'extra', nil, nil, nil, { message = 'Ungeziefer!' })
                            G.E_MANAGER:add_event(Event({
                                trigger = 'after',
                                delay = 0.1,
                                func = function()
                                    local lost = G.GAME.current_round.hands_left - 1
                                    ease_hands_played(-lost)
                                    card.ability.extra.xmult = card.ability.extra.xmult + (card.ability.extra.xmultmod * lost)
                                    return true
                                end
                            }))
                            return true
                        end
                    }))
                end
            }
        end

        if context.joker_main then
            return{
                xmult = card.ability.extra.xmult
            }
        end

        if context.end_of_round and card.ability.extra.xmult > 1 and context.cardarea == G.jokers then
            card.ability.extra.xmult = 1
            if not context.blueprint then
                return{
                    message = localize('k_reset'),
                    colour = G.C.MULT,
                    message_card = card
                }
            end
        end

    end
}

--One More Time G
SMODS.Joker {
    key = 'one_more',
    atlas = 'Jokers',
    pos = {
        x = 6,
        y = 3
    },
    blueprint_compat = true,
    perishable_compat = true,
    eternal_compat = true,
    rarity = 3,
    cost = 7,
    config = {
        extra = {
            edition = 0
        }
    },

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = G.P_CENTERS.e_foil
        info_queue[#info_queue+1] = G.P_CENTERS.e_holo
        info_queue[#info_queue+1] = G.P_CENTERS.e_polychrome
        local flag = 0
        if G.consumeables then
            for i=1, #G.consumeables.cards do
                if G.consumeables.cards[i].ability.set == "Planet" then
                    flag = flag + 1
                end
            end
        end
        return {
            vars = {flag}
        }
    end,

    calculate = function(self, card, context)

        if context.cardarea == G.jokers and context.before then
            local flag = 0
            local daft = 0
            local bestedition = 0

            for i=1, #G.consumeables.cards do
                if G.consumeables.cards[i].ability.set == "Planet" then
                    flag = flag + 1
                end
            end

            for i = 1, #context.scoring_hand do
                if not context.scoring_hand[i].edition
                and not context.scoring_hand[i].debuff
                and flag > 0 then
                    daft = daft + 1
                    flag = flag - 1
                    local over = false
                    local edition = poll_edition('aura', nil, true, true)
                    context.scoring_hand[i]:set_edition(edition, true, true, true)
                    if context.scoring_hand[i].edition.foil and bestedition < 1 then
                        bestedition = 1
                    elseif context.scoring_hand[i].edition.holo and bestedition < 2 then
                        bestedition = 2
                    elseif context.scoring_hand[i].edition.polychrome  and bestedition < 3 then
                        bestedition = 3
                    end
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            context.scoring_hand[i]:juice_up()
                            return true
                        end
                    }))
                end
            end

            if daft >= 1 then
                G.E_MANAGER:add_event(Event({
                        func = function()
                            if bestedition == 3 then
                                play_sound('polychrome1', 1.2, 0.7)
                            elseif bestedition == 2 then
                                play_sound('holo1', 1.2*1.58, 0.4)
                            elseif bestedition == 1 then
                                play_sound('foil1', 1.2, 0.4)
                            end
                            return true
                        end
                    }))
                return{
                    message = "One More Time!",
                    colour = G.C.DARK_EDITION,
                    message_card = context.blueprint_card or card,
                }
            end
        end
    end
}

--Get Destruction
local dissolved = Card.start_dissolve
function Card:start_dissolve(dissolve_colours, silent, dissolve_time_fac, no_juice)
    if next(SMODS.find_card('j_drx1_stamp')) and self.playing_card then
        if self.area then self.area:remove_card(self) end
        if not self.added_to_deck then self:add_to_deck() end
        local still_in_playingcard_table = false
        for k, v in pairs(G.playing_cards) do
            if v == self then
                still_in_playingcard_table = true
                break
            end
        end
        if not still_in_playingcard_table then
            G.playing_card = (G.playing_card and G.playing_card + 1) or 1
            table.insert(G.playing_cards, self)
        end
        SMODS.calculate_context({drx1_cardtryingtobedestroyed = true, other_card = self})
        G.hand:emplace(self)
        return
    else
        local dis = dissolved(self)
        return dis
    end
end

local shattered = Card.shatter
function Card:shatter()
    if next(SMODS.find_card('j_drx1_stamp')) and self.playing_card then
        if self.area then self.area:remove_card(self) end
        if not self.added_to_deck then self:add_to_deck() end
        local still_in_playingcard_table = false
        for k, v in pairs(G.playing_cards) do
            if v == self then
                still_in_playingcard_table = true
                break
            end
        end
        if not still_in_playingcard_table then
            G.playing_card = (G.playing_card and G.playing_card + 1) or 1
            table.insert(G.playing_cards, self)
        end
        SMODS.calculate_context({drx1_cardtryingtobedestroyed = true, other_card = self})
        G.hand:emplace(self)
        return
    else
        local sha = shattered(self)
        return sha
    end
end

--Philosopher Pulse
local set_spritesref = Card.set_sprites
function Card:set_sprites(_center, _front)
    set_spritesref(self, _center, _front)
    if _center and _center.name == "j_drx1_stamp" then
        self.children.floating_sprite = Sprite(
            self.T.x,
            self.T.y,
            self.T.w,
            self.T.h,
            G.ASSET_ATLAS[_center.atlas or _center.set],
            { x = 5, y = 4 }
        )
        self.children.floating_sprite.role.draw_major = self
        self.children.floating_sprite.states.hover.can = false
        self.children.floating_sprite.states.click.can = false
    end
end

SMODS.DrawStep({
    key = "floating_sprite",
    order = 59,
    func = function(self)
        if self.ability.name == "j_drx1_stamp" and (self.config.center.discovered or self.bypass_discovery_center) and self.facing == 'front' then
            local scale_mod = 0.05 + 0.05*math.sin(1.8*G.TIMERS.REAL) + 0.03*math.sin((G.TIMERS.REAL - math.floor(G.TIMERS.REAL))*math.pi*11)*(1 - (G.TIMERS.REAL - math.floor(G.TIMERS.REAL)))^3
            local rotate_mod = 0.1*math.sin(1.219*G.TIMERS.REAL) + 0.07*math.sin((G.TIMERS.REAL)*math.pi*5)*(1 - (G.TIMERS.REAL - math.floor(G.TIMERS.REAL)))^2

            self.children.floating_sprite.role.draw_major = self
            self.children.floating_sprite:draw_shader('dissolve',0, nil, nil, self.children.center,scale_mod, rotate_mod,nil, 0.1 + 0.03*math.sin(1.8*G.TIMERS.REAL),nil, 0.6)
            self.children.floating_sprite:draw_shader('dissolve', nil, nil, nil, self.children.center, scale_mod, rotate_mod)
        end
    end
})

--Philosopher Stone G
SMODS.Joker {
    key = 'stamp',
    atlas = 'Jokers',
    pos = {
        x = 4,
        y = 4
    },
    blueprint_compat = false,
    perishable_compat = true,
    eternal_compat = true,
    rarity = 3,
    cost = 7,
    config = {
        extra = {
        }
    },

    loc_vars = function(self, info_queue, card)
        return {
            vars = {}
        }
    end,

    calculate = function(self, card, context)
        if context.drx1_cardtryingtobedestroyed and not context.blueprint then
            if not context.other_card.seal then
            G.E_MANAGER:add_event(Event({
                trigger = 'before',
                delay = 0.0,
                func = (function()
                    local seals = {}
                    play_sound('tarot1')
                    for k, v in pairs(G.P_SEALS) do
                        table.insert(seals, k)
                    end
                    context.other_card:set_seal(pseudorandom_element(seals, pseudoseed('seal')))
                    return true
                end)}))
            end
            G.E_MANAGER:add_event(Event({
                func = function()
                    context.other_card:juice_up()
                    return true
                end
            }))
            card_eval_status_text(card, 'extra', nil, nil, nil, { message = 'Transmutation!', colour = G.C.MULT })
        end
    end
}

-- Matt / Radical Joker G
SMODS.Joker {
    key = 'radical_joker',
    atlas = 'Jokers',
    pos = {
        x = 0,
        y = 0
    },
    blueprint_compat = true,
    perishable_compat = true,
    eternal_compat = true,
    rarity = 1,
    cost = 4,
    config = {
        extra = {
            money = 10
        }
    },
    loc_vars = function(self, info_queue, card)
        return {
            vars = {card.ability.extra.money}
        }
    end,
    calculate = function(self, card, context)
        if context.before and G.GAME.current_round.hands_left == 0 then
            ease_dollars(card.ability.extra.money)
            return {
                message_card = context.blueprint_card or card,
                message = localize('$') .. card.ability.extra.money,
                colour = G.C.MONEY
            }
        end
    end
}

-- Ogier / Hype G
SMODS.Joker {
    key = 'hype',
    atlas = 'Jokers',
    pos = {
        x = 2,
        y = 1
    },
    blueprint_compat = false,
    perishable_compat = true,
    eternal_compat = true,
    rarity = 1,
    cost = 5,
    config = {
        extra = {
            money = 6
        }
    },

    in_pool = function(self, args)
        return args and (args.source == 'sho' or args.source == 'buf')
    end,

    loc_vars = function(self, info_queue, card)
        return {
            vars = {card.ability.extra.money}
        }
    end,

    calc_dollar_bonus = function(self, card)
        local bonus = card.ability.extra.money
        if bonus > 0 then
            return bonus
        end
    end,

    calculate = function(self, card, context)

        if context.selling_self and not context.blueprint then
            card.sell_cost = 0
            card.sell_cost = -((G.GAME.dollars))
        end
    end
}

-- Mathis / High on Joker G
SMODS.Joker {
    key = 'high_on_joker',
    atlas = 'Jokers',
    pos = {
        x = 1,
        y = 1
    },
    blueprint_compat = true,
    perishable_compat = true,
    eternal_compat = true,
    rarity = 1,
    cost = 5,
    config = {
        extra = {
            mult = 0,
            multmod = 15,
        }
    },

    loc_vars = function(self, info_queue, card)
        return {
            vars = {card.ability.extra.mult, card.ability.extra.multmod}
        }
    end,

    calculate = function(self, card, context)

        if not context.blueprint then
            if context.skip_blind then
                card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.multmod
                return {
                    message = 'Yes yes',
                    colour = G.C.RED,
                    message_card = card,
                }
            end

            if context.end_of_round and G.GAME.blind.boss and card.ability.extra.mult > 0 then
                card.ability.extra.mult = 0
                return {
                    message = 'Mais naaaan',
                    colour = G.C.RED,
                }
            end
        end

        if context.joker_main and card.ability.extra.mult > 0 then
            return {
                mult = card.ability.extra.mult
            }
        end
    end
}

-- Leo / Kiwi R
SMODS.Joker {
    key = 'kiwi',
    atlas = 'Jokers',
    pos = {
        x = 1,
        y = 0
    },
    rarity = 2,
    cost = 5,
    blueprint_compat = false,
    perishable_compat = true,
    eternal_compat = false,
    config = {
        extra = {
            base = 0,
            increase = 1,
            bossb = 0
        }
    },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = G.P_CENTERS.e_negative
        info_queue[#info_queue+1] = G.P_CENTERS.j_egg
        return {
            vars = {card.ability.extra.base, card.ability.extra.increase, card.ability.extra.bossb}
        }
    end,
    calculate = function(self, card, context)

        if context.end_of_round and context.main_eval and G.GAME.blind.boss and not context.blueprint then
            card.ability.extra.bossb = card.ability.extra.bossb or 0
            card.ability.extra.bossb = card.ability.extra.bossb + 1
            card_eval_status_text(card, 'extra', nil, nil, nil, {message = card.ability.extra.bossb..'/2', colour = G.C.FILTER})

            if card.ability.extra.bossb >= 2 then
                card.ability.extra.base = card.ability.extra.base + card.ability.extra.increase
                card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('k_upgrade_ex'), colour = G.C.FILTER})
            end

            if card.ability.extra.bossb == 2 then
                local eval = function(card)
                    return (card.ability.extra.bossb >= 2)
                end
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 0.4,
                    func = function()
                        juice_card_until(card, eval, true)
                        return true
                    end}))
            end
        end

        if context.selling_self and card.ability.extra.base > 0 and not context.blueprint then
            local jokers_to_create = card.ability.extra.base
            
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.2,
                func = function()
                    for i = 1, jokers_to_create do
                        local card = create_card('Joker', G.jokers, nil, 0, nil, nil, 'j_egg', nil,
                            card.edition and card.edition.negative)
                        card:set_edition({
                            negative = true
                        }, true)
                        card:add_to_deck()
                        G.jokers:emplace(card)
                        card:start_materialize()
                        G.GAME.joker_buffer = 0
                    end
                return true
            end}))

            return {
                message = localize('k_eaten_ex'),
                colour = G.C.DARK_EDITION
            }
        end
    end
}

-- Roman / Apathy G
SMODS.Joker {
    key = 'apathy',
    atlas = 'Jokers',
    pos = {
        x = 3,
        y = 0
    },
    blueprint_compat = true,
    perishable_compat = true,
    eternal_compat = true,
    rarity = 2,
    cost = 6,
    config = {
        extra = {
        }
    },
    calculate = function(self, card, context)

        if context.skip_blind and not G.FORCE_TAG then
            local _pool, _pool_key = get_current_pool('Tag', nil, nil, nil)
            local _tag_name = pseudorandom_element(_pool, pseudoseed(_pool_key))
            local it = 1
            while _tag_name == 'UNAVAILABLE' or _tag_name == "tag_double" or _tag_name == "tag_orbital" do
                it = it + 1
                _tag_name = pseudorandom_element(_pool, pseudoseed(_pool_key .. '_resample' .. it))
            end

            G.GAME.round_resets.blind_tags = G.GAME.round_resets.blind_tags or {}

            card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = 'Wow!', colour = G.C.RED})

            local _tag = Tag(_tag_name, nil, G.GAME.blind)
            add_tag(_tag)
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0,
                func = function()
                    play_sound('generic1', 0.9 + math.random() * 0.1, 0.8)
                    play_sound('holo1', 1.2 + math.random() * 0.1, 0.4)
                return true
            end}))
        end
    end
}

-- Andrew / Royal Bat G
SMODS.Joker {
    key = 'royal_bat',
    atlas = 'Jokers',
    pos = {
        x = 3,
        y = 1
    },
    blueprint_compat = false,
    perishable_compat = true,
    eternal_compat = true,
    rarity = 2,
    cost = 7,
    config = {
        extra = {
        }
    },

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = G.P_CENTERS.c_death
        info_queue[#info_queue+1] = G.P_CENTERS.c_tower
        return {
            vars = {
                colours = {
                    G.C.SECONDARY_SET.Tarot,
                    {1, 1, 1, 1}
            }
        }
    }
    
    end,

    calculate = function(self, card, context)

        if context.destroying_card
        and not context.blueprint
        and #context.full_hand == 1
        and context.full_hand[1]:is_face()
        and G.GAME.current_round.hands_played == 0 then
            if #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
                G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                local function random_poll()
                    return math.random(0, 1)
                end
                if random_poll() == 0 then
                    card_eval_status_text(card, 'extra', nil, nil, nil, {message = 'Death', colour = G.C.SECONDARY_SET.Tarot})
                    G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 0.1,
                    func = function()
                        local card = create_card(nil, G.consumeables, nil, nil, nil, nil, 'c_death', 'sup')
                        card:add_to_deck()
                        G.consumeables:emplace(card)
                        G.GAME.consumeable_buffer = 0
                        return true
                    end
                    }))
                else
                    card_eval_status_text(card, 'extra', nil, nil, nil, {message = 'Tower', colour = G.C.SECONDARY_SET.Tarot})
                    G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 0.1,
                    func = function()
                        local card = create_card(nil, G.consumeables, nil, nil, nil, nil, 'c_tower', 'sup')
                        card:add_to_deck()
                        G.consumeables:emplace(card)
                        G.GAME.consumeable_buffer = 0
                        return true
                    end
                    }))
                end
            end
            return true
        end
    end
}

-- Triduc / Lucky 7s R
SMODS.Joker {
    key = 'lucky_7s',
    atlas = 'Jokers',
    pos = {
        x = 4,
        y = 1
    },
    blueprint_compat = true,
    perishable_compat = true,
    eternal_compat = true,
    rarity = 2,
    cost = 6,
    config = {
        extra = {
            odds = 3,
            money = 2
        }
    },

    loc_vars = function(self, info_queue, card)
        return {
            vars = {'' .. (G.GAME and G.GAME.probabilities.normal or 1), card.ability.extra.odds, card.ability.extra.money}
        }
    end,

    calculate = function(self, card, context)

        if context.individual and context.cardarea == G.play then
            if (pseudorandom('7s') < G.GAME.probabilities.normal / card.ability.extra.odds) then
                if (context.other_card:get_id() == 7) then
                    context.other_card.ability.perma_p_dollars = context.other_card.ability.perma_p_dollars or 0
                    context.other_card.ability.perma_p_dollars = context.other_card.ability.perma_p_dollars + card.ability.extra.money

                    return {
                        extra = {message = localize('k_upgrade_ex'), colour = G.C.MONEY},
                        colour = G.C.MONEY,
                        message_card = context.other_card
                    }
                end
            end
        end

        
    end
}

-- Teddy / Tobacco Paper G
SMODS.Joker {
    key = 'tobacco_paper',
    atlas = 'Jokers',
    pos = {
        x = 6,
        y = 0
    },
    blueprint_compat = true,
    perishable_compat = true,
    eternal_compat = true,
    rarity = 2,
    cost = 6,
    enhancement_gate = 'm_lucky',
    config = {
        extra = {
            high = 5
        }
    },

    loc_vars = function(self, info_queue, card)

        info_queue[#info_queue+1] = G.P_CENTERS.m_lucky
        return {
            vars = {'' .. (G.GAME and G.GAME.probabilities.normal or 1), card.ability.extra.high}
        }
    end,

    calculate = function(self, card, context)

        if context.repetition and context.cardarea == G.play
        and context.other_card.ability.name == 'Lucky Card' then

            local reps = 0
            local roll = pseudorandom('tp')

            if (roll < G.GAME.probabilities.normal / card.ability.extra.high) then
                reps = 2
            else
                reps = 1
            end
            return{
                message = localize('k_again_ex'),
                repetitions = reps,
                card = context.blueprint_card or card
            }
        end


    end
}

-- Momo / Don Juan G
SMODS.Joker {
    key = 'don_juan',
    atlas = 'Jokers',
    pos = {
        x = 5,
        y = 1
    },
     soul_pos = {
        x = 2,
        y = 2
    },
    blueprint_compat = true,
    perishable_compat = true,
    eternal_compat = true,
    rarity = 2,
    cost = 6,
    enhancement_gate = 'm_wild',
    config = {
        extra = {
            odds = 4,
            hands = {'Flush', 'Straight Flush', 'Flush House', 'Flush Five'}
    }
    },

    loc_vars = function(self, info_queue, card)

        info_queue[#info_queue+1] = G.P_CENTERS.m_wild
        return {
            vars = {'' .. (G.GAME and G.GAME.probabilities.normal or 1),
            card.ability.extra.odds}
        }
    end,

    calculate = function(self, card, context)

        local flushes = {'Flush', 'Straigt Flush', 'Flush House', 'Flush Five'}

        if context.before then
        local nb = 0
        -- UGLY check for rockfall
        -- local rock = false
        --     if next(SMODS.find_card('j_drx1_rockfall')) then
        --         rock = true
        --     end

            for i = 1, #context.scoring_hand do
                if (SMODS.has_enhancement(context.scoring_hand[i], 'm_wild')
                -- or (rock == true and SMODS.has_enhancement(context.scoring_hand[i], 'm_stone'))
                ) 
                and (pseudorandom('don') < G.GAME.probabilities.normal / card.ability.extra.odds) then
                    nb = nb + 1
                end
            end

            for i = 1, nb do
                card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = localize('k_level_up_ex'), colour = G.C.SECONDARY_SET.Planet})
                update_hand_text({sound = 'button', volume = 0.7, pitch = 0.8, delay = 0.3}, {handname='Flushes',chips = '...', mult = '...', level=''})
                G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.2, func = function()
                    play_sound('tarot1')
                    card:juice_up(0.8, 0.5)
                    G.TAROT_INTERRUPT_PULSE = true
                return true end }))
                update_hand_text({delay = 0}, {mult = '+', StatusText = true})
                G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.9, func = function()
                    play_sound('tarot1')
                    card:juice_up(0.8, 0.5)
                return true end }))
                update_hand_text({delay = 0}, {chips = '+', StatusText = true})
                G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.9, func = function()
                    play_sound('tarot1')
                    card:juice_up(0.8, 0.5)
                    G.TAROT_INTERRUPT_PULSE = nil
                return true end }))
                update_hand_text({sound = 'button', volume = 0.7, pitch = 0.9, delay = 0}, {level='+1'}) delay(1.3)
                for k, v in ipairs(card.ability.extra.hands) do
                    level_up_hand(card, v, true, 1)
                end
                update_hand_text({sound = 'button', volume = 0.7, pitch = 1.1, delay = 0}, {mult = 0, chips = 0, handname = '', level = ''})
            end
        end
    end
}

-- Get level up
local lvl_ref = level_up_hand
function level_up_hand(card, hand, instant, amount)
    lvl_ref(card, hand, instant, amount)

    SMODS.calculate_context({lvl_up = hand})
end

-- Thomas / Herringen G
SMODS.Joker {
    key = 'herringen',
    atlas = 'Jokers',
    pos = {
        x = 6,
        y = 1
    },
    blueprint_compat = false,
    perishable_compat = true,
    eternal_compat = true,
    rarity = 2,
    cost = 5,
    config = {
        extra = {
            lvl = 3,
            discardmod = 1,
            flag = 0,
    }
    },

    loc_vars = function(self, info_queue, card)
        return {
            vars = {card.ability.extra.lvl,
            card.ability.extra.discardmod,
            math.floor(to_big(G.GAME.hands["Straight Flush"].level)/card.ability.extra.lvl),
            card.ability.extra.flag}
        }
    end,

    remove_from_deck = function(self, card, from_debuff)
        if math.floor(to_big(G.GAME.hands["Straight Flush"].level)/card.ability.extra.lvl) > 0 then
            G.GAME.round_resets.discards = G.GAME.round_resets.discards - math.floor(to_big(G.GAME.hands["Straight Flush"].level)/card.ability.extra.lvl)
            if G.GAME.current_round.discards_left > 0 then
                if G.GAME.current_round.discards_left > math.floor(to_big(G.GAME.hands["Straight Flush"].level)/card.ability.extra.lvl) then
                    ease_discard(-math.floor(to_big(G.GAME.hands["Straight Flush"].level)/card.ability.extra.lvl))
                else
                    ease_discard(-G.GAME.current_round.discards_left)
                end
            end
        end
    end,
    
    add_to_deck = function(self, card, from_debuff)
        card.ability.extra.flag = math.floor(to_big(G.GAME.hands["Straight Flush"].level)/card.ability.extra.lvl)
        if math.floor(to_big(G.GAME.hands["Straight Flush"].level)/card.ability.extra.lvl) > 0 then
            G.GAME.round_resets.discards = G.GAME.round_resets.discards + math.floor(to_big(G.GAME.hands["Straight Flush"].level)/card.ability.extra.lvl)
            ease_discard(math.floor(to_big(G.GAME.hands["Straight Flush"].level)/card.ability.extra.lvl))
        end
    end,    

    calculate = function(self, card, context)

        if not context.blueprint then
            if context.lvl_up == "Straight Flush" then
                if card.ability.extra.flag < math.floor(to_big(G.GAME.hands["Straight Flush"].level)/card.ability.extra.lvl) then
                    G.GAME.round_resets.discards = G.GAME.round_resets.discards + (math.floor(to_big(G.GAME.hands["Straight Flush"].level)/card.ability.extra.lvl) - card.ability.extra.flag)
                    ease_discard(math.floor(to_big(G.GAME.hands["Straight Flush"].level)/card.ability.extra.lvl) - card.ability.extra.flag)
                    card.ability.extra.flag = math.floor(to_big(G.GAME.hands["Straight Flush"].level)/card.ability.extra.lvl)
                    card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = 'Evade!', colour = G.C.SECONDARY_SET.Planet})
                elseif card.ability.extra.flag > math.floor(to_big(G.GAME.hands["Straight Flush"].level)/card.ability.extra.lvl) then
                    G.GAME.round_resets.discards = G.GAME.round_resets.discards - (card.ability.extra.flag - math.floor(to_big(G.GAME.hands["Straight Flush"].level)/card.ability.extra.lvl))
                    if G.GAME.current_round.discards_left > 0 then
                        if G.GAME.current_round.discards_left > math.floor(to_big(G.GAME.hands["Straight Flush"].level)/card.ability.extra.lvl) then
                            ease_discard(-(card.ability.extra.flag - math.floor(to_big(G.GAME.hands["Straight Flush"].level)/card.ability.extra.lvl)))
                        else
                            ease_discard(-G.GAME.current_round.discards_left)
                        end
                    end
                    card.ability.extra.flag = math.floor(to_big(G.GAME.hands["Straight Flush"].level)/card.ability.extra.lvl)
                    card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = 'Destroyed!', colour = G.C.SECONDARY_SET.Planet})
                end
            end
        end
    end
}

-- Eliaz / The Worm G
SMODS.Joker {
    key = 'the_worm',
    atlas = 'Jokers',
    pos = {
        x = 0,
        y = 1
    },
    draw = function(self, card, layer)
        if card.config.center.discovered or card.bypass_discovery_center then
            card.children.center:draw_shader('voucher', nil, card.ARGS.send_to_shader)
        end
    end,
    blueprint_compat = true,
    perishable_compat = true,
    eternal_compat = true,
    rarity = 3,
    cost = 8,
    config = {
        extra = {
            odds = 2
        }
    },

    loc_vars = function(self, info_queue, card)
        return {
            vars = {'' .. (G.GAME and G.GAME.probabilities.normal or 1), card.ability.extra.odds}
        }
    end,
    calculate = function(self, card, context)

        if context.remove_playing_cards then
            local destruction = 0
            local bouboule = 0

            for k, val in ipairs(context.removed) do
                destruction = destruction + 1
            end

            for i = 1, destruction do
                if #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit and
                (pseudorandom('goon') < G.GAME.probabilities.normal / card.ability.extra.odds) then
                    bouboule = 1
                    G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                    --card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = 'Consumed!', colour = G.C.SECONDARY_SET.Spectral})
                    G.E_MANAGER:add_event(Event({
                        trigger = 'before',
                        func = function()
                            SMODS.add_card({
                                set = "Spectral"
                            })
                            G.GAME.consumeable_buffer = 0
                            return true
                        end
                    }))
                end
            end

            if bouboule == 1 then
                return{
                    message = "Devoured!",
                    colour = G.C.SECONDARY_SET.Spectral,
                    message_card = context.blueprint_card or card,
                }
            end
        end
    end
}

-- Detection de easedollars
local base_ease_dollars = ease_dollars
function ease_dollars(mod, x)
    base_ease_dollars(mod,x)
    
    SMODS.calculate_context({dr_ease_dollars = mod})
end

-- Colin / The Godfather G
SMODS.Joker {
    key = 'the_godfather',
    atlas = 'Jokers',
    pos = {
        x = 4,
        y = 0
    },
    blueprint_compat = true,
    perishable_compat = true,
    eternal_compat = true,
    rarity = 3,
    cost = 8,
    config = {
        extra = {
            xmult = 4,
            moneycap = 7,
            moneyearned = 0,
            spe = 0,
            odds = 7
        }
    },

    loc_vars = function(self, info_queue, card)
        return {
            vars = {card.ability.extra.xmult, card.ability.extra.moneycap, card.ability.extra.moneyearned, card.ability.extra.spe}
        }
    end,

    calculate = function(self, card, context)
        
        if not context.blueprint then
            if G.GAME.blind.in_blind and context.dr_ease_dollars then
                card.ability.extra.moneyearned = card.ability.extra.moneyearned or 0
                card.ability.extra.spe = card.ability.extra.spe or 0
                card.ability.extra.moneyearned = card.ability.extra.moneyearned + context.dr_ease_dollars

                if card.ability.extra.moneyearned < card.ability.extra.moneycap and card.ability.extra.spe > 0 then
                    card.ability.extra.spe = 0
                end
                
                if card.ability.extra.moneyearned >= card.ability.extra.moneycap then
                    card.ability.extra.spe = card.ability.extra.spe + 1
                    if card.ability.extra.spe == 1 then
                        card_eval_status_text(card, 'extra', nil, nil, nil, {message = 'Deal!', colour = G.C.MONEY})
                        local eval = function(card)
                            return (card.ability.extra.moneyearned >= card.ability.extra.moneycap)
                        end
                        G.E_MANAGER:add_event(Event({
                            trigger = 'after',
                            delay = 0.4,
                            func = function()
                                juice_card_until(card, eval, true)
                                return true
                            end}))
                    end
                end
            end
        end

        if context.joker_main then
            if card.ability.extra.moneyearned >= card.ability.extra.moneycap then
                return {
                    xmult = card.ability.extra.xmult
                }
            end
        end

        if context.end_of_round then
            card.ability.extra.moneyearned = 0
            card.ability.extra.spe = 0
        end 
    end
}

-- Mario / Boredom G
SMODS.Joker {
    key = 'boredom',
    atlas = 'Jokers',
    pos = {
        x = 2,
        y = 0
    },
    blueprint_compat = true,
    perishable_compat = false,
    eternal_compat = true,
    rarity = 3,
    cost = 8,
    config = {
        extra = {
            increase = 0.5,
            Xmult = 1
        }
    },
    loc_vars = function(self, info_queue, card)
        return {
            vars = {card.ability.extra.increase, card.ability.extra.Xmult}
        }
    end,

    calculate = function(self, card, context)

        if context.hand_drawn and G.GAME.current_round.hands_played >= 1 and card.ability.extra.Xmult > 1 and not context.blueprint then
            card.ability.extra.Xmult = 1
            return {
                message = localize('k_reset'),
                colour = G.C.RED
            }
        end

        if context.joker_main then
            return {
                xmult = card.ability.extra.Xmult
            }
        end

        if context.end_of_round and context.main_eval and not context.blueprint then
            if G.GAME.current_round.hands_played == 1 then
                card.ability.extra.Xmult = card.ability.extra.Xmult + card.ability.extra.increase
                return {
                    message = "Dolores...",
                    colour = G.C.RED
                }
            end
        end
    end
}

-- Garruke / Dauphine G
SMODS.Joker {
    key = 'dauphine',
    atlas = 'Jokers',
    pos = {
        x = 5,
        y = 0
    },
    blueprint_compat = false,
    perishable_compat = true,
    eternal_compat = true,
    rarity = 3,
    cost = 8,
    config = {
        extra = {
        }
    },
}

-- Levy / Bokida G (planet card apparition a bit whacky but better)
SMODS.Joker {
    key = 'bokida',
    atlas = 'Jokers',
    pos = {
        x = 0,
        y = 2
    },
    soul_pos = {
        x = 1,
        y = 2
    },
    rarity = 4,
    cost = 20,
    blueprint_compat = true,
    config = {
        extra = {
            
        }
    },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = {key = 'e_negative_consumable', set = 'Edition', config = {extra = 1}}
    end,
    calculate = function(self, card, context)

        if context.before then
            local card_type = 'Planet'
            local _planet = 0

            card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = G.GAME.last_hand_played, colour = G.C.DARK_EDITION})

            for k, v in pairs(G.P_CENTER_POOLS.Planet) do
                if v.config.hand_type == G.GAME.last_hand_played then
                    _planet = v.key
                end
            end
            local card = create_card(card_type, G.consumeables, nil, nil, nil, nil, _planet, 'blus1')
            card.states.visible = false
            card:add_to_deck()
            G.consumeables:emplace(card)
            G.E_MANAGER:add_event(Event({
                func = function()
                    card:start_materialize()
                    card:set_edition({
                    negative = true
                    }, true)
                    --card:juice_up()
                    return true
                end
            })) 
        end

        if context.selling_self then
            local jokers_to_create = G.jokers.config.card_limit - #G.jokers.cards + 1
            if jokers_to_create > 1 then
                card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = "Balls", colour = G.C.DARK_EDITION})
            else
                card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = "Ball", colour = G.C.DARK_EDITION})
            end
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.2,
                func = function()
                    for i = 1, jokers_to_create do
                        local card = create_card('Joker', G.jokers, nil, 0, nil, nil, 'j_8_ball')
                        card:add_to_deck()
                        G.jokers:emplace(card)
                        card:start_materialize()
                        G.GAME.joker_buffer = 0
                    end
                return true
            end}))
        end
    end
}

-- Absinthe G
SMODS.Joker {
    key = 'absinthe',
    atlas = 'Jokers',
    pos = {
        x = 3,
        y = 2
    },
    blueprint_compat = true,
    perishable_compat = true,
    eternal_compat = false,
    rarity = 2,
    cost = 5,
    config = {
        extra = {
            current = 1,
            odds = 8,
            rate = 1,
        }
    },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = G.P_CENTERS.e_foil
        info_queue[#info_queue+1] = G.P_CENTERS.e_holo
        info_queue[#info_queue+1] = G.P_CENTERS.e_polychrome
        local current = 1
        local rate = 1
        if card then
            current = card.ability.extra.current or 1
            rate = card.ability.extra.rate
        end
        if G.GAME and G.GAME.probabilities.normal then
			current = current * G.GAME.probabilities.normal
			rate = rate * G.GAME.probabilities.normal
		end
        return {
            vars = {current, card.ability.extra.odds, rate}
        }
    end,

    calculate = function(self, card, context)

        if context.end_of_round and context.main_eval and not context.blueprint then
            card.ability.extra.current = (card.ability.extra.current or 1) + card.ability.extra.rate
            return{
                message = localize("k_upgrade_ex"),
                colour = G.C.GREEN,
                message_card = card,
            }
        end

        if context.selling_self then
            for i = 1, #G.jokers.cards do
                if G.jokers.cards[i] ~= card and not G.jokers.cards[i].edition then
                    local target = G.jokers.cards[i]
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            if (pseudorandom('algul') < card.ability.extra.current * G.GAME.probabilities.normal / card.ability.extra.odds) then
                                G.E_MANAGER:add_event(Event({
                                    trigger = 'before',
                                    func = function()
                                        local edition = poll_edition('wheel_of_fortune', nil, true, true)
                                        target:set_edition(edition, true)
                                        target:juice_up()
                                    return true
                                end
                                }))
                                delay(0.9)
                            else
                                card_eval_status_text(target, 'extra', nil, nil, nil, {message = localize('k_nope_ex'), colour = G.C.GREEN})
                            end
                            return true
                        end
                    }))
                end
            end
        end
    end
}

-- Knock-Off G
SMODS.Joker {
    key = 'knockoff',
    atlas = 'Jokers',
    pos = {
        x = 4,
        y = 2
    },
    blueprint_compat = true,
    perishable_compat = true,
    eternal_compat = false,
    rarity = 2,
    cost = 8,
    config = {
        extra = {
        }
    },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = {key = 'perishable', set = 'Other', vars = {G.GAME.perishable_rounds or 1, G.GAME.perishable_rounds}}
        return {
        }
    end,

    calculate = function(self, card, context)
        if context.selling_self then
            local jokers = {}
            for i=1, #G.jokers.cards do 
                if G.jokers.cards[i] ~= card then
                    jokers[#jokers+1] = G.jokers.cards[i]
                end
            end
            if #jokers > 0 then 
                if #G.jokers.cards <= G.jokers.config.card_limit then 
                    card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = localize('k_duplicated_ex')})
                    local chosen_joker = jokers[#jokers]
                    local card = copy_card(chosen_joker, nil, nil, nil, chosen_joker.edition and chosen_joker.edition.negative)
                    card:set_eternal(false)
                    SMODS.Stickers["perishable"]:apply(card, true)
                    card.sell_cost = 0
                    card:add_to_deck()
                    G.jokers:emplace(card)
                else
                    card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = localize('k_no_room_ex')})
                end
            else
                card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = localize('k_no_other_jokers')})
            end
        end
    end
}

-- Devotion G
SMODS.Joker {
    key = 'devotion',
    atlas = 'Jokers',
    pos = {
        x = 6,
        y = 2
    },
    blueprint_compat = true,
    perishable_compat = true,
    eternal_compat = false,
    rarity = 2,
    cost = 6,
    config = {
        extra = {
            different = 7,
            hands = {},
            aura = 2,
            devotion = 0,
        }
    },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = G.P_CENTERS.c_aura
        
        local hand = 0
        for k, v in pairs(card.ability.extra.hands or {}) do
            hand = hand + 1
        end

        return {
            vars = {card.ability.extra.different, hand, card.ability.extra.aura, card.ability.extra.devotion}
        }
    end,

    calculate = function(self, card, context)

        if context.before and context.main_eval and not context.blueprint then
            local hand = 0
            for k, v in pairs(card.ability.extra.hands or {}) do
                hand = hand + 1
            end
            card.ability.extra.hands[context.scoring_name] = true
            local new_hand = 0
            for k, v in pairs(card.ability.extra.hands or {}) do
                new_hand = new_hand + 1
            end
            if hand ~= new_hand then
                card_eval_status_text(card, 'extra', nil, nil, nil, {message = new_hand..'/7', colour = G.C.DARK_EDITION})
                if new_hand == 7 then
                    card.ability.extra.devotion = 1
                    card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('k_upgrade_ex'), colour = G.C.DARK_EDITION})
                    local eval = function(card)
                        return (card.ability.extra.devotion >= 1)
                    end
                    G.E_MANAGER:add_event(Event({
                        trigger = 'after',
                        delay = 0.4,
                        func = function()
                            juice_card_until(card, eval, true)
                            return true
                        end}))
                end
            end
        end

        if context.selling_self and card.ability.extra.devotion == 1 then
            card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = 'Aura', colour = G.C.DARK_EDITION})
            for i=1, card.ability.extra.aura do
                local card = create_card(nil, G.consumeables, nil, nil, nil, nil, 'c_aura', 'sup')
                card:add_to_deck()
                G.consumeables:emplace(card)
                card.states.visible = false
                    G.E_MANAGER:add_event(Event({
                        trigger = 'before',
                        func = function()
                            card:set_edition({negative = true}, true, true)
                            card:start_materialize()
                            --card:juice_up()
                            return true
                        end
                    }))
            end
            G.E_MANAGER:add_event(Event({
                trigger = 'before',
                func = function()
                    play_sound('negative', 1.5, 0.4)
                    return true
                end
            }))
        end

        -- if context.selling_self and card.ability.extra.devotion == 1 then
        --     if #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
        --         card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = 'Aura', colour = G.C.DARK_EDITION})
        --         G.E_MANAGER:add_event(Event({
        --             trigger = 'before',
        --             func = function()
        --                 play_sound('timpani')
        --                 return true
        --             end
        --         }))
        --     end
        --     for i=1, card.ability.extra.aura do
        --         if #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
        --             G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
        --             G.E_MANAGER:add_event(Event({
        --                 trigger = 'before',
        --                 func = (function()
        --                     local card = create_card(nil, G.consumeables, nil, nil, nil, nil, 'c_aura', 'sup')
        --                     card:add_to_deck()
        --                     G.consumeables:emplace(card)
        --                     G.GAME.consumeable_buffer = 0
        --                     return true
        --                 end)
        --             }))
        --         end
        --     end
        --  end
    end
}

-- Anarchy R
SMODS.Joker {
    key = 'anarchy',
    atlas = 'Jokers',
    pos = {
        x = 5,
        y = 2
    },
    blueprint_compat = false,
    perishable_compat = true,
    eternal_compat = true,
    rarity = 2,
    cost = 5,
    config = {
        extra = {
        }
    },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = G.P_CENTERS.e_polychrome
        info_queue[#info_queue+1] = G.P_CENTERS.m_wild
        return {
        }
    end,

    calculate = function(self, card, context)

        if context.before and not context.blueprint and G.GAME.current_round.hands_left == 0 then
            local anar = false
            for i=1, #context.full_hand do
                local card_is_scoring = false
                for j=1, #context.scoring_hand do
                    if context.full_hand[i] == context.scoring_hand[j] then
                        card_is_scoring = true
                    end
                end
                if card_is_scoring == false and not context.full_hand[i].debuff then
                    anar = true
                    local anarcard = context.full_hand[i]
                    anarcard:set_ability(G.P_CENTERS.m_wild, nil, true)
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            anarcard:flip()
                            if not anarcard.edition then
                                local edition = {polychrome = true}
                                anarcard:set_edition(edition, true, true)
                            end
                            anarcard:flip()
                            return true
                        end
                    }))
                end
            end
            if anar == true then
                G.E_MANAGER:add_event(Event({
                    func = function()
                        play_sound('polychrome1', 1.2, 0.7)
                        return
                        true
                    end
                }))
                return{
                    message = "No Gods, No Masters",
                    colour = G.C.MULT,
                    message_card = card
                }
            end
        end
    end
}

-- Decomposition G
SMODS.Joker {
    key = 'decomposition',
    atlas = 'Jokers',
    pos = {
        x = 2,
        y = 5
    },
    blueprint_compat = true,
    perishable_compat = true,
    eternal_compat = true,
    rarity = 2,
    cost = 6,
    config = {
        extra = {
            clubs = 4,
        }
    },
    loc_vars = function(self, info_queue, card)
        return {
            vars = {card.ability.extra.clubs}
        }
    end,

    calculate = function(self, card, context)

        if context.after then
            local club = 0
            for i = 1, #context.scoring_hand do
                if context.scoring_hand[i]:is_suit("Clubs") then
                    club = club + 1
                end
            end

            if club < 4 then
                return
            end

            for i = 1, #context.scoring_hand do
                G.E_MANAGER:add_event(Event({
                    trigger = "after",
                    delay = 0.2,
                    func = function()
                        local card = context.scoring_hand[i]
                        -- HERE LAST ARG TO CHANGE RANK DECREASE
                        if card:get_id() > 2 then
                            assert(SMODS.modify_rank(card, -1))
                            card:juice_up()
                            play_sound("card1")
                        end
                    return true
                end}))
            end
            if G.consumeables.config.card_limit > #G.consumeables.cards + G.GAME.consumeable_buffer then
                G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 0.4,
                    func = function()
                        local card = create_card('Tarot', G.consumeables, nil, nil, nil, nil, nil, 'car')
                        card:add_to_deck()
                        G.consumeables:emplace(card)
                        G.GAME.consumeable_buffer = 0
                    return true
                end}))
            end
            return{
                message = 'Value Down!',
                colour = G.C.SUITS.Clubs,
                message_card = context.blueprint_card or card,
            }
        end
    end
}

-- -- Get Suit
-- local getsuitref = Card.is_suit
-- function Card:is_suit(suit, bypass_debuff, flush_calc)
--     local suit = getsuitref(self, suit, bypass_debuff, flush_calc)

--     if next(SMODS.find_card('j_drx1_rockfall'))
--     and SMODS.has_enhancement(self, 'm_stone')
--     and not self.debuff
--     then
--         return true
--     end

--     return suit
-- end

-- Quantum Enhancement ACTIVATION
SMODS.current_mod.optional_features = function()
    return {
        quantum_enhancements = true,
    }
end

-- Rockfall Area R
SMODS.Joker {
    key = 'rockfall',
    atlas = 'Jokers',
    pos = {
        x = 4,
        y = 5
    },
    blueprint_compat = false,
    perishable_compat = true,
    eternal_compat = true,
    enhancement_gate = 'm_stone',
    rarity = 2,
    cost = 6,
    config = {
        extra = {
        }
    },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = G.P_CENTERS.m_stone
        info_queue[#info_queue+1] = G.P_CENTERS.m_wild
        return {
        }
    end,

    calculate = function(self, card, context)
        
        if context.check_enhancement and context.other_card.config.center.key == "m_stone" then
            return {
                ['m_wild'] = true
            }
        end
    end,
}

-- Shuffle hook
local oldshuffle = CardArea.shuffle
function CardArea:shuffle(_seed)
    local g = oldshuffle(self, _seed)

    if self == G.deck then
        local artofwar = nil


        for _, j in ipairs(G.jokers.cards or {}) do
            if j.config.center.key == "j_drx1_art_of_war" then
                artofwar = j
                break
            end
        end
        
        if artofwar and artofwar.ability.extra.art_to_draw then
            local prioritys = {}
            local otherones = {}

            for k, v in pairs(self.cards) do
                local is_priority = false

                for _, w in ipairs(artofwar.ability.extra.art_to_draw) do
                    if v == w then
                        is_priority = true
                        break
                    end
                end

                if is_priority then
                    table.insert(prioritys, v)
                else
                    table.insert(otherones, v)
                end
            end
            
            for _, card in ipairs(prioritys) do
                table.insert(otherones, card)
            end

            self.cards = otherones
            self:set_ranks()
        end
    end
    return g
end

-- Art of War R
SMODS.Joker {
    key = 'art_of_war',
    atlas = 'Jokers',
    pos = {
        x = 3,
        y = 5
    },
    blueprint_compat = false,
    perishable_compat = true,
    eternal_compat = true,
    rarity = 2,
    cost = 3,
    config = {
        extra = {
            art_to_draw = {}
        }
    },
    loc_vars = function(self, info_queue, card)
        return {
        }
    end,

    calculate = function(self, card, context)

        if not context.blueprint then
            if context.after then
                card.ability.extra.art_to_draw = card.ability.extra.art_to_draw or {}

                for i = #context.full_hand, 1, -1 do
                    local card_is_scoring = false

                    for j = #context.scoring_hand, 1, -1 do
                        if context.full_hand[i] == context.scoring_hand[j] then
                            card_is_scoring = true
                        end
                    end

                    if card_is_scoring == false and not context.full_hand[i].debuff then
                        local anarcard = context.full_hand[i]
                        table.insert(card.ability.extra.art_to_draw, 1, anarcard)
                    end
                end
            end

            if context.hand_drawn then
                for i = 1, #context.hand_drawn do
                    for j = 1, #card.ability.extra.art_to_draw do
                        if card.ability.extra.art_to_draw[j] == context.hand_drawn[i] then
                            table.remove(card.ability.extra.art_to_draw, j)
                        end
                    end
                end
            end
        end
    end
}

-- Collector Booster G
SMODS.Joker {
    key = 'collector',
    atlas = 'Jokers',
    pos = {
        x = 5,
        y = 5
    },
    draw = function(self, card, layer)
        if card.config.center.discovered or card.bypass_discovery_center then
            card.children.center:draw_shader('voucher', nil, card.ARGS.send_to_shader)
        end
    end,
    blueprint_compat = false,
    perishable_compat = true,
    eternal_compat = true,
    rarity = 3,
    cost = 7,
    config = {
        extra = {
        }
    },

    loc_vars = function(self, info_queue, card)
        return {
            vars = {card.ability.extra.defaults}
        }
    end,

    add_to_deck = function(self, card, from_debuff)
        local _collector = nil
        for _, j in ipairs(G.jokers.cards or {}) do
            if j.config.center.key == "j_drx1_collector" and j.ability.extra.defaults["Common"] ~= 0 and not j.debuff then
                _collector = j
                break
            end
        end

        card.ability.extra.defaults = card.ability.extra.defaults or {}
        for rarity_key, v in pairs(SMODS.Rarities) do
            if rarity_key ~= "Uncommon" then
                if _collector then
                    card.ability.extra.defaults[rarity_key] = _collector.ability.extra.defaults[rarity_key]
                    G.GAME[rarity_key:lower().."_mod"] = 0 
                else
                    card.ability.extra.defaults[rarity_key] = G.GAME[rarity_key:lower().."_mod"]
                    G.GAME[rarity_key:lower().."_mod"] = 0 
                end
            end
        end
    end,

    remove_from_deck = function(self, card, from_debuff)
        local _collector = nil
        for _, j in ipairs(G.jokers.cards or {}) do
            if j.config.center.key == "j_drx1_collector" and j~=self and not j.debuff then
                _collector = j
                break
            end
        end

        if not _collector and card.ability.extra.defaults then
            for rarity_key, v in pairs(SMODS.Rarities) do
                if rarity_key ~= "Uncommon" then
                    G.GAME[rarity_key:lower().."_mod"] = card.ability.extra.defaults[rarity_key]
                end
            end
        end
    end,
}

---------------------------------------------
-------------MOD CODE END--------------------