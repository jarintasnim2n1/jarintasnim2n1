// SPDX-License-Identifier: MIT
pragma solidity ^0.8.8;
contract Ether{
address payable public owner;
    constructor(){
        owner=payable(msg.sender);
    }
    receive() external payable { }
    function withdraw() external {
        require(msg.sender == owner,"only owner can withdraw");
   payable(owner).transfer (address(this).balance);
  }
}