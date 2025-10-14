// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract voting{
    bool public isvoting;
    struct Vote{
        address  receiver;
        uint256 timestamp;
    } 
    mapping(address=>Vote) public votes;
    event voteadd(address indexed voter,address receiver, uint256 timestamp);
    event voteremove(address removeby);
    event startvote(address startby);
    event stopvote(address stopedby);

    constructor() {
        isvoting=false;
    }
    function startVote() external returns(bool){
        isvoting=true;
        emit startvote(msg.sender);
        return true;
    }
    function stopVote() external returns(bool){
        isvoting=false;
        emit stopvote(msg.sender);
        return true;
    }
    function Addvote(address _receiver) external {
       votes[msg.sender].receiver=_receiver;
       votes[msg.sender].timestamp=block.timestamp;
       emit voteadd(msg.sender,votes[msg.sender].receiver,votes[msg.sender].timestamp);
    }
    function removeVote(address _voter) external{
        delete votes[_voter];
        emit voteremove(msg.sender);
    }
    function getVote(address _voter) external  view returns(address candidate){
        return votes[_voter].receiver;
    }
}