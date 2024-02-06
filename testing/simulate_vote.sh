#!/bin/bash

# Default parameters
DEFAULT_RINGSIZE=2
DEFAULT_DERI_AMOUNT=0
DEFAULT_TOKEN_AMOUNT=1
DEFAULT_TRUE_AMOUNT=1
DEFAULT_FALSE_AMOUNT=0
VOTE_TOKEN_MAX=25
VOTE_DERI_COST=2000
VOTE_START=$(($(date +%s) + 10))
VOTE_END=$(($(date +%s) + 360))
VOTE_TOKEN_ONE=1
VOTE_NO=0 
VOTE_YES=1
VOTE_ABSTAIN=2 # VOTING NOT TO VOTE 

# Function to invoke the wallet script with error handling
invoke_wallet() {
    echo "$@"
    if ! cli/invoke_wallet1.sh "$@" ; then
        echo "Error invoking wallet script: $@"
        exit 1
    fi
    sleep 1
}

# Vote with 100 DERI, 1 token, 2 rings, and yes=1
invoke_wallet \
    Vote \
    $VOTE_DERI_COST \
    $DEFAULT_TOKEN_AMOUNT \
    $DEFAULT_RINGSIZE \
    $VOTE_YES

# Add more functions as needed
