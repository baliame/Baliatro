# v0.1.0~pre3

## Compatibility

* Update compatibility to Steamodded 1420a.

## 🚀 New additions

### Jokers
* Added upgraded joker **Labradorite**, replacing Onyx Agate as the upgraded version of Gluttonous Joker.
* Added upgraded joker **Splatter**, replacing Marble Joker as the upgraded version of Splash.
* Added "art" for a few of the jokers. By art, I of course mean visual distinction from having no image associated with it.
* Added uncommon economy joker **Lesser Demon**.

### Enhancements
* **Stone Cards** now display the original rank and suit of the card they convert.
* Card UI now respects **replace_base_card** for nominal chip value.
* **Stone Cards** now have replace_base_card set.
* Add perma mult, xmult and dollars display to custom SMODS Enhancements UI.

### Vouchers
* Added voucher **Specialty Store**, which grants +1 Booster Pack slot.
* Added voucher **Premium Selection**, requires Specialty Store, which grants a chance for any upgradable joker in a Buffoon Pack to be instead the upgraded variant.

## ⚖️ Balance

### Jokers
* **Fool's Gambit** now has a 1 in 2 chance to not add Faded Polychrome (from 1 in 4).
* **The Rook** now creates two copies of Tower.
* **En Passant** no longer removes Seal or Enhancement if transfer targets already have the same Seal or Enhancement.
* **Bodybuilder** no longer subtracts chips, instead it now has a base 1 in 2 chance to rank up a card.
* **Aceology PhD** now grants X2 Mult (from X4)
* **Appraiser Joker** now grants 1 times the amount of times a card was scored as Chips (down from 2 times)

### Postcards
* **New York** now always applies Mortgage, and never Perishable.
* **Cairo** now also creates 1 copy of Ankh, but is now Uncommon.
* **Budapest** and **Nice** is now Common.
* **Boston** is now Rare.

### Planets
* Added diminishing returns to **Europa** and **Io**
* Reduced the bonus granted by **Europa** and **Io** to 0.025 per use. **Io** in particular may warrant further intervention.

### Mechanics
* Reduced base Mortgage rate to $15 (from $20).
* **Haunted** cards create **Ephemeral** consumables, which are Negative but self-destruct after 3 rounds.
* **Scenic** edition now also grows when the edition itself triggers to avoid complete dud hits, but starts from +2 chips growth now to somewhat alleviate the early game power spike.
* **Photographic** edition should now interact correctly with jokers that provide multiple values in one scoring (eg. Scholar, Aceology PhD).

## 🛠️ Bug Fixes

### Jokers
* Fix visual display bug of retrigger count on **Hack**.
* **Sandbag** had an unintentionally high price.
* Adjusted the description of some jokers visually.
* Clarified on **Sharpening Stone** that only upgradable editions are ever considered.
* Fixed **Sharpening Stone** incorrectly (not) interacting with faded editions.

### Planets
* Fixed a bug where **Luna**'s artificial scarcity was tied to the level of **Callisto** instead.

### Blinds
* **The Count** now respects having no rank (stone cards will no longer be debuffed)

### Mechanics
* Temporarily disabled **Photographic** augment message.