#!/bin/bash
TEST_DIR="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"
BASEDIR="$(dirname "$(dirname "$(dirname "$TEST_DIR")")")"

$BASEDIR/cli/getScStatus.sh $TEST_DIR/before.json

$BASEDIR/cli/invoke_wallet2.sh UpdateIcon 0 0 2 $(echo -n "This icon url won't show up" | xxd -p -c 20000)
sleep 1
$BASEDIR/cli/getScStatus.sh $TEST_DIR/after.json