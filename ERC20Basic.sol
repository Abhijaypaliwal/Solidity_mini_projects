
// contracts/GLDToken.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract GLDToken is ERC20 {
    constructor() public ERC20("token1", "token1") {
        
    }

    function safeMint(address _to, uint _amount) public {

        _mint(_to, _amount );
       
    }
}
