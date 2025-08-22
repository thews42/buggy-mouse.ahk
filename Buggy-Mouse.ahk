
/*
**    Buggy-Mouse.ahk - Fix a buggy mouse. Stop it from double-clicking when you try to single-click.
**    Authors: JSLover - Forked by bhackel, updated using chatgpt-4o
**    AutoHotkey 1.1+
**
*/

#SingleInstance force

; **************************** Settings ****************************
DoubleClickMin_ms := 90  ; Minimum double-click time to block rapid double-clicks.
; **************************** /Settings ****************************

; *** Tray Menu Setup ***
Text_ClicksBlocked := "Clicks Blocked"
Menu, Tray, Add, %Text_ClicksBlocked%, ShowClicksBlocked
Menu, Tray, Default, %Text_ClicksBlocked%
Menu, Tray, NoStandard

; Detect primary mouse button setting (used for info only)
PrimaryButton := GetPrimaryMouseButton()

; Explicit hotkeys for mouse buttons (call handlers)
*LButton::
*MButton::
*RButton::
    ProcessMouseDown(A_ThisHotkey)
return

*LButton up::
*MButton up::
*RButton up::
    ProcessMouseUp(A_ThisHotkey)
return

; Update Tray Menu with click block count
UpdateTray() {
    global Text_ClicksBlocked, BlockedCount_Down, BlockedCount_Up
    BlockedCount_Total := BlockedCount_Down + BlockedCount_Up
    MenuText := Text_ClicksBlocked ": " BlockedCount_Total
    Menu, Tray, Tip, %MenuText% - %A_ScriptName%
}

; Show clicks blocked info
ShowClicksBlocked:
    global BlockedCount_Down, BlockedCount_Up, PrimaryButton, Text_ClicksBlocked
    MsgBox, 64,, %Text_ClicksBlocked% - Down: %BlockedCount_Down% Up: %BlockedCount_Up%`nPrimary: %PrimaryButton%
return

; Mouse down handler
ProcessMouseDown(hotkey) {
    global DoubleClickMin_ms, LastMouseDown_ts, LastMouseDown
    global BlockedCount_Down, blockeddown
    Critical
    keyName := Hotkey_GetKeyName(hotkey)
    TimeSinceLastDown := A_TickCount - LastMouseDown_ts

    if (hotkey = LastMouseDown && TimeSinceLastDown <= DoubleClickMin_ms) {
        blockeddown := 1
        BlockedCount_Down++
        UpdateTray()
    } else {
        blockeddown := 0
        Send, {Blind}{%keyName% DownTemp}
    }
    LastMouseDown := hotkey
    LastMouseDown_ts := A_TickCount
}

; Mouse up handler
ProcessMouseUp(hotkey) {
    global LastMouseUp_ts
    global BlockedCount_Up, blockeddown
    Critical
    keyName := Hotkey_GetKeyName(hotkey)

    if (blockeddown) {
        BlockedCount_Up++
        UpdateTray()
    } else {
        Send, {Blind}{%keyName% up}
    }
    blockeddown := 0
    LastMouseUp_ts := A_TickCount
}

; Utility: Make hotkey safe for variable names
MakeVarSafe(hotkey) {
    return RegExReplace(hotkey, "i)[^a-z0-9_]", "_")
}

; Utility: Get key name without modifiers
Hotkey_GetKeyName(hotkey) {
    hotkey := RegExReplace(hotkey, "i)^[^a-z0-9_]+")  ; Remove modifiers
    return StrSplit(hotkey, " ")[1]  ; Get key name
}

; Utility: Detect current primary mouse button (left or right)
GetPrimaryMouseButton() {
    ; 0 = Left is primary, 1 = Right is primary
    if (DllCall("GetSystemMetrics", "int", 23) = 0) {
        return "LButton"
    } else {
        return "RButton"
    }
}

^+#!F9::Suspend
^+#!F12::ExitApp
