/*
   dVote - Decentralized Voting

   Copyright (c) 2024 Alumn0

   Dero Address: Alumn0
   Website: https://github.com/Alumn0
   MIT License: https://raw.githubusercontent.com/Alumn0/dVote/dev/license.txt
*/

Function InitializePrivate() Uint64
1 IF getCreator() != "false" THEN GOTO 99
// mandatory: creator address for withdraw and update functions
2 STORE(getStorePrefix("config") + ",Creator", ADDRESS_STRING(SIGNER()))
98 RETURN 0
99 RETURN 1
End Function

/**********************
public voting functions
**********************/
Function Vote(choice Uint64) Uint64 // 0 = no, 1 = yes, 2 = abstain, 100000 = yes, 200000 = abstain
1 IF ASSETVALUE(SCID()) < 1 || DEROVALUE() < (getVotingFee() * ASSETVALUE(SCID())) || isVotingOpen() != 1 || choice < 0 || (choice > 2 && choice != 100000 && choice != 200000) || (getRejectAnonymousVote() != 0 && isSignerKnown() != 1) || (getAllowMultipleParticipation() != 1 && hasParticipated(ADDRESS_STRING(SIGNER())) != 0) || getParticipationMaxToken() < ASSETVALUE(SCID()) THEN GOTO 5
2 addVote(choice, ASSETVALUE(SCID()))
3 addBalance(getVotingFee() * ASSETVALUE(SCID()))
4 RETURN refund(0, DEROVALUE() - (getVotingFee() * ASSETVALUE(SCID())))
5 RETURN refund(ASSETVALUE(SCID()), DEROVALUE())
6 RETURN 0
End Function



Function TallyVotes() Uint64

/*************
getVotes
(0) = no,
(1) = yes,
(2) = abstain,
(3) = invalid,
(4) = total
*************/

/***********
getVotesMin
(0) = no,
(1) = yes,
(2) = total
***********/

1 DIM conclusion as Uint64
2 LET conclusion = 2 // inconclusive

// vote count based conclusion
3 IF getVotesMin(0) == 0 || getVotesMin(0) > getVotes(0) THEN GOTO 5
4 LET conclusion = 0 // no
5 IF getVotesMin(1) == 0 || getVotesMin(1) > getVotes(1) THEN GOTO 7
6 LET conclusion = 1 // yes
7 IF conclusion != 2 THEN GOTO 15 // if concluded, then skip time based conclusion

// time based conclusion
8 IF getVotingEnd() == 0 || getVotingEnd() > BLOCK_TIMESTAMP() THEN GOTO 16 // time not yet up, skip time based conclusion
9 IF getVotesMin(2) != 0 && getVotesMin(2) > getVotes(4) THEN GOTO 15 // concluded as inconclusive
10 IF getVotes(0) == getVotes(1) THEN GOTO 15 // no and yes count is equal, concluded as inconclusive
11 IF getVotes(0) > getVotes(1) THEN GOTO 14 // no count is higher than yes count, concluded as no
12 LET conclusion = 1 // yes
13 GOTO 15
14 LET conclusion = 0 // no
15 STORE("Conclusion", conclusion)
16 RETURN 0
End Function

/**********************
 public admin functions
**********************/
Function UpdateCollection(collection String) Uint64
1 IF isCreator() != 1 THEN GOTO 3
2 RETURN setCollection(HEXDECODE(collection))
3 RETURN 1
End Function

Function UpdateTags(tags String) Uint64
1 IF isCreator() != 1 THEN GOTO 3
2 RETURN setTags(HEXDECODE(tags))
3 RETURN 1
End Function

Function UpdateCover(url String) Uint64
1 IF isCreator() != 1 THEN GOTO 3
2 RETURN setCover(HEXDECODE(url))
3 RETURN 1
End Function

Function UpdateIcon(url String) Uint64
1 IF isCreator() != 1 THEN GOTO 3
2 RETURN setIcon(HEXDECODE(url))
3 RETURN 1
End Function

Function UpdateType(value String) Uint64
1 IF isCreator() != 1 THEN GOTO 3
2 RETURN setType(HEXDECODE(value))
3 RETURN 1
End Function

Function UpdateName(name String) Uint64
1 IF isCreator() != 1 THEN GOTO 3
2 RETURN setName(HEXDECODE(name))
3 RETURN 1
End Function

Function UpdateDescription(description String) Uint64
1 IF isCreator() != 1 THEN GOTO 3
2 RETURN setDescription(HEXDECODE(description))
3 RETURN 1
End Function

Function UpdateVotesMax(qty Uint64) Uint64
1 IF isCreator() != 1 THEN GOTO 3
2 RETURN setVotesMax(qty)
3 RETURN 1
End Function

