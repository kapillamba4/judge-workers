#!/usr/bin/env bash
SCRIPTPATH=$(dirname "$0")
RUNBOX="${SCRIPTPATH}/runbox"

echo $RUNBOX
# Create runbox
mkdir -p $RUNBOX

# Copy source to runbox
cp $SCRIPTPATH/source.c $RUNBOX/source.c

# Test Compile
docker run --rm -v "$PWD/runbox":/usr/src/runbox -w /usr/src/runbox codingblocks/judge-worker-c /bin/compile.sh

# Delete runbox
#rm -rf $RUNBOX