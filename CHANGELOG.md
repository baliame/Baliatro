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
