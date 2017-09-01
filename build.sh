#!/bin/bash

CURRENT_DIR=$( cd "$(dirname "${BASH_SOURCE}")" ; pwd -P )
cd "$CURRENT_DIR"

csc_path="/c/Windows/Microsoft.NET/Framework/v4.0.30319/csc.exe"
ahk_path="/c/Program Files/AutoHotkey/Compiler/Ahk2Exe.exe"
svz_path="/c/Program Files/7-Zip/7z.exe"

echo "> Copying NAudio files"
rm -rf build/
mkdir build
cp -r cs/NAudio/ build

echo "> Compiling CS exe"
cd cs
"${csc_path}" //optimize+ /reference:NAudio/NAudio.dll /target:exe /out:../build/AHKTTSWatcher.exe AHKTTSWatcher.cs

echo "> Compiling AHK exe"
cd ../ahk

[ -f "ahk_tts.zip" ] && rm "ahk_tts.zip"
[ -f "AHKTTS.exe" ] && rm "AHKTTS.exe"

"${ahk_path}" //in "main.ahk" //out "../build/AHKTTS.exe"
cp settings.ini ../build

echo "> Compressing"
cd ../build
"${svz_path}" a -mx9 "ahk_tts.zip" *

echo "> Done"
