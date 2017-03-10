ahk-tts
===

A simple (*but clunky*) interface which converts text to speech with [Microsoft Speech API](https://msdn.microsoft.com/en-us/library/ms723602%28v=vs.85%29.aspx) via [AutoHotkey](https://autohotkey.com/).

This is definitely not the first project to do this. Do check out the other similar (and more complete) AHK projects.

- https://autohotkey.com/board/topic/77686-text-to-speech-examples-for-autohotkey-v11/
- https://autohotkey.com/board/topic/53429-function-easy-text-to-speech/#entry372022


### Usage

![capture](https://cloud.githubusercontent.com/assets/3540471/22048860/bc0dd828-dd6a-11e6-9d23-c4ea4ed486d1.png)

| Item   | Description |
| ------ | --- |
| Output | The output channel for the speech. If you have more than one speakers (or output), it can be a tad useful. |
| Voice  | The voice for the text. The choices available depends on your operating system. |
| Volume | The loudness for the speech. |
| Rate   | The reading speed for the text. |
| Pitch  | The pitch for the speech. |
| Text   | The text to convert into speech, or the path to a `.wav` file. |
| Speak  | The button to start converting the text to speech. Alternatively, you can press `ENTER` on the Text field. |
| Preset 1 - 0 | The button to save the current text into a preset, which can be converted into speech later with a hotkey. |

Here is where it gets *clunky*. To allow dynamic binding of hotkey (that is, allow user to change what keypresses to trigger the presets) is rather complex, and I chose not do it (sorry).

To save the current Text as a preset, click on one of the Preset buttons. To play the preset speech, hold `CTRL` and press the number (`1` to `0`). Example, type in "Hello World", press "Preset 2" button to save it, and press `CTRL + 2` to "speech it out".

The hotkeys are bound globally, so it might interrupt your usual activity. If you find the need to change it, please edit the source and recompile. Look for the `BindPresets` method in `main.ahk`.

It will also create a file called `ahktts_settings.ini`. Here is where it stores the presets.

**New in v1.3!** I found out that the [Microsoft Speech API is capable of playing `.wav` files](https://msdn.microsoft.com/en-us/library/jj127898.aspx#Playback). And can be <strike>ab</strike>used to double as a soundboard. Below are the requirements for the `.wav` file, [as listed by Microsoft](https://msdn.microsoft.com/en-us/library/hh378414.aspx).

> The audio element supports WMA files and .WAV files containing RIFF headers and encoded with the following parameters.
> 
> - **Format**, PCM, a-law, u-law
> - **Bit-depth**, 8 bits, 16 bits
> - **Channels**, Mono only
> - **Sampling Rate**, All sampling rates supported.

So, the Text field now accepts a path to your system's `.wav` files. For convenience, I recommend placing the audio files into a `wav` folder in the same level as the `ahk_tts.exe`, and specify the path as "wav\loud_applause.wav" in Text.


### Why

My friends and I are currently using [Discord](https://discordapp.com/) for voice chat during games. It is rather inconvenient for me to use the mic, so I wanted to use a soundboard or something similar. But I ended up writing this out, and coupled it with a [virtual cable](http://vb-audio.pagesperso-orange.fr/Cable/index.htm). Here's a simplified view of how things work.

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
