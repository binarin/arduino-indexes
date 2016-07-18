#!/usr/bin/env bash
set -eu
set -o pipefail

prefetch_files=(
  http://downloads.arduino.cc/packages/package_index.json.gz
  http://downloads.arduino.cc/packages/package_index.json.sig
  http://downloads.arduino.cc/libraries/library_index.json.gz
)

for file in "${prefetch_files[@]}"; do
    hashAndPath=$(nix-prefetch-url --print-path $file)
    hash=$(echo "$hashAndPath" | head -n 1)
    path=$(echo "$hashAndPath" | tail -n +2)
    base=$(basename $file)
    cp --no-preserve=all $path $base
    echo $hash > $base.sha256
done
