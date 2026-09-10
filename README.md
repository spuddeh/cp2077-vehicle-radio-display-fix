# Vehicle Radio Display Fix

The car's radio display shows the station that is actually playing, and whether the radio is on.

In the unmodded game the display is written only when you pick a station or press the radio key.
Getting into a car with the Radioport on hands the Radioport's station to the car without telling
the display, and a car that resumes its last station does the same, so the display keeps showing
whatever it showed last. This mod writes the display from the radio itself each time you get in.

**Nexus:** not yet released.
**Source:** <https://github.com/spuddeh/cp2077-vehicle-radio-display-fix>

## Requirements

- [redscript](https://www.nexusmods.com/cyberpunk2077/mods/1511)
- [Codeware](https://www.nexusmods.com/cyberpunk2077/mods/7780)

[RedLogger](https://www.nexusmods.com/cyberpunk2077/mods/31920) is optional. With it installed the
mod writes a log to `r6/logs/mods/`; without it the logging compiles away.

## License

Licensed under the [PolyForm Noncommercial License 1.0.0](LICENSE). You may use, modify, and share
this mod and its source for any **noncommercial** purpose, as long as you credit the original
creator. Commercial use, including paid mods or selling, is not permitted.

## Disclaimer

This mod was developed with the assistance of an LLM. All in-game testing and code validation was
performed by a human. No rogue AIs were permitted through the Blackwall.
