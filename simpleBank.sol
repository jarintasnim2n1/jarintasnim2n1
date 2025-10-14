// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;
contract simpleBank{
    //bank deposite function, withdraw and check balance
    uint64 public balance;
  function deposit(uint64 amount) public {
   balance+=amount;
  }
  function withdraw(uint64 amount) public {
    require(balance>=amount,"Insufficient balance");
    balance -=amount;
  }
  function checkMoney() public view returns(uint64){
    return balance;
  }
}