pragma solidity ^0.8.16;


contract structPractice {

    struct personDetails {
        string name;
        uint age;
        uint phoneNo;
        string addressDetails;
        uint uniqueId;
    }

    personDetails detailsOfPerson ;
    mapping (address => personDetails) public personMappingOnAddress;
    mapping (uint => personDetails) public personMappingOnUinqueID;
    uint256 private counter = 0;

    function generateUniqueNumber() public returns (uint256) {
        counter++;
        uint256 uniqueNumber = (block.timestamp * 100000000000) + counter;
        return uniqueNumber;
    }

    function setDetailsOfPerson(string memory _name, uint _age, uint _phoneNo, string memory _addressDetails) public {
        uint256 _uniqueNumber = generateUniqueNumber();
        detailsOfPerson = personDetails(_name, _age, _phoneNo, _addressDetails, _uniqueNumber);
        personMappingOnAddress[msg.sender] = detailsOfPerson;
        personMappingOnUinqueID[_uniqueNumber] = detailsOfPerson;
    }

    function returnDetails() public view returns(personDetails memory) {
        return personMappingOnAddress[msg.sender];
    }
}