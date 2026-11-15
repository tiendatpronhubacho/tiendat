# TienDat — 3012 xtool SwiftPM migration

Project root for 3012 xtool Studio: `Package.swift` + `xtool.yml`. App product `TienDat`; bundle ID `com.tiendat.ogios`; minimum iOS 16. The original Xcode project and source are retained under `OriginalXcode/`.

## Important limitations
This is a migration scaffold, not a verified successful build. The source was an Xcode project using a bridging header and Objective-C/C native files. SwiftPM uses separate native modules, so the former bridging-header symbols are imported through `TienDatObjC` and `TienDatC`.

To remain within the normal iOS app sandbox, cross-app container activation, other-app enumeration/launching, and exploit-backed filesystem access are disabled. `MCMBridge` and `AppIconHelper` are safe no-op stubs. UI and ordinary in-app functionality are retained, but privileged cross-app file functions will not work.

## Import from iPhone in 3012
1. Extract the ZIP in Files.
2. Open 3012 → xtool Studio → import the extracted folder containing `Package.swift` and `xtool.yml`.
3. Run **Sync** (`xtool sync`).
4. Open **Status** and verify product `TienDat` and bundle ID `com.tiendat.ogios`.
5. Choose **Build**, not **Inject**. Review build logs and fix any reported compile errors.
6. Export the resulting unsigned IPA artifact and sign it with a certificate/profile you are authorized to use.

The 3012 IPA's embedded CLI text confirms `xtool build` is routed through a configured SSH VPS or exported Actions ZIP. The iPhone is the control/import interface; the build is not a native on-device Xcode compile. Configure the build backend in 3012 before starting.
