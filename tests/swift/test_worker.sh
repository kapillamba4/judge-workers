#!/usr/bin/env bash
pushd $(dirname "$0")
DIR=$(pwd)
RUNBOX="${DIR}/runbox"

echo $RUNBOX
# Create runbox
mkdir -p $RUNBOX

# Copy source to runbox
cp $DIR/program.swift $RUNBOX/program.swift
cp $DIR/run.stdin $RUNBOX/run.stdin

# Test Compile
docker run \
    --cpus="1" \
    --memory="100m" \
    --ulimit nofile=64:64 \
    --rm \
    --read-only \
    -v "$RUNBOX":/usr/src/runbox \
    -v "$RUNBOX":/tmp \
    -w /usr/src/runbox codingblocks/judge-worker-swift \
    bash -c "/bin/compile.sh && /bin/run.sh"

ls -lh ${RUNBOX}

expected="Hello World"
actual="$(cat ${RUNBOX}/run.stdout)"
if [ "$expected" == "$actual" ] ;then
    :
else
    echo "MISMATCH: Expected = $expected; Actual = $actual"
    exit 1
fi

# Delete runbox
sudo rm -rf $RUNBOX