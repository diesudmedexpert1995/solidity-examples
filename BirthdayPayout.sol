// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;
import "https://github.com/bokkypoobah/BokkyPooBahsDateTimeLibrary/blob/master/contracts/BokkyPooBahsDateTimeLibrary.sol";

contract BirthdayPayout{
    uint256 constant PRESENT = 1 ether;

    address _owner;
    string _ownerName;

    struct Teammate {
       address _address;
       string _name;
       uint256 _birthday; 
       uint256 _salary;
       uint256 _lastPayoutTimestamp;
    }

    
    Teammate[] private teammates;
    constructor(){
        _owner = msg.sender;
        _ownerName = "Vlad";
    }

    function addTeammate(address account_, string memory name_, uint256 birthday_, uint256 salary_) public onlyOwner {
        require(msg.sender != _owner, "Cannot add oneself");
        Teammate memory newTeammate = Teammate(account_, name_, birthday_, salary_, 0);
        teammates.push(newTeammate);
        emit NewTeammate(account_, name_);
        
    }
    function findBirthday() public returns(uint){
        require(getTeam().length > 0, "Team list is empty");
        for (uint256 i = 0; i< getTeam().length; i++) 
        {
           if(isBirthday(i) && checkLastPayoutDate(i)){
                birthdayPayout(i); 
           }
        }
        revert("None found");
    }

    function isBirthday(uint256 index_) internal view returns(bool){
        uint256 birthday = getTeam()[index_]._birthday;
        uint todayTimestamp = block.timestamp;
        return _compareDate(birthday, todayTimestamp);
    }

    function setLastPayout(uint256 index_) public view onlyOwner {
        getTeam()[index_]._lastPayoutTimestamp = block.timestamp;
    }

    function checkLastPayoutDate(uint256 index)public view returns(bool){
        uint256 lastPayoutDateTimestamp = getTeammate(index)._lastPayoutTimestamp;
        (uint256 last_payout_year, uint256 last_payout_month, uint256 last_payout_day) = getDateFromTimestamp(lastPayoutDateTimestamp);
        uint256 todayTimestamp = block.timestamp;
        (uint256 today_year, uint256 today_month, uint256 today_day) = getDateFromTimestamp(todayTimestamp);

        if(last_payout_year == today_year && last_payout_month == today_month && last_payout_day == today_day) {
            return false;
        }
        return true;
    }

    function getTeam() public view returns(Teammate[] memory){
        return teammates;
    }

    function getTeammate(uint256 index_) public view returns(Teammate memory){
        return teammates[index_];
    }

    function _compareDate(uint256 date1, uint256 date2 ) internal pure returns(bool){
        (, uint256 month1, uint256 day1) = getDateFromTimestamp(date1);
        (, uint256 month2, uint256 day2) = getDateFromTimestamp(date2);
        if(month1 == month2 && day2 == day1){
            return true;
        }else return false;
    }

    function birthdayPayout(uint256 index_) public onlyOwner {
        require(address(this).balance >= PRESENT, "Not enough balance");
        setLastPayout(index_);
        sendToTeammate(index_);
        emit HappyBirthday(teammates[index_]._name, teammates[index_]._address);
    }

    function sendToTeammate(uint256 index) internal onlyOwner{
        payable(teammates[index]._address).transfer(teammates[index]._salary);
    }

    function getDateFromTimestamp(uint256 timestamp) internal pure returns(uint256, uint256, uint256) {
        return BokkyPooBahsDateTimeLibrary.timestampToDate(timestamp);
    }

    modifier onlyOwner{
        require(msg.sender == _owner, "Sender should be contract owner");
        _;
    }
    
    function deposit() public payable {}

    event NewTeammate(address account, string name);
    event HappyBirthday(string name, address account);
}