Function UpdateVotingStart(timestamp Uint64) Uint64
1 IF isCreator() != 1 THEN GOTO 3
2 RETURN setVotingStart(timestamp)
3 RETURN 1
End Function

Function UpdateVotingEnd(timestamp Uint64) Uint64
1 IF isCreator() != 1 THEN GOTO 3
2 RETURN setVotingEnd(timestamp)
3 RETURN 1
End Function

Function UpdateVotesMin(qty Uint64, option Uint64) Uint64 // 0 = no, 1 = yes, 2 = total
1 IF isCreator() != 1 THEN GOTO 3
2 RETURN setVotesMin(qty, option)
3 RETURN 1
End Function

Function UpdateVotingFee(qtyDeri Uint64) Uint64
1 IF isCreator() != 1 THEN GOTO 3
2 RETURN setVotingFee(qtyDeri)
3 RETURN 1
End Function

Function UpdateDisplayVoters(display Uint64) Uint64
1 IF isCreator() != 1 THEN GOTO 3
2 RETURN setDisplayVoters(display)
3 RETURN 1
End Function

Function UpdateRejectAnonymousVote(reject Uint64) Uint64
1 IF isCreator() != 1 THEN GOTO 3
2 RETURN setRejectAnonymousVote(reject)
3 RETURN 1
End Function

Function UpdateAllowMultipleParticipation(allow Uint64) Uint64
1 IF isCreator() != 1 THEN GOTO 3
2 RETURN setAllowMultipleParticipation(allow)
3 RETURN 1
End Function

Function UpdateParticipationMaxToken(qty Uint64) Uint64
1 IF isCreator() != 1 THEN GOTO 3
2 RETURN setParticipationMaxToken(qty)
3 RETURN 1
End Function

Function Withdraw(qtyDeri Uint64) Uint64
1 IF isCreator() != 1 THEN GOTO 7
2 IF qtyDeri > getBalance() THEN GOTO 5 // allow to override the balance
3 STORE("Balance", getBalance() - qtyDeri)
4 GOTO 6
5 STORE("Balance", 0)
6 RETURN SEND_DERO_TO_ADDRESS(SIGNER(), qtyDeri) != qtyDeri
7 RETURN 1
End Function


/***********************
private helper functions
***********************/
Function isCreator() Uint64
1 IF getCreator() != ADDRESS_STRING(SIGNER()) THEN GOTO 3
2 RETURN 1
3 RETURN 0
End Function

Function isSignerKnown() Uint64
1 IF ADDRESS_STRING(SIGNER()) == "" THEN GOTO 3
2 RETURN 1
3 RETURN 0
End Function

Function isModifiable() Uint64
1 IF getVotesMax() != 0 THEN GOTO 3
2 RETURN 1
3 RETURN 0
End Function

Function isVotingOpen() Uint64
1 IF isModifiable() != 0 || getVotingStart() > BLOCK_TIMESTAMP() || (getVotingEnd() != 0 && getVotingEnd() < BLOCK_TIMESTAMP()) THEN GOTO 3
2 RETURN 1
3 RETURN 0
End Function

Function refund(qtyToken Uint64, qtyDeri Uint64) Uint64
1 IF isSignerKnown() != 1 THEN GOTO 7 
2 IF qtyToken < 1 THEN GOTO 4
3 SEND_ASSET_TO_ADDRESS(SIGNER(), qtyToken, SCID())
4 IF qtyDeri < 1 THEN GOTO 11
5 SEND_DERO_TO_ADDRESS(SIGNER(), qtyDeri)
6 GOTO 11
7 IF qtyToken < 1 THEN GOTO 9 // handle signer unknown, refunding impossible
8 addVote(3, qtyToken) // invalid vote
9 IF qtyDeri < 1 THEN GOTO 11
10 addBalance(qtyDeri)
11 RETURN 0
End Function

Function addBalance(qty Uint64) Uint64
1 RETURN STORE("Balance", getBalance() + qty) != 1
End Function

Function addVote(choice Uint64, qty Uint64) // 0 = no, 1 = yes, 2 = abstain, 3 = invalid
1 STORE(getStorePrefix("count") +  "," + getVotesStoreKey(choice), getVotes(choice) + qty)
2 STORE(getStorePrefix("count") +  "," + getVotesStoreKey(4), getVotes(4) + qty) // increase total vote count
3 IF getDisplayVoters() != 1 || isSignerKnown() != 1 THEN GOTO 5
4 STORE(getStorePrefix("data") +  "," + getVotesStoreKey(choice) + "," + BLOCK_HEIGHT() + "," + BLOCK_TIMESTAMP(), ADDRESS_STRING(SIGNER()) + "," + qty)
5 IF isSignerKnown() != 1 THEN GOTO 7
6 addParticipated(ADDRESS_STRING(SIGNER()))
7 TallyVotes()
8 RETURN
End Function

