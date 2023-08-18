pragma solidity ^0.8.16;
contract realEstate {

    receive() external payable {}

    struct propertyDetails {
        uint propertyNumber;
        string name;
        string Type;
        uint TotalValue;
        uint MinValueToInvest;
        uint remainingAmount;
        string propertyAddress;
        bool readyToPayInterest;
        bool recieveingInvestment;
    }

    function checkListing(uint _propertyNumber) internal returns (bool){
        if(propertyMapping[_propertyNumber].remainingAmount == 0) {
            propertyMapping[_propertyNumber].recieveingInvestment = false;
            return false;
        }
        else {
            return true;
        }
        
    }
    address immutable admin;

    constructor() {
        admin = msg.sender;  
    }

    modifier onlyOwner {
        require(msg.sender == admin, "only admin can call this function");
        _;
    }

    propertyDetails property;
    mapping (uint => propertyDetails) public propertyMapping;
    mapping (address => mapping (uint => uint)) public addressInvestments;
    mapping (uint => mapping (uint => address)) public propertyToAddress;
    mapping (uint => uint) public numberOfAddresses;

    uint propertyNumber = 0;

    function listProperty(uint _propertyNumber, string memory _name, string memory _Type, uint _TotalValue, uint _MinValueToInvest, 
    string memory _propertyAddress, bool _readyToPayInterest, bool _recieveingInvestment) external returns (bool) 
    {

        propertyNumber += 1;
        property = propertyDetails(_propertyNumber, _name, _Type, _TotalValue, _MinValueToInvest,_TotalValue, _propertyAddress, _readyToPayInterest, _recieveingInvestment);
        propertyMapping[propertyNumber] = property;
        return true;
    }

    function investInRealEstate(uint _propertyNumber)  public payable returns (bool) {
       require(checkListing(_propertyNumber) == true, "investment is full");
       require(msg.value >= propertyMapping[_propertyNumber].MinValueToInvest 
       && msg.value <= propertyMapping[_propertyNumber].remainingAmount 
       && propertyMapping[_propertyNumber].recieveingInvestment == true, "less than minimum investment");
       //require(checkListing(_propertyNumber) == true, "investment is full");
        addressInvestments[msg.sender][_propertyNumber] = msg.value;
        propertyToAddress[_propertyNumber][numberOfAddresses[_propertyNumber]] = msg.sender;
        propertyMapping[_propertyNumber].remainingAmount -= msg.value;
        numberOfAddresses[_propertyNumber] +=1;
        return true;

    }

    

    function distributeRewards(uint _propertyNumber) external payable onlyOwner returns (bool) {
        uint temp = 0;
 
        while(propertyToAddress[_propertyNumber][temp] != address(0)) {
            address tempAddr = propertyToAddress[_propertyNumber][temp];
            uint distributeVal = (addressInvestments[tempAddr][_propertyNumber] *10)/(100);

            (bool sent, bytes memory data) = propertyToAddress[_propertyNumber][temp].call{value: distributeVal}("");
            require(sent, "Failed to send Ether");
            temp+=1;
        }
        return true;

    }



}