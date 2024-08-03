// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract ContactBook {
    string private ownerName;
    address private ownerAddress;
    address[] private contactsAddreses;
    mapping(address => string) addressToContactName;
    
    constructor(string memory ownerName_){
        ownerName = ownerName_;
        ownerAddress = msg.sender;
    }

    function addContact(string memory contactName_, address contactAddress_) public onlyOwner {
        contactsAddreses.push(contactAddress_);
        addressToContactName[contactAddress_] = contactName_;
        emit AddContact(contactAddress_, contactName_, contactsAddreses.length-1);
    }

    function getOwnerName() public view returns(string memory){
        return ownerName;
    }

    function getOwnerAddress() public view returns(address){
        return ownerAddress;
    }

    function setOwnerName(string memory name_) public onlyOwner {
        ownerName = name_;
    }

    function setOwnerAddress(address ownerAddress_) public onlyOwner {
        ownerAddress = ownerAddress_;
    }

    function getContactAddress(uint256 index_) public view returns(address){
        return contactsAddreses[index_];
    }

    function getContactName(uint256 index_)public view returns(string memory){
        return addressToContactName[getContactAddress(index_)];
    }

    modifier onlyOwner(){
        require(msg.sender == ownerAddress, "Only contract owner can use it");
        _;
    }

    event AddContact(address contactAddress, string contactName, uint256 lastIndex);
    
}