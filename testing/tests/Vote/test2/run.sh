#!/bin/bash
TEST_DIR="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"
BASEDIR="$(dirname "$(dirname "$(dirname "$TEST_DIR")")")"

sleep 10
$BASEDIR/cli/getScStatus.sh $TEST_DIR/before.json

$BASEDIR/cli/invoke_wallet1.sh Vote 100 1 2 0
sleep 1
$BASEDIR/cli/invoke_wallet1.sh Vote 800 5 2 1
sleep 1
$BASEDIR/cli/invoke_wallet1.sh Vote 100 1 2 100000
sleep 1
$BASEDIR/cli/invoke_wallet1.sh Vote 100 1 2 2
sleep 1
$BASEDIR/cli/invoke_wallet1.sh Vote 100 1 2 200000
sleep 1
$BASEDIR/cli/getScStatus.sh $TEST_DIR/after.json