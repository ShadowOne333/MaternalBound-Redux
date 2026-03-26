* Implement a Key items-only menu similar to Mother 3, exclusively for Key items during the story so they don't clutter up space in the main inventory.
* Implement a Tools items-only menu similar to Mother 3 with Duster, exclusively for Battle items that can be reused infinitely by Jeff. This can be a copy-paste from the Key items one, but it will require a Battle hijack as well so it can be used in battle.
* Implement special running sprites for when using the Run button similar to Mother 3. This should apply for all party characters: Ness, Paula, Jeff, Poo; and guest party characters: Porky, Picky, Flying Men, Tony, Bubble Monkey, King. Possibly Dungeon Man too but it depends.
* Change Saturn shops option menus to use Saturn font for "Buy/Sell"
* Floating sprite implementation for when Ness receives a phone call, similar to Mother 3's Transceiver. It should be made similar to how Capt. Strong does it in Onett. (Some receiver calls from Orange kid are in data_34)
* Check the Fly Honey softlock and fix it (data_35)
* Fix Magicant boost to Vitality and another stat not working if Ness is already level 99 (data_36)
* Enable Bicycle with a full party (probably make it something like a taxi bike when 2 or more party members are present) (data_38.l_0xc803ac and data_35.l_0xc7c6f1)
* Change how the player obtains the Bazooka and the Broken Iron so they can only be obtained once. The Bazooka is obtained from the seller near the Pyramid, and the Broken Iron is obtained from two other shops, tweak them accordingly.

---FIXED/DONE---
* Game crashes after getting the Tendakraut when the Photoman appears (possible memory leak). Fixed in data_58.l_0xc9d95e, adding the reference in case it happens in other places.
* Town map doesn't open when pressing Start (probably because the Town map is not in the Goods inventory, make it check flag instead)
