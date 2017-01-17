#SingleInstance force
#NoTrayIcon

#Include tts.ahk
#Include utility.ahk

SettingsFile := A_ScriptDir . "/ahktts_settings.ini"
AudioTextHistory := []

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
    
    Gui, Add, Text, w70 h24 x10 y74, Volume:
    Gui, Add, Slider, w310 h24 x80 y70 vAudioVolume Range0-100 TickInterval10, 100
    
    Gui, Add, Text, w70 h24 x10 y104, Rate:
    Gui, Add, Slider, w115 h24 x80 y100 vAudioRate Range-10-10 TickInterval2, -2
    
    Gui, Add, Text, w70 h24 x205 y104, Pitch:
    Gui, Add, Slider, w115 h24 x275 y100 vAudioPitch Range-10-10 TickInterval2, 0
    
    Gui, Add, Text, w70 h24 x10 y134, Text:
    Gui, Add, ComboBox, w310 h24 x80 y130 r5 vAudioText, Hello world
    GuiControl, Choose, AudioText, 1
    
    Gui, Add, Button, Default Center w380 h30 x10 y164 gExecuteSubmit, Speak
    
    Gui, Add, Button, Center w76 h30  x10 y210 gExecuteSavePreset, Preset 1
    Gui, Add, Button, Center w76 h30  x86 y210 gExecuteSavePreset, Preset 2
    Gui, Add, Button, Center w76 h30 x162 y210 gExecuteSavePreset, Preset 3
    Gui, Add, Button, Center w76 h30 x238 y210 gExecuteSavePreset, Preset 4
    Gui, Add, Button, Center w76 h30 x314 y210 gExecuteSavePreset, Preset 5
    
    Gui, Add, Button, Center w76 h30  x10 y240 gExecuteSavePreset, Preset 6
    Gui, Add, Button, Center w76 h30  x86 y240 gExecuteSavePreset, Preset 7
    Gui, Add, Button, Center w76 h30 x162 y240 gExecuteSavePreset, Preset 8
    Gui, Add, Button, Center w76 h30 x238 y240 gExecuteSavePreset, Preset 9
    Gui, Add, Button, Center w76 h30 x314 y240 gExecuteSavePreset, Preset 10
    
    Gui, Add, StatusBar, , Ready
    
    Temp := ""
    Gui, Show, Center w400, AHK Text to Speech
    
    GuiControl, Focus, AudioText
    BindPresets()
    
    OnMessage(0x200, "WindowMouseMove")
Return

; ========================================

ExecuteSubmit:
    Gui, Submit, NoHide
    
    If (AudioText != "") {
        SetCurrentAudioOutput(AudioOutput)
        SetCurrentAudioVoice(AudioVoice)
        SetCurrentAudioRate(AudioRate)
        SetCurrentAudioVolume(AudioVolume)
        
        TTSSpeak(AudioText, AudioPitch)
        
        If (AudioText != AudioTextHistory[1]) {
            AudioTextHistory.InsertAt(1, AudioText)
            
            AudioTextHistoryLength := AudioTextHistory.Length() - 20
            Loop, %AudioTextHistoryLength% {
                AudioTextHistory.Pop()
            }
            
            TempAudioTextList := JoinArray(AudioTextHistory, "|")
            GuiControl, , AudioText, % "|" . TempAudioTextList
        }
        
        GuiControl, Focus, AudioText
        Send, ^a
    }
Return


ExecuteSavePreset:
    Gui, Submit, NoHide
    
    CurrentPresetIndex := GetPresetIntegerFromText(A_GuiControl)
    WriteSettings("Rate" . CurrentPresetIndex, AudioRate)
    WriteSettings("Volume" . CurrentPresetIndex, AudioVolume)
    WriteSettings("Pitch" . CurrentPresetIndex, AudioPitch)
    WriteSettings("Text" . CurrentPresetIndex, AudioText)
Return


ExecutePlayPreset:
    CurrentPresetIndex := GetPresetIntegerFromText(A_ThisHotkey)
    PresetAudioText := ReadSettings("Text" . CurrentPresetIndex, "")
    
    If (PresetAudioText != "") {
        PresetAudioRate := ReadSettings("Rate" . CurrentPresetIndex, -2)
        PresetAudioVolume := ReadSettings("Volume" . CurrentPresetIndex, 100)
        PresetAudioPitch := ReadSettings("Pitch" . CurrentPresetIndex, 0)
        
        Gui, Submit, NoHide
        
        SetCurrentAudioOutput(AudioOutput)
        SetCurrentAudioVoice(AudioVoice)
        
        SetCurrentAudioRate(PresetAudioRate)
        SetCurrentAudioVolume(PresetAudioVolume)
        
        TTSSpeak(PresetAudioText, PresetAudioPitch)
    }
Return


WindowMouseMove(wparam, lparam, msg, hwnd) {
    If (A_GuiControl && RegExMatch(A_GuiControl, "^Preset \d+$")) {
        CurrentPresetIndex := GetPresetIntegerFromText(A_GuiControl)
        PresetAudioText := ReadSettings("Text" . CurrentPresetIndex, "")
        
        If (PresetAudioText == "") {
            PresetAudioText := "[No text assigned]"
        }
        
        SB_SetText(A_GuiControl . ": " . PresetAudioText)
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
