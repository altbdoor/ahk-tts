#NoEnv
#NoTrayIcon
#KeyHistory 0
#SingleInstance force

SetWorkingDir, %A_ScriptDir%
ListLines, Off

#Include tts.ahk
#Include utility.ahk

AppVersion := 1.7
AppTitle := "AHK Text to Speech v" . AppVersion

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
    
    PresetWidth := 38
    PresetHeight := 24
    PresetDimension := "w" . PresetWidth . " h" . PresetHeight
    
    TopFactor := 204
    
    Loop, 20 {
        PresetName := "P" . A_Index
        ZeroIndex := A_Index - 1
        
        Factor := Mod(ZeroIndex, 10)
        LeftFactor := 10 + (Factor * PresetWidth)
        
        If (ZeroIndex > 0 && Factor == 0) {
            TopFactor += PresetHeight
        }
        
        Gui, Add, Button, Center %PresetDimension% x%LeftFactor% y%TopFactor% gExecuteSavePreset, %PresetName%
    }
    
    Gui, Add, StatusBar, , Ready
    
    Temp := ""
    Gui, Show, Center w400, %AppTitle%
    
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
        
        TTSInstance.Speak(PrepareMP3ToWav(AudioText)
            , AudioRate
            , AudioVolume
            , AudioPitch
            , GetFastInterruptablePath())
        
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
        
        TTSInstance.Speak(PrepareMP3ToWav(PresetAudioText)
            , PresetAudioRate
            , PresetAudioVolume
            , PresetAudioPitch
            , GetFastInterruptablePath())
    }
Return


; WindowMouseMove(wparam, lparam, msg, hwnd)
WindowMouseMove() {
    If (A_GuiControl && RegExMatch(A_GuiControl, "^P\d+$")) {
        CurrentPresetIndex := GetPresetIntegerFromText(A_GuiControl)
        PresetAudioText := ReadSettings("presetAudio", "Text" . CurrentPresetIndex, "")
        
        If (PresetAudioText == "") {
            PresetAudioText := "[No text assigned]"
        }
        
        PresetText := StrReplace(A_GuiControl, "P", "Preset ")
        SB_SetText(PresetText . ": " . PresetAudioText)
    }
}


#If WinActive(AppTitle)
^BS:: Send, ^+{left}{delete}
#If


GuiClose:
    ExitApp
Return
