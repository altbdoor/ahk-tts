ahk-tts
===

A simple, but clunky interface which converts text to speech or plays `.wav` sound files with [Microsoft Speech API](https://msdn.microsoft.com/en-us/library/ms723602%28v=vs.85%29.aspx) via [AutoHotkey](https://autohotkey.com/).

This is definitely not the first project to do this. Do check out the other similar (and more complete) AHK projects.

- https://autohotkey.com/board/topic/77686-text-to-speech-examples-for-autohotkey-v11/
- https://autohotkey.com/board/topic/53429-function-easy-text-to-speech/#entry372022


### Usage

![capture](https://cloud.githubusercontent.com/assets/3540471/22048860/bc0dd828-dd6a-11e6-9d23-c4ea4ed486d1.png)

| Item   | Description |
| ------ | --- |
| Output | The output channel for the speech. If you have more than one speaker (or output), it can be a tad useful. |
| Voice  | The voice for the text. The choices available depends on your operating system. |
| Volume | The loudness for the speech. It does not affect `.wav` files. |
| Rate   | The reading speed for the text. It does not affect `.wav` files. |
| Pitch  | The pitch for the speech. It does not affect `.wav` files. |
| Text   | The text to convert into speech, or the path to `.wav` file. |
| Speak  | The button to convert the text to speech, or play the `.wav` file. Alternatively, you can press `ENTER` on the Text field. |
| Preset 1 - 0 | The button to save the current text, or path to `.wav` file into a preset, which can be called later with a hotkey. |


### Limitations

- To allow dynamic binding of hotkey (that is, allow user to change what keypresses to trigger the presets) is rather complex, and I chose not do it (sorry).

- The hotkeys are bound globally, so it might interrupt your usual activity. If you find the need to change it, please edit the source and recompile. Look for the `BindPresets` method in `main.ahk`.

- Microsoft Speech API is capable of [playing only `.wav` files](https://msdn.microsoft.com/en-us/library/jj127898.aspx#Playback). Below are the requirements for the `.wav` file, [as listed by Microsoft](https://msdn.microsoft.com/en-us/library/hh378414.aspx).
  
  > The audio element supports WMA files and .WAV files containing RIFF headers and encoded with the following parameters.
  > 
  > - **Format**, PCM, a-law, u-law
  > - **Bit-depth**, 8 bits, 16 bits
  > - **Channels**, Mono only
  > - **Sampling Rate**, All sampling rates supported.
  
  If you use [ffmpeg](https://ffmpeg.org/), [here's a snippet](http://stackoverflow.com/questions/13358287/how-to-convert-any-mp3-file-to-wav-16khz-mono-16bit) to convert MP3 to WAV with volume adjustment.
  
  `ffmpeg -i "input.mp3" -acodec pcm_s16le -ac 1 -ar 16000 -af "volume=0.4" "output.wav"`


### Why

My friends and I were using [Discord](https://discordapp.com/) for voice chat while playing games. It is inconvenient for me to use the mic, so I wanted to use a soundboard or something similar. I ended up writing this out, and coupled it with a [virtual cable](http://vb-audio.pagesperso-orange.fr/Cable/index.htm). Here's a simplified view of how things work.

```
[ ahk-tts ]         // here is where you type the text, then it sends the text
  |                 // to MS Speech API
  v
[ MS Speech API ]   // which will convert it into speech audio, and directed
  |                 // into the virtual speaker (Output), as set in ahk-tts
  v
[ CABLE Input ]     // the virtual speaker will just pass the audio into the
  |                 // virtual mic
  v
[ CABLE Output ]    // and the speech audio is now being broadcasted in this
  |                 // virtual mic
  v
[ Browser ]         // which can be picked up by the browser!
```

Additionally, you can "listen" to your speech audio by changing a setting in the virtual mic. Just "listen" your virtual mic via the default speakers, and voila.
