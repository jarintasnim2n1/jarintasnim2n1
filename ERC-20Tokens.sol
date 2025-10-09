// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;
contract  ERC20Token{
string public name;
string public symbol;
uint8 public decimal;
uint256 private totalSupply;
mapping(address=>uint256) public balances;
mapping (address=>mapping (address=>uint256)) public allowed;
event Transfer(address owner, address to, uint256 tokens);
event Approval(address indexed owner, address indexed spender, uint256 tokens);
constructor(string memory _name, string memory _symbol, uint8 _decimal,uint256 _totalSuply){
    name= _name;
    decimal= _decimal;
    symbol= _symbol;
    totalSupply= _totalSuply;
    balances[msg.sender]=totalSupply;
    emit Transfer(address(0),msg.sender, totalSupply);
}
function _totalSupply() public view returns(uint256){
    return totalSupply;
}
function balanceOf(address _address) public view returns(uint256){
 return balances[_address];
}
function transfer(address _to, uint256 _value)public  returns(bool success){
    require(balances[msg.sender]>=_value,"insufficient balance");
    balances[msg.sender]=balances[msg.sender]-_value;
    balances[_to]= balances[_to]+ _value;
    emit Transfer(msg.sender, _to, _value);
    return true;
}
function approve( address _spender, uint256 _tokens) public returns(bool success){
    allowed[msg.sender][_spender]=_tokens;
    emit Approval(msg.sender, _spender, _tokens);
    return true;
}
function transferFrom(address _owner, address _to, uint256 _tokens)public returns(bool success){
    require(_tokens<= balances[_owner],"Insufficient balance");
    require(_tokens<= allowed[_owner][msg.sender], "Tokens not allowed");
    balances[_owner]= balances[_owner]-_tokens;
    balances[_to]=balances[_to]+_tokens;
    allowed[_owner][msg.sender]=allowed[_owner][msg.sender]-_tokens;
    emit Transfer(_owner, _to, _tokens);
    return true;
}

function allowance(address _owner, address _spender) public view returns(uint256 remaningTokens){
    return allowed[_owner][_spender];
}
}