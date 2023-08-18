pragma solidity ^0.5.16;

contract electionList {

    mapping (address => bool) eligibility;
    mapping (address => bool) isVoted;

    function makeEligible() public  {
        eligibility[msg.sender]=true;
    }




    uint256 candidate1;
    uint256 candidate2;

    function vote(uint voteNum) public {
        require(eligibility[msg.sender]==true);
        if(voteNum == 1){
            candidate1+=1;
        }
        else if(voteNum==2){
            candidate2+=1;
        }
        else {
            revert("number should either be 1 or 2");
        }
    }
}