Function hasParticipated(address String) Uint64
1 RETURN EXISTS(getStorePrefix("data") + ",participant," + address)
End Function

Function addParticipated(address String) Uint64
1 IF address == "" THEN GOTO 5
2 IF hasParticipated(address) THEN GOTO 4
3 RETURN STORE(getStorePrefix("data") + ",participant," + address, 1) != 1
4 RETURN STORE(getStorePrefix("data") + ",participant," + address, LOAD(getStorePrefix("data") + ",participant," + address) + 1) != 1
5 RETURN 1
End Function

/***********************
private getter functions
***********************/
Function getVotesMax() Uint64
1 IF EXISTS(getStorePrefix("config") + ",VotesMax") != 1 THEN GOTO 3
2 RETURN LOAD(getStorePrefix("config") + ",VotesMax")
3 RETURN 0
End Function

Function getVotingStart() Uint64
1 IF EXISTS(getStorePrefix("config") + ",VotingStart") != 1 THEN GOTO 3
2 RETURN LOAD(getStorePrefix("config") + ",VotingStart")
3 RETURN 0
End Function

Function getVotingEnd() Uint64
1 IF EXISTS(getStorePrefix("config") + ",VotingEnd") != 1 THEN GOTO 3
2 RETURN LOAD(getStorePrefix("config") + ",VotingEnd")
3 RETURN 0
End Function

Function getVotesMin(option Uint64) Uint64 // 0 = no, 1 = yes, 2 = total
1 IF EXISTS(getStorePrefix("config") + "," + getVotesMinStoreKey(option)) != 1 THEN GOTO 3
2 RETURN LOAD(getStorePrefix("config") + "," + getVotesMinStoreKey(option))
3 RETURN 0
End Function

Function getVotingFee() Uint64
1 IF EXISTS(getStorePrefix("config") + ",VotingFee") != 1 THEN GOTO 3
2 RETURN LOAD(getStorePrefix("config") + ",VotingFee")
3 RETURN 0
End Function

Function getCreator() String
1 IF EXISTS(getStorePrefix("config") + ",Creator") != 1 THEN GOTO 3
2 RETURN LOAD(getStorePrefix("config") + ",Creator")
3 RETURN "false"
End Function

Function getDisplayVoters() Uint64
1 IF EXISTS(getStorePrefix("config") + ",DisplayVoters") != 1 THEN GOTO 3
2 RETURN LOAD(getStorePrefix("config") + ",DisplayVoters")
3 RETURN 0
End Function

Function getRejectAnonymousVote() Uint64
1 IF EXISTS(getStorePrefix("config") + ",RejectAnonymousVote") != 1 THEN GOTO 3
2 RETURN LOAD(getStorePrefix("config") + ",RejectAnonymousVote")
3 RETURN 0
End Function

Function getBalance() Uint64
1 IF EXISTS("Balance") != 1 THEN GOTO 3
2 RETURN LOAD("Balance")
3 RETURN 0
End Function

Function getVotes(option Uint64) Uint64 // 0 = no, 1 = yes, 2 = abstain, 3 = invalid, 4 = total
1 IF EXISTS(getStorePrefix("count") +  "," + getVotesStoreKey(option)) != 1 THEN GOTO 3
2 RETURN LOAD(getStorePrefix("count") +  "," + getVotesStoreKey(option))
3 RETURN 0
End Function

Function getVotesStoreKey(option Uint64) String
1 IF option != 0 THEN GOTO 3
2 RETURN "VotesNo"
3 IF option != 1 && option != 100000 THEN GOTO 5
4 RETURN "VotesYes"
5 IF option != 2 && option != 200000 THEN GOTO 7
6 RETURN "VotesAbstain"
7 IF option != 3 THEN GOTO 9
8 RETURN "VotesInvalid"
9 IF option != 4 THEN GOTO 11
10 RETURN "VotesTotal"
11 RETURN ""
End Function

Function getVotesMinStoreKey(option Uint64) String
1 IF option != 0 THEN GOTO 3
2 RETURN "VotesNoMin"
3 IF option != 1 THEN GOTO 5
4 RETURN "VotesYesMin"
5 IF option != 2 THEN GOTO 7
6 RETURN "VotesTotalMin"
7 RETURN ""
End Function

Function getStorePrefix(option String) String
1 IF option != "data" THEN GOTO 3
2 RETURN "~DATA"
3 IF option != "config" THEN GOTO 5
4 RETURN "SETTINGS"
5 IF option != "count" THEN GOTO 7
6 RETURN "COUNT"
7 RETURN ""
End Function


