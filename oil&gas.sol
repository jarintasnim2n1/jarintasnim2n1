// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

contract OilAndGas{
address public owner;
struct OilWell{
    string name;
    address operator;
    uint256 production;
}
struct Buyer{
    address buyerAddress;
    string oilName;
    uint256 amount;
}
uint256 public profit;
uint256 public count;
mapping(uint=>Buyer) public buyerAddresses;
mapping(address =>bool) public buyerAddress;
mapping(string=>mapping(uint256=>uint256)) public amountToPrice;
mapping(string=> OilWell) public oilWells;
mapping(address=>Buyer) public buyers;
event OilWellAdded(string indexed, address indexed _protocols);
event productionChanged(string indexed ,  uint256 _productioon);
constructor(){
    owner=msg.sender;
}
modifier Onlyowner{
    require(msg.sender== owner, "Only owner can call");
    _;
}
function oilCreated(string memory _name, uint256 _production) public Onlyowner{
 oilWells[_name]= OilWell(_name, msg.sender, _production);
emit OilWellAdded(_name, msg.sender);
}
function ChangeOperator(string  memory _index, address _operator )public Onlyowner{
    oilWells[_index].operator=_operator ;
}
function ChangeProduction(string memory _name, uint256 _production)public Onlyowner{
    oilWells[_name].production = _production;
}
function CheckOil(string memory _name)public view Onlyowner returns(string memory, uint256) {
return (oilWells[_name].name, oilWells[_name].production); 
}
function SetAmount(string memory _name, uint256 _amount, uint256 _price) public payable Onlyowner {
    amountToPrice[_name][_amount]=_price;
}
function BuyOil(address _address, string memory _name, uint256 _amount, uint256 pay) public payable{
    require(_amount>0 && pay>0, "Amount and pay must be greater than 0");
    require(amountToPrice[_name][_amount]==pay,"Insufficient balance");
    require(oilWells[_name].production >= _amount, "not enough oils");
    if(!buyerAddress[_address]){
    buyerAddress[_address]=true;
     buyerAddresses[count] = Buyer({ 
            amount: _amount,
            oilName: _name,
            buyerAddress: _address
        });
    count++;
    }
    oilWells[_name].production -= _amount;
    buyers[_address].amount += _amount;
    buyers[_address].oilName= _name;
    buyers[_address].buyerAddress = _address;
    profit +=pay;
}
function remainOil(string memory _name) public view returns(uint256){
    return oilWells[_name].production;
}
function ShowProfit() public view returns(uint256){
    return profit;
}
function BuyerList() public view returns(Buyer[] memory){
  
    Buyer[] memory TotalBuyer= new Buyer[](count); 
    for(uint256 i=0;i<count ; ++i ){
      TotalBuyer[i]=buyerAddresses[i];
    }
    return TotalBuyer;
}
}