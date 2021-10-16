#!/bin/sh

set -e

compile() {
  pandoc -t revealjs -s slides.md \
    -V theme=night \
    -V revealjs-url=./reveal.js \
    --css slides.css \
    --highlight-style zenburn \
    -o slides.html
}

while compile; do
  inotifywait -e close_write slides.md slides.css
done
