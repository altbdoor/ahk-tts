; https://autohotkey.com/board/topic/77686-text-to-speech-examples-for-autohotkey-v11/
; https://autohotkey.com/board/topic/53429-function-easy-text-to-speech/#entry372022
; https://msdn.microsoft.com/en-us/library/ms723602%28v=vs.85%29.aspx
; https://msdn.microsoft.com/en-us/library/ms717077%28v=vs.85%29.aspx
; https://msdn.microsoft.com/en-us/library/jj127898.aspx

class TTS {
    static Instance := ComObjCreate("SAPI.SpVoice")
    
    GetAudioOutputs() {
        AudioOutputList := []
        Loop % this.Instance.GetAudioOutputs.Count {
            Description := this.Instance.GetAudioOutputs.Item(A_Index - 1).GetDescription
            AudioOutputList.Push(Description)
        }
        
        Return AudioOutputList
    }
    
    GetCurrentAudioOutput() {
        Return this.Instance.AudioOutput.GetDescription
    }
    
    SetCurrentAudioOutput(AudioOutputDescription) {
        If (this.GetCurrentAudioOutput() != AudioOutputDescription) {
            Loop % this.Instance.GetAudioOutputs.Count {
                AudioOutputObject := this.Instance.GetAudioOutputs.Item(A_Index - 1)
                Description := AudioOutputObject.GetDescription
                If (Description == AudioOutputDescription) {
                    this.Instance.AudioOutput := AudioOutputObject
                    Break
                }
            }
        }
        
    }
    
    GetAudioVoices() {
        AudioVoiceList := []
        Loop % this.Instance.GetVoices.Count {
            Description := this.Instance.GetVoices.Item(A_Index - 1).GetDescription
            AudioVoiceList.Push(Description)
        }
        
        Return AudioVoiceList
    }
    
    GetCurrentAudioVoice() {
        Return this.Instance.Voice.GetDescription
    }
    
    SetCurrentAudioVoice(AudioVoiceDescription) {
        If (this.GetCurrentAudioVoice() != AudioVoiceDescription) {
            Loop % this.Instance.GetVoices.Count {
                VoiceObject := this.Instance.GetVoices.Item(A_Index - 1)
                Description := VoiceObject.GetDescription
                If (Description == AudioVoiceDescription) {
                    this.Instance.Voice := VoiceObject
                    Break
                }
            }
        }
        
    }
    
    ; SetCurrentAudioRate(AudioRate) {
    ;     this.Instance.Rate := AudioRate
    ; }
    
    ; SetCurrentAudioVolume(AudioVolume) {
    ;     this.Instance.Volume := AudioVolume
    ; }
    
    PrepareSpeechText(TextContent, AudioRate, AudioVolume, AudioPitch) {
        Return "<rate absspeed='" . AudioRate . "'/>"
            . "<volume level='" . AudioVolume . "'/>"
            . "<pitch absmiddle='" . AudioPitch . "'/>"
            . TextContent
    }
    
    PrepareAudioText(TextContent) {
        Return "<?xml version='1.0' encoding='ISO-8859-1'?>"
            . "<speak version='1.0' xmlns='http://www.w3.org/2001/10/synthesis' xml:lang='en-US'>"
            . "<audio src='" . TextContent . "'></audio>"
            . "</speak>"
    }
    
    Speak(TextContent, AudioRate, AudioVolume, AudioPitch) {
        this.Instance.Speak("", 0x1|0x2)
        
        If (FileExist(TextContent) && RegExMatch(TextContent, "i)\.wav$")) {
            TextContent := this.PrepareAudioText(TextContent)
        }
        Else {
            TextContent := this.PrepareSpeechText(TextContent, AudioRate, AudioVolume, AudioPitch)
        }
        
        Try {
            this.Instance.Speak(TextContent, 0x1|0x2)
        }
        Catch {
            this.Instance.Speak("error parsing text", 0x1|0x2)
        }
        
    }
    
    SpeakToFile(TextContent, AudioRate, AudioVolume, AudioPitch, OutputFile) {
        OriginalOutputStream := this.Instance.AudioOutputStream
        OriginalOutputFormat := this.Instance.AllowAudioOutputFormatChangesOnNextSet
        this.Instance.AllowAudioOutputFormatChangesOnNextSet := 1
        
        SpStream := ComObjCreate("SAPI.SpFileStream")
        SpStream.Open(OutputFile, 3)
        this.Instance.AudioOutputStream := SpStream
        TextContent := this.PrepareSpeechText(TextContent, AudioRate, AudioVolume, AudioPitch)
        this.Instance.Speak(TextContent, 0x0)
        SpStream.Close()
        
        this.Instance.AudioOutputStream := OriginalOutputStream
        this.Instance.AllowAudioOutputFormatChangesOnNextSet := OriginalOutputFormat
    }
    
}
