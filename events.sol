// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;
contract eventNotify{
    event register(address userAddress, string name, uint timestamp);
    event notification(address user, uint points , bool activity);
    struct User{
        string name;
        uint points;
        bool activity;
    }
    mapping (address=>User) public users;
    function getRegistrate(string calldata name) public{
     require(!users[msg.sender].activity, "user is register already!");
     users[msg.sender]= User(name,0,true);
     emit register(msg.sender,name,block.timestamp);
    }
    function point( uint _points,bool _activity)public{
     require(!users[msg.sender].activity, "user is register already!");
     users[msg.sender].points +=_points;
  emit notification(msg.sender,_points,_activity);
    }
}