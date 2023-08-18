// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts@4.7.3/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts@4.7.3/token/ERC20/extensions/draft-ERC20Permit.sol";

contract MyToken is ERC20, ERC20Permit {
    constructor() ERC20("MyToken", "MTK") ERC20Permit("MyToken") {}

    function mint(address to, uint256 value) external {
        _mint(to, value);
    }

    function transfertoContract(address _from, uint _amount) external {
        _transfer(_from, address(this), _amount);
    }

    function transferToAddr(address _from, address _to, uint _amount) external {
        require(_amount >20, "token is less than 20");
        // for 1000 token transfer, there would be 2% charge, else flat 20 token fees
        if(_amount < 1000) {
            _transfer(_from, address(this), 20);
            _transfer(_from, _to, _amount-20);
        }
        else {
            uint fees = (_amount *2)/(100);
            _transfer(_from, address(this), fees);
            _transfer(_from, _to, _amount-fees);
        }

    }
}
