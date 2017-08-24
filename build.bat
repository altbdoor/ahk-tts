@echo off

set originalpath=%cd%
cd %~dp0
set basepath=%cd%

set csc_path=C:\Windows\Microsoft.NET\Framework\v4.0.30319\csc.exe
set ahk2exe_path=C:\Program Files\AutoHotkey\Compiler\Ahk2Exe.exe
set szexe_path=C:\Program Files\7-Zip\7z.exe

rem ========================================

echo --------------------
echo Copying NAudio files

cd %basepath%
mkdir build
cd build
mkdir NAudio
copy ..\cs\NAudio\* .\NAudio /Y

echo --------------------
echo Compiling CS exe

cd %basepath%\cs
"%csc_path%" /optimize+ /reference:NAudio/NAudio.dll /target:exe /out:../build/FileWatcher.exe FileWatcher.cs

echo --------------------
echo Compiling AHK exe

cd %basepath%\ahk
set input_name=main.ahk
set output_name=ahk_tts

taskkill /IM %output_name%.exe /T /F

if EXIST %output_name%.exe del /F %output_name%.exe
if EXIST %output_name%.zip del /F %output_name%.zip

"%ahk2exe_path%" /in %input_name% /out ../build/%output_name%.exe
copy settings.ini ..\build /Y

echo --------------------
echo Compressing

cd %basepath%\build

"%szexe_path%" a -mx9 %output_name%.zip *

cd %originalpath%
echo Done!
