# v0.2.0~pre11

## 🛠️ Bug Fixes

- Fix crash when viewing Run Info or Deck Info.

# v0.2.0~pre10

## Compatibility

- Update compatibility to Steamodded **BETA 0321e**.
  - Fix crash on starting a new run
- Baliatro now wraps copy_card() to make replication of Immortal cards through other mods unpleasant.

## 🚀 New additions

### Jokers

- Added "art" to **1. e4**, **1. ...e5**, **En Passant**, **Monolith**, **The Favourite**, **Sevenfold Avenger**, **Whale Joker**, **Tug of War**, **Romeo** and **Katamari Joker**.
- Added new common Joker **All In**
- Added new upgraded Joker **Il Vaticano**, as the upgraded variant of **En Passant**.
- Added new uncommon Joker **The Elephant**.
  - The Elephant is a historic chess piece, which adds an effect to _The Devil_, similarly to the other chess piece jokers.
  - Unlike the other chess piece Jokers, The Elephant does not generate The Devil. This is intentional, as the effect has a potential to be stronger than The Rook while not similarly locking the player into a build.
- Added new uncommon Joker **Vanilla Beans** and new rare Joker **Blank Card**.
  - These are intended to support and later provide a transition for builds starting with Plain mechanic jokers. Comes with art!
- Added new uncommon Joker **Frequent Flyer Card**.
  - This is intended to support Chips-stacking strategies with a very strong source of Mult that is somewhat weak in the early game. Comes with art!

### Consumables

- Added Tarot card **Ace of Cups**.
  - This can be used to cleanse a card, making it plain. Primary intention is to allow a late game pathway to creating plain cards for a pivot to **Blank Card**.
  - Has weaker alternative uses to make it not a completely dead draw from packs.
- Added legendary Tarot card **King of Swords**.
  - This applies a random non-faded edition, seal and enhancement to a single card.
  - The frequency is currently relatively high, and may be lowered in the future.
  - In addition to providing an additional red seal source, this is also intended to somewhat aid a transition from Plain cards into **Blank Card**.

### Pacts

- Added "art" to all pacts.
- Added the **Plenty** and **Craftmanship** pact family.

## ⚖️ Balance

### Enhancement

- **Resistant** cards no longer innately have -2 Mult. Instead, the card permanently gains -0.5 Mult when scored.
  - The penalty for Resistant cards early was brutal, but came at very little cost for established decks in later antes. This way, an Ace of Pentacles can be used in a pinch for play scoring strategies at the cost of weakening the card.

### Jokers

- **Scales** now loses X0.1 Mult when an unchosen hand is played (from X0.2 Mult) and can no longer select the same hand twice in a row.
  - This should somewhat.. balance the scales on its sometimes awful tendency to get stuck on Straight Flush. Still no guarantees, though!
- **Lesser Demon** now also causes held Gold cards to grant +8 Mult.
  - This card is extremely particular in exchange for a somewhat weak effect. This should effectively make it stronger than a Midas Mask as long as you can draw your sixes.
- **Effigy** now grants 6 retriggers in total, but only up to 3 per card.
  - This effectively grants 3 retriggers per card for Pairs, 2 retriggers per card for Three of a Kind, while keeping it only marginally better than _Sock and Buskin_ and _Hack_ for Flush Fives, and equivalent to _Hanginger Chad_ for High Cards.

### Planets

- **Phobos** once again grants +5 Mult per use.

### Pacts

- **The Devil's Scorn** no longer comes with a Showdown pact, instead, it always comes with **The Scorn**, which is a 2X Blind that destroys all consumables when defeated.
  - This should severely reduce the extreme case downsides of interacting with the mechanic.
- The **Fingers** contract now grants +2 Hand Size (from +3).
  - +3 Hand Size gave a one-card solution to applying Tug of War to the play area on a 5-card played hand. This way, at least one hand size has to be acquired from another source.
- Blinds applied by pacts now also apply their score multiplier.
  - Taking Pacts should always weigh potential gain against potential downsides. This should make it more of a hail mary play to take a pact on ante 4 on a run that is somewhat struggling.
- **The Wall** and **Violet Vessel** can now appear as pact blinds.
- **The Rail** can no longer appear as a pact blind.
  - Debuffed cards do not count as played for The Rail, so effectively, it was stuck debuffing every playing card.
  - Besides, Rail as a pact blind is cruel and unusual punishment due to the unconditional volume of playing cards debuffed.

