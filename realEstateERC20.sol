pragma solidity ^0.8.16;


import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract GLDToken is ERC20 {
    constructor(uint256 initialSupply) public ERC20("token1", "token1") {
        _mint(msg.sender, initialSupply);
    }
}

