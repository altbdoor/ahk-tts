HotkeyCache := {}

GetSettingsFilePath() {
    Return A_ScriptDir . "/settings.ini"
}

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

WriteSettings(Section, Key, Value) {
    SettingsFile := GetSettingsFilePath()
    IniWrite, %Value%, %SettingsFile%, %Section%, %Key%
    Return
}

ReadSettings(Section, Key, DefaultValue) {
    SettingsFile := GetSettingsFilePath()
    
    If (DefaultValue == "") {
        IniRead, Value, %SettingsFile%, %Section%, %Key%, %A_Space%
    }
    Else {
        IniRead, Value, %SettingsFile%, %Section%, %Key%, %DefaultValue%
    }
    
    Return Value
}

GetPresetIntegerFromText(PresetText) {
    PresetIndex := RegExReplace(PresetText, "[^\d]", "")
    
    Return PresetIndex
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

PrepareMP3ToWav(MP3Path) {
    MP3ConverterArgs := ReadSettings("presetMP3", "MP3ConverterArgs", "")
    WavTempPath := A_Temp . "/ahktts_wav_temp"
    
    If (MP3ConverterArgs != "" && FileExist(MP3Path) && RegExMatch(MP3Path, "i)\.mp3$")) {
        FileCreateDir, %WavTempPath%
        MP3Hash := FileMD5(MP3Path)
        WavPath := WavTempPath . "/" . MP3Hash . ".wav"
        
        If (FileExist(WavPath)) {
            MP3Path := WavPath
        }
        Else {
            MP3ConverterArgs := StrReplace(MP3ConverterArgs, "{$inFile}", MP3Path)
            MP3ConverterArgs := StrReplace(MP3ConverterArgs, "{$outFile}", WavPath)
            
            Try {
                RunWait, %MP3ConverterArgs%, , Hide
                MP3Path := WavPath
            }
            Catch {
                MP3Path := "error parsing " . MP3Path
            }
        }
        
    }
    
    Return MP3Path
}

FileMD5( sFile="", cSz=4 ) {  ; by SKAN www.autohotkey.com/community/viewtopic.php?t=64211
 cSz := (cSz<0||cSz>8) ? 2**22 : 2**(18+cSz), VarSetCapacity( Buffer,cSz,0 ) ; 18-Jun-2009
 hFil := DllCall( "CreateFile", Str,sFile,UInt,0x80000000, Int,3,Int,0,Int,3,Int,0,Int,0 )
 IfLess,hFil,1, Return,hFil
 hMod := DllCall( "LoadLibrary", Str,"advapi32.dll" )
 DllCall( "GetFileSizeEx", UInt,hFil, UInt,&Buffer ),    fSz := NumGet( Buffer,0,"Int64" )
 VarSetCapacity( MD5_CTX,104,0 ),    DllCall( "advapi32\MD5Init", UInt,&MD5_CTX )
 Loop % ( fSz//cSz + !!Mod( fSz,cSz ) )
   DllCall( "ReadFile", UInt,hFil, UInt,&Buffer, UInt,cSz, UIntP,bytesRead, UInt,0 )
 , DllCall( "advapi32\MD5Update", UInt,&MD5_CTX, UInt,&Buffer, UInt,bytesRead )
 DllCall( "advapi32\MD5Final", UInt,&MD5_CTX )
 DllCall( "CloseHandle", UInt,hFil )
 Loop % StrLen( Hex:="123456789ABCDEF0" )
  N := NumGet( MD5_CTX,87+A_Index,"Char"), MD5 .= SubStr(Hex,N>>4,1) . SubStr(Hex,N&15,1)
Return MD5, DllCall( "FreeLibrary", UInt,hMod )
}
