// SPDX-License-Identifier: MIT
pragma solidity ^0.8.8;

contract VotingSystem{
    struct Candidate{
        uint id;
        string name;
        uint voteCount;
    }
    struct Voter{
      bool hasVoted;
      uint votedCandidateId;
      bool isEligible;
    }
  address public chairperson;
  mapping(uint=>Candidate) public candidates;
  mapping(address =>Voter) public voters;
  uint public candidateCount;
  bool public votingActive;
  uint public endTime;
  event CandidateAdded(uint candidateId, string name);
  event VoterRegistered(address indexed voterAddress);
  event VoteCasted(address indexed voter, uint indexed candidateId);
  event VotingStarted(uint endTime);
  event VotingEnding();
  modifier OnlyChairperson(){
    require(msg.sender== chairperson,"only chairperson can call this");
    _;
  }
  modifier VotingActive(){
    require(votingActive,"vote has not started yet");
    require(block.timestamp<endTime, "Voting time over");
    _;
  }
  constructor(){
    chairperson= msg.sender;
    votingActive= false;
    
  }
  function addCandidate(string memory _name) public OnlyChairperson{
    require(!votingActive, "Candidate can't be added while voting");
    candidateCount++;
    candidates[candidateCount]=Candidate(candidateCount,_name,0);
    emit CandidateAdded(candidateCount, _name);
  }
  function AddVoter(address _voter) public OnlyChairperson{
    require(!(voters[_voter].isEligible),"duplicate voter not acceptable");
    voters[_voter].isEligible=true;
    emit VoterRegistered(_voter);
  }

  function startVoting(uint _endTime) public OnlyChairperson{
    require(!votingActive,"voting already started");
    require(candidateCount>0,"No candidate");
    endTime= block.timestamp + (_endTime * 1 minutes);
    votingActive=true;
    emit VotingStarted(endTime);

  }
  function Vote(uint _candidate) public VotingActive{
    if(block.timestamp>=endTime){
      votingActive=false;
      emit VotingEnding();
    }
    Voter storage sender= voters[msg.sender];
    require(sender.isEligible,"You are not eligible for vote");
    require(!sender.hasVoted,"You voted already");
    require(_candidate>0 && _candidate<=candidateCount,"Invalid Candidate Id");
    sender.hasVoted=true;
    sender.votedCandidateId= _candidate;
    candidates[_candidate].voteCount++;
    emit VoteCasted(msg.sender,_candidate);
  }

  function endVoting() public OnlyChairperson{
    require(votingActive,"Voting is not running");
    votingActive= false;
    emit VotingEnding();

  }
  function getWinner() public view OnlyChairperson returns(uint winnerId,  string memory winnerName, uint winnerVot){
    require(!votingActive,"voting is running still");
    uint maxVote=0;
    uint winningCandidateId=0;
    for(uint i=1;i<=candidateCount; i++){
        if(candidates[i].voteCount> maxVote){
            maxVote=candidates[i].voteCount;
            winningCandidateId= i;
        }

    }
     return (winningCandidateId,candidates[winningCandidateId].name, candidates[winningCandidateId].voteCount);
  }
  function remainingTime() public view returns(uint remainime){
    if(!votingActive || block.timestamp>= endTime){
      return 0;
    }
    return endTime-(block.timestamp)/60;
  }
  function getAllCandidate() public view returns( Candidate[] memory){
    Candidate[] memory allCandidate =new Candidate[](candidateCount);
    for(uint i=0;i<candidateCount;++i){
      allCandidate[i]= candidates[i];
    }
    return allCandidate;
  }
}
