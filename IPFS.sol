pragma solidity ^0.8.16;

contract IPFSstore {

    mapping (address => mapping(uint256 => string)) public links;
    mapping (address => uint) public linkCounts;

    function storeStrings(address _addrToStore, string memory _link) public returns (bool) {
        
        links[_addrToStore][linkCounts[_addrToStore]+1] = _link;
        linkCounts[_addrToStore]+=1;
        return true;

    }
}