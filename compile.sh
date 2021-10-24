#!/bin/sh

set -e

PANDOC_VERSION=2.14

pandoc() {
  docker run --rm \
    --volume "`pwd`:/data" \
    --user `id -u`:`id -g` \
    "pandoc/core:$PANDOC_VERSION" "$@"
}

compile() {
  pandoc -t revealjs -s slides.md \
    -f markdown-markdown_in_html_blocks-native_divs \
    --template=custom.revealjs \
    -V theme=night \
    -V revealjs-url=./reveal.js \
    --css slides.css \
    --highlight-style zenburn \
    -o index.html
}

if test "$#" -eq 1; then
  compile
else
  while compile; do
    inotifywait -e close_write slides.md slides.css
  done
fi
