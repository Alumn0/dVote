#!/bin/bash
TEST_DIR="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"
BASEDIR="$(dirname "$(dirname "$(dirname "$TEST_DIR")")")"

$BASEDIR/cli/invoke_wallet1.sh UpdateVotesMax 0 0 2 25