@echo off

set originalpath=%cd%
cd %~dp0
set basepath=%cd%

set szexe_path=C:\Program Files\7-Zip\7z.exe

rem ========================================

mkdir NAudio
cd NAudio

powershell -Command "(New-Object Net.WebClient).DownloadFile('https://github.com/naudio/NAudio/releases/download/NAudio_1.8_Release/NAudio-1.8.0-Release.zip', 'package.zip')"

"%szexe_path%" x package.zip
del package.zip

cd %originalpath%
echo Done!
