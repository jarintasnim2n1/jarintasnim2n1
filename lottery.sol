// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract Lottery{
    address public owner;
    address[] public players;
    uint public endtime;
    bool public startLottery;
    constructor(){
        owner=msg.sender;
    }
    modifier onlyOwner{
        require(msg.sender== owner, "only owner can all this function");
        _;
    }
    function LotterytimeStart(uint _endTime) public onlyOwner {
        require(!startLottery, "Lottery is started already");
        endtime = block.timestamp + _endTime*1 minutes;
        startLottery=true;
    }
    function EndLottery() public onlyOwner{
        require(startLottery, "lottery is not started");
        startLottery= false;
    }
    function isEntered() private view returns(bool){
      for(uint i=0;i<players.length;++i){
        if(players[i]==msg.sender)return true;
      }
      return false;
    }
    function enter() public payable{
        require(startLottery,"Lottery is not started");
        if(block.timestamp>= endtime)startLottery=false;
        require(msg.sender!= owner,"owner can't enter" );
        require(msg.value>=1, "you have to pay more than 1 ether");
        require(!isEntered(),"you are entered");
        players.push(payable (msg.sender));
        startLottery=true;
    } 
    function random() private view returns(uint){
        return uint(keccak256(abi.encodePacked(block.prevrandao, block.number,players)));
    }
  function pickWinner() public payable onlyOwner {
    require(!startLottery,"lottery is running still ");
    require(players.length>= 3,"Atleast 3 players exist.");
  uint index= random()%players.length;
  address winner = players[index];
  payable(winner).transfer(address(this).balance);
  players= new address[](0);
  }
  function getallPlayer() public view returns(address[] memory){
    return players;
  }
  function remainingTime() public view returns(uint){
   if(!startLottery || block.timestamp>=endtime)return 0;
   return endtime - (block.timestamp)/60;
  }
}