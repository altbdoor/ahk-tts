ahk-tts
===

A simple, but clunky [AutoHotkey](https://autohotkey.com/) application which:

- converts text to speech via [Microsoft Speech API](https://msdn.microsoft.com/en-us/library/ms723602%28v=vs.85%29.aspx)
- plays MP3/WAV sound files via [NAudio](https://github.com/naudio/NAudio)

This is definitely not the first project to do this. Do check out the other similar (and more complete) AHK projects.

- https://autohotkey.com/board/topic/77686-text-to-speech-examples-for-autohotkey-v11/
- https://autohotkey.com/board/topic/53429-function-easy-text-to-speech/#entry372022


### Usage

![capture](https://user-images.githubusercontent.com/3540471/29443871-9ccf3bec-840d-11e7-961e-bfe94ed3516a.png)


#### GUI settings

| Item   | Description |
| ------ | --- |
| Output | The output channel for the speech. If you have more than one speaker (or output), it can be a tad useful. |
| Voice  | The voice for the text. The choices available depends on your operating system. |
| Volume | The loudness for the speech. |
| Rate   | The reading speed for the text. It does not affect audio files. |
| Pitch  | The pitch for the speech. It does not affect audio files. |
| Text   | The text to convert into speech, or the path to audio file. |
| Speak  | The button to convert the text to speech, or play the audio file. Alternatively, you can press `ENTER` on the Text field. |
| Preset 1 - 20 | The button to save the current text, or path to audio file into a preset, which can be called later with a hotkey. |


#### Advanced settings

There are more advanced configurations in the `settings.ini` file. The application needs to be restarted in order to take in the setting changes here.

- **CacheDir** (default: _cache) <br>
    A relative or absolute path to a directory, which will be used for caching purposes. This directory will be used heavily in generating text to speech WAV files.

- **Hotkey1** to **Hotkey20** <br>
    Only `Hotkey1` to `Hotkey10` are configured, with `Ctrl` + `1` to `Ctrl` + `0` respectively. These are the hotkey combinations which will trigger a playback of Preset 1 to 20. The hotkey combination needs to follow [AHK's keylist](https://autohotkey.com/docs/KeyList.htm). As an example, `Ctrl` and `1` is defined by `Ctrl & 1`.


### Limitations

- To allow users to change hotkeys dynamically via GUI is rather complex. The hotkeys are editable in `settings.ini`, albeit a little troublesome.

- The hotkeys are bound globally, so it might interrupt usual activity on computer. Please edit the hotkeys in `settings.ini` as deemed fit.


### Downloads

[See Releases](//github.com/altbdoor/ahk-tts/releases)


### Why

My friends and I were using [Discord](https://discordapp.com/) for voice chat while playing games. It is inconvenient for me to use the mic, so I wanted to use a soundboard or something similar. I ended up writing this out, and coupled it with a [virtual cable](http://vb-audio.pagesperso-orange.fr/Cable/index.htm). Here's a simplified view of how things work.

```
[ ahk-tts ]         // here is where you type the text, then it sends the text
  |                 // to MS Speech API to be converted to audio
  v
[ NAudio ]          // which will direct the sound into the virtual speaker
  |                 // (Output), as set in ahk-tts
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
