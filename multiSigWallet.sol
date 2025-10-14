// SPDX-License-Identifier: MIT
pragma solidity ^0.8.8;
contract multiSig{
    address[] public owners;
    uint numOfCompletion;
    struct Transaction{
        address to;
        uint value;
        bool execute;
    }
    mapping (uint=>mapping (address=>bool)) public isconfirmed;
    Transaction[] public transactions;
    event TransactionSbmit(uint TransactionId, address sender, address receiver, uint value);
    event TransactionConfirmation(uint transactionId);
    event TransactionExecuted(uint transactionId);
    constructor(address[] memory _owners, uint _numberOfCompletion){
        require(_owners.length>1,"owners required must be greater than 1");
        require(_numberOfCompletion>0 && _numberOfCompletion<=_owners.length, "owner must be greater than number of completion");

        for(uint i=0;i< _owners.length;++i){
            require(owners[i]!= address(0), "Invalid owner");
            owners.push(_owners[i]);
        }
        numOfCompletion= _numberOfCompletion;
    }

    function submitTransaction(address _to) public payable{
      require(_to!=address(0), "Invalid receiver");
      require(msg.value>0, "Insuffieciennt balance");
      uint transactionId= transactions.length;
      transactions.push(Transaction({to:_to, value:msg.value, execute:false}));
      emit TransactionSbmit(transactionId, msg.sender, _to, msg.value);
    }
    function ConfirmTransaction(uint _transactionId) public {
        require(_transactionId<transactions.length,"Invalid transaction"); 
        require(!isconfirmed[_transactionId][msg.sender],"Already confirmed");
        isconfirmed[_transactionId][msg.sender]=true;
        emit TransactionConfirmation(_transactionId);
        if(isTransactionConfirm(_transactionId)){
            ExcuteTransaction(_transactionId);
        }
    }
    function ExcuteTransaction(uint _transactionId) public{
        require(_transactionId<transactions.length,"Invalid transaction"); 
        require(!transactions[_transactionId].execute,"Already executerd");
        (bool success,)=transactions[_transactionId].to.call{value:transactions[_transactionId].value}("");
        require(success,"Transaction execution failed");
        transactions[_transactionId].execute = true;
        emit TransactionExecuted(_transactionId);

    }

    function isTransactionConfirm(uint _transactionId) internal view returns(bool){
        require(_transactionId<transactions.length,"Invalid transaction"); 
        uint confirmCount;
        for(uint i=0;i<owners.length;++i){
           if(isconfirmed[_transactionId][owners[i]])confirmCount++; 
        }
        return confirmCount>=numOfCompletion;
    }
}