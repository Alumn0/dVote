#!/bin/bash
BASEDIR="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"

curl -s --request POST --data-binary @$BASEDIR/dVote.bas http://127.0.0.1:30000/install_sc | grep -oE "[0-9a-f]{64}" | sed 's/^/SCID=/' > $BASEDIR/scid.dat
$BASEDIR/getWalletAddresses.sh
