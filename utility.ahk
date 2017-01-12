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

WriteSettings(Key, Value) {
    global SettingsFile
    IniWrite, %Value%, %SettingsFile%, preset, %Key%
    Return
}

ReadSettings(Key, DefaultValue) {
    global SettingsFile
    
    If (DefaultValue == "") {
        IniRead, Value, %SettingsFile%, preset, %Key%, %A_Space%
    }
    Else {
        IniRead, Value, %SettingsFile%, preset, %Key%, %DefaultValue%
    }
    
    Return Value
}

GetPresetIntegerFromText(PresetText) {
    PresetIndex := RegExReplace(PresetText, "[^\d]", "")
    PresetIndex := Mod(PresetIndex, 10)
    
    Return PresetIndex
}
