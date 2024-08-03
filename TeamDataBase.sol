// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract TeamDataBase {
    address _owner;
    /* struct Teammate {
       string _name;
       uint256 _age;
       bool _paused;
       address _address; 
    }
    uint256[] public balances;*/
    mapping(address => string) team; 
    address[] private teamAddreses;
    constructor(){
        _owner = msg.sender;
    }

    function addTeammate(address account_, string memory name_) public onlyOwner {
        //require(msg.sender != account_, "Cant add oneself");
        teamAddreses.push(account_);
        team[account_] = name_;
        emit NewTeammate(account_, name_);
        
    }

    function getTeammateAddress(uint256 index) public view returns(address){
        return teamAddreses[index];
    }

    function getTeammateName(address account_) public view returns(string memory){
        return team[account_];
    }

    function getTeammate(uint256 index_) public view returns(string memory){
        return getTeammateName(getTeammateAddress(index_));
    }

    function send(uint index, uint amount) public payable onlyOwner {
        payable(getTeammateAddress(index)).transfer(amount);
    }

    modifier onlyOwner{
        require(msg.sender == _owner, "Sender should be contract owner");
        _;
    }

    event NewTeammate(address account, string name);

}