Function getAllowMultipleParticipation() Uint64
1 IF EXISTS(getStorePrefix("config") + ",AllowMultipleParticipation") != 1 THEN GOTO 3
2 RETURN LOAD(getStorePrefix("config") + ",AllowMultipleParticipation")
3 RETURN 0
End Function

Function getParticipationMaxToken() Uint64
1 IF EXISTS(getStorePrefix("config") + ",ParticipationMaxToken") != 1 THEN GOTO 3
2 RETURN LOAD(getStorePrefix("config") + ",ParticipationMaxToken")
3 RETURN 1
End Function

/***********************
private setter functions
***********************/
Function setVotesMax(qty Uint64) Uint64
1 IF qty < 1 || isModifiable() != 1 THEN GOTO 4
2 STORE(getStorePrefix("config") + ",VotesMax", qty)
3 RETURN SEND_ASSET_TO_ADDRESS(SIGNER(), qty, SCID()) != qty
4 RETURN 1
End Function

Function setVotingStart(timestamp Uint64) Uint64
1 IF timestamp < BLOCK_TIMESTAMP() || (getVotingEnd() != 0 && timestamp >= getVotingEnd()) || isModifiable() != 1 THEN GOTO 3
2 RETURN STORE(getStorePrefix("config") + ",VotingStart", timestamp) != 1
3 RETURN 1
End Function

Function setVotingEnd(timestamp Uint64) Uint64
1 IF timestamp <= BLOCK_TIMESTAMP() || (getVotingStart() != 0 && timestamp <= getVotingStart()) || isModifiable() != 1 THEN GOTO 3
2 RETURN STORE(getStorePrefix("config") + ",VotingEnd", timestamp) != 1
3 RETURN 1
End Function

Function setVotesMin(qty Uint64, option Uint64) Uint64 // 0 = no, 1 = yes, 2 = total
1 IF option < 0 || option > 2 || isModifiable() != 1 THEN GOTO 3
2 RETURN STORE(getStorePrefix("config") + "," + getVotesMinStoreKey(option), qty) != 1
3 RETURN 1
End Function

Function setVotingFee(qty Uint64) Uint64
1 IF qty < 0 || isModifiable() != 1 THEN GOTO 3
2 RETURN STORE(getStorePrefix("config") + ",VotingFee", qty) != 1
3 RETURN 1
End Function

Function setDisplayVoters(display Uint64) Uint64
1 IF (display != 0 && display != 1) || isModifiable() != 1 THEN GOTO 3
2 RETURN STORE(getStorePrefix("config") + ",DisplayVoters", display) != 1
3 RETURN 1
End Function

Function setRejectAnonymousVote(reject Uint64) Uint64
1 IF (reject != 0 && reject != 1) || isModifiable() != 1 THEN GOTO 3
2 RETURN STORE(getStorePrefix("config") + ",RejectAnonymousVote", reject) != 1
3 RETURN 1
End Function

Function setDescription(description String) Uint64
1 IF isModifiable() != 1 THEN GOTO 3
2 RETURN STORE("descrHdr", description) != 1
3 RETURN 1
End Function

Function setName(name String) Uint64
1 IF isModifiable() != 1 THEN GOTO 3
2 RETURN STORE("nameHdr", name) != 1
3 RETURN 1
End Function

Function setType(value String) Uint64
1 IF isModifiable() != 1 THEN GOTO 3
2 RETURN STORE("typeHdr", value) != 1
3 RETURN 1
End Function

Function setIcon(url String) Uint64
1 IF isModifiable() != 1 THEN GOTO 3
2 RETURN STORE("iconURLHdr", url) != 1
3 RETURN 1
End Function

Function setCover(url String) Uint64
1 IF isModifiable() != 1 THEN GOTO 3
2 RETURN STORE("coverURL", url) != 1
3 RETURN 1
End Function

Function setTags(tags String) Uint64
1 IF isModifiable() != 1 THEN GOTO 3
2 RETURN STORE("tagsHdr", tags) != 1
3 RETURN 1
End Function

Function setCollection(collection String) Uint64
1 IF isModifiable() != 1 THEN GOTO 3
2 RETURN STORE("collection", collection) != 1
3 RETURN 1
End Function

Function setAllowMultipleParticipation(allow Uint64) Uint64
1 IF (allow != 0 && allow != 1) || isModifiable() != 1 THEN GOTO 3
2 RETURN STORE(getStorePrefix("config") + ",AllowMultipleParticipation", allow) != 1
3 RETURN 1
End Function

Function setParticipationMaxToken(qty Uint64) Uint64
1 IF qty < 1 || isModifiable() != 1 THEN GOTO 3
2 RETURN STORE(getStorePrefix("config") + ",ParticipationMaxToken", qty) != 1
3 RETURN 1
End Function