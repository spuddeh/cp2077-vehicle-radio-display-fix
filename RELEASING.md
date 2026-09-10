# Releasing

This repo publishes Vehicle Radio Display Fix to **GitHub Releases** and **Nexus Mods** via
[`.github/workflows/release.yml`](.github/workflows/release.yml), driven by
[`release-manifest.json`](release-manifest.json).

The mod is pure redscript (one loose `.reds` file, no `.archive`), so there is no WolvenKit step:
the workflow stages `r6` and zips it, so `r6/...` lands at the zip root exactly as the game expects.

| Artifact id | What | File on Nexus |
| --- | --- | --- |
| `vehicle-radio-display-fix` | The mod | main |

## First release is manual (then it automates)

A Nexus **file id does not exist until a file has been uploaded once**, so the very first upload
cannot come from CI. Do this once:

1. **Create the Nexus mod page** and set its requirements and description (paste
   `nexus_description.bbc`).
2. **Build the first zip locally** and upload it by hand through the Nexus site:
   ```pwsh
   Compress-Archive -Path "r6" -DestinationPath "VehicleRadioDisplayFix_v1.0.0.zip" -Force
   ```
3. **Read the file id and set it as a repository VARIABLE.** On the mod page open the **Files**
   tab > **API Info** and copy the id - Nexus labels it **"Group ID"** there. Set it as the
   repository variable **`NEXUS_FILE_ID_VEHICLE_RADIO_DISPLAY_FIX`** (Settings > Secrets and
   variables > Actions > **Variables**), and set `nexus_mod_id` in `release-manifest.json` to the
   mod page number.

   > **It does not go in the repo.** The id does not exist until this first upload.
   >
   > **Do NOT take the id from the public v1 API.** That endpoint has a field also called
   > `file_id`, in a different id space. The wrong value looks plausible and fails only at
   > release time.
   >
   > **A variable, not a secret:** it is an identifier, not a credential, and does nothing
   > without `NEXUSMODS_API_KEY`.
4. **Add the API key secret** `NEXUSMODS_API_KEY` (Settings > Secrets and variables > Actions >
   **Secrets**).

After that, every future release publishes automatically.

## Before cutting any release: bump the version

The version in the git tag is what CI ships, and it must agree with:

- the `.reds` header (`File Version:` line),
- `@changelog.md` and `nexus_changelog.md`,
- `currentVersion` in `release-manifest.json`.

`release-check` verifies this.

## Cutting a release

1. Commit the version bump and your changes.
2. Create a GitHub Release whose **tag** is `vehicle-radio-display-fix-v<version>`:
   ```pwsh
   gh release create vehicle-radio-display-fix-v1.0.0 --title "Vehicle Radio Display Fix v1.0.0" --notes "..."
   ```
   The release body feeds two Nexus fields, split by a `<!-- nexus-description-end -->` marker on
   its own line. Everything **before** the marker becomes the **file description** (capped at 255
   chars); everything **after** it is appended to the mod page's **changelog**. With no marker, the
   whole body becomes the changelog and no file description is sent. Plain lines, no markdown.
3. On publish, the workflow zips `r6` as `VehicleRadioDisplayFix_v<version>.zip`, attaches it to
   the GitHub Release, and uploads to Nexus.
