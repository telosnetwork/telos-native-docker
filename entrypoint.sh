#!/bin/bash

set -ex

cd /node

tar -xvf data-dir.tar.gz
nodeos --data-dir=/node/data-dir --config-dir=/node --enable-stale-production --genesis-json=/node/genesis.json

cd -
