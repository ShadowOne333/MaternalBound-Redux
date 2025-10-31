![MaternalBound Redux Logo](https://i.imgur.com/331VwHb.png)

-----------------

<p align="center">
  <a href="https://www.youtube.com/watch?v=djQo0qAt5S8"><img width="460" height="300" src="https://i.imgur.com/rpWFcjd.jpg"></img></a>
</p>

-------------------

# **Index**

* [**Links**](#links)

* [**MaternalBound Redux Info**](#maternalbound-redux)

* [**Changelog**](#changelog)

* [**Patching and Usage Instructions**](#instructions)

* [**Project Licence**](#license)

* [**Credits**](#credits)

* [**Sprite Credits**](#sprites)

-------------

## Links

* **Main release patch:**
https://github.com/ShadowOne333/MaternalBound-Redux/releases

* **MSU-1 PCM pack:**
https://archive.org/details/earthbound-msu-1-pack <br />
	(Mirror at Zeldix.net: https://www.zeldix.net/t1931-earthbound-msu-1 )

* **MaternalBound Discord:**
https://discord.gg/v7kyYrv

-----------------

## MaternalBound Redux

***MaternalBound Redux is a completely revamped and improved version of the original MaternalBound:*** <br />
https://forum.starmen.net/forum/Community/PKHack/WIP-MaternalBound-Uncensoring-Other-junk-hack/

**What does this mean?**

That everything you found in the original MaternalBound can also be found here, but with a much more polished detail and also with a ton of Quality of Life improvements made to it.<br />
The whole source code for the project is available as well! Be sure to check out the release page at the bottom of this post to enter the GitHub page for the project, alongside the release page for the patches.

**So… What changes can you expect out of MaternalBound Redux in addition to the ones found in the original MaternalBound?**

----------------

## Changelog

Don’t get dizzy while reading the full changelog:

* A lot of bugfixes from the original EarthBound have been fixed:
    - Brain stone bug
    - Crying status ailment bug
    - Game over OSS bug
    - Guts bug
    - Palette tint bug
    - Party members diagonal run bug
    - Return item control code bug
    - Rock candy bug
    - Single 2BPP battle backgrounds bug
    - Teleport hardlock bug
    - Tent check bug
    - Text highlight bug
    - Several debug menu bugs have been fixed
    - PSI Special fixed to PK Special (PK Rockin)
    - Region crack to make the game playable in any region
* Fully functional title screen with NO glitches (no more “TH” in the middle like before)
* MSU-1 integration (alongside the very first PCM pack for EarthBound)
* Fully hardware compatible (can be played in reproduction cartridges)
* New Controls hack implemented. Full button remapping to something similar to other RPGs of the era, like FFVI.
    - A/L button: Talk to people or check object (You won’t get the “No problem here” message anymore)
    - X button: Opens up the main game menu (Goods, Equip, etc)
    - B button: Open up HP/PP boxes and cash-on-hand window
    - Y button: Run when held down
    - Start button: Opens/Closes up the map
* Unique overworld enemy sprites for EVERY enemy found in the game, to give it a little bit of a Mother 3 vibe
* Sprites have been edited to match their official artwork (clay models) of some characters
* All 4 robot sprites are now unique, and each one has a specific object from the character to differentiate them from each other
* New custom diagonal sprites for ALL characters that join the party at one point (Porky, Picky, King, Tony, Bubble Monkey, Flying Man, Dungeon Man). This also includes:
    - All character tiny sprites (Ness, Paula, Jeff, Poo)
    - All ghost sprites (Normal and tiny)
       - Animation for each and every ghost sprite as well
    - Diamondized sprite (Normal and tiny)
    - Teddy Bear (Normal and tiny)
* Redesigned the greek letters used for PSI (alpha, beta, gamma, sigma and omega) so that they better match the form of the actual greek letters they represent
* Implemented photosensitive reduction hacks made from subsequent releases of EarthBound (SNES Mini, Virtual Console) into MaternalBound, to make the experience the most seizure-safe possible
* Extended Naming Screen Character Table, for both the party and the player’s name prompt
* Completely rewritten script based on Tomato’s Legends of Localization book (Thanks TragicManner!)
* Poo’s “Mirror” command has been renamed to “Transform” to more accurately represent what the move does, and it’s actual Japanese name
* Even MORE uncensoring (based on the Legends of Localization book by Clyde Mandelin)
* A ton of NPC dialogue bugfixes (examples include no more “Ness ate the pizza together”, Twoson old lady NPC dialogue, etc)
* More typo fixes from the original script
* Characters known by name now get their name displayed at the title of the text box
* Dad no longer calls you after a while. You will no longer be interrupted by him
* Every location of the game is now accessible through PSI Teleport
* Some PSI animations had wrong tiles in them, those have been fixed
* Fixed the Dusty Dunes teleport location not appearing
* Reworked enemy battle sprites
* Now using an equipabble item inside the Goods menu will equip said item, instead of giving the “is an item that can be equipped” message (Thanks, Chaz!)
* Reworked Gas Station screen, so that all letters now letters use the same type of font, and also words are now evenly spaced out
* Full localization/translation and revamp of the Debug menus found in the game:
    - ATM debug menu (Apple option when pressing the Y button in the “View Map” option of the Kirby debug menu)
    - Kirby Debug menu and its options
* A lot of bugfixes done to all of the Debug menus themselves:
    - ATM Debug menu had 3 events which caused Ness to be stuck in objects, these have now been fixed (Events 2, 35 and 46)
    - Fixed the Kirby sprite assembly from the Debug menu (CoilSnake glitches/removes it)
    - The whole Kirby Y button menu is fully restored and localized
    - Palette for the text windows in the Kirby debug menu is now fixed to default Plain flavour instead of the pinkish glitched one
    - Full button remapping for the Debug menu as well
      - A/L button talks to NPCs while on debug mode
      - B button refreshes the screen
      - X button opens up the game menu (Goods, Equip, etc)
      - Y button opens up the Debug menu
    - A completely removed debug menu (found originally in Mother 2, but removed in EarthBound) is now restored in the “Banana” option of the debug menu
    - Fixed the “Show battle” option crashing from a fresh boot
* Diamond bullet from Mother 2 is back… Although not implemented in the main text.
    But… it can be found somewhere in the game.
    D-Man made an amazing work on re-enabling the coloured diamond from Mother 2 which was replaced for a white dot/bullet in EarthBound. The way to enable it in game can be done by replacing all of the “@” from the ccscript files with the command {diam}.
    His work was just too good to not mention it.
    The reason why it was not implemented into MaternalBound Redux was due to two things:
    - The diamond is 8 pixels wide. Leaving it as such would move some phrases which barely fit in three lines. Ways to fix this:
       - This would require verifying the ENTIRE script once again (which is something I’m not fond with)
       - Modify the diamond code to just print out 6 pixels wide instead of 8.
       - Change the automatic linebreak code to make a space of 8 pixels instead of 6 from the window perimeter.
       - Change every manual linebreak to have 3 spaces instead of 2 in all the ccscript files.
    - The diamond does not show up in battle. This is unknown, as Mother 2 also didn’t have the diamond for battles. (Why though?)
* A lot more in-game and script bugfixes

-----------------

## Instructions

To play MaternalBound Redux, the following is required:

* Snes9x 1.54 or above (any recent version of it should work)
* EarthBound (U) SNES ROM:

		EarthBound (USA).sfc
		No-Intro: Super Nintendo Entertainment System (v. 20180813-062835)
		File/ROM SHA-1: D67A8EF36EF616BC39306AA1B486E1BD3047815A
		File/ROM CRC32: DC9BB451
* Floating IPS (FLIPS)
* MaternalBound-Redux.ips patch

Navigate to the [releases](https://github.com/ShadowOne333/MaternalBound-Redux/releases) page and grab either the BPS or IPS hacks which can be patched into a clean EarthBound ROM (4MB expanded EarthBound ROM for IPS) with either [Lunar IPS](https://www.romhacking.net/utilities/240/), [FLIPS](https://www.romhacking.net/utilities/1040/) or by using [Romhacking’s Online ROM Patcher](https://www.romhacking.net/patch/). Alternatively, the EBP hack can be patched into a clean EarthBound ROM by using the [EarthBound Patcher](https://github.com/Lyrositor/EBPatcher).

If you want to use the hack with **MSU-1**, grab the **PCM pack** released alongside this hack from the following archived link:
https://archive.org/details/earthbound-msu-1-pack
Or, alternatively, from the mirrored download in Zeldix at the beginning of this page:
https://app.box.com/s/fkmjx61w4m7xom1kmir5zk7xv6jx9u8f
Simply rename your ROM to *"eb_msu1.smc"* and place it in the same folder as all the .pcm/.msu files.
You need to use Snes9x v1.54 or above in order for the MSU-1 hack to work.

---------------

## License

MaternalBound Redux is a project licensed under the terms of the GPLv3, which means that you are given legal permission to copy, distribute and/or modify this project, as long as:

1) The source for the available modified project is shared and also available to the public without exception.
2) The modified project subjects itself different naming convention, to differentiate it from the main and licensed MaternalBound Redux project.

You can find a copy of the license in the LICENSE file.

---------------

## Credits

* **TragicManner:**	For the Legends of Localization: EarthBound book, from which the entirety of the script rewrite was done
* **D-Man:** A lot of the ASM work was thanks to him and his amazing skills at 65816 knowledge
* **H.S:**	Bunch of troubleshooting and ASM help as well
* **PhoenixBound:**	Beta testing the hack, feedback and also bringing up details which eventually ended up being more features, and a lot of ASM implementations too.
* **Karmageddon:**	For being such a detailed beta tester, and all his feedback which helped polish MaternalBound Redux to where it is right now!
* **DarkSamus993:**	His debugging and ASM skills are amazing, he helped a lot to figure out the Kirby sprite assembly and its fix, as well as the palette issue in the Debug menu.
* **Herringway:**	For his New Controls hack, which was taken as a base, but then heavily reworked to be fully customizable using CoilSnake
* **Howisthisaname:** For the EarthBound Enhanced hack, which is where some of the reworked battle sprites come from, while some were made entirely by me
* **Conn:**	For the creation of the MSU hack for EarthBound. I transcribed the patch to CCS format and also helped with the loop table.
* **Miles:**	For the coloured "CAST" text in the ending, identical to how it was in Mother 2. The code for this was made by PhoenixBound.
* Special thanks to all my beta-testers and people on the MaternalBound Discord (https://discord.gg/v7kyYrv) for their feedback and suggestions!


### Sprites:

* **Jamsilva:**	For all the incredible work he did with the overworld sprites as well as some battle sprites for both his own hack and Redux <br />
* **PhoenixBound:**	Besides all his previous credited work, also want to thank him for the awesome overworld sprites he made for Redux as well <br />
* **Crav (Great Space Pickle):** Sprite artist for the Mother: Cognitive Dissonance project, and for the permission to use some of the unique overworld sprites from that project into Redux! <br />
* **Rickstie:**	For the ongoing interchange of sprite between him and me for the diagonal sprites, inspiration for the robot sprites and other touches to the main characters <br />
* **Howisthisaname:** For the neat EarthBound Enhanced hack, which is where some of the reworked battle sprites come from. The specific sprites from his EB Enhanced project are as follows:

|	Sprite number			|	Enemy name			|	Reason			|
|:-----------------------------------:	|:----------------------------------:	|:-----------------------------------:| 
|006                                     |Red Antoid				|(Slight body changes)|
|007/008/210                             |Evil Mushroom(s)			|(Shading of the feet)|
|012                                     |Mystical Record			|(Face edits)|
|022/023                                 |Annoying Men				|(1 to 1)|
|024                                     |Unassuming Guy			|(1 to 1)|
|032                                     |Cranky Ladies				|(1 to 1)|
|047/048                                 |Arachnid(s)				|(Straight line in the body)|
|049/050/182/183                         |Kraken(s)				|(1 to 1, except colors)|
|054                                     |Cop					|(Few, small changes)|
|061                                     |Crazed Sign				|(Shading)|
|064                                     |Skate Punk				|(Glasses, smile, bottom of the board)|
|065/066                                 |Skelpion(s)				|(Tail and claws)|
|067/068/069/074/075/184/185/186/187/188 |Starmen				|(Shading)|
|079/080/228                             |Cops(s)				|(Various improvements)|
|083/190				 |Diamond Dog				|(Eye and slight spikes/shading)|
|089                                     |Dali's Clock				|(Shading)|
|100                                     |Zap Eel				|(Color of the sparks)|
|104/105                                 |Booka(s)				|(Changed eyes, reshaped body)|
|131                                     |Frank					|(Overall design)|
|135                                     |Tough Guy				|(1 to 1)|
|140                                     |Sentry Robot				|(Added body detail)|
|148                                     |Demonic Petunia			|(1 to 1)|
|223/227                                 |Caterpillar(s)			|(Overall design)|
|224                                     |Evil Eye				|(Slight body shading)|
