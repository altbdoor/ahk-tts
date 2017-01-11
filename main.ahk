#SingleInstance force
#NoTrayIcon

#Include tts.ahk
#Include utility.ahk

SettingsFile := A_ScriptDir . "/ahktts_settings.ini"

GUI:
    Gui, Font, s10, Segoe UI
    
    Gui, Add, Text, w70 h24 x10 y14, Output:
    Gui, Add, DropDownList, w310 x80 y10 vAudioOutput
    Temp := GetComboBoxChoice(GetAudioOutputs(), GetCurrentAudioOutput())
    GuiControl, , AudioOutput, % Temp["Choices"]
    GuiControl, Choose, AudioOutput, % Temp["Index"]
    
    Gui, Add, Text, w70 h24 x10 y44, Voice:
    Gui, Add, DropDownList, w310 x80 y40 vAudioVoice
    Temp := GetComboBoxChoice(GetAudioVoices(), GetCurrentAudioVoice())
    GuiControl, , AudioVoice, % Temp["Choices"]
    GuiControl, Choose, AudioVoice, % Temp["Index"]
    
    Gui, Add, Text, w70 h24 x10 y74, Rate:
    Gui, Add, Slider, w115 h24 x80 y70 vAudioRate Range-10-10 TickInterval2, -2
    
    Gui, Add, Text, w70 h24 x205 y74, Volume:
    Gui, Add, Slider, w115 h24 x275 y70 vAudioVolume Range0-100 TickInterval10, 100
    
    Gui, Add, Text, w70 h24x x10 y104, Text:
    Gui, Add, Edit, Text w310 h24 x80 y100 vAudioText, Hello world
    
    Gui, Add, Button, Default Center w380 h30 x10 y134 gExecuteSubmit, Speak
    
    Gui, Add, Button, Center w76 h30  x10 y180 gExecuteSavePreset, Preset 1
    Gui, Add, Button, Center w76 h30  x86 y180 gExecuteSavePreset, Preset 2
    Gui, Add, Button, Center w76 h30 x162 y180 gExecuteSavePreset, Preset 3
    Gui, Add, Button, Center w76 h30 x238 y180 gExecuteSavePreset, Preset 4
    Gui, Add, Button, Center w76 h30 x314 y180 gExecuteSavePreset, Preset 5
    
    Gui, Add, Button, Center w76 h30  x10 y210 gExecuteSavePreset, Preset 6
    Gui, Add, Button, Center w76 h30  x86 y210 gExecuteSavePreset, Preset 7
    Gui, Add, Button, Center w76 h30 x162 y210 gExecuteSavePreset, Preset 8
    Gui, Add, Button, Center w76 h30 x238 y210 gExecuteSavePreset, Preset 9
    Gui, Add, Button, Center w76 h30 x314 y210 gExecuteSavePreset, Preset 10
    
    Gui, Add, StatusBar, , Ready
    
    Temp := ""
    Gui, Show, Center w400, AHK Text to Speech
    
    BindPresets()
    
    OnMessage(0x200, "WindowMouseMove")
Return

; ========================================

ExecuteSubmit:
    Gui, Submit, NoHide
    
    SetCurrentAudioOutput(AudioOutput)
    SetCurrentAudioVoice(AudioVoice)
    SetCurrentAudioRate(AudioRate)
    SetCurrentAudioVolume(AudioVolume)
    
    If (WinActive("AHK Text to Speech")) {
        GuiControl, Focus, AudioText
        Send, ^a
    }
    
    TTSSpeak(AudioText)
Return


ExecuteSavePreset:
    Gui, Submit, NoHide
    
    CurrentPreset := A_GuiControl
    CurrentPresetIndex := StrReplace(CurrentPreset, "Preset ", "")
    
    WriteSettings(CurrentPresetIndex, AudioText)
Return


ExecutePlayPreset:
    CurrentPreset := A_ThisHotkey
    CurrentPresetIndex := RegExReplace(CurrentPreset, "[^\d]", "")
    
    PresetAudioText := ReadSettings(CurrentPresetIndex, "")
    
    If (PresetAudioText != "") {
        GuiControl, , AudioText, % PresetAudioText
        GoSub, ExecuteSubmit
    }
Return


WindowMouseMove(wparam, lparam, msg, hwnd) {
    If (A_GuiControl) {
        If (RegExMatch(A_GuiControl, "^Preset \d$")) {
            CurrentPreset := A_GuiControl
            CurrentPresetIndex := StrReplace(CurrentPreset, "Preset ", "")
            
            PresetAudioText := ReadSettings(CurrentPresetIndex, "")
            
            If (PresetAudioText == "") {
                PresetAudioText := "[No text assigned]"
            }
            
            SB_SetText(A_GuiControl . ": " . PresetAudioText)
        }
    }
}


BindPresets() {
    Loop, 10 {
        ReIndex := Mod(A_Index, 10)
        HotKeyAssign := "Ctrl & " . ReIndex
        Hotkey, %HotKeyAssign%, ExecutePlayPreset
    }
}


GuiClose:
    ExitApp
Return
