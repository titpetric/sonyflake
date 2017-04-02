#!/bin/bash
set -e

## Get git commit ID and pass command to make
CI_COMMIT_ID=${CI_COMMIT_ID:-$(git rev-list HEAD | head -n 1)}
CI_COMMIT_ID_SHORT=${CI_COMMIT_ID:0:7}

## Get tag ID
CI_TAG_ID=$(git tag | tail -n 1)
if [ -z "${CI_TAG_ID}" ]; then
	CI_TAG_ID="v0.0.0";
fi

make -e CI_TAG_ID=${CI_TAG_ID} \
     -e CI_COMMIT_ID=${CI_COMMIT_ID} \
     -e CI_COMMIT_ID_SHORT=${CI_COMMIT_ID_SHORT} "$@"
