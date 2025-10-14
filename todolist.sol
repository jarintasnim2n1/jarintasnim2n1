
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract myTodo{
    struct Task{
        string content;
        bool complete;
    }
    Task[] public tasks;
    function createTask(string calldata _content, bool _complete) public{
        tasks.push(Task(_content, _complete));
    }
    function completeTask(uint64 index) public{
        require(index<tasks.length, "task is not exits");
        tasks[index].complete=true;
    }
    function getTask(uint index) public  view returns(string memory content, bool complete){
      require(index< tasks.length,"Index out of bounds");
      Task storage task= tasks[index];
      return (task.content, task.complete);
    }
}