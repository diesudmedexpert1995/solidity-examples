// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract TodoList{
    struct Task{
        string _text;
        bool _completed;
    }

    Task[] public tasks;

    function create(string calldata text_) external {
        tasks.push(Task({
            _text: text_,
            _completed: false
        }));
    }
    function update(string calldata text_, uint index_) external {
        tasks[index_]._text = text_;
    }
    
    function makeComplete(uint index_) external {
        tasks[index_]._completed = !tasks[index_]._completed;
    }
    
    function get(uint index_) external view returns(string memory, bool){
        Task memory task = tasks[index_];
        return (task._text, task._completed);
    }
}