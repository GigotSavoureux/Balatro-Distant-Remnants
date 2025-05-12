return {
    descriptions = {
        Joker = {
            j_drx1_radical_joker = {
                name = 'Radical Joker',
                text = {
                    'Earn {C:money}$#1#{} on {C:attention}final{}',
                    '{C:attention}hand{} of round',
                },
            },
            j_drx1_hype = {
                name = 'Hype',
                text = {
                    'Earn {C:money}$#1#{} at',
                    'end of round',
                    '{S:1.1,C:red,E:2}Set money to',
                    '{S:1.1,C:money,E:2}$0{S:1.1,C:red,E:2} when sold',
                },
            },
            j_drx1_kiwi = {
                name = 'Kiwi',
                text = {
                    'After defeating {C:attention}2',
                    '{C:attention}Boss Blinds{}, sell this card',
                    'to create {C:attention}1{} {C:dark_edition, s:0,9}Negative{} {C:attention}Egg{},',
                    '{C:attention}+#2#{} per additional {C:attention}Boss Blind',
                    '{C:inactive} (Currently {C:attention}#1# {C:dark_edition, s:0,9}Negative{C:attention} Egg{C:inactive})'
                },
            },
            j_drx1_apathy = {
                name = 'Apathy',
                text = {
                    'Create a {C:green}random{} {C:attention}Tag{}',
                    'when you skip a {C:attention}Blind{}',
                    '{C:inactive,s:0.6} (Visuals are in progress)'
                },
            },
            j_drx1_high_on_joker = {
                name = 'High on Joker',
                text = {
                    '{X:mult,C:white} X#1# {} Mult if played {C:attention}poker',
                    '{C:attention}hand{} is a {C:attention}#2#',
                    'Poker hand changes every hand',
                },
            },
            j_drx1_royal_bat = {
                name = 'Royal Bat',
                text = {
                    '{C:green}#1# in #2#{} chance to',
                    'create a {B:1,V:2}Death{} when',
                    'hand played contains a',
                    'scoring {C:attention}Jack{} and {C:attention}King{}',
                    '{C:inactive} (Must have room)',
                },
            },
            j_drx1_lucky_7s = {
                name = 'Lucky 7s',
                text = {
                    'Played {C:attention}7s{} have',
                    '{C:green}#1# in #2#{} chance to',
                    'permanently gain {C:money}$#3#{}',
                    'when scored',
                },
            },
            j_drx1_tobacco_paper = {
                name = 'Tobacco Paper',
                text = {
                    'Retrigger all',
                    'played {C:attention}Lucky Cards,',
                    '{C:green}#1# in #2#{} chance to',
                    'retrigger {C:attention}twice{} instead',
                },
            },
            j_drx1_don_juan = {
                name = 'Don Juan',
                text = {
                    'Each scoring {C:attention}Wild Card',
                    'has {C:green}#1# in #2#{} chance to',
                    'upgrade every {C:legendary,E:1}Flush hand',
                },
            },
            j_drx1_herringen = {
                name = 'Herringen',
                text = {
                    'This Joker gains',
                    '{C:red}+#1#{} discard every',
                    '{C:attention}#3#{} {C:planet,E:2}Neptune{} cards used',
                    '{C:inactive} (Currently {C:red}+#2#{}{C:inactive} discards,{} {C:attention}#4#{}{C:inactive}/{}{C:planet}#3#{}{C:inactive})',
                },
            },
            j_drx1_the_worm = {
                name = 'The Worm',
                text = {
                    '{C:green}#1# in #2#{} chance to create',
                    'a random {C:spectral}Spectral{} card',
                    'per destroyed {C:attention}card{}',
                    '{C:inactive} (Must have room)',
                },
            },
            j_drx1_the_godfather = {
                name = 'The Godfather',
                text = {
                    '{X:mult,C:white} X#1# {} Mult if you',
                    'earned at least {C:money}$#2#{}',
                    'during current {C:attention}Blind',
                    '{C:inactive} (Currently {}{C:money}$#3#{} {C:inactive}earned)',
                },
            },
            j_drx1_boredom = {
                name = 'Boredom',
                text = {
                    'This Joker gains {X:mult,C:white} X#1# {} Mult',
                    'per {C:attention}consecutive Blind{} beaten',
                    'on first played {C:attention}hand{}',
                    '{C:inactive}(Currently {X:mult,C:white} X#2# {C:inactive} Mult)',
                },
            },
            j_drx1_dauphine = {
                name = 'Dauphine',
                text = {
                    'All cards with',
                    '{C:diamonds}Diamond{} suit are',
                    'considered {C:attention}Kings',
                },
            },
            j_drx1_bokida = {
                name = 'Bokida',
                text = {
                    'Create a {C:dark_edition,s:0.9}Negative{}',
                    '{C:planet}Planet{} card of',
                    'played {C:attention}poker hand',
                },
            },
            j_drx1_menu = {
                name = 'The Menu Please',
                text = {
                    "This Joker gains {C:attention}twice{} the",
                    "amount of the scoring {C:attention}Chips",
                    "of {C:attention}Destroyed cards",
                    "{C:inactive} (Currently {C:chips}+#1#{C:inactive} Chips)",
                },
            },
            j_drx1_eglantine = {
                name = 'Eglantine',
                text = {
                    "{X:red,C:white} X#1# {} Mult",
                    "{C:attention}-#2#{} card slot",
                    "available in shop",
                },
            },
            j_drx1_great_wall = {
                name = 'The Great Wall of China',
                text = {
                    "Gives {C:blue}+1{} Hands for",
                    "every {C:blue}#1#{C:attention} Stone Cards{}",
                    "in your {C:attention}full deck",
                    "{C:inactive} (Currently {C:blue}#2#{C:inactive} hand)",
                },
            },
            j_drx1_bucket_spade = {
                name = 'A Bucket and a Spade',
                text = {
                    "Add {C:red}+#1#{} Mult to this",
                    "Joker and lose {C:money}$#2#{} if {C:attention}played",
                    "{C:attention}hand{} contains a {C:spades}Spade{} card",
                    "{C:inactive} (Currently {C:red}+#3#{C:inactive} Mult)",
                },
            },
            j_drx1_off_head = {
                name = 'Off with their heads!',
                text = {
                    "If played hand contains",
                    "a scoring {C:hearts}Queen of Hearts{},",
                    "{C:attention}destroy{} every other",
                    "scoring cards",
                },
            },
            j_drx1_password = {
                name = 'Safe Password',
                text = {
                    "Draw {C:attention}#1#{} more cards",
                    "if {C:attention}played hand",
                    "contains a {C:attention}Straight",
                },
            },
            j_drx1_slipstream = {
                name = 'Slipstream',
                text = {
                    "Leftmost played card",
                    "becomes a {C:attention}Glass Card{}",
                    "if played hand contains",
                    "a {C:attention}Straight",
                },
            },
            j_drx1_mismatched = {
                name = 'Mismatched Socks',
                text = {
                    "{C:green}#1# in #2# chance{} to create",
                    "a {C:attention}#3#{} if poker",
                    "hand is a {C:attention}Two Pair",
                },
            },
            j_drx1_hang_tag = {
                name = 'Hang Tag',
                text = {
                    "This Joker gains",
                    "{C:chips}+#1#{} Chips per {C:attention}Tag{}",
                    "used this run",
                    "{C:inactive} (Currently {C:chips}+#2#{C:inactive} Chips)",
                },
            },
            j_drx1_ingsoc = {
                name = 'Ingsoc',
                text = {
                    "{C:green}#1# in #2# chance{} for",
                    "each scoring {C:attention}8{} and {C:attention}4",
                    "to retrigger all cards",
                    "{C:attention}held in hand{} abilities",
                },
            },
            j_drx1_metamorphosis = {
                name = 'Metamorphosis',
                text = {
                    "When {C:attention}Blind{} is selected,",
                    "set {C:attention}hands{} to {C:blue}#1#",
                    "This Joker gains {X:red,C:white} X#2# ",
                    "per {C:attention}lost hand",
                    "{C:inactive} (Currently {X:red,C:white} X#3# {C:inactive})",
                },
            },
            j_drx1_one_more = {
                name = 'One More Time!',
                text = {
                    "Add {C:dark_edition}Foil{}, {C:dark_edition}Holographic{},",
                    "or {C:dark_edition}Polychrome{} effect to",
                    "played {C:attention}Enhanced cards{}, then",
                    "remove card {C:attention}Enhancement",
                },
            },
            j_drx1_stamp = {
                name = "Philosopher's Stone",
                text = {
                    "When {C:attention}destroying{} a {C:attention}Playing Card{},",
                    "{S:1.1,C:red,E:2} prevent its Destruction{}",
                    "and add a random {C:attention}Seal{}",
                },
            },
            j_drx1_hydra = {
                name = "Lernaean Hydra",
                text = {
                    "Each card {C:attention}held in hand",
                    "gives {X:mult,C:white} X#2# {} Mult if played hand",
                    "contains {C:attention}#1#{} or more cards",
                },
            },
            j_drx1_consumerism = {
                name = "Consumerism",
                text = {
                    "Played {C:attention}Enhanced cards",
                    "give {C:red}+#1#{} when scored",
                    "Increase by {C:red}+#2#{} for each round",
                    "started with {C:money}$#3#{} or less",
                },
            },
        },
    },
}