# buggy-mouse.ahk
A fork of the same name by bhackel, which was forked from JSLover. Fix a buggy mouse. Stop it from double-clicking when you try to single-click.

Original file was hosted on http://jslover.secsrv.net/AutoHotkey/Scripts/Buggy-Mouse but has since been removed

### Changelog

#### Version 1.2.0

- **Improvement: Reliable Button Handling**
  - Replaced dynamic primary-button hotkeys with explicit `LButton`/`MButton`/`RButton` hotkeys that delegate to shared handlers.
- **Fix: Debounce Logic and Globals**
  - Corrected blocked-click logic for down/up events and declared necessary globals inside handler functions to avoid scope issues.
- **Improvement: Tray Updates**
  - Converted tray update label into a function for cleaner calls and updated tooltip text to include total blocked clicks.

#### Version 1.1.0

- **Feature: Dynamic Primary Button Detection**
  - Added functionality to detect the current primary mouse button (left or right) using the `GetSystemMetrics` API. This ensures that the script dynamically adapts to the user's primary mouse button setting, whether it's set to **left-click** or **right-click** as the primary button in Windows.
  - Implemented the `GetPrimaryMouseButton()` function to manage this detection.

- **Improvement: Dynamic Button Handling**
  - Refactored the script to use the detected primary mouse button for handling mouse down and up events. The script now works seamlessly regardless of which button (left or right) is configured as the primary mouse button, ensuring the double-click prevention works as expected in all configurations.
