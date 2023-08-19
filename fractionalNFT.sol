pragma solidity ^0.8.16;


interface IERC721 {

    function transferFrom(address from, address to,  uint256 tokenId) external  ;

    function name() external view   returns (string memory);

    function approve(address spender, uint256 amount) external returns (bool) ;

}

interface IERC20 {
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

    function name() external view   returns (string memory);

    function approve(address spender, uint256 amount) external returns (bool) ;

    function safeMint(address _to, uint _amount) external;

    function balanceOf(address account) external returns (uint256) ;



}

contract fractionalNFT {
    

    struct nftDetails {
        address currentOwner;
        uint totalSupply;
        address nftContractDetails;
        uint nftTokenId;
        bool canTransfer;
    }
    receive() external payable {}

    nftDetails details;
    address public tokenAddr = 0x6b10DE261d222be77a9FD7C9fBdcD46cF7b387A8;

     /**
     * @notice Set an NFT for fractional ownership.
     * @param _nftContract Address of the NFT contract.
     * @param _tokenID ID of the NFT token.
     * @param _totalsupply Total supply of fractional tokens.
     * @return True if the setup is successful.
     */

    function setNftForFraction(address _nftContract, uint _tokenID, uint _totalsupply) public returns (bool) {
        IERC721 NFTinstance = IERC721(_nftContract);
        NFTinstance.transferFrom(msg.sender, address(this), _tokenID);
      //   IERC20 TokenInstance = IERC20(tokenAddr);
        // TokenInstance.safeMint(_totalsupply);
        details.currentOwner = address(this);
        details.totalSupply = _totalsupply;
        details.nftContractDetails = _nftContract;
        details.nftTokenId = _tokenID;
        details.canTransfer = false;
        return true;

    }
/**
     * @notice Buy fractional ownership of the NFT.
     * @return True if the purchase is successful.
     */

    function BuyFractionNFT() public payable returns (bool) {
       // uint _valOfNFT = msg.value;
        // 1 eth = 1000000000000000000 fraction

           IERC20 TokenInstance = IERC20(tokenAddr);
          TokenInstance.safeMint(msg.sender, msg.value*(10**18));
        
        return true;

    }

 /**
     * @notice Withdraw fractional ownership and the associated NFT.
     * @return True if the withdrawal is successful.
     */

    function withdrawNFT() public returns (bool) {
        require(details.canTransfer == true, "could not withdraw now");
        IERC20 TokenInstance = IERC20(tokenAddr);
        require(TokenInstance.balanceOf(msg.sender) == details.totalSupply, "holding amount should be equal to total supply");
        TokenInstance.transferFrom(msg.sender, address(this), details.totalSupply);
        IERC721 NFTinstance = IERC721(details.nftContractDetails);
        NFTinstance.transferFrom(address(this), msg.sender, details.nftTokenId);
        return true;
    }
}
