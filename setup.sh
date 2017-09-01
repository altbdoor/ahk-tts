#!/bin/bash

CURRENT_DIR=$( cd "$(dirname "${BASH_SOURCE}")" ; pwd -P )
cd "$CURRENT_DIR"

cd cs
[ ! -d NAudio ] && mkdir NAudio
cd NAudio

curl -L -o "package.zip" "https://github.com/naudio/NAudio/releases/download/NAudio_1.8_Release/NAudio-1.8.0-Release.zip"
unzip package.zip
rm package.zip
