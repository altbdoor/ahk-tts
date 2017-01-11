ahk-tts
===

A simple (*but clunky*) interface which converts text to speech with [Microsoft Speech API](https://msdn.microsoft.com/en-us/library/ms723602%28v=vs.85%29.aspx) via [AutoHotkey](https://autohotkey.com/).

This is definitely not the first project to do this. Do check out the other similar (and more complete) AHK projects.

- https://autohotkey.com/board/topic/77686-text-to-speech-examples-for-autohotkey-v11/
- https://autohotkey.com/board/topic/53429-function-easy-text-to-speech/#entry372022


### Usage

![capture](https://cloud.githubusercontent.com/assets/3540471/21844175/9ec3e452-d828-11e6-89be-690d06ae64b0.png)

| Item   | Description |
| ------ | --- |
| Output | The output channel for the speech. If you have more than one speakers (or output), it can be a tad useful. |
| Voice  | The voice for the text. The choices available depends on your operating system. |
| Rate   | The reading speed for the text. |
| Volume | The loudness for the speech. |
| Text   | The text to convert into speech. |
| Speak  | The button to start converting the text to speech. Alternatively, you can press `ENTER` on the Text field. |
| Preset 1 - 10 | The button to save the current text into a preset, which can be converted into speech later with a hotkey. |

Here is where it gets *clunky*. To allow dynamic binding of hotkey (that is, allow user to change what keypresses to trigger the presets) is rather complex, and I chose to not do it.

To bring up the respective presets, you hold `CTRL` and press the numbers `1` to `0`. The hotkeys are bound globally, so it might interrupt one or more of your stuff. If you find the need to change it, please edit the source and recompile.

It will also create a file called `ahktts_settings.ini`. Here is where it stores the presets.


### Why

My friends and I are currently using [Discord](https://discordapp.com/) for voice chat during games. It is rather inconvenient for me to use the mic, so I wanted to use a soundboard or something similar. But I ended up writing this out with a [virtual cable](http://vb-audio.pagesperso-orange.fr/Cable/index.htm). Here's a simplified view of how things work.

```
[ ahk-tts ]         // here is where you type the text, then it sends it to
  |                 // MS Speech API
  v
[ MS Speech API ]   // which will convert it into speech audio, and directed
  |                 // into the virtual speaker, as set in ahk-tts
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
