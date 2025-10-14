// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract Government{
    address[] public citizens;
    address[] public officials;
    address payable owner;
    mapping(address=> bool) public isOfficial;
    constructor(){
       owner= payable(msg.sender);
    }
    function registerAsCitizen()public{
        require(!isOfficial[msg.sender],"only official can register");
        citizens.push(msg.sender);
    }
    
    function registerAsOfficial()public{
        require(!isOfficial[msg.sender],"can't register as officials");
        officials.push(msg.sender);
        isOfficial[msg.sender]=true;
    }
    function vote(address candidate) public view{ 
        require(!isOfficial[msg.sender],"can't vote as officials");
        require(isOfficial[candidate],"candidate must be registered as officials");   
    }
    function proposeLaw(string memory law) public view  {
        require(!isOfficial[msg.sender],"only officials can propose laws");
        
    }
    function enactlaw(string memory law) public view{
       require(msg.sender==owner, "only owner can enact law");
    }
    function getOfficials() public view returns(address[] memory){
        return officials;
    }
    function getcitizens() public view returns(address[] memory){
        return citizens;
    }
    function grantAccess(address payable user) public{
    require(msg.sender==owner,"only owner can give the access");
    owner=user;
    }
    function revokeAccess(address payable user) public{
    require(msg.sender==owner,"only owner can give the access");
    require(user!= owner, "current owner can't revoke access");
    owner=payable(msg.sender);
    }
    function destroy() public{
        require(msg.sender==owner,"only owner can destroy the contract");
        selfdestruct(owner);
    }
}