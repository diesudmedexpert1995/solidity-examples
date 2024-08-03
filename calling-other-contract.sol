// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract Callee{
    uint public x;
    uint public value;

    function setX(uint x_) public returns(uint x){
        x = x_;
    }

    function setXAndSendEther(uint x_) public payable returns(uint x, uint value){
        x = x_;
        value = msg.value;
    }
}

contract Caller{
    function setX(Callee callee_, uint x_) public {
        uint x = callee_.setX(x_);
    }

    function setXFromAddress(address addr_, uint x_) public {
        Callee callee = Callee(addr_);
        callee.setX(x_);

    }
    function setXandSetEther(Callee callee_, uint x_) public payable {
        (uint x, uint256 value) = callee_.setXAndSendEther{value: msg.value}(x_);
    }
}