#NoEnv
SendMode Input
SetWorkingDir %A_ScriptDir%

#SingleInstance force
#NoTrayIcon

#KeyHistory 0
ListLines Off

#Include tts.ahk
#Include utility.ahk

AppVersion := 1.5
AppTitle := "AHK Text to Speech v" . AppVersion
SettingsFile := A_ScriptDir . "/settings.ini"
AudioTextHistory := []
TTSInstance := new TTS()

GUI:
    Gui, Font, s10, Segoe UI
    
    Gui, Add, Text, w70 h24 x10 y14, Output:
    Gui, Add, DropDownList, w310 x80 y10 vAudioOutput
    Temp := GetComboBoxChoice(TTSInstance.GetAudioOutputs(), TTSInstance.GetCurrentAudioOutput())
    GuiControl, , AudioOutput, % Temp["Choices"]
    GuiControl, Choose, AudioOutput, % Temp["Index"]
    
    Gui, Add, Text, w70 h24 x10 y44, Voice:
    Gui, Add, DropDownList, w310 x80 y40 vAudioVoice
    Temp := GetComboBoxChoice(TTSInstance.GetAudioVoices(), TTSInstance.GetCurrentAudioVoice())
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
    Gui, Add, Button, Center w76 h30 x314 y240 gExecuteSavePreset, Preset 0
    
    Gui, Add, StatusBar, , Ready
    
    Temp := ""
    Gui, Show, Center w400, % AppTitle
    
    GuiControl, Focus, AudioText
    BindHotkeys()
    
    OnMessage(0x200, "WindowMouseMove")
Return

; ========================================

ExecuteSubmit:
    Gui, Submit, NoHide
    
    If (AudioText != "") {
        TTSInstance.SetCurrentAudioOutput(AudioOutput)
        TTSInstance.SetCurrentAudioVoice(AudioVoice)
        ; TTSInstance.SetCurrentAudioRate(AudioRate)
        ; TTSInstance.SetCurrentAudioVolume(AudioVolume)
        
        TTSInstance.Speak(AudioText, AudioRate, AudioVolume, AudioPitch)
        
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
    WriteSettings("presetAudio", "Rate" . CurrentPresetIndex, AudioRate)
    WriteSettings("presetAudio", "Volume" . CurrentPresetIndex, AudioVolume)
    WriteSettings("presetAudio", "Pitch" . CurrentPresetIndex, AudioPitch)
    WriteSettings("presetAudio", "Text" . CurrentPresetIndex, AudioText)
    WindowMouseMove()
Return


ExecutePlayPreset:
    CurrentPresetIndex := GetPresetIntegerFromHotkey(A_ThisHotkey)
    PresetAudioText := ReadSettings("presetAudio", "Text" . CurrentPresetIndex, "")
    
    If (CurrentPresetIndex != -1 && PresetAudioText != "") {
        PresetAudioRate := ReadSettings("presetAudio", "Rate" . CurrentPresetIndex, -2)
        PresetAudioVolume := ReadSettings("presetAudio", "Volume" . CurrentPresetIndex, 100)
        PresetAudioPitch := ReadSettings("presetAudio", "Pitch" . CurrentPresetIndex, 0)
        
        Gui, Submit, NoHide
        
        TTSInstance.SetCurrentAudioOutput(AudioOutput)
        TTSInstance.SetCurrentAudioVoice(AudioVoice)
        ; TTSInstance.SetCurrentAudioRate(PresetAudioRate)
        ; TTSInstance.SetCurrentAudioVolume(PresetAudioVolume)
        
        TTSInstance.Speak(PresetAudioText, PresetAudioRate, PresetAudioVolume, PresetAudioPitch)
    }
Return


; WindowMouseMove(wparam, lparam, msg, hwnd)
WindowMouseMove() {
    If (A_GuiControl && RegExMatch(A_GuiControl, "^Preset \d+$")) {
        CurrentPresetIndex := GetPresetIntegerFromText(A_GuiControl)
        PresetAudioText := ReadSettings("presetAudio", "Text" . CurrentPresetIndex, "")
        
        If (PresetAudioText == "") {
            PresetAudioText := "[No text assigned]"
        }
        
        SB_SetText(A_GuiControl . ": " . PresetAudioText)
    }
}


BindHotkeys() {
    Loop, 10 {
        ReIndex := Mod(A_Index, 10)
        HotkeyAssign := ReadSettings("presetHotkey", "Hotkey" . ReIndex, "")
        
        If (HotkeyAssign != "") {
            Hotkey, %HotKeyAssign%, ExecutePlayPreset
        }
    }
    
}


#If WinActive(AppTitle)
^BS:: Send, ^+{left}{delete}
#If


GuiClose:
    ExitApp
Return
