// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;
contract crowdFund{
    mapping(address => uint256) public contributors;
   address public manager;
   uint256 public minmumContributions;
   uint256 public deadline;
   uint256 public raiseAmount;
   uint256 public noOfContributors;
   uint256 public target;
   constructor(uint256 _target, uint256 _deadline){
    target= _target;
    manager= msg.sender;
    deadline=_deadline+block.timestamp;
    minmumContributions= 100 wei;
   }
   struct Request{
    string description;
    address payable recipient;
    bool completed;
    uint256 value;
    uint256 noOfVoter;
    mapping(address=>bool)voters;
   }
   mapping (uint256 =>Request) public requests;
   uint256 numRequest;

   function sendEth() public payable{
    require(block.timestamp>deadline, "Deadline has passed");
    require(msg.value>=minmumContributions," Minimum contribution is not satisfied!");
   if(contributors[msg.sender]==0)
    noOfContributors++;
   contributors[msg.sender]+=msg.value;
   raiseAmount+=msg.value;

   }
   function getBalance() public view  returns(uint256){
    return address(this).balance;
   }
   function refund() public {
    require(block.timestamp>deadline && raiseAmount<target,"You are not eligible for refund");
    require(contributors[msg.sender]>0,"You can't refund");
    address payable user=payable(msg.sender);
    user.transfer(contributors[msg.sender]);
    contributors[msg.sender]=0;
   }
   modifier onlyManager{
    require(msg.sender== manager,"only manager can call this function");
    _;
   }
   function createRequest(string memory _description, address payable _recipient, uint256 _value) public onlyManager{
   Request storage newRequest= requests[numRequest];
   numRequest++;
   newRequest.description= _description;
   newRequest.recipient=_recipient;
   newRequest.value=_value;
   newRequest.completed=false;
   newRequest.noOfVoter=0;
   }
   function voteRequest(uint256 _requestNo) public{
    require(contributors[msg.sender]>0,"You must contribute");
    Request storage thisRequest = requests[_requestNo];
    require(thisRequest.voters[msg.sender]==false , "You have already voted");
    thisRequest.voters[msg.sender]=true;
    thisRequest.noOfVoter++;

   }
  function makePaymnt(uint256 _requestNo) public onlyManager{
    require(raiseAmount>=target,"Target is not reached");
    Request storage thisRequest= requests[_requestNo];
    require(thisRequest.completed==false,"The request has been completed");
    require(thisRequest.noOfVoter> noOfContributors/2, "majority doesn't support");
    thisRequest.recipient.transfer(thisRequest.value);
    thisRequest.completed= true;
  }
}