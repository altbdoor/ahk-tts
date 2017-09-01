HotkeyCache := {}

SettingsFilePath := A_ScriptDir . "/settings.ini"

; ========================================

JoinArray(Arr, Glue) {
    FinalString := ""
    
    Loop % Arr.Length() {
        FinalString .= Arr[A_Index] . Glue
    }
    
    Return SubStr(FinalString, 1, StrLen(FinalString) - 1)
}

GetComboBoxChoice(TheList, TheCurrent) {
    Loop % TheList.Length() {
        If (TheCurrent == TheList[A_Index]) {
            TheCurrent := A_Index
            Break
        }
    }
    TheList := JoinArray(TheList, "|")
    
    Return {"Index": TheCurrent, "Choices": TheList}
}

WriteSettings(IniSection, IniKey, IniValue) {
    global SettingsFilePath
    IniWrite, %IniValue%, %SettingsFilePath%, %IniSection%, %IniKey%
    Return
}

ReadSettings(IniSection, IniKey, DefaultValue) {
    global SettingsFilePath
    
    If (DefaultValue == "") {
        IniRead, Value, %SettingsFilePath%, %IniSection%, %IniKey%, %A_Space%
    }
    Else {
        IniRead, Value, %SettingsFilePath%, %IniSection%, %IniKey%, %DefaultValue%
    }
    
    Return Value
}

GetPresetIntegerFromText(PresetText) {
    Return RegExReplace(PresetText, "[^\d]", "")
}

GetPresetIntegerFromHotkey(HotkeyText) {
    global HotkeyCache
    
    ResultIndex := -1
    If (HotkeyCache.HasKey(HotkeyText)) {
        ResultIndex := HotkeyCache[HotkeyText]
    }
    
    Return ResultIndex
}

BindHotkeys() {
    global HotkeyCache
    
    Loop, 20 {
        HotkeyAssign := ReadSettings("presetHotkey", "Hotkey" . A_Index, "")
        
        If (HotkeyAssign != "") {
            Hotkey, %HotKeyAssign%, ExecutePlayPreset
            HotkeyCache[HotKeyAssign] := A_Index
        }
    }
    
}
