// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

contract Hello {
    string private _name;
    function speak() view public returns(string memory){
        if (keccak256(bytes(_name)) == keccak256(bytes(""))){
            return "Hello World";
        }
        else {
            return  string.concat("Hello ", _name);
        }
    }

    function setName(string memory name_) public{
        _name = name_;
    }
    function getName() view public returns(string memory){
        return _name;
    }

    function deposit() public payable{

    }

    function getBalance() public view returns(uint256){
        return address(this).balance;
    }

    function withdraw() public {
        return payable(msg.sender).transfer(getBalance());
    }
}