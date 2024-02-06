#!/bin/bash
TEST_DIR="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"
BASEDIR="$(dirname "$(dirname "$(dirname "$TEST_DIR")")")"

$BASEDIR/installsc_wallet1.sh
sleep 1
$BASEDIR/tests/init_default.sh
sleep 1
$BASEDIR/cli/invoke_wallet1.sh UpdateVotingEnd 0 0 2 $(($(date +%s) + 15))
sleep 1
$BASEDIR/cli/invoke_wallet1.sh UpdateAllowMultipleParticipation 0 0 2 1
sleep 1
$BASEDIR/cli/invoke_wallet1.sh UpdateParticipationMaxToken 0 0 2 100
sleep 1
$BASEDIR/cli/invoke_wallet1.sh UpdateVotesMax 0 0 2 500
sleep 1
$BASEDIR/cli/invoke_wallet1.sh Vote 1000 5 2 1
sleep 1
$BASEDIR/cli/invoke_wallet1.sh Vote 1000 2 2 0
sleep 1
$BASEDIR/cli/invoke_wallet1.sh Vote 1000 10 2 2

