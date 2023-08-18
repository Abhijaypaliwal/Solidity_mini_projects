//SPDX-License-Identifier: MIT
pragma solidity ^0.8.16;

interface ERC20 {

    function transferFrom(address from, address to,  uint256 amount) external  returns (bool);

    function name() external view   returns (string memory);

    function approve(address spender, uint256 amount) external returns (bool) ;

}

contract dao {

    receive() external payable{}
    event SetProposal(string  _proposalInfo, uint _expiry);
    event SetFavourProposal(uint _proposalNumber, uint  _votes);
    event SetAgainstProposal(uint _proposalNumber, uint _votes);

    address public constant OTHER_CONTRACT = 0x3b2728fC13f9DCc1eaB1e697f97E27aD8Ebe3D78;
    ERC20 transfer = ERC20(OTHER_CONTRACT);
    uint public proposalNumber = 0;

    mapping(uint => proposal) public proposalCountMapping;
    mapping(address => mapping(uint => uint)) public tokenVotes;

    struct proposal {
        string proposalInfo;
        address proposalInitiator;
        uint proposalVotesTotal;
        uint proposalVotesAgainst;
        uint proposalVotesFavour;
        uint expiry;
    }

    proposal daoProposal;

    function setProposal(string memory _proposalInfo, uint _expiry) public returns(bool) {
        daoProposal = proposal(_proposalInfo, msg.sender, 0,0,0,_expiry);
        proposalNumber++;
        proposalCountMapping[proposalNumber] = daoProposal;
        emit SetProposal(_proposalInfo, _expiry);
    }

    function setFavourProposal(uint _proposalNumber, uint _votes) public {
        require(proposalCountMapping[_proposalNumber].expiry >= block.timestamp, "proposal expired");
        require(_votes >= 10**18, "vote token cannot less than 1 DAOP");
        transfer.transferFrom(msg.sender,address(this), _votes);
        proposal memory daoPro = proposalCountMapping[_proposalNumber];
        daoPro.proposalVotesTotal += _votes;
        daoPro.proposalVotesFavour += _votes;
        proposalCountMapping[_proposalNumber] = daoPro;
        tokenVotes[msg.sender][_proposalNumber] = _votes;
        emit SetFavourProposal(_proposalNumber, _votes);       
    }

    function setAgainstProposal(uint _proposalNumber, uint _votes) public {
        require(proposalCountMapping[_proposalNumber].expiry >= block.timestamp, "proposal expired");
        require(_votes >= 10**18, "vote token cannot less than 1 DAOP");
        transfer.transferFrom(msg.sender,address(this), _votes);
        proposal memory daoPro = proposalCountMapping[_proposalNumber];
        daoPro.proposalVotesTotal += _votes;
        daoPro.proposalVotesAgainst += _votes;
        proposalCountMapping[_proposalNumber] = daoPro;
        tokenVotes[msg.sender][_proposalNumber] = _votes;
        emit SetAgainstProposal(_proposalNumber, _votes);
    }

    function claimTokens(uint _proposalNumber) public {
        require(proposalCountMapping[_proposalNumber].expiry <= block.timestamp, "proposal has not been expired");
        require(tokenVotes[msg.sender][_proposalNumber] > 0, "no token to be claimed");
        transfer.transferFrom(address(this),msg.sender, tokenVotes[msg.sender][_proposalNumber]);
    }
}