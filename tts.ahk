; https://autohotkey.com/board/topic/77686-text-to-speech-examples-for-autohotkey-v11/
; https://autohotkey.com/board/topic/53429-function-easy-text-to-speech/#entry372022
; https://msdn.microsoft.com/en-us/library/ms723602%28v=vs.85%29.aspx

VoiceInstance := ComObjCreate("SAPI.SpVoice")

GetAudioOutputs() {
    global VoiceInstance
    
    AudioOutputList := []
    Loop % VoiceInstance.GetAudioOutputs.Count {
        Description := VoiceInstance.GetAudioOutputs.Item(A_Index - 1).GetDescription
        AudioOutputList.Push(Description)
    }
    
    Return AudioOutputList
}

GetCurrentAudioOutput() {
    global VoiceInstance
    Return VoiceInstance.AudioOutput.GetDescription
}

SetCurrentAudioOutput(AudioOutputDescription) {
    global VoiceInstance
    
    Loop % VoiceInstance.GetAudioOutputs.Count {
        AudioOutputObject := VoiceInstance.GetAudioOutputs.Item(A_Index - 1)
        Description := AudioOutputObject.GetDescription
        If (Description == AudioOutputDescription) {
            VoiceInstance.AudioOutput := AudioOutputObject
            Break
        }
    }
}

GetAudioVoices() {
    global VoiceInstance
    
    AudioVoiceList := []
    Loop % VoiceInstance.GetVoices.Count {
        Description := VoiceInstance.GetVoices.Item(A_Index - 1).GetDescription
        AudioVoiceList.Push(Description)
    }
    
    Return AudioVoiceList
}

GetCurrentAudioVoice() {
    global VoiceInstance
    Return VoiceInstance.Voice.GetDescription
}

SetCurrentAudioVoice(AudioVoiceDescription) {
    global VoiceInstance
    
    Loop % VoiceInstance.GetVoices.Count {
        VoiceObject := VoiceInstance.GetVoices.Item(A_Index - 1)
        Description := VoiceObject.GetDescription
        If (Description == AudioVoiceDescription) {
            VoiceInstance.Voice := VoiceObject
            Break
        }
    }
}

SetCurrentAudioRate(AudioRate) {
    global VoiceInstance
    VoiceInstance.Rate := AudioRate
}

SetCurrentAudioVolume(AudioVolume) {
    global VoiceInstance
    VoiceInstance.Volume := AudioVolume
}

TTSSpeak(TextContent, AudioPitch) {
    global VoiceInstance
    VoiceInstance.Speak("<pitch absmiddle='" . AudioPitch . "'/>" . TextContent, 0x1|0x2)
}
