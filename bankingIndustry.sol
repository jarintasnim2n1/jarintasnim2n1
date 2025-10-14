// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;
contract BankingIndustry{
    address payable owner;
    mapping(address=>uint) public balances;
    constructor(){
        owner=payable(msg.sender);
    }
    function deposit() public payable{
      require(msg.value>0,"Deposit amount must be greater than 0");
        balances[msg.sender]+=msg.value; 
        
    }
    function withdraw(uint amount) public {
        require(msg.sender== owner,"only owner can withdraw funds");
        require(amount>0, "withdraw amount must be greater than 0");
        require(amount<=balances[msg.sender],"Insufficient funds");
        payable(msg.sender).transfer(amount);
        balances[msg.sender]-= amount;
    }
    function getBalance(address payable user) public view returns(uint){
         return balances[user];
    }
    function transfer(address payable recipient, uint amount) public {
        require(amount<=balances[msg.sender], "Insufficient funds");
        require(amount>0,"Transfer amount must be grater than 0");
        balances[msg.sender]-=amount;
        balances[recipient] +=amount;
    }
    function grantAccess(address payable user) public{
        require(msg.sender== owner, "Only owner can grant access");
        owner= user;
    }
    function revokeAccess(address payable user) public{
        require(msg.sender== owner,"only owner can revoke access");
        owner= payable(user);
    }
}