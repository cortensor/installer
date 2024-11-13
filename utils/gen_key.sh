#!/bin/bash

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

cd ~/.cortensor

/usr/local/bin/cortensord ~/.cortensor/.env tool gen_key