## 🛠️ Bug Fixes

### Blinds

- Fix **Turquoise Ladder** just straight up not working.

### Editions

- **Photographic** playing cards, should you happen to acquire one, will now correctly score XChips on held in hand and joker-induced effects.
- **Scenic** cards now correctly count XChips gain as triggering.

### Jokers

- Fix end of round crash with **Invisible Joker**.
- Fix **The Knight** setting the incorrect field on cards, thus not granting permanent dollar bonuses.
- Fix **The Pawn**, **The Rook**, **The Knight**, **The Bishop** and **The Queen** retriggering enhanced held in hand cards.
- Added some missing informational boxes.

### Pacts

- Fix in-shop crash with Verdant Leaf.

# v0.2.0~pre9

## ⚖️ Balance

### Jokers

- **Hadron Collider** now grants X0.2 per hand matching criteria played (from X0.35).
  - In general, early Flush gameplans felt like they had a too easy time scaling this Joker compared to other scaling uncommon options. They still do, but hopefully this forces some hand expenditure.
- **Microtransaction Cards** XChips output has been increased to 1.2, 1.35, 1.5, 1.8 respectively (from 1.1, 1.2, 1.3, 1.5).
  - With the general negative effects of these cards on economy, it felt warranted to make them slightly stronger.
  - This should counteract the devastating effects of losing 1-2 dollar per card for early plans.
  - In general, lategame builds which aim to use Epic MTX cards as stabler alternatives to Glass cards will still find themselves struggling to keep up economically without proper planning.
  - SMODS fix for Microtransaction cards is still pending (currently negative p_dollars on enhancement has no effect).

## 🛠️ Bug Fixes

### Blinds

- Fix another crash with **The Fish** blind.

# v0.2.0~pre8

## 🛠️ Bug Fixes

### Blinds

- Fix crash during **The Wheel** blind.
- Fix cards staying flipped when being played during **The House**, **The Wheel** or **The Fish**.

### Cosmetic

- Fix banned joker data being appended to some interest cap info boxes.

# v0.2.0~pre7

## ⚖️ Balance

### Jokers

- **Tax Collector** now subtracts $8 (from $6), effectively granting $1 for a three-suit hand and $4 for a four-suit hand, making it more on-par with vanilla Common economy options.

## 🛠️ Bug Fixes

### Jokers

- Fix crash when **Real Estate** would appear in a shop or pack.

### Blinds

- Fixed various bugs with the new Blinds introduced.

# v0.2.0~pre6

## Compatibility

- Update compatibility to Steamodded **BETA 0303a**.
- Now utilizes core SMODS perma bonuses.

## 🚀 New additions

### Jokers

- Introduced new Common joker **Echo**.
- Introduced new Common joker **Monolith**.
- Introduced new Common joker **Sicilian Defence**.
  - These jokers are intended to compliment the otherwise diluting pool of early Common jokers for reliable scoring and gaining deck direction.
- Introduced new Common joker **Whale Joker**
- Introduced new Uncommon joker **Vapor Marketplace**
- Introduced new Uncommon joker **Battle Pass**
  - These jokers can grant a lot of early power, in exchange for economy, offering the option of cashing out for a midgame pivot or developing a strong supporting economy to avoid being consumed by debt.

### Enhancements

- Introduced **Microtransaction** enhancements. This has 4 tiers, each counting as a different enhancement but treated as the same by supporting jokers.
  - **Microtransaction** enhancements aren't created by any consumeable, but may be found in Standard Packs.

### Deal with the Devil

- Audience with the Devil packs appear with an initial interval of 9 played rounds, extending by 3 rounds every time a pack appears. A pack contains 2 random pacts.
- Currently features 6 pacts, each with 3 variants, for a total of 18 pacts.
- Pacts should not be destroyable, manipulated in any way by Postcards, or copiable by any effect.

### Cosmetic

- Interest cap is now an info display. No functional change.
- Nice Blind display, idea from Victin.

## 🛠️ Bug Fixes

### Blinds

- Fixed various bugs with the new Blinds introduced.

## ⚖️ Balance

### Jokers

