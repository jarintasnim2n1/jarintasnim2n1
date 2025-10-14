// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;
contract crowdFunding{
    address public organizer;
    uint256 public target;
    uint256 public deadline;
    uint256 public minContribution;
    uint256 public totalContributors;
    uint256 public raiseAmount;
    bool isFund;
  mapping(address =>uint256) public contributors;
  event FundRased(uint256 amount);
  constructor(uint256 _target, uint256 _deadline, uint256 _minContribution){
   organizer=msg.sender;
   target= _target;
   deadline=block.timestamp + _deadline;
   minContribution= _minContribution;
  }
  struct Request{
    bool isComplete;
    string  description;
    uint256 value;
    address payable recipient;
    uint256 noOfVoter;
    mapping(address=>bool) voters;
  }
  mapping(uint256=> Request) public requests;
  uint256 public requestCount;
  function sendEth() public payable {
    require(block.timestamp > deadline,"Funding time over");
    require(msg.value >= minContribution, "minimum contribution not met");
    if(contributors[msg.sender]== 0)totalContributors++;
    contributors[msg.sender]+=msg.value;
    raiseAmount+=msg.value;
  }
  function getBalance() public view returns(uint256){
    return address(this).balance;
  }
  function refund() public {
   require(block.timestamp>deadline && raiseAmount<target, "You are not eligible for refund");
   require(contributors[msg.sender]>0,"You are not a contributor");
   payable(msg.sender).transfer(contributors[msg.sender]);
   contributors[msg.sender]=0;
   totalContributors--;
  }
  modifier onlyOrganizer{
    require(msg.sender == organizer,"Only organizer call this function");
    _;
  }
  function createRequest(string memory _description, uint256 _value, address payable _recipient)public onlyOrganizer{
    Request storage newRequest= requests[requestCount];
    requestCount++;
    newRequest.description = _description;
    newRequest.value = _value;
    newRequest.recipient =_recipient;
    newRequest.noOfVoter=0;
    newRequest.isComplete=false;
  }
  function voteRequest(uint _noRequest) public{
   require(contributors[msg.sender]>0,"You are not a contributor");
   Request storage thisRequest = requests[_noRequest];
   require(!thisRequest.voters[msg.sender], "you are not vote yet");
   thisRequest.voters[msg.sender]=true;
   thisRequest.noOfVoter++;
  }
  function makePayment(uint256 _numRequest) public onlyOrganizer{
    require(raiseAmount>=target, "target is not met");
    Request storage thisrequest= requests[_numRequest];
    require(!thisrequest.isComplete, "the request is completed");
    require(thisrequest.noOfVoter>= totalContributors/2,"not enough  voters");
    thisrequest.recipient.transfer(thisrequest.value);
    thisrequest.isComplete=true;

  }
}