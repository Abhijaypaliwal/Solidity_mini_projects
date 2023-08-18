//SPDX-License-Identifier: MIT
pragma solidity ^0.5.16;

contract test{

    string public hello;
    uint256 public moneycount;

    function setString(string memory _hello) public {
        hello = _hello;

    }

    function getHello() public view returns(string memory){
        return hello;
    }
    function getmoney() internal  returns(uint256){
       moneycount+=1;
        return moneycount;
    }
}

contract test2 is test {
    uint256 public money;
    function getData() public  returns (uint256)
     {
         money= getmoney();
        return money;
    }
}