- **Uneven Freeman** now grants +31 permanent Chips (from +51)
- **Katamari Joker** now gains +1 Mult when most scored rank is scored (from +2)
- **Bodybuilder** now has +4 Mult.
- **Real Estate** can now always spawn duplicates, but only grants +X0.5 when sold.

### Tarot cards

- **The Emperor**, **The Fool** and **The High Priestess** now grant the same edition to all cards created as theirs, instead of just negative.

### Editions

- **Photographic** now grants XChips. It grants a multiplicatively stacking bonus for each instance of the card scoring Chips, Mult, or Dollars.
  - For example, a joker that grants +20 Chips and +4 Mult when a card is scored will also grant in the same instance - at base level - 1.1 x 1.1 = 1.21 XChips.

### Postcards

- With the changes to Photographic edition, **Boston** is now once again Uncommon.

# v0.1.0~pre5

## Compatibility

- Update compatibility to Steamodded **1421b**.

## 🚀 New additions

### Jokers

- Added new Rare Joker **Afterimage**.

## 🛠️ Bug Fixes

### Editions

- Fixed an issue where **Ethereal** cards would not be correctly destroyed if unscored or left in hand when playing a hand.

# v0.1.0~pre4

## Compatibility

- Fix conflict with Bunco

# v0.1.0~pre3

## Compatibility

- Update compatibility to Steamodded **1420a**.

## 🚀 New additions

### Jokers

- Added upgraded joker **Labradorite**, replacing Onyx Agate as the upgraded version of Gluttonous Joker.
- Added upgraded joker **Splatter**, replacing Marble Joker as the upgraded version of Splash.
- Added "art" for a few of the jokers. By art, I of course mean visual distinction from having no image associated with it.
- Added uncommon economy joker **Lesser Demon**.

### Enhancements

- **Stone Cards** now display the original rank and suit of the card they convert.
- Card UI now respects **replace_base_card** for nominal chip value.
- **Stone Cards** now have replace_base_card set.
- Add perma mult, xmult and dollars display to custom SMODS Enhancements UI.

### Vouchers

- Added voucher **Specialty Store**, which grants +1 Booster Pack slot.
- Added voucher **Premium Selection**, requires Specialty Store, which grants a chance for any upgradable joker in a Buffoon Pack to be instead the upgraded variant.

## ⚖️ Balance

### Jokers

- **Fool's Gambit** now has a 1 in 2 chance to not add Faded Polychrome (from 1 in 4).
- **The Rook** now creates two copies of Tower.
- **En Passant** no longer removes Seal or Enhancement if transfer targets already have the same Seal or Enhancement.
- **Bodybuilder** no longer subtracts chips, instead it now has a base 1 in 2 chance to rank up a card.
- **Aceology PhD** now grants X2 Mult (from X4)
- **Appraiser Joker** now grants 1 times the amount of times a card was scored as Chips (down from 2 times)

### Postcards

- **New York** now always applies Mortgage, and never Perishable.
- **Cairo** now also creates 1 copy of Ankh, but is now Uncommon.
- **Budapest** and **Nice** is now Common.
- **Boston** is now Rare.

### Planets

- Added diminishing returns to **Europa** and **Io**
- Reduced the bonus granted by **Europa** and **Io** to 0.025 per use. **Io** in particular may warrant further intervention.

### Mechanics

- Reduced base Mortgage rate to $15 (from $20).
- **Haunted** cards create **Ephemeral** consumables, which are Negative but self-destruct after 3 rounds.
- **Scenic** edition now also grows when the edition itself triggers to avoid complete dud hits, but starts from +2 chips growth now to somewhat alleviate the early game power spike.
- **Photographic** edition should now interact correctly with jokers that provide multiple values in one scoring (eg. Scholar, Aceology PhD).

## 🛠️ Bug Fixes

### Jokers

- Fix visual display bug of retrigger count on **Hack**.
- **Sandbag** had an unintentionally high price.
- Adjusted the description of some jokers visually.
- Clarified on **Sharpening Stone** that only upgradable editions are ever considered.
- Fixed **Sharpening Stone** incorrectly (not) interacting with faded editions.

### Planets

- Fixed a bug where **Luna**'s artificial scarcity was tied to the level of **Callisto** instead.

### Blinds

- **The Count** now respects having no rank (stone cards will no longer be debuffed)

### Mechanics

- Temporarily disabled **Photographic** augment message.
