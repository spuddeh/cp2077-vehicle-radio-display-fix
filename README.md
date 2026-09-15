# Vehicle Radio Display Fix

The car's radio display shows the station that is actually playing, and whether the radio is on.

In the unmodded game the display is written only when you pick a station or press the radio key.
Getting into a car with the Radioport on hands the Radioport's station to the car without telling
the display, and a car that resumes its last station does the same, so the display keeps showing
whatever it showed last. This mod writes the display from the radio itself each time you get in.

**Nexus:** <https://www.nexusmods.com/cyberpunk2077/mods/33736>
**Source:** <https://github.com/spuddeh/cp2077-vehicle-radio-display-fix>

## Requirements

- [redscript](https://www.nexusmods.com/cyberpunk2077/mods/1511)
- [Codeware](https://www.nexusmods.com/cyberpunk2077/mods/7780)

[RedLogger](https://www.nexusmods.com/cyberpunk2077/mods/31920) is optional. With it installed the
mod writes a log to `r6/logs/mods/`; without it the logging compiles away.

## License

Licensed under the [MIT License](LICENSE). Use, change and share this mod and its source,
including in your own mods. Keep the licence notice with any copy.

## Disclaimer

This mod was developed with the assistance of an LLM. All in-game testing and code validation was
performed by a human. No rogue AIs were permitted through the Blackwall.
