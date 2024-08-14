#!/bin/bash

URL="https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp"

mkdir -p "${HOME}/.local/bin/"

curl -L "$URL" -o "${HOME}/.local/bin/yt-dlp"

chmod a+rx "${HOME}/.local/bin/yt-dlp"

echo "To update, run 'yt-dlp -U'."
