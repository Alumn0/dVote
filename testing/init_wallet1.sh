#!/bin/bash

# Default parameters
DEFAULT_RINGSIZE=2
DEFAULT_DERI_AMOUNT=0
DEFAULT_TOKEN_AMOUNT=0
DEFAULT_TRUE_AMOUNT=1
DEFAULT_FALSE_AMOUNT=0
VOTE_TOKEN_MAX=25
VOTE_DERI_COST=500000
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

# Update voting start time
invoke_wallet \
    UpdateVotingStart \
    $DEFAULT_DERI_AMOUNT \
    $DEFAULT_TOKEN_AMOUNT \
    $DEFAULT_RINGSIZE \
    $VOTE_START

# Update voting end time
invoke_wallet \
    UpdateVotingEnd \
    $DEFAULT_DERI_AMOUNT \
    $DEFAULT_TOKEN_AMOUNT \
    $DEFAULT_RINGSIZE \
    $VOTE_END

# Update voting fee
invoke_wallet \
    UpdateVotingFee \
    $DEFAULT_DERI_AMOUNT \
    $DEFAULT_TOKEN_AMOUNT \
    $DEFAULT_RINGSIZE \
    $VOTE_DERI_COST

# Update display voters
invoke_wallet \
    UpdateDisplayVoters \
    $DEFAULT_DERI_AMOUNT \
    $DEFAULT_TOKEN_AMOUNT \
    $DEFAULT_RINGSIZE \
    $DEFAULT_TRUE_AMOUNT 

# Update reject anonymous votes
invoke_wallet \
    UpdateRejectAnonymousVote \
    $DEFAULT_DERI_AMOUNT \
    $DEFAULT_TOKEN_AMOUNT \
    $DEFAULT_RINGSIZE \
    $DEFAULT_FALSE_AMOUNT

Update votes max
invoke_wallet \
    UpdateVotesMax \
    $DEFAULT_DERI_AMOUNT \
    $DEFAULT_TOKEN_AMOUNT \
    $DEFAULT_RINGSIZE \
    $VOTE_TOKEN_MAX

# Add more functions as needed
