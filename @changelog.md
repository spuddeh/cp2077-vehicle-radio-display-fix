# Changelog

## [1.0.0] - 2026-09-10

### Added

- The vehicle radio display is written from the receiver after the Radioport handoff, after the
  vehicle's mount handler, on the engine's `VehicleRadioStationChanged` report, and 0.3 s and
  1.5 s after mounting: `VehRadioState`, `VehRadioStationName` and the component's `m_radioState`.
