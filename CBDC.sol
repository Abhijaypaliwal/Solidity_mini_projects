pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract CBDC is ERC20 {
    address public controllingParty;
    uint public interestRateBasisPoints=500;
    //uint decimals=18;
    mapping(address => bool) public blacklist;
    mapping(address => uint) private stakedTreasuryBond;
    mapping(address => uint) private stakedFromTS;
    mapping(address => uint) public stakeTime;
    event UpdateConrollingParty(address oldConrollingParty, address newConrollingParty);
    event UpdateInterestRate(uint oldInterest, uint newInterestRate);
    event IncreaseMoneySupply(uint oldMoneySupply, uint inflationAmount);
    event UpdateBlackList(address _criminal, bool blocked);
    event StakeTreasuryBond(address user, uint amount);
    event UnStakeTreasuryBond(address user, uint amount);
    event ClaimTreasuryBonds(address user, uint amount);

    constructor(address _controllingParty, uint initialSupply) 
        ERC20("Central bank digital currency","CBDC") {
            controllingParty= _controllingParty;
            _mint(_controllingParty, initialSupply);
        }

    function updateControllingParty(address newControllingParty) external {

        require(msg.sender == controllingParty,"not controlling party");
        address oldControllingParty=controllingParty;
        controllingParty= newControllingParty;
        _transfer(oldControllingParty,controllingParty, balanceOf(controllingParty));
        emit UpdateConrollingParty(oldControllingParty,  controllingParty);

    }

    function updateInterestRate(uint newInterestRateBasisPoints) external {
         require(msg.sender == controllingParty,"not controlling party");
         uint oldInterest= newInterestRateBasisPoints;
         interestRateBasisPoints= newInterestRateBasisPoints;
         emit UpdateInterestRate(oldInterest, newInterestRateBasisPoints);

    }

    function increaseMoneySupply(uint inflationAmount) external{
        require(msg.sender == controllingParty,"not controlling party");
        uint supply= totalSupply();
        uint newsupply= supply+inflationAmount;
        _mint(msg.sender, inflationAmount);
        emit IncreaseMoneySupply(supply, newsupply);

    }

    function _transfer(address from, address to, uint amount) internal virtual override {
        require(blacklist[from]== false,"from user is blacklisted");
        require(blacklist[to]== false,"to user is blacklisted");
        super._transfer(from, to, amount);

    }

    function stakeCBDC(uint stakeAmount) public{
        require(blacklist[msg.sender]== false,"user is blacklisted");
        super._transfer(msg.sender, controllingParty, stakeAmount);
        stakeTime[msg.sender]= block.timestamp;
        stakedTreasuryBond[msg.sender]= stakeAmount;
        emit StakeTreasuryBond(msg.sender, stakeAmount);
    }

    function unstakeCBDC() public {
        require(blacklist[msg.sender]== false,"user is blacklisted");
        uint interestAmount= (block.timestamp- stakeTime[msg.sender]) * (interestRateBasisPoints* decimals())/(365*24*60*60);
         //15854895991882;
         uint totalAmount= stakedTreasuryBond[msg.sender]+ interestAmount;
         _mint(controllingParty,interestAmount);
         super._transfer(controllingParty, msg.sender, totalAmount);



    }

    



}