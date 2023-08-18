pragma solidity ^0.8.20;

//import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

interface ERC721 {

    function transferFrom(address from, address to,  uint256 tokenId) external  ;

    function name() external view   returns (string memory);

    function approve(address spender, uint256 amount) external returns (bool) ;

}

contract auction {

    mapping(address => mapping(uint  => bool)) public AuctionSetBool;
    mapping(address => mapping(uint  => bool)) public inContract;
    mapping(address => mapping(uint  => address)) public ownerNFT;
    mapping(address => mapping(uint  => uint)) public AuctionTimestamp;
    mapping(address => mapping(uint  => uint)) public HighestBid;
    mapping(address => mapping(uint  => mapping(address => uint))) public HighestBidByPerson;
    mapping(address => mapping(uint  => address)) public highestBidder;
    
    
    receive() external payable{}

    function setAuctionForNFT(address _contract, uint _tokenId, uint _timestamp ) public  {
        AuctionSetBool[_contract][_tokenId] = true;
        ERC721 transfer = ERC721(_contract);
        transfer.transferFrom(msg.sender,address(this), _tokenId );
        inContract[_contract][_tokenId] = true;
        ownerNFT[_contract][_tokenId] = msg.sender;
        AuctionTimestamp[_contract][_tokenId] = _timestamp;
    }


    function bidForNFT(address _contract, uint _tokenId) public payable returns(bool) {
        
        require(msg.value > HighestBidByPerson[_contract][_tokenId][msg.sender], "current bid is lower than previous bid by you");
        require(msg.value > HighestBid[_contract][_tokenId], "your bid is lower than highest placed bid");
        require(block.timestamp < AuctionTimestamp[_contract][_tokenId], "auction is expired");
        

        if (HighestBidByPerson[_contract][_tokenId][msg.sender] == 0 )
        {
             
             address  _address = address(this);
             (bool sent, bytes memory data) = _address.call{value: HighestBidByPerson[_contract][_tokenId][msg.sender]}("");
             HighestBid[_contract][_tokenId] = msg.value;
             HighestBidByPerson[_contract][_tokenId][msg.sender] = msg.value;
             highestBidder[_contract][_tokenId] = msg.sender;
             return true;

        }
        else {
            if (HighestBidByPerson[_contract][_tokenId][msg.sender] < msg.value) {
                address  _address = address(this);
                (bool sent, bytes memory data) = _address.call{value: msg.value}("");
                address payable _addr = payable (msg.sender);
                _addr.transfer(HighestBidByPerson[_contract][_tokenId][msg.sender]);
                HighestBidByPerson[_contract][_tokenId][msg.sender] = msg.value;
                HighestBid[_contract][_tokenId] = msg.value;
                highestBidder[_contract][_tokenId] = msg.sender;
                return true;
            }

        }
    }

    function auctionEnd(address _contract, uint _tokenId) public returns(bool) {
        require(block.timestamp >= AuctionTimestamp[_contract][_tokenId],"auction has not ended");
        ERC721 nftContract = ERC721(_contract);
        nftContract.transferFrom(address(this), highestBidder[_contract][_tokenId], _tokenId);
        address payable _addr = payable (ownerNFT[_contract][_tokenId]);
        _addr.transfer(HighestBid[_contract][_tokenId]);
        AuctionSetBool[_contract][_tokenId] = false;
        inContract[_contract][_tokenId] = false;
        return true;
    }

    function getHighestBid(address _contract, uint _tokenId) public payable returns(uint) {
        return HighestBid[_contract][_tokenId];
    }

    function getHighestBidByPerson(address _contract, uint _tokenId) public payable returns(uint) {
        return HighestBidByPerson[_contract][_tokenId][msg.sender];
    }